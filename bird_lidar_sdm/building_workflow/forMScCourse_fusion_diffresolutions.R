"
@author: Zsofia Koma, UvA
Aim: test the fusion of different resoltions for Global Ecology and Biodiversity course
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
full_path="C:/Users/zsofi/Google Drive/_Amsterdam/00_PhD/Teaching/MScCourse_GlobEcol_Biodiv/Project_dataset/Data_Prep/"

lidar_data="/lidar/Lidarmetrics_forMScCourse.grd"
landcover_file="LGN7.tif"
bird_data="/bird/Breeding_bird_atlas_individual_observationsRoerdomp_grouped_presonly_nl.csv"
polygon_file="/bird/kmsquares.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))
plot(polygon)

lidarmetrics=stack(paste(full_path,lidar_data,sep=""))

# Join bird presence data to polygon


# Create landcover mask in 1 km x 1km resolution and add to the polygon

# Aggregate LiDAR to 1 km x 1km and add to the polygon
beginCluster()
polygon <- extract(lidarmetrics, polygon, fun = mean, na.rm = TRUE, sp = TRUE)
endCluster()
