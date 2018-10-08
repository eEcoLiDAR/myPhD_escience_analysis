"
@author: Zsofia Koma, UvA
Aim: pre-process atlas data 

Input: csv
Output: shp

Function:
1. Selection
- bird species
- year
- presence or absence (export into two separate csv file)

Example usage (from command line):   

"

library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("dplyr")

library("maptools")

# Set global variables
setwd("D:/Koma/MSc_course/birdatlas") # working directory

# Import data
bird_data=read.csv(file="Breeding_bird_atlas_aggregated_data_kmsquares.csv",header=TRUE,sep=";")

# Selection

bird_species="Roerdomp"

bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

bird_data_onebird_pres=bird_data_onebird[ which(bird_data_onebird$number>0),]
bird_data_onebird_abs=bird_data_onebird[ which(bird_data_onebird$number==0),]

# Export

coordinates(bird_data_onebird_pres)=~x+y
proj4string(bird_data_onebird_pres)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_onebird_pres, paste(bird_species,"bird_points.shp",sep=""),overwrite=TRUE)

coordinates(bird_data_onebird_abs)=~x+y
proj4string(bird_data_onebird_abs)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_onebird_abs, paste(bird_species,"bird_abs.shp",sep=""),overwrite=TRUE)



