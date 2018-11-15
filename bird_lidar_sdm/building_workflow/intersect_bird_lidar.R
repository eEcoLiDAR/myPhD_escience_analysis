"
@author: Zsofia Koma, UvA
Aim: explore the intersection of bird and lidar data for Global Ecology and Biodiversity course
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
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
filename="Breeding_bird_atlas_aggregated_data_kmsquares.csv"
lidarfile="terrainData100m_run2.tif"

setwd(full_path)

# Import LiDAR metrics
lidarmetrics=stack(lidarfile)
lidarmetrics=flip(lidarmetrics,direction = 'y')

# Import bird data and filter
bird_species="Roerdomp"

bird_data=read.csv(file=filename,header=TRUE,sep=";")
bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

bird_data_onebird_onlypres=bird_data_onebird[ which(bird_data_onebird$present==1),]

coordinates(bird_data_onebird_onlypres)=~x+y
proj4string(bird_data_onebird_onlypres)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Intersection
vals <- extract(lidarmetrics,bird_data_onebird_onlypres)
bird_data_onebird_onlypres$v1 <- vals[,1]

# Visulaize

