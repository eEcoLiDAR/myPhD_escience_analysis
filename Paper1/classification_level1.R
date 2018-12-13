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

lidar="lidarmetrics_forClassification.grd"

pdf("level1plot.pdf") 

# Import

featuretable_level1=read.csv(level1)

lidarmetrics=stack(lidar)

unique(featuretable_level1$layer)

# apply RF
modelRF_level1 <- randomForest(x=featuretable_level1[ ,c(1:22)], y=factor(featuretable_level1$layer),importance = TRUE)
class(modelRF_level1)
varImpPlot(modelRF_level1)

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



# accuracy assessment
first_seed <- 3
accuracies <-c()
for (i in 1:3){
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


# predict for sub-region
crop_lidarmetrics1=crop(lidarmetrics,extent(206573,209611,594309,597140))

predLC_crop_level1_1 <- predict(crop_lidarmetrics1, model=modelRF_level1, na.rm=TRUE)

cols_level1 <- c("grey", "dark green", "darkslategray1")
plot(predLC_crop_level1_1,col=cols_level1)

crop_lidarmetrics2=crop(lidarmetrics,extent(205462,207261,598308,600314))

predLC_crop_level1_2 <- predict(crop_lidarmetrics2, model=modelRF_level1, na.rm=TRUE)

cols_level1 <- c("grey", "dark green", "darkslategray1")
plot(predLC_crop_level1_2,col=cols_level1)

crop_lidarmetrics3=crop(lidarmetrics,extent(207790,210179,597664,600168))

predLC_crop_level1_3 <- predict(crop_lidarmetrics3, model=modelRF_level1, na.rm=TRUE)

cols_level1 <- c("grey", "dark green", "darkslategray1")
plot(predLC_crop_level1_3,col=cols_level1)

dev.off()

writeRaster(predLC_crop_level1_1, filename="classified_reg1_lev1.tif", format="GTiff",overwrite=TRUE)
writeRaster(predLC_crop_level1_2, filename="classified_reg2_lev1.tif", format="GTiff",overwrite=TRUE)
writeRaster(predLC_crop_level1_3, filename="classified_reg3_lev1.tif", format="GTiff",overwrite=TRUE)