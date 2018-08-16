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


# Set global variables
setwd("D:/Koma/Paper1_ReedStructure") # working directory

# Import
classes = rgdal::readOGR("vlakken_union_structuur.shp")
plot(classes)

