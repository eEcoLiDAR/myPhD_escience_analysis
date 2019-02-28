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

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

birdobsfile="Snor_indobs_presonly_nl.csv"
birdkmfile="Snor_kmsquare_presabs_nl.csv"

lidarfile="lidarmetrics_wetlands_expanded.grd"

setwd(full_path)

# Import 
lidarmetrics=stack(lidarfile)

bird_data_obs=read.csv(file=birdobsfile,header=TRUE,sep=",")
bird_data_km=read.csv(file=birdkmfile,header=TRUE,sep=",")

# Calc geom. mean of observation coords per kmsquare
geomcoord_mean_kmsquaresgroup <- bird_data_obs %>%
  group_by(kmsquare) %>%
  summarise(X = mean(x_observation),Y = mean(y_observation))

geomcoord_mean_kmsquaresgroup$species <- "Snor"
geomcoord_mean_kmsquaresgroup$occurrence <- 1

write.csv(geomcoord_mean_kmsquaresgroup, file = 'Snor_pres_perkmsquare_geommean.csv',row.names=FALSE)

# Create absence data
birdkmfile_onlynull=bird_data_km[ which(bird_data_km$occurrence==0),]

birdkmfile_onlynull_org <- data.frame("kmsquare" = birdkmfile_onlynull$kmsquare, "X" = birdkmfile_onlynull$X, "Y" = birdkmfile_onlynull$Y, "species"=birdkmfile_onlynull$species,"occurrence"=birdkmfile_onlynull$occurrence)

# Aggregate
bird_presabs <- rbind(geomcoord_mean_kmsquaresgroup, birdkmfile_onlynull_org) 

write.csv(bird_presabs, file = 'Snor_presabs_perkmsquare_geommean.csv',row.names=FALSE)
