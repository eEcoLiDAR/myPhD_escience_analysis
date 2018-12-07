"
@author: Zsofia Koma, UvA
Aim: Explore LiDAR metrics based on validation dataw

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
setwd("D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/tiled") # working directory

# Import
training = rgdal::readOGR("training_buffer3.shp")
plot(training)

# LiDAR metrics
eiglargest=raster("mosaic_eigenlargest.tif")
eigmedium=raster("mosaic_eigenmedium.tif")
eigsmallest=raster("mosaic_eigensmallest.tif")
ani=raster("mosaic_anisotropy.tif")
curva=raster("mosaic_curvature.tif")
lin=raster("mosaic_linearity.tif")
plan=raster("mosaic_planarity.tif")
sph=raster("mosaic_sphericity.tif")

shape_lidarmetrics = addLayer(eiglargest,eigmedium,eigsmallest,ani,curva,lin,plan,sph)

height_max=raster("mosaic_heightq090.tif")
height_025=raster("mosaic_heightq025.tif")
height_075=raster("mosaic_heightq075.tif")
height_med=raster("mosaic_heightmedian.tif")
height_mean=raster("mosaic_heightmean.tif")

height_metrics = addLayer(height_max,height_025,height_075,height_med,height_mean)

heightcover=raster("mosaic_pulsepenrat.tif")

heightskew=raster("mosaic_heightskew.tif")
height_std=raster("mosaic_heightstd.tif")
height_kurto=raster("mosaic_heightkurto.tif")
height_var=raster("mosaic_heightvar.tif")

distribution_metrics = addLayer(heightskew,height_kurto,height_std,height_var)

height_dtm=raster("mosaic_terrainmean.tif")
height_dtmvar=raster("mosaic_terrainvar.tif")

terrainmetrics = addLayer(height_dtm,height_dtmvar)

# Preprocess import data (rasterizing, masking)

classes_rast_veg_h <- rasterize(training,height_max,field="Vegetation")
classes_rast_str_h <- rasterize(training,height_max,field="Structure")

classes_rast_veg_cov <- rasterize(training,heightcover,field="Vegetation")
classes_rast_str_cov <- rasterize(training,heightcover,field="Structure")

classes_rast_veg_shap <- rasterize(training,ani,field="Vegetation")
classes_rast_str_shap <- rasterize(training,ani,field="Structure")

classes_rast_veg_dist <- rasterize(training,height_std,field="Vegetation")
classes_rast_str_dist <- rasterize(training,height_std,field="Structure")

classes_rast_veg_dtm <- rasterize(training,height_dtmvar,field="Vegetation")
classes_rast_str_dtm <- rasterize(training,height_dtmvar,field="Structure")

# Reduce to specific extent

area_ofint = extent(206000,212000,596000,598000)

classes_rast_veg_h_c=crop(classes_rast_veg_h, area_ofint)
classes_rast_str_h_c=crop(classes_rast_str_h, area_ofint)

height_metrics_c=crop(height_metrics, area_ofint)

classes_rast_veg_cov_c=crop(classes_rast_veg_cov, area_ofint)
classes_rast_str_cov_c=crop(classes_rast_str_cov, area_ofint)

cover_metrics_c=crop(heightcover, area_ofint)

classes_rast_veg_shap_c=crop(classes_rast_veg_shap, area_ofint)
classes_rast_str_shap_c=crop(classes_rast_str_shap, area_ofint)

shape_lidarmetrics_c=crop(shape_lidarmetrics, area_ofint)

classes_rast_veg_dist_c=crop(classes_rast_veg_dist, area_ofint)
classes_rast_str_dist_c=crop(classes_rast_str_dist, area_ofint)

distribution_metrics_c=crop(distribution_metrics, area_ofint)

classes_rast_veg_dtm_c=crop(classes_rast_veg_dtm, area_ofint)
classes_rast_str_dtm_c=crop(classes_rast_str_dtm, area_ofint)

dtm_metrics_c=crop(terrainmetrics, area_ofint)

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

pdf("plots.pdf")

ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightq090,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightq025,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightq075,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightmedian,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_h, aes(group=layer.2, x=layer.2,y=mosaic_heightmean,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_cov, aes(group=layer.2, x=layer.2,y=mosaic_pulsepenrat,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_eigenlargest,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_eigenmedium,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_eigensmallest,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_anisotropy,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_curvature,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_linearity,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_planarity,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_shap, aes(group=layer.2, x=layer.2,y=mosaic_sphericity,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_dist, aes(group=layer.2, x=layer.2,y=mosaic_heightstd,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_dist, aes(group=layer.2, x=layer.2,y=mosaic_heightkurto,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_dist, aes(group=layer.2, x=layer.2,y=mosaic_heightskew,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_dist, aes(group=layer.2, x=layer.2,y=mosaic_heightvar,color=as.factor(layer.1))) + geom_boxplot()

ggplot(featuretable_dtm, aes(group=layer.2, x=layer.2,y=mosaic_terrainmean,color=as.factor(layer.1))) + geom_boxplot()
ggplot(featuretable_dtm, aes(group=layer.2, x=layer.2,y=mosaic_terrainvar,color=as.factor(layer.1))) + geom_boxplot()

dev.off()