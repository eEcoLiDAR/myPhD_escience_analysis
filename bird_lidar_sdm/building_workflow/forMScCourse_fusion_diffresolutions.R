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

# Join LiDAR metrics to 1 km x 1km and add to the polygon
beginCluster()
polygon_withmetrics <- extract(lidarmetrics, bird_polygons_pres, fun = mean, na.rm = TRUE, sp = TRUE)
endCluster()

spplot(polygon_withmetrics, zcol="perc_90_all",sp.layout = nl)

# Create 1km x 1km resolution grid 
# It will be sightly shifted
lidarmetrics_1km <- aggregate(lidarmetrics, fact = 10, fun = mean)
writeRaster(lidarmetrics_1km, "lidarmetrics_1km.grd",overwrite=TRUE)

# Precise aggreement with polygon
raster_extent=rasterFromXYZ(bird_polygons@data[c('X','Y','occurrence')])
#writeRaster(raster_extent, "grid.grd",overwrite=TRUE)

lidarmetrics_1km_polyraster=resample(lidarmetrics_1km, raster_extent, method="ngb")
writeRaster(lidarmetrics_1km_polyraster, "lidarmetrics_1km_polygrid.grd",overwrite=TRUE)

# Create landcover mask in 1 km x 1km resolution and align with the polygon
formask_wetland <- setValues(raster(landcover), NA)
formask_wetland[landcover==41 | landcover==42 | landcover==43 ] <- 1

wetland_mask=resample(formask_wetland, raster_extent, method="ngb")
writeRaster(wetland_mask, "wetland_mask_1km.grd",overwrite=TRUE)


