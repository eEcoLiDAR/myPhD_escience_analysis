"
@author: Zsofia Koma, UvA
Aim: intersection between training and features
"
library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory
setwd("D:/Koma/Paper1/ALS/forClassification/")

# Import

#classes = rgdal::readOGR("selpolyper_level1_v4.shp")
classes = rgdal::readOGR("selpolyper_level2_v4.shp")

classes@data$V4=as.numeric(factor(classes@data$V3))

#lidarmetrics=stack("lidarmetrics_forClassification.grd")
lidarmetrics=stack("lidarmetrics_forlevel2.grd")

# Masking
classes_rast <- rasterize(classes, lidarmetrics[[1]],field="V4")
#writeRaster(classes_rast,"test_polygonasraster.tif")

masked <- mask(lidarmetrics, classes_rast)

# convert training data into the right format
trainingbrick <- addLayer(masked, classes_rast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

#write.table(featuretable,"featuretable_level1_b2o5.csv",row.names=FALSE,sep=",")
write.table(featuretable,"featuretable_level2_b2o5.csv",row.names=FALSE,sep=",")
#write.table(featuretable,"featuretable_level3_b2o5.csv",row.names=FALSE,sep=",")