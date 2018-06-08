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

Question:
1. 

"

library(lidR)
library(rgdal)
library(sp)
library(spatialEco)
library(randomForest)

# Set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

# Import data
las = readLAS("lauwermeer_example.las")

classes = rgdal::readOGR("poly_forclasstest.shp")
#classes@data

# Calculate features
metrics=las %>% grid_metrics(.stdmetrics,res=1)
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
modelRF <- randomForest(x=featuretable[ ,c(1:4)], y=featuretable$layer,importance = TRUE)
class(modelRF)
modelRF$confusion
varImpPlot(modelRF)

# predict
predLC <- predict(lidar_metrics, model=modelRF, na.rm=TRUE)

names(featuretable)
names(lidar_metrics)

plot(predLC)
print(predLC)
