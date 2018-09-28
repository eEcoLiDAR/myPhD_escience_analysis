library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/Data/Lauwersmeer_island") # working directory

# Import
classes = rgdal::readOGR("training_buffer2o5.shp")
plot(classes)

ani=raster("lauwermeer_merged_anisotrophy.tif")
curva=raster("lauwermeer_merged_curvature.tif")
lin=raster("lauwermeer_merged_linearity.tif")
plan=raster("lauwermeer_merged_planarity.tif")
sph=raster("lauwermeer_merged_sphericity.tif")

height_max=raster("lauwermeer_merged_heightq090.tif")
height_025=raster("lauwermeer_merged_heightq025.tif")
height_075=raster("lauwermeer_merged_heightq075.tif")
height_med=raster("lauwermeer_merged_heightmedian.tif")
height_mean=raster("lauwermeer_merged_heightmean.tif")

heightcover=raster("lauwermeer_merged_cover_pulsepenrat.tif")

heightskew=raster("lauwermeer_merged_vertdistr_heightskew.tif")
height_std=raster("lauwermeer_merged_vertdistr_heightstd.tif")

height_dtm=raster("lauwermeer_merged_terrainmean.tif")
height_dtmvar=raster("lauwermeer_merged_terrainvar.tif")

# Preprocess import data (rasterizing, masking)
classes_rast <- rasterize(classes, height_std,field="Vegetation")
#plot(classes_rast)

lidar_metrics = addLayer(height_max,height_025,height_075,height_med,height_mean,heightcover,heightskew,height_std,ani,curva,lin)

masked <- mask(lidar_metrics, classes_rast)

# convert training data into the right format
trainingbrick <- addLayer(masked, classes_rast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

# apply RF
modelRF <- randomForest(x=featuretable[ ,c(1:11)], y=factor(featuretable$layer),importance = TRUE)
class(modelRF)
varImpPlot(modelRF)

# accuracy assessment
first_seed <- 5
accuracies <-c()
for (i in 1:1){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- createDataPartition(y=featuretable$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable[trainIndex,]
  testingSet<- featuretable[-trainIndex,]
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:11)])
  testingSet$rightPred <- prediction == testingSet$layer
  t<-table(prediction, testingSet$layer)
  print(t)
  accuracy <- sum(testingSet$rightPred)/nrow(testingSet)
  accuracies <- c(accuracies,accuracy)
  print(accuracy)
}

# predict
predLC <- predict(lidar_metrics, model=modelRF, na.rm=TRUE)

names(featuretable)
names(lidar_metrics)

plot(predLC)

writeRaster(predLC, filename="classified3.tif", format="GTiff",overwrite=TRUE)
