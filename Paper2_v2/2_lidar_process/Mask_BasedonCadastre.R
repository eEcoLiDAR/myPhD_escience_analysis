"
@author: Zsofia Koma, UvA
Aim: Apply cadastre based filters
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

lidar=stack("D:/Koma/Paper2/lidar_2015_10.tif")
powerlinemask=stack("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/Kataster/powerlines_mask.tif")

proj4string(lidar)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
proj4string(powerlinemask)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

powermask <- setValues(raster(lidar), 1)
powermask[powerlinemask[[1]]==255] <- NA

lidar_masked=mask(lidar,powermask)
writeRaster(lidar_masked,"D:/Koma/Paper2/lidar_masked.tif",overwrite=TRUE)

writeRaster(powermask,"D:/Koma/Paper2/powermask.tif",overwrite=TRUE)