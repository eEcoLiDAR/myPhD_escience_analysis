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
  featuretable <- na.omit(featuretable)
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

Analysis_FeatureImportance = function(forest)
{
  library(randomForestExplainer)
  
  importance_frame <- measure_importance(forest)
  
  importance_frame$norm_accuracy_decrease <- (importance_frame$accuracy_decrease-min(importance_frame$accuracy_decrease))/(max(importance_frame$accuracy_decrease)-min(importance_frame$accuracy_decrease))
  importance_frame$norm_gini_decrease <- (importance_frame$gini_decrease-min(importance_frame$gini_decrease))/(max(importance_frame$gini_decrease)-min(importance_frame$gini_decrease))
  
  return(importance_frame)
}

Response_l1 = function(forest_l1,featuretable_l1,id) {
  p1=partialPlot(forest_l1, featuretable_l1, impvar[id], 1, plot=FALSE)
  p2=partialPlot(forest_l1, featuretable_l1, impvar[id], 2, plot=FALSE)
  
  response_l1_c1 <- data.frame(p1[["x"]], p1[["y"]])
  names(response_l1_c1)[1]<-"class_1_x"
  names(response_l1_c1)[2]<-"class_1_y"
  response_l1_c1$class <- 1
  
  response_l1_c2 <- data.frame(p2[["x"]], p2[["y"]])
  names(response_l1_c2)[1]<-"class_1_x"
  names(response_l1_c2)[2]<-"class_1_y"
  response_l1_c2$class <- 2
  
  response_l1 <- rbind(response_l1_c1, response_l1_c2)
  
  return(response_l1)
}

Response_l2 = function(forest_l1,featuretable_l1,id) {
  p1=partialPlot(forest_l1, featuretable_l1, impvar[id], 1, plot=FALSE)
  p2=partialPlot(forest_l1, featuretable_l1, impvar[id], 2, plot=FALSE)
  p3=partialPlot(forest_l1, featuretable_l1, impvar[id], 3, plot=FALSE)
  p4=partialPlot(forest_l1, featuretable_l1, impvar[id], 4, plot=FALSE)
  p5=partialPlot(forest_l1, featuretable_l1, impvar[id], 5, plot=FALSE)
  
  response_l1_c1 <- data.frame(p1[["x"]], p1[["y"]])
  names(response_l1_c1)[1]<-"class_1_x"
  names(response_l1_c1)[2]<-"class_1_y"
  response_l1_c1$class <- 1
  
  response_l1_c2 <- data.frame(p2[["x"]], p2[["y"]])
  names(response_l1_c2)[1]<-"class_1_x"
  names(response_l1_c2)[2]<-"class_1_y"
  response_l1_c2$class <- 2
  
  response_l1_c3 <- data.frame(p3[["x"]], p3[["y"]])
  names(response_l1_c3)[1]<-"class_1_x"
  names(response_l1_c3)[2]<-"class_1_y"
  response_l1_c3$class <- 3
  
  response_l1_c4 <- data.frame(p4[["x"]], p4[["y"]])
  names(response_l1_c4)[1]<-"class_1_x"
  names(response_l1_c4)[2]<-"class_1_y"
  response_l1_c4$class <- 4
  
  response_l1_c5 <- data.frame(p5[["x"]], p5[["y"]])
  names(response_l1_c5)[1]<-"class_1_x"
  names(response_l1_c5)[2]<-"class_1_y"
  response_l1_c5$class <- 5
  
  response_l1 <- rbind(response_l1_c1, response_l1_c2, response_l1_c3, response_l1_c4, response_l1_c5)
  
  return(response_l1)
}

Response_l3 = function(forest_l1,featuretable_l1,id) {
  p1=partialPlot(forest_l1, featuretable_l1, impvar[id], 1, plot=FALSE)
  p2=partialPlot(forest_l1, featuretable_l1, impvar[id], 2, plot=FALSE)
  p3=partialPlot(forest_l1, featuretable_l1, impvar[id], 3, plot=FALSE)
  
  response_l1_c1 <- data.frame(p1[["x"]], p1[["y"]])
  names(response_l1_c1)[1]<-"class_1_x"
  names(response_l1_c1)[2]<-"class_1_y"
  response_l1_c1$class <- 1
  
  response_l1_c2 <- data.frame(p2[["x"]], p2[["y"]])
  names(response_l1_c2)[1]<-"class_1_x"
  names(response_l1_c2)[2]<-"class_1_y"
  response_l1_c2$class <- 2
  
  response_l1_c3 <- data.frame(p3[["x"]], p3[["y"]])
  names(response_l1_c3)[1]<-"class_1_x"
  names(response_l1_c3)[2]<-"class_1_y"
  response_l1_c3$class <- 3
  
  response_l1 <- rbind(response_l1_c1, response_l1_c2, response_l1_c3)
  
  return(response_l1)
}