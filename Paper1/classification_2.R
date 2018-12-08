"
@author: Zsofia Koma, UvA
Aim: classify
"
library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
setwd("D:/Koma/Paper1/ALS/forClassification/") # working directory

# Import
classes = rgdal::readOGR("training_level2_b2o5.shp")
classes@data$V4=as.numeric(factor(classes@data$V3))

lidarmetrics=stack("lidarmetrics_forClassification.grd")

# Masking
classes_rast <- rasterize(classes, lidarmetrics[[1]],field="V4")

masked <- mask(lidarmetrics, classes_rast)

# convert training data into the right format
trainingbrick <- addLayer(masked, classes_rast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

write.table(featuretable,"featuretable_level2_b2o5.csv",row.names=FALSE,sep=",")

# apply RF
modelRF <- randomForest(x=featuretable[ ,c(1:22)], y=factor(featuretable$layer),importance = TRUE)
class(modelRF)
varImpPlot(modelRF)

# accuracy assessment
first_seed <- 2
accuracies <-c()
for (i in 1:2){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- createDataPartition(y=featuretable$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable[trainIndex,]
  testingSet<- featuretable[-trainIndex,]
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:22)])
  testingSet$rightPred <- prediction == testingSet$layer
  t<-table(prediction, testingSet$layer)
  print(t)
  accuracy <- sum(testingSet$rightPred)/nrow(testingSet)
  accuracies <- c(accuracies,accuracy)
  print(accuracy)
}

# predict for sub-region


# predict for whole study area
predLC <- predict(lidarmetrics, model=modelRF, na.rm=TRUE)

writeRaster(predLC, filename="classified.tif", format="GTiff",overwrite=TRUE)