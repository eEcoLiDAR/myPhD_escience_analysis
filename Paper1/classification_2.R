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
classes = rgdal::readOGR("training.shp")
classes@data$V6=as.numeric(factor(classes@data$V4))

lidarmetrics=stack("lidarmetrics_forClassification.grd")

# Masking
classes_rast <- rasterize(classes, lidarmetrics[[1]],field="V6")

masked <- mask(lidarmetrics, classes_rast)

# convert training data into the right format
trainingbrick <- addLayer(masked, classes_rast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

write.table(featuretable,"featuretable.csv",row.names=FALSE,sep=",")

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

# predict
predLC <- predict(lidarmetrics, model=modelRF, na.rm=TRUE)

names(featuretable)
names(lidarmetrics)

plot(predLC)

writeRaster(predLC, filename="classified.tif", format="GTiff",overwrite=TRUE)