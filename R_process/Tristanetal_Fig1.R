"
@author: Zsofia Koma, UvA
Aim: Create Fig.1. in Bakx et al., 2018 
-- a.) data structure representation of features (area, voxel, object)
-- b.) schematic overview of the integration of LiDAR into SDM workflow (based on Guisan et al.,2017 book page 43)

Input: 
Output: 

Function:

Example usage (from command line):   

ToDo: 

Question:

"
# Import required libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("dplyr")

library("maptools")

# Set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/birddata") # working directory

bird_species="Kleine Karekiet"

# B.) 

# Plot observation data

# Import data
bird_data=read.csv(file="Breeding_bird_atlas_aggregated_data_kmsquares.csv",header=TRUE,sep=";")

#Filter
bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

# Visualization

coordinates(bird_data_onebird)=~x+y
proj4string(bird_data_onebird)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
spplot(bird_data_onebird,"present",col.regions =c("red", "blue"),legendEntries = c("0","1"),cuts = 2)


