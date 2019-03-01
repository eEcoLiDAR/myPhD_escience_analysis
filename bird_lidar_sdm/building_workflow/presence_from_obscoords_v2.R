"
@author: Zsofia Koma, UvA
Aim: create presence data from observation coordinates 
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
library("sf")

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

birdobsfile="Baardman_indobs_presonly_nl.csv"
birdkmfile="Baardman_kmsquare_presabs_nl.csv"

lidarfile="lidarmetrics_wetlands_expanded2.grd"

setwd(full_path)

# Import 
lidarmetrics=stack(lidarfile)

bird_data_obs=read.csv(file=birdobsfile,header=TRUE,sep=",")
bird_data_km=read.csv(file=birdkmfile,header=TRUE,sep=",")

# Create 100m polygons
polygon_100mcell <- rasterToPolygons(lidarmetrics[[22]])
writeOGR(polygon_100mcell, ".", "polygon_100mcell", driver="ESRI Shapefile")
polygon_100mcell@data$lidarmetrics_100m_ID=seq(from=1,to=nrow(polygon_100mcell@data),by=1)

bird_data_obs$X=bird_data_obs$x_observation
bird_data_obs$Y=bird_data_obs$y_observation

bird_data_obs_shp=bird_data_obs[c("X","Y","x_observation","y_observation","species","kmsquare","number")]
coordinates(bird_data_obs_shp)=~X+Y
proj4string(bird_data_obs_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

intersect_poly_birdobs = point.in.poly(bird_data_obs_shp, polygon_100mcell)

writeOGR(intersect_poly_birdobs, ".", "intersect_poly_birdobs", driver="ESRI Shapefile")

# Aggregate only one presence within 100m
bird_presence_per100m=intersect_poly_birdobs@data
bird_presence_per100m=bird_presence_per100m[complete.cases(bird_presence_per100m), ]

bird_presence_per100m$perc_90_nonground <- NULL

bird_presence_per100m_aggr=ddply(bird_presence_per100m,~lidarmetrics_100m_ID+species,summarise,sum=sum(number),mean(x_observation),mean(y_observation))
bird_presence_per100m_aggr = within(bird_presence_per100m_aggr, {
  occurrence = ifelse(sum >0, 1, 0)
})

write.csv(bird_presence_per100m_aggr, file ='Baardman_indobs_grouped100m_presonly_nl.csv',row.names=FALSE)

names(bird_presence_per100m_aggr)[4]<-"X"
names(bird_presence_per100m_aggr)[5]<-"Y"

bird_presence_per100m_aggr_forjoin=bird_presence_per100m_aggr[c("X","Y","species","occurrence")]

# Add absence
birdkmfile_onlynull=bird_data_km[ which(bird_data_km$occurrence==0),]
birdkmfile_onlynull_org <- data.frame("X" = birdkmfile_onlynull$X, "Y" = birdkmfile_onlynull$Y, "species"=birdkmfile_onlynull$species,"occurrence"=birdkmfile_onlynull$occurrence)

# Aggregate
bird_presabs <- rbind(bird_presence_per100m_aggr_forjoin, birdkmfile_onlynull_org) 
write.csv(bird_presabs, file = 'Baardman_indpres_kmsquareabs_joined.csv',row.names=FALSE)

#Intersect with lidarmetrics extent again
bird_presabs$X_obs=bird_presabs$X
bird_presabs$Y_obs=bird_presabs$Y

bird_presabs_shp=bird_presabs[c("X","Y","X_obs","Y_obs","species","occurrence")]
coordinates(bird_presabs_shp)=~X_obs+Y_obs
proj4string(bird_presabs_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

intersect_bird_presabs = point.in.poly(bird_presabs_shp, polygon_100mcell)
bird_presabs_lidar=intersect_bird_presabs@data
bird_presabs_lidar=bird_presabs_lidar[complete.cases(bird_presabs_lidar), ]

bird_presabs_lidar$perc_90_nonground <- NULL
write.csv(bird_presabs_lidar, file = 'Baardman_bird_presabs_lidar.csv',row.names=FALSE)