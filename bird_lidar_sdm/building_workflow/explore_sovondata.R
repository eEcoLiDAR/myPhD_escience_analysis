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

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

# Set global variables
full_path="C:/zsofia/Amsterdam/BirdData/2018-06-08/"
filename="Breeding_bird_atlas_aggregated_data_kmsquares.csv"
nl="Boundary_NL_RDNew.shp"

setwd(full_path)

# Filter only for bird of interest
bird_species="Roerdomp"

bird_data=read.csv(file=filename,header=TRUE,sep=";")
bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

print("Years where the observations was made:")
print(unique(bird_data_onebird$year))
uniqueyears=unique(bird_data_onebird$year)

bird_data_onebird_onlypres=bird_data_onebird[ which(bird_data_onebird$present==1),]

# Visualization
nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=bird_data_onebird_onlypres, aes(x=x,y=y,size=number),inherit.aes = FALSE)

# Shapefile export
coordinates(bird_data_onebird)=~x+y
proj4string(bird_data_onebird)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

for (year in uniqueyears){
  mapdata=bird_data_onebird[ which(bird_data_onebird$year==year),]
  rgdal::writeOGR(mapdata, "." ,paste(year,bird_species,sep="_"), 'ESRI Shapefile')
}




