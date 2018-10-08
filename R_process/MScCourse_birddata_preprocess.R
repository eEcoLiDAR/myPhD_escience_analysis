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

Comment:
kmsquare case can be they registrate to the presence 1 but the number NA

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

#bird_species="Roerdomp"
bird_species="Kleine Karekiet"

# atlas squares
#######################################################

# Import data
bird_data_atl=read.csv(file="Bird atlas numbers per atlassquare.csv",header=TRUE,sep=";")

# Selection

bird_data_atl_onebird=bird_data_atl[ which(bird_data_atl$species==bird_species),]

# Export

coordinates(bird_data_atl_onebird)=~x+y
proj4string(bird_data_atl_onebird)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_atl_onebird, paste(bird_species,"bird_points_atlas.shp",sep=""),overwrite=TRUE)

# 1 km squares
#######################################################

# Import data
bird_data_km=read.csv(file="Breeding_bird_atlas_aggregated_data_kmsquares.csv",header=TRUE,sep=";")

# Selection

bird_data_km_onebird=bird_data_km[ which(bird_data_km$species==bird_species),]

bird_data_km_onebird_pres=bird_data_km_onebird[ which(bird_data_km_onebird$present>0),]
bird_data_km_onebird_abs=bird_data_km_onebird[ which(bird_data_km_onebird$number==0),]

# Export

coordinates(bird_data_km_onebird_pres)=~x+y
proj4string(bird_data_km_onebird_pres)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_km_onebird_pres, paste(bird_species,"bird_pres_km.shp",sep=""),overwrite=TRUE)

coordinates(bird_data_km_onebird_abs)=~x+y
proj4string(bird_data_km_onebird_abs)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_km_onebird_abs, paste(bird_species,"bird_abs_km.shp",sep=""),overwrite=TRUE)

# 10 min counts
#######################################################

# Import data
bird_data_10min=read.csv(file="Breeding_bird_atlas_aggregated_data_10_minute_point_counts.csv",header=TRUE,sep=";")

# Selection

bird_data_10min_onebird=bird_data_10min[ which(bird_data_10min$species==bird_species),]

bird_data_10min_onebird_pres=bird_data_10min_onebird[ which(bird_data_10min_onebird$number>0),]
bird_data_10min_onebird_abs=bird_data_10min_onebird[ which(bird_data_10min_onebird$number==0),]

# Export

coordinates(bird_data_10min_onebird_pres)=~x_point+y_point
proj4string(bird_data_10min_onebird_pres)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_10min_onebird_pres, paste(bird_species,"bird_pres_10min.shp",sep=""),overwrite=TRUE)

coordinates(bird_data_10min_onebird_abs)=~x_point+y_point
proj4string(bird_data_10min_onebird_abs)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_10min_onebird_abs, paste(bird_species,"bird_abs_10min.shp",sep=""),overwrite=TRUE)

# 5 min counts
#######################################################

# Import data
bird_data_5min=read.csv(file="Breeding_bird_atlas_aggregated_data_5_minute_point_counts.csv",header=TRUE,sep=";")

# Selection

bird_data_5min_onebird=bird_data_5min[ which(bird_data_5min$species==bird_species),]

bird_data_5min_onebird_pres=bird_data_5min_onebird[ which(bird_data_5min_onebird$number>0),]
bird_data_5min_onebird_abs=bird_data_5min_onebird[ which(bird_data_5min_onebird$number==0),]

# Export

coordinates(bird_data_5min_onebird_pres)=~x_point+y_point
proj4string(bird_data_5min_onebird_pres)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_5min_onebird_pres, paste(bird_species,"bird_pres_5min.shp",sep=""),overwrite=TRUE)

coordinates(bird_data_5min_onebird_abs)=~x_point+y_point
proj4string(bird_data_5min_onebird_abs)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_5min_onebird_abs, paste(bird_species,"bird_abs_5min.shp",sep=""),overwrite=TRUE)

# individual observations
#######################################################

# Import data
bird_data_ind=read.csv(file="Breeding_bird_atlas_individual_observations.csv",header=TRUE,sep=";")

# Selection

bird_data_ind_onebird=bird_data_ind[ which(bird_data_ind$species==bird_species),]

# Export

coordinates(bird_data_ind_onebird)=~x_point+y_point
proj4string(bird_data_ind_onebird)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_ind_onebird, paste(bird_species,"bird_points_ind.shp",sep=""),overwrite=TRUE)


