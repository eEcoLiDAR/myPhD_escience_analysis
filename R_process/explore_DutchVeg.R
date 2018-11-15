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
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

# Set global variables
full_path="C:/zsofia/Amsterdam/Swamps_March2018/"
nl="C:/zsofia/Amsterdam/BirdData/2018-06-08/Boundary_NL_RDNew.shp"
filename="Swamp_communities_header.csv"

setwd(full_path)

# Import
swamp_data=read.csv(file=filename,header=TRUE,sep="\t")

swamp_data["year"]=format(as.Date(swamp_data[,8], format="%d-%m-%Y"),"%Y")
swamp_data_filtered=swamp_data[ which(swamp_data$year>2005),]

nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

# Visualize
ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=swamp_data_filtered, aes(x=X.Coordinaat..m.,y=Y.Coordinaat..m.,color=factor(Associa..1.)),inherit.aes = FALSE) +
  theme(legend.position="none")