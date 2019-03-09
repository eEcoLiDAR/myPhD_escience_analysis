"
@author: Zsofia Koma, UvA
Aim: Functions for classification process
"

Create_Intersection = function(classes,lidarmetrics)
{
  library(raster)
  library(sp)
  library(spatialEco)
  
  classes@data$V4=as.numeric(factor(classes@data$V3))
  
  # Masking
  classes_rast <- rasterize(classes, lidarmetrics[[1]],field="V4")
  masked <- mask(lidarmetrics, classes_rast)
  
  # convert training data into the right format
  trainingbrick <- addLayer(masked, classes_rast)
  featuretable <- getValues(trainingbrick)
  #featuretable <- na.omit(featuretable)
  featuretable <- as.data.frame(featuretable)
  
  return(featuretable)
}

Classification_werrorass = function(featuretable_level1,lidarmetrics,level_id) 
{
  library(randomForest)
  library(caret)
  
  trainIndex <- caret::createDataPartition(y=featuretable_level1$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable_level1[trainIndex,]
  testingSet<- featuretable_level1[-trainIndex,]
  
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:29)])
  
  conf_m=confusionMatrix(factor(prediction), factor(testingSet$layer),mode = "everything")
  
  sink(paste(level_id,"acc.txt",sep=""))
  print(conf_m)
  sink()
  
  predLC <- predict(lidarmetrics, model=modelFit, na.rm=TRUE)
  
  return(predLC)
}