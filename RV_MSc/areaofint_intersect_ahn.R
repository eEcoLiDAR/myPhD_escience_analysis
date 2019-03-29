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
full_path="C:/Koma/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/"
#full_path="D:/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/"

areaofintfile="bound_1km_ptransect.shp"
ahnfile="ahn2.shp"

setwd(full_path)

# Import 

ahn2 = readOGR(dsn=ahnfile)
areaofint=readOGR(dsn=areaofintfile)

# Intersection
intersected=raster::intersect(ahn2,areaofint)
intersected_df=intersected@data

req_ahn2 <- intersected_df %>%
  group_by(bladnr) %>%
  summarise(nofobs = length(bladnr))

write.table(req_ahn2, file = "req_ahn2_for1km.csv",row.names=FALSE,col.names=TRUE,sep=",")