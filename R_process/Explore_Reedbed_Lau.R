"
@author: Zsofia Koma, UvA
Aim: Explore LiDAR metrics based on validation data

input:
output:

Fuctions:

Example: 

"

library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

library(maptools)
library(plyr)
library(rgeos)

library(ggplot2)

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/WholeLau_TotalVegetation") # working directory

# Import
training = rgdal::readOGR("D:/Koma/Paper1_ReedStructure/training_buffer3.shp")
plot(training)

#ani=raster("mosaic_anisotropy.tif")
#curva=raster("mosaic_curvature.tif")
#omni=raster("mosaic_omnivariance.tif")
heightkurto=raster("mosaic_heightkurto.tif")
height_max=raster("mosaic_heightmax.tif")
height_med=raster("mosaic_heightmedian.tif")
height_std=raster("mosaic_heightstd.tif")
height_dtm=raster("mosaic_meandtm.tif")


# Preprocess import data (rasterizing, masking)
classes_rast <- rasterize(training,height_max,field="Structure")
plot(classes_rast)

lidar_metrics = addLayer(heightkurto,height_max,height_med,height_std)

a_ofint = extent(206000,212000,596000,598000)
lidar_metrics_c=crop(lidar_metrics, a_ofint)
classes_rast_c=crop(classes_rast, a_ofint)

masked <- mask(lidar_metrics_c, classes_rast_c)

trainingbrick <- addLayer(masked, classes_rast_c)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

# create exploration analysis

ggplot(featuretable, aes(group=layer, x=layer,y=mosaic_heightstd)) + geom_boxplot()
