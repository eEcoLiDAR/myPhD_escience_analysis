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
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory
setwd("D:/Koma/Paper1/ALS/forClassification4/")

level1="featuretable_level2_b2o5.csv"

lidar="lidarmetrics_forlevel2.grd"

pdf("level2plot.pdf") 

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

conf_m=confusionMatrix(factor(prediction), factor(testingSet$layer),mode = "everything")
conf_m

#Export accuracy report 
tocsv_t <- data.frame(conf_m$table)
write.csv(tocsv_t,file="conf_m_level1.csv")

tocsv_oa <- data.frame(conf_m$overall)
write.csv(tocsv_oa,file="acc_oa_level1.csv")

tocsv_cl <- data.frame(conf_m$byClass)
write.csv(tocsv_cl,file="acc_byclass_level1.csv")

sink("acc_level1.txt")
print(conf_m)
sink()  # returns output to the console

prediction_prob <- predict(modelFit,testingSet[ ,c(1:22)],type="prob")

for (i in 1:6) {
  result.roc <- roc(testingSet$layer, prediction_prob[,i])
  plot(result.roc,print.thres="best", print.thres.best.method="closest.topleft")
  title(paste("class:",i,"AUC",auc(result.roc)))
  print(auc(result.roc))
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

cols_level1 <- c("grey", "dark green", "chartreuse","darkgoldenrod1","darkolivegreen4","darkslategray1")
plot(predLC_crop_level1_1,col=cols_level1)

crop_lidarmetrics2=crop(lidarmetrics,extent(205462,207261,598308,600314))

predLC_crop_level1_2 <- predict(crop_lidarmetrics2, model=modelRF_level1, na.rm=TRUE)

plot(predLC_crop_level1_2,col=cols_level1)

crop_lidarmetrics3=crop(lidarmetrics,extent(207790,210179,597664,600168))

predLC_crop_level1_3 <- predict(crop_lidarmetrics3, model=modelRF_level1, na.rm=TRUE)

plot(predLC_crop_level1_3,col=cols_level1)

#predict probabilities

crop_lidarmetrics1_pt = rasterToPoints(crop_lidarmetrics1)
crop_lidarmetrics1_df = data.frame(crop_lidarmetrics1_pt)
crop_lidarmetrics1_df = na.omit(crop_lidarmetrics1_df)

predLC_crop_level1_1_prob_df = predict(modelRF_level1,crop_lidarmetrics1_df[ ,c(3:24)], type = "prob")
predLC_crop_level1_1_prob_df_merged <- cbind(crop_lidarmetrics1_df$x, crop_lidarmetrics1_df$y, predLC_crop_level1_1_prob_df) 
level1_reg1_prob_class1=rasterFromXYZ(predLC_crop_level1_1_prob_df_merged[,c(1,2,3)])
level1_reg1_prob_class2=rasterFromXYZ(predLC_crop_level1_1_prob_df_merged[,c(1,2,4)])
level1_reg1_prob_class3=rasterFromXYZ(predLC_crop_level1_1_prob_df_merged[,c(1,2,5)])
level1_reg1_prob_class4=rasterFromXYZ(predLC_crop_level1_1_prob_df_merged[,c(1,2,6)])
level1_reg1_prob_class5=rasterFromXYZ(predLC_crop_level1_1_prob_df_merged[,c(1,2,7)])
level1_reg1_prob_class6=rasterFromXYZ(predLC_crop_level1_1_prob_df_merged[,c(1,2,8)])

plot(level1_reg1_prob_class1)
plot(level1_reg1_prob_class2)
plot(level1_reg1_prob_class3)
plot(level1_reg1_prob_class4)
plot(level1_reg1_prob_class5)
plot(level1_reg1_prob_class6)

crop_lidarmetrics2_pt = rasterToPoints(crop_lidarmetrics2)
crop_lidarmetrics2_df = data.frame(crop_lidarmetrics2_pt)
crop_lidarmetrics2_df = na.omit(crop_lidarmetrics2_df)

predLC_crop_level1_2_prob_df = predict(modelRF_level1,crop_lidarmetrics2_df[ ,c(3:24)], type = "prob")
predLC_crop_level1_2_prob_df_merged <- cbind(crop_lidarmetrics2_df$x, crop_lidarmetrics2_df$y, predLC_crop_level1_2_prob_df) 
level1_reg2_prob_class1=rasterFromXYZ(predLC_crop_level1_2_prob_df_merged[,c(1,2,3)])
level1_reg2_prob_class2=rasterFromXYZ(predLC_crop_level1_2_prob_df_merged[,c(1,2,4)])
level1_reg2_prob_class3=rasterFromXYZ(predLC_crop_level1_2_prob_df_merged[,c(1,2,5)])
level1_reg2_prob_class4=rasterFromXYZ(predLC_crop_level1_2_prob_df_merged[,c(1,2,6)])
level1_reg2_prob_class5=rasterFromXYZ(predLC_crop_level1_2_prob_df_merged[,c(1,2,7)])
level1_reg2_prob_class6=rasterFromXYZ(predLC_crop_level1_2_prob_df_merged[,c(1,2,8)])

plot(level1_reg2_prob_class1)
plot(level1_reg2_prob_class2)
plot(level1_reg2_prob_class3)
plot(level1_reg2_prob_class4)
plot(level1_reg2_prob_class5)
plot(level1_reg2_prob_class6)

crop_lidarmetrics3_pt = rasterToPoints(crop_lidarmetrics3)
crop_lidarmetrics3_df = data.frame(crop_lidarmetrics3_pt)
crop_lidarmetrics3_df = na.omit(crop_lidarmetrics3_df)

predLC_crop_level1_3_prob_df = predict(modelRF_level1,crop_lidarmetrics3_df[ ,c(3:24)], type = "prob")
predLC_crop_level1_3_prob_df_merged <- cbind(crop_lidarmetrics3_df$x, crop_lidarmetrics3_df$y, predLC_crop_level1_3_prob_df) 
level1_reg3_prob_class1=rasterFromXYZ(predLC_crop_level1_3_prob_df_merged[,c(1,2,3)])
level1_reg3_prob_class2=rasterFromXYZ(predLC_crop_level1_3_prob_df_merged[,c(1,2,4)])
level1_reg3_prob_class3=rasterFromXYZ(predLC_crop_level1_3_prob_df_merged[,c(1,2,5)])
level1_reg3_prob_class4=rasterFromXYZ(predLC_crop_level1_3_prob_df_merged[,c(1,2,6)])
level1_reg3_prob_class5=rasterFromXYZ(predLC_crop_level1_3_prob_df_merged[,c(1,2,7)])
level1_reg3_prob_class6=rasterFromXYZ(predLC_crop_level1_3_prob_df_merged[,c(1,2,8)])

plot(level1_reg3_prob_class1)
plot(level1_reg3_prob_class2)
plot(level1_reg3_prob_class3)
plot(level1_reg3_prob_class4)
plot(level1_reg3_prob_class5)
plot(level1_reg3_prob_class6)

dev.off()

writeRaster(predLC_crop_level1_1, filename="classified_reg1_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class1, filename="classified_prob_class1_reg1_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class2, filename="classified_prob_class2_reg1_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class3, filename="classified_prob_class3_reg1_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class4, filename="classified_prob_class4_reg1_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class5, filename="classified_prob_class5_reg1_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class6, filename="classified_prob_class6_reg1_lev2.tif", format="GTiff",overwrite=TRUE)

writeRaster(predLC_crop_level1_2, filename="classified_reg2_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg2_prob_class1, filename="classified_prob_class1_reg2_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg2_prob_class2, filename="classified_prob_class2_reg2_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg2_prob_class3, filename="classified_prob_class3_reg2_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg2_prob_class4, filename="classified_prob_class4_reg2_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg2_prob_class5, filename="classified_prob_class5_reg2_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class6, filename="classified_prob_class6_reg2_lev2.tif", format="GTiff",overwrite=TRUE)

writeRaster(predLC_crop_level1_3, filename="classified_reg3_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg3_prob_class1, filename="classified_prob_class1_reg3_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg3_prob_class2, filename="classified_prob_class2_reg3_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg3_prob_class3, filename="classified_prob_class3_reg3_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg3_prob_class4, filename="classified_prob_class4_reg3_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg3_prob_class5, filename="classified_prob_class5_reg3_lev2.tif", format="GTiff",overwrite=TRUE)
writeRaster(level1_reg1_prob_class6, filename="classified_prob_class6_reg3_lev2.tif", format="GTiff",overwrite=TRUE)

# predict for whole study area
predLC <- predict(lidarmetrics, model=modelRF_level1, na.rm=TRUE)
writeRaster(predLC, filename="classified_level2.tif", format="GTiff",overwrite=TRUE)