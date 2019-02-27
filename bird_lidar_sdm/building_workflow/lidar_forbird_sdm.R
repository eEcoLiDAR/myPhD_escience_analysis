"
@author: Zsofia Koma, UvA
Aim: explore the intersection of bird and lidar data 
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("gridExtra")

library("ggplot2")

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

lidarfile="Lidarmetrics_forMScCourse.grd"
landcoverfile="LGN7.tif"

setwd(full_path)

# Import LiDAR metrics
lidarmetrics=stack(lidarfile)
bird_data=read.csv(file=filename,header=TRUE,sep=",")
landcover=stack(landcoverfile)

# Habitat selection
formask <- setValues(raster(landcover), NA)
formask[landcover==30 | landcover==45 | landcover==41 | landcover==42] <- 1

formask=crop(formask,extent(lidarmetrics))
formask_resampled=resample(formask,lidarmetrics)

lidarmetrics_sel <- mask(lidarmetrics, formask_resampled)
writeRaster(lidarmetrics_sel, "lidarmetrics_sel.grd",overwrite=TRUE)