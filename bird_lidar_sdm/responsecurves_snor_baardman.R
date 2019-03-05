"
@author: Zsofia Koma, UvA
Aim: SDM
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
library("usdm")

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_3/"

snorfile="Snor_bird_data_forSDM.shp"
baardmanfile="Baardman_bird_data_forSDM.shp"

lidarfile="lidarmetrics_forSDM.grd"

setwd(full_path)

# Import
lidarmetrics=stack(lidarfile)

Snor=readOGR(dsn=snorfile)
Baardman=readOGR(dsn=baardmanfile)

# Intersection

snor_data_forsdm <- sdmData(formula=occurrence~., train=Snor, predictors=lidarmetrics)
snor_data_forsdm

baardman_data_forsdm <- sdmData(formula=occurrence~., train=Baardman, predictors=lidarmetrics)
baardman_data_forsdm

# Modelling

snor_model <- sdm(occurrence~.,data=snor_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=50)
snor_model

baardman_model <- sdm(occurrence~.,data=baardman_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=50)
baardman_model
