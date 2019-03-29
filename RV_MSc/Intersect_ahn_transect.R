"
@author: Zsofia Koma, UvA
Aim: overlay butterfly transect with LiDAR 
"

# Import libraries
library("rgdal")
library("raster")
library("rgeos")
library("spatialEco")
library("dplyr")

library("ggplot2")
library("gridExtra")

# Set global variables
#full_path="C:/Koma/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/"
full_path="D:/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/"

transectfile="Transects_0712_Complete.csv"
ahnfile="ahn2.shp"

setwd(full_path)

# Import 

ahn2 = readOGR(dsn=ahnfile)
transect=read.csv(file=transectfile,header=TRUE,sep=";",dec=",")

# Convert transect to point shp

transect$X=transect$x
transect$Y=transect$y

transect_shp=transect[c("X","Y","x","y","Tr_sec","Transect","Section")]
coordinates(transect_shp)=~X+Y
proj4string(transect_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

intersect_points_wpoly = spatialEco::point.in.poly(transect_shp, ahn2)
intersect_points_wpoly_df=intersect_points_wpoly@data

per_ahn2 <- intersect_points_wpoly_df %>%
  group_by(bladnr) %>%
  summarise(nofobs = length(bladnr))

# Create shapefile for area of interest selection within tile

intersect_points_wpoly_circles <- gBuffer( intersect_points_wpoly, width=5000, byid=TRUE,capStyle="SQUARE")