library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/WholeLau_TotalVegetation") # working directory

# Import
classes = rgdal::readOGR("D:/Koma/Paper1_ReedStructure/selectedclasses_polygon.shp")
plot(classes)

ani=raster("mosaic_anisotropy.tif")
curva=raster("mosaic_curvature.tif")
heightkurto=raster("mosaic_heightkurto.tif")
height_max=raster("mosaic_heightmax.tif")
omni=raster("mosaic_omnivariance.tif")

# Preprocess import data (rasterizing, masking)
classes_rast <- rasterize(classes, ani,field="classes")
plot(classes_rast)

lidar_metrics = addLayer(ani, curva, omni)

masked <- mask(lidar_metrics, classes_rast)

# convert training data into the right format
trainingbrick <- addLayer(masked, classes_rast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

# apply RF
modelRF <- randomForest(x=featuretable[ ,c(1:4)], y=factor(featuretable$layer),importance = TRUE)
class(modelRF)
varImpPlot(modelRF)

# accuracy assessment
first_seed <- 5
accuracies <-c()
for (i in 1:3){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- createDataPartition(y=featuretable$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable[trainIndex,]
  testingSet<- featuretable[-trainIndex,]
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:4)])
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

cols=c("khaki1","green","dark green","blue")
plot(predLC,col=cols)
