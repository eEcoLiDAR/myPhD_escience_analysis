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
full_path="D:/Koma/Paper3/DataProcess/"

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

snor_model <- sdm(occurrence~.,data=snor_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=5)
snor_model

baardman_model <- sdm(occurrence~.,data=baardman_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=15)
baardman_model

rcurve(snor_model,id = 5,mean=F,confidence = T)
