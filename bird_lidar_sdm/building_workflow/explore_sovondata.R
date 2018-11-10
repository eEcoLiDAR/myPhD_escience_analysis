"
@author: Zsofia Koma, UvA
Aim: preprocess atlas data for Global Ecology and Biodiversity course
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("dplyr")
library("maptools")

# Set global variables
full_path="C:/zsofia/Amsterdam/BirdData/2018-06-08/"
filename="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

setwd(full_path)

# Filter only for bird of interest
bird_species="Roerdomp"

bird_data=read.csv(file=filename,header=TRUE,sep=";")
bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

print("Years where the observations was made:")
print(unique(bird_data_onebird$year))
uniqueyears=unique(bird_data_onebird$year)

# Visualization
coordinates(bird_data_onebird)=~x+y
proj4string(bird_data_onebird)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

for (year in uniqueyears){
  mapdata=bird_data_onebird[ which(bird_data_onebird$year==year),]
  rgdal::writeOGR(mapdata, "." ,paste(year,bird_species,sep="_"), 'ESRI Shapefile')
}
