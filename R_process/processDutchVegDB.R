"
@author: Zsofia Koma, UvA
Aim: Organizing the Dutch vegetation database 
  
Input: 
Output: 

"

# call the required libraries
library("stringr")

library("sp")
library("rgdal")
library("raster")
library("dplyr")

# set global variables
setwd("D:/Sync/_Amsterdam/04_Paper3_LargeScaleReedbed/fromStephanHennekens/PhragmitesAustralis_Febr2018/") # working directory

min_year=2010
max_uncertainity=5

radius_m=5

# import data
VegDB_header=read.csv(file="Phragmites_australis_header.csv",header=TRUE,sep="\t")
VegDB_species=read.csv(file="Phragmites_australis_species.csv",header=TRUE,sep="\t")

# introduce filters
VegDB_header$year=as.numeric(str_sub(VegDB_header$Datum.van.opname,-4,-1)) # define a numeric year attribute
VegDB_header_filtered=VegDB_header[ which(VegDB_header$year>min_year & VegDB_header$Location.uncertainty..m.<max_uncertainity),]

VegDB_species_filtered=VegDB_species[ which(VegDB_species$Species.name=="Phragmites australis"),]

# join
VegDB <- left_join(VegDB_header_filtered, VegDB_species_filtered, by = 'PlotObservationID')

VegDB_filter=VegDB[ which(VegDB$Cover..>70),]

# Export the point data

coordinates(VegDB_filter)=~Longitude+Latitude
proj4string(VegDB_filter)<- CRS("+proj=longlat +datum=WGS84")
raster::shapefile(VegDB_filter, "PhA_DutchVegDB_points.shp",overwrite=TRUE)


