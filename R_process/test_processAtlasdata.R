"
@author: Zsofia Koma, UvA
Aim: preprocess atlas data into an input raster 

Input: 
Output: 

Function:

Example usage (from command line):   

ToDo: 
1. How to export the info related to polygon get from the point data

Question:

"

library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("dplyr")

library("maptools")

# Set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/birddata") # working directory

# Import data
bird_data=read.csv(file="Breeding_bird_atlas_aggregated_data_kmsquares.csv",header=TRUE,sep=";")

kmsquares= rgdal::readOGR("Atlassquares.shp")
proj4string(kmsquares)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Selection
bird_species="Kleine Karekiet"

bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

# Visualization

coordinates(bird_data_onebird)=~x+y
proj4string(bird_data_onebird)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
spplot(bird_data_onebird,"present",col.regions =c("red", "blue"),legendEntries = c("0","1"),cuts = 2)

# Join and export

#pts_in_poly = point.in.poly(bird_data_onebird, kmsquares)
#rgdal::writeOGR(pts_in_poly, '.', 'example_atlas', 'ESRI Shapefile')

plot(bird_data_onebird)
plot(kmsquares, add=TRUE)

bird_data_onebird@data <- mutate(bird_data_onebird@data, id_point = as.numeric(rownames(bird_data_onebird@data)))
kmsquares@data <- mutate(kmsquares@data, id_grid = as.numeric(rownames(kmsquares@data)))

# Overlap
birds_insquare <- over(bird_data_onebird, kmsquares)
birds_insquare <- mutate(birds_insquare, id = as.numeric(rownames(birds_insquare)))

birds_insquare <- left_join(bird_data_onebird@data, birds_insquare, by = c("id_point" = "id"))

birds_insquare_f <- birds_insquare %>% group_by(id_grid) %>%
summarise(npoint = n()) %>%
arrange(id_grid)

kmsquares@data <- left_join(kmsquares@data, birds_insquare_f, by = c("id_grid" = "id_grid"))
plot(kmsquares,col=kmsquares$present)

rgdal::writeOGR(kmsquares, "." ,'onebird_atlas', 'ESRI Shapefile')