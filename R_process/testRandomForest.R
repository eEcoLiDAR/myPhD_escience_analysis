"
@author: Zsofia Koma, UvA
Aim: build a raster based classification workflow for processing LiDAR data
  
Input: las and shp files
Output: classified raster

Function:
1. Import ALS (las) file
2. Create features
3. Classify based on training data (Random Forest)
4. Plot the classification results
  
Example usage (from command line):   
  
ToDo: 
1. How to drop the NaN values
2. Export specific class as polygon

Question:
1. 

"

library(lidR)
library(rgdal)
library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
setwd("C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

# Import data
las = readLAS("lauwermeer_example.las")

classes = rgdal::readOGR("training_classes.shp")
#classes@data

# Calculate features
metrics=grid_metrics(las,.stdmetrics,res=5)
#nanvalues=sapply(metrics, function(x) all(is.nan(x)))
#metrics_filt=metrics[,!nanvalues]

# Feature export
max_z=as.raster(metrics[,c(1:2,6)])
std_z=as.raster(metrics[,c(1:2,8)])
skew_z=as.raster(metrics[,c(1:2,9)])
entr_z=as.raster(metrics[,c(1:2,10)])

lidar_metrics = addLayer(max_z, std_z, skew_z, entr_z)

plot(lidar_metrics)

plot(entr_z)
plot(classes, add = TRUE)

#writeRaster(max_z, filename="max_z.tif", format="GTiff")

# select training areas

classes_rast <- rasterize(classes, max_z,field="id")
plot(classes_rast)

masked <- mask(lidar_metrics, classes_rast)
plot(masked)

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

cols <- c("orange", "dark green")
plot(predLC,col=cols)
print(predLC)

# export 
#class_poly=rasterToPolygons(predLC,fun=function(x){x==1})
#writeOGR(class_poly, '.', 'class_test2', 'ESRI Shapefile')
writeRaster(predLC, filename="predLC.tif", format="GTiff")

#Extract only reed values within the classified raster
predLC_reed_mask <- setValues(raster(predLC), NA)
predLC_reed_mask[predLC<2] <- 1

#Extract layers for reedbeds
reed <- mask(lidar_metrics, predLC_reed_mask)
plot(reed)

#Export
writeRaster(reed, filename="reed.tif", format="GTiff")
