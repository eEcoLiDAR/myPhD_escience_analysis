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
full_path="D:/Sync/_Amsterdam/00_PhD/Teaching/MScCourse_GlobEcol_Biodiv/Project_dataset/Data_Prep/"

lidar_data="/lidar/Lidarmetrics_forMScCourse.grd"
landcover_file="LGN7.tif"
bird_data="/bird/Breeding_bird_atlas_individual_observationsRoerdomp_grouped_presonly_nl.csv"
polygon_file="/bird/kmsquares.shp"
nl_boundary="/bird/Boundary_NL_RDNew.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))
nl=readOGR(dsn=paste(full_path,nl_boundary,sep=""))
#plot(polygon)


birds=read.csv(paste(full_path,bird_data,sep=""), header=TRUE, sep=",")

lidarmetrics=stack(paste(full_path,lidar_data,sep=""))

landcover=stack(paste(full_path,landcover_file,sep=""))

# Join bird presence data to polygon
bird_polygons=merge(polygon,birds,by.x="KMHOK",by.y="kmsquare")
bird_polygons@data[is.na(bird_polygons@data$occurrence), "occurrence"] <- 0
bird_polygons_pres <- bird_polygons[bird_polygons@data$occurrence==1,]
plot(bird_polygons_pres)

# Create landcover mask in 1 km x 1km resolution and add to the polygon

# Aggregate LiDAR to 1 km x 1km and add to the polygon
beginCluster()
polygon_withmetrics <- extract(lidarmetrics, bird_polygons_pres, fun = mean, na.rm = TRUE, sp = TRUE)
endCluster()

spplot(polygon_withmetrics, zcol="perc_90_all",sp.layout = nl)
