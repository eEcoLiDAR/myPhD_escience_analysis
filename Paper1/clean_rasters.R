"
@author: Zsofia Koma, UvA
Aim: Clean up and merge LiDAR metrics
"
#install.packages(c("sp","rgdal","raster","spatialEco","rgeos","plyr","dplyr","maptools","gridExtra","ggplot2","ggmap","maps","mapdata"))

library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

# global variables

#args = commandArgs(trailingOnly=TRUE)

#workingdirectory=args[1]
#filename=args[2]

workingdirectory="D:/Koma/Paper1/ALS/forClassification/"
filename_tile1="alltiles_fea_2o5m.tif"

setwd(workingdirectory)

# Import
lidar_tile1=stack(filename_tile1)
names(lidar_tile1) <- c('z','dens_ab_mean','eigv1','eigv2','eigv3','gpstime','int','kurto_z','max_z',
                        'mean_z','median_z','min_z','perc_10','perc_30','perc_50','perc_70','perc_90',
                        'pdens','pulsepenratio','class','skew_z','std_z','var_z','z_entrop',
                        'n_max_z','n_mean_z','n_median_z','n_perc_10','n_perc_30','n_perc_50',
                        'n_perc_70','n_perc_90','dtm','aspect','roughness','shd','slope')

#lidar_tile1@layers

# Calculate eigenvalue metrics
lidar_tile1$linearity=(lidar_tile1$eigv1-lidar_tile1$eigv1)/lidar_tile1$eigv1
lidar_tile1$planarity=(lidar_tile1$eigv2-lidar_tile1$eigv3)/lidar_tile1$eigv1
lidar_tile1$sphericity=lidar_tile1$eigv3/lidar_tile1$eigv1
lidar_tile1$anisotropy=(lidar_tile1$eigv1-lidar_tile1$eigv3)/lidar_tile1$eigv1
lidar_tile1$curvature=lidar_tile1$eigv3/(lidar_tile1$eigv1+lidar_tile1$eigv2+lidar_tile1$eigv3)

# Select menaingful layers and export
lidarmetrics <- subset(lidar_tile1, c(8,19,21,22,23,24,25,26,27,28,29,30,31,32,34,35,37,38,39,40,41,42), drop=FALSE)
crs(lidarmetrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(lidarmetrics, "lidarmetrics_forClassification.grd",overwrite=TRUE)

support_raster <- subset(lidar_tile1, c(12,18,34,37))
crs(lidarmetrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(support_raster, "support_raster.grd",overwrite=TRUE)
