"
@author: Zsofia Koma, UvA
Aim: preprocess bird data for Global Ecology and Biodiversity course
"

# Import libraries
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

# Set global variables
full_path="C:/Users/zsofi/Google Drive/_Amsterdam/00_PhD/Teaching/MScCourse_GlobEcol_Biodiv/Project_dataset/Data_Prep/lidar/"

lidar_data_run1="terrainData100m_run1_filtered.tif"
lidar_data_run2="terrainData100m_run2_filtered.tif"

setwd(full_path)

# Import
lidar_run1=stack(lidar_data_run1)
names(lidar_run1) <- c("kurto_z_all","mean_z_all","max_z_all","perc_10_all","perc_30_all","perc_50_all","perc_70_all"
                       ,"perc_90_all","point_density","skew_z_all","std_z_all","var_z_all","pulse_pen_ratio_all"
                       ,"density_absolute_mean_all")
#plot(lidar_run1)

lidar_run2=stack(lidar_data_run2)
names(lidar_run2) <- c("kurto_z_nonground","mean_z__nonground","max_z__nonground","perc_10_nonground","perc_30_nonground","perc_50_nonground"
                       ,"perc_70_nonground","perc_90_nonground","point_density","skew_z_nonground","std_z_nonground","var_z_nonground","pulse_pen_ratio_nonground",
                       "density_absolute_mean_nonground")
#plot(lidar_run2)

lidarmetrics=stack(lidar_run1,lidar_run2[["kurto_z_nonground"]],lidar_run2[["mean_z__nonground"]],lidar_run2[["max_z__nonground"]],
                   lidar_run2[["perc_10_nonground"]],lidar_run2[["perc_30_nonground"]],lidar_run2[["perc_50_nonground"]],lidar_run2[["perc_70_nonground"]],
                   lidar_run2[["perc_90_nonground"]],lidar_run2[["skew_z_nonground"]],lidar_run2[["std_z_nonground"]],lidar_run2[["var_z_nonground"]])
#plot(lidarmetrics)

crs(lidarmetrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

writeRaster(lidarmetrics, "Lidarmetrics_forMScCourse.tif",overwrite=TRUE)
writeRaster(lidarmetrics, "Lidarmetrics_forMScCourse.grd",overwrite=TRUE)

# Just fast check
lidar=stack("Lidarmetrics_forMScCourse.grd")
names(lidar)

