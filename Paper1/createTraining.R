"
@author: Zsofia Koma, UvA
Aim: create training data
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

# Set global variables
full_path="C:/Users/zsofi/Google Drive/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/2_Dataset/FieldData/"
polygon_file="vlakken_union_structuur.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))
print(unique(polygon@data$StructDef))

Human <- polygon[polygon@data$StructDef == "A",]
plot(Human)

points_inpoly=spsample(Human, n = 15, "random")

points_inpoly_df=as.data.frame(points_inpoly)
points_inpoly_df$level3="A"

plot(points_inpoly)
plot(Human,add=TRUE)
