"
@author: Zsofia Koma, UvA
Aim: sampling digitized polygons and create training-validation data

input:
output:

Fuctions:

Example: 

"

library(raster)
library(sp)
library(spatialEco)
library(ggplot2)
library(maptools)
library(plyr)

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure") # working directory

# Import
veg_map = rgdal::readOGR("vlakken_union_structuur.shp")

# ggplot visualization
veg_map@data$id = rownames(veg_map@data)
veg_map.points = fortify(veg_map, region="id")
veg_map.df = join(veg_map.points, veg_map@data, by="id")
ggplot(veg_map.df) + aes(long,lat,group=group,fill=structyp_e) + geom_polygon() + geom_path(color="white") + coord_equal() + scale_color_brewer(palette="Set1")

# Sampling
veg_map_sample=spsample(veg_map,500,type="stratified")

plot(veg_map)
plot(veg_map_sample,add=TRUE)