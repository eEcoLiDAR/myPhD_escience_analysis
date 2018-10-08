library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/tiled") # working directory

# Import
classes = rgdal::readOGR("training_buffer3.shp")
plot(classes)

eiglargest=raster("mosaic_eigenlargest.tif")
eigmedium=raster("mosaic_eigenmedium.tif")
eigsmallest=raster("mosaic_eigensmallest.tif")
ani=raster("mosaic_anisotropy.tif")
curva=raster("mosaic_curvature.tif")
lin=raster("mosaic_linearity.tif")
plan=raster("mosaic_planarity.tif")
sph=raster("mosaic_sphericity.tif")

height_max=raster("mosaic_heightq090.tif")
height_025=raster("mosaic_heightq025.tif")
height_075=raster("mosaic_heightq075.tif")
height_med=raster("mosaic_heightmedian.tif")
height_mean=raster("mosaic_heightmean.tif")

heightcover=raster("mosaic_pulsepenrat.tif")

heightskew=raster("mosaic_heightskew.tif")
height_std=raster("mosaic_heightstd.tif")
height_kurto=raster("mosaic_heightkurto.tif")
height_var=raster("mosaic_heightvar.tif")

height_dtm=raster("mosaic_terrainmean.tif")
height_dtmvar=raster("mosaic_terrainvar.tif")

# Preprocess import data (rasterizing, masking)
classes_rast <- rasterize(classes, height_std,field="Vegetation")
#plot(classes_rast)

lidar_metrics = addLayer(height_max,height_025,height_075,height_med,height_mean,heightcover,heightskew,height_std,height_kurto,height_var,
                         eiglargest,eigmedium,eigsmallest,ani,curva,lin,plan,sph,height_dtm,height_dtmvar)

masked <- mask(lidar_metrics, classes_rast)

# convert training data into the right format
trainingbrick <- addLayer(masked, classes_rast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

# apply RF
modelRF <- randomForest(x=featuretable[ ,c(1:20)], y=factor(featuretable$layer),importance = TRUE)
class(modelRF)
varImpPlot(modelRF)

# accuracy assessment
first_seed <- 5
accuracies <-c()
for (i in 1:5){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- createDataPartition(y=featuretable$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable[trainIndex,]
  testingSet<- featuretable[-trainIndex,]
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:20)])
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

writeRaster(predLC, filename="classified.tif", format="GTiff",overwrite=TRUE)
