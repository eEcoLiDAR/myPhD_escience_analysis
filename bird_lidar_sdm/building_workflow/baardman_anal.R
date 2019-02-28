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
library("sdm")

# Set global variables
#full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

filename="Baardman_kmsquare_presabs_nl.csv"
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
#writeRaster(lidarmetrics_sel, "lidarmetrics_sel.grd",overwrite=TRUE)

gc()

# Intersection

bird_data$km_x=bird_data$X
bird_data$km_y=bird_data$Y

coordinates(bird_data)=~X+Y
proj4string(bird_data)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

vals <- raster::extract(lidarmetrics_sel,bird_data)
bird_data$pulsepen <- vals[,13]
bird_data$maxh <- vals[,17]
bird_data$std <- vals[,24]


bird_withLiDAR=bird_data@data
bird_withLiDAR=bird_withLiDAR[complete.cases(bird_withLiDAR), ]

write.csv(bird_withLiDAR, file = "bird_withLiDAR.csv",row.names=FALSE)

# Exploration analysis
bird_withLiDAR=bird_withLiDAR[-sample(which(bird_withLiDAR$occurrence==0), 400),]

p <- ggplot(bird_withLiDAR, aes(x=occurrence,y=pulsepen,group=factor(occurrence))) + 
  geom_boxplot()
p

p <- ggplot(bird_withLiDAR, aes(x=occurrence,y=maxh,group=factor(occurrence))) + 
  geom_boxplot()
p

p <- ggplot(bird_withLiDAR, aes(x=occurrence,y=std,group=factor(occurrence))) + 
  geom_boxplot()
p
