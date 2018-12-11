"
@author: Zsofia Koma, UvA
Aim: classify
"
library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)
library(pROC)

# Set global variables
setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory

level1="featuretable_level1_b2o5.csv"
level2="featuretable_level2_b2o5.csv"
level3="featuretable_level3_b2o5.csv"

lidar="lidarmetrics_forClassification.grd"

pdf("rplot.pdf") 

# Import

featuretable_level1=read.csv(level1)
featuretable_level2=read.csv(level2)
featuretable_level3=read.csv(level3)

lidarmetrics=stack(lidar)

unique(featuretable_level1$layer)
unique(featuretable_level2$layer)
unique(featuretable_level3$layer)

# apply RF
modelRF_level1 <- randomForest(x=featuretable_level1[ ,c(1:22)], y=factor(featuretable_level1$layer),importance = TRUE)
class(modelRF_level1)
varImpPlot(modelRF_level1)

modelRF_level2 <- randomForest(x=featuretable_level2[ ,c(1:22)], y=factor(featuretable_level2$layer),importance = TRUE)
class(modelRF_level2)
varImpPlot(modelRF_level2)

modelRF_level3 <- randomForest(x=featuretable_level3[ ,c(1:22)], y=factor(featuretable_level3$layer),importance = TRUE)
class(modelRF_level3)
varImpPlot(modelRF_level3)

# RF other way round

trainIndex <- caret::createDataPartition(y=featuretable_level1$layer, p=0.75, list=FALSE)
trainingSet<- featuretable_level1[trainIndex,]
testingSet<- featuretable_level1[-trainIndex,]

#modelRF_level1_v2 <- train(layer~., tuneLength = 3, data = trainingSet, method = "rf", importance = TRUE, trControl = trainControl(method = "cv", number = 5, savePredictions = "final", classProbs = T))

modelFit <- randomForest(factor(layer)~.,data=trainingSet)
prediction <- predict(modelFit,testingSet[ ,c(1:22)])

confusionMatrix(factor(prediction), factor(testingSet$layer))

prediction_prob <- predict(modelFit,testingSet[ ,c(1:22)],type="prob")

for (i in 1:3) {
  result.roc <- roc(testingSet$layer, prediction_prob[,i])
  plot(result.roc,print.thres="best", print.thres.best.method="closest.topleft")
  title(paste(i))
}

trainIndex <- caret::createDataPartition(y=featuretable_level2$layer, p=0.75, list=FALSE)
trainingSet<- featuretable_level2[trainIndex,]
testingSet<- featuretable_level2[-trainIndex,]

#modelRF_level1_v2 <- train(layer~., tuneLength = 3, data = trainingSet, method = "rf", importance = TRUE, trControl = trainControl(method = "cv", number = 5, savePredictions = "final", classProbs = T))

modelFit <- randomForest(factor(layer)~.,data=trainingSet)
prediction <- predict(modelFit,testingSet[ ,c(1:22)])

confusionMatrix(factor(prediction), factor(testingSet$layer))

prediction_prob <- predict(modelFit,testingSet[ ,c(1:22)],type="prob")

for (i in 1:6) {
  print(i)
  result.roc <- roc(testingSet$layer, prediction_prob[,i])
  plot(result.roc,print.thres="best", print.thres.best.method="closest.topleft")
  title(paste(i))
}

trainIndex <- caret::createDataPartition(y=featuretable_level3$layer, p=0.75, list=FALSE)
trainingSet<- featuretable_level3[trainIndex,]
testingSet<- featuretable_level3[-trainIndex,]

#modelRF_level1_v2 <- train(layer~., tuneLength = 3, data = trainingSet, method = "rf", importance = TRUE, trControl = trainControl(method = "cv", number = 5, savePredictions = "final", classProbs = T))

modelFit <- randomForest(factor(layer)~.,data=trainingSet)
prediction <- predict(modelFit,testingSet[ ,c(1:22)])

confusionMatrix(factor(prediction), factor(testingSet$layer))

prediction_prob <- predict(modelFit,testingSet[ ,c(1:22)],type="prob")

for (i in 1:9) {
  print(i)
  result.roc <- roc(testingSet$layer, prediction_prob[,i])
  plot(result.roc,print.thres="best", print.thres.best.method="closest.topleft")
  title(paste(i))
}

# accuracy assessment
first_seed <- 2
accuracies <-c()
for (i in 1:2){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- caret::createDataPartition(y=featuretable_level1$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable_level1[trainIndex,]
  testingSet<- featuretable_level1[-trainIndex,]
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:22)])
  testingSet$rightPred <- prediction == testingSet$layer
  t<-table(prediction, testingSet$layer)
  print(t)
  accuracy <- sum(testingSet$rightPred)/nrow(testingSet)
  accuracies <- c(accuracies,accuracy)
  print(accuracy)
}

first_seed <- 2
accuracies <-c()
for (i in 1:2){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- caret::createDataPartition(y=featuretable_level2$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable_level2[trainIndex,]
  testingSet<- featuretable_level2[-trainIndex,]
  modelFit <- randomForest(factor(layer)~.,data=trainingSet)
  prediction <- predict(modelFit,testingSet[ ,c(1:22)])
  testingSet$rightPred <- prediction == testingSet$layer
  t<-table(prediction, testingSet$layer)
  print(t)
  accuracy <- sum(testingSet$rightPred)/nrow(testingSet)
  accuracies <- c(accuracies,accuracy)
  print(accuracy)
}

first_seed <- 2
accuracies <-c()
for (i in 1:2){
  set.seed(first_seed)
  first_seed <- first_seed+1
  trainIndex <- caret::createDataPartition(y=featuretable_level3$layer, p=0.75, list=FALSE)
  trainingSet<- featuretable_level3[trainIndex,]
  testingSet<- featuretable_level3[-trainIndex,]
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
crop_lidarmetrics=crop(lidarmetrics,extent(206573,209611,594309,597140))

predLC_crop_level1 <- predict(crop_lidarmetrics, model=modelRF_level1, na.rm=TRUE)
predLC_crop_level2 <- predict(crop_lidarmetrics, model=modelRF_level2, na.rm=TRUE)
predLC_crop_level3 <- predict(crop_lidarmetrics, model=modelRF_level3, na.rm=TRUE)

cols_level1 <- c("grey", "dark green", "darkslategray1")
plot(predLC_crop_level1,col=cols_level1)

cols_level2 <- c("grey", "dark green", "chartreuse","darkgoldenrod1","darkolivegreen4","darkslategray1")
plot(predLC_crop_level2,col=cols_level2)

cols_level3 <- c("grey", "dark green", "chartreuse","darkgoldenrod1","darkgoldenrod3","darkorange1","darkolivegreen4","darkkhaki","darkslategray1")
plot(predLC_crop_level3,col=cols_level3)

dev.off()

# predict for whole study area
#predLC <- predict(lidarmetrics, model=modelRF, na.rm=TRUE)
#writeRaster(predLC, filename="classified.tif", format="GTiff",overwrite=TRUE)