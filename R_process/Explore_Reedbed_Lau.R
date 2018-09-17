"
@author: Zsofia Koma, UvA
Aim: Explore LiDAR metrics based on validation data

input:
output:

Fuctions:
By feature groups (different extents cannot be merged at the moment):
  - Height
  - Cover
  - Structure
    - 3D shape
    - Distribution
  - DTM

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
library(rgdal)

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/WholeLau_TotalVegetation") # working directory

# Import
training = rgdal::readOGR("D:/Koma/Paper1_ReedStructure/training_buffer3.shp")
plot(training)

# Height
height_max=raster("mosaic_heightmax.tif")
height_med=raster("mosaic_heightmedian.tif")

height_metrics = addLayer(height_max,height_med)

# Coverage
cover=raster("mosaic_pulsepenrat.tif")

# 3D shape
ani=raster("mosaic_anisotropy.tif")
curva=raster("mosaic_curvature.tif")
omni=raster("mosaic_omnivariance.tif")

shape_lidarmetrics = addLayer(ani,curva,omni)

# Distribution
heightkurto=raster("mosaic_heightkurto.tif")
height_std=raster("mosaic_heightstd.tif")

distribution_metrics = addLayer(heightkurto,height_std)

# DTM
dtm_var=raster("mosaic_terrainvar.tif")

# Preprocess import data (rasterizing, masking)

classes_rast_veg_h <- rasterize(training,height_max,field="Vegetation")
classes_rast_str_h <- rasterize(training,height_max,field="Structure")

classes_rast_veg_cov <- rasterize(training,cover,field="Vegetation")
classes_rast_str_cov <- rasterize(training,cover,field="Structure")

classes_rast_veg_shap <- rasterize(training,ani,field="Vegetation")
classes_rast_str_shap <- rasterize(training,ani,field="Structure")

classes_rast_veg_dist <- rasterize(training,height_std,field="Vegetation")
classes_rast_str_dist <- rasterize(training,height_std,field="Structure")

classes_rast_veg_dtm <- rasterize(training,dtm_var,field="Vegetation")
classes_rast_str_dtm <- rasterize(training,dtm_var,field="Structure")

# Reduce to specific extent

area_ofint = extent(206000,212000,596000,598000)

classes_rast_veg_h_c=crop(classes_rast_veg_h, area_ofint)
classes_rast_str_h_c=crop(classes_rast_str_h, area_ofint)

height_metrics_c=crop(height_metrics, area_ofint)

classes_rast_veg_cov_c=crop(classes_rast_veg_cov, area_ofint)
classes_rast_str_cov_c=crop(classes_rast_str_cov, area_ofint)

cover_metrics_c=crop(cover, area_ofint)

classes_rast_veg_shap_c=crop(classes_rast_veg_shap, area_ofint)
classes_rast_str_shap_c=crop(classes_rast_str_shap, area_ofint)

shape_lidarmetrics_c=crop(shape_lidarmetrics, area_ofint)

classes_rast_veg_dist_c=crop(classes_rast_veg_dist, area_ofint)
classes_rast_str_dist_c=crop(classes_rast_str_dist, area_ofint)

distribution_metrics_c=crop(distribution_metrics, area_ofint)

classes_rast_veg_dtm_c=crop(classes_rast_veg_dtm, area_ofint)
classes_rast_str_dtm_c=crop(classes_rast_str_dtm, area_ofint)

dtm_metrics_c=crop(dtm_var, area_ofint)

# Masking
masked_h <- mask(height_metrics_c, classes_rast_veg_h_c)
masked_cov <- mask(cover_metrics_c, classes_rast_veg_cov_c)
masked_shap <- mask(shape_lidarmetrics_c, classes_rast_veg_shap_c)
masked_dist <- mask(distribution_metrics_c, classes_rast_veg_dist_c)
masked_dtm <- mask(dtm_metrics_c, classes_rast_veg_dtm_c)

trainingbrick_h <- addLayer(masked_h, classes_rast_veg_h_c,classes_rast_str_h_c)
trainingbrick_cov <- addLayer(masked_cov, classes_rast_veg_cov_c,classes_rast_str_cov_c)
trainingbrick_shap <- addLayer(masked_shap, classes_rast_veg_shap_c,classes_rast_str_shap_c)
trainingbrick_dist <- addLayer(masked_dist, classes_rast_veg_dist_c,classes_rast_str_dist_c)
trainingbrick_dtm <- addLayer(masked_dtm, classes_rast_veg_dtm_c,classes_rast_str_dtm_c)

featuretable_h <- getValues(trainingbrick_h)
featuretable_cov <- getValues(trainingbrick_cov)
featuretable_shap <- getValues(trainingbrick_shap)
featuretable_dist <- getValues(trainingbrick_dist)
featuretable_dtm <- getValues(trainingbrick_dtm)

featuretable_h <- na.omit(featuretable_h)
featuretable_cov <- na.omit(featuretable_cov)
featuretable_shap <- na.omit(featuretable_shap)
featuretable_dist <- na.omit(featuretable_dist)
featuretable_dtm <- na.omit(featuretable_dtm)

featuretable_h <- as.data.frame(featuretable_h)
featuretable_cov <- as.data.frame(featuretable_cov)
featuretable_shap <- as.data.frame(featuretable_shap)
featuretable_dist <- as.data.frame(featuretable_dist)
featuretable_dtm <- as.data.frame(featuretable_dtm)

# Visualize
# Boxplot

ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightmax,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightmedian,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_cov, aes(group=layer.2, x=layer.2,y=mosaic_pulsepenrat,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_anisotropy,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_curvature,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_omnivariance,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_dist, aes(group=layer.2, x=layer.2,y=mosaic_heightstd,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_dist, aes(group=layer.2, x=layer.2,y=mosaic_heightkurto,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_dtm, aes(group=layer.2, x=layer.2,y=mosaic_terrainvar,color=as.factor(layer.1))) + geom_boxplot()

