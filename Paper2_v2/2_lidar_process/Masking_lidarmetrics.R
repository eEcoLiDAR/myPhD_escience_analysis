"
@author: Zsofia Koma, UvA
Aim: prepare data for SDM modelling - masking raster
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/escience_metrics/"
setwd(workingdirectory)

#lgn7file="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/Data/LGN7.tif"
lgn7_wetland_mask_resampledfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/lgn7_wetland_mask_resampled.tif"

H90percfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/escience_metrics/metrics_10m_H_90perc.tif"

## Import

#lgn7=stack(lgn7file)
#proj4string(lgn7)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
lgn7_wetland_mask_resampled=stack(lgn7_wetland_mask_resampledfile)
proj4string(lgn7_wetland_mask_resampled)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

#H90perc=stack(H90percfile)
#proj4string(H90perc)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

## Create LGN7 filter

#lgn7_wetland_mask <- setValues(raster(lgn7), NA)
#lgn7_wetland_mask[lgn7==16 | lgn7==17 | lgn7==30 | lgn7==41 | lgn7==42 | lgn7==43 | lgn7==45] <- 1

## Mask LiDAR layers based on lgn7 mask

#lgn7_wetland_mask=crop(lgn7_wetland_mask,extent(H90perc))
#lgn7_wetland_mask_resampled=resample(lgn7_wetland_mask,H90perc)

#writeRaster(lgn7_wetland_mask_resampled,"lgn7_wetland_mask_resampled.tif",overwrite=TRUE)

#H90perc_masked <- mask(H90perc, lgn7_wetland_mask_resampled)
#writeRaster(H90perc_masked,"H90perc_masked.tif",overwrite=TRUE)

# For loop for all lidar metrics layers

rlist=list.files(getwd(), pattern="tif$", full.names=FALSE)

for (i in rlist) {
  print(i)
  
  metrics=stack(i)
  metrics_masked <- mask(metrics, lgn7_wetland_mask_resampled)
  
  writeRaster(metrics_masked,paste(substr(i,1,nchar(i)-4),"_masked.tif",sep=""),overwrite=TRUE)
  
}