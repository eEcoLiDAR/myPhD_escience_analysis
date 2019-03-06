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

setwd(full_path)

load("snor_model.RData")

rcurve(snor_model,id = c(seq(from=201,to=225,by=1)),mean=T,confidence = T)