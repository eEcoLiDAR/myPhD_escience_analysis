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
1. cropping

"
# Run install packages
install.packages(c("sp","rgdal","raster","spatialEco","rgeos","dplyr","XML","maptools","dismo","ggmap"))

# Import required libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("dplyr")
library("XML")

library("maptools")
library("dismo")
library("ggmap")

# Set global variables
Rpath=getwd() # set relative path based on github repository
setwd(paste(Rpath,"/birddata/",sep="")) # set working directory

bird_species="Kleine Karekiet"
year_min=2000

##################################################################################################################
# B.) schematic overview of the integration of LiDAR into SDM workflow (based on Guisan et al.,2017 book page 43)#
##################################################################################################################

####### Plot observation data #######

# Import and pre-process data
nl= rgdal::readOGR("Boundary_NL_RDNew.shp")
bird_data=read.csv(file="Breeding_bird_atlas_aggregated_data_kmsquares.csv",header=TRUE,sep=";")

# Filter
bird_data_filtered=bird_data[ which(bird_data$year>year_min),]
bird_data_onebird=bird_data_filtered[ which(bird_data_filtered$species==bird_species),]
bird_data_onebird = bird_data_onebird[order(bird_data_onebird$kmsquare, -bird_data_onebird$present ), ] # order it that presence entry most likely remain in the dataset
bird_data_onebird=bird_data_onebird[!duplicated(bird_data_onebird[c(4,5)]),] #remove duplicates based on x,y (for nicer visualization)

# Coordinates

RDNew=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

coordinates(bird_data_onebird)=~x+y
proj4string(bird_data_onebird)=RDNew

# Visualization

bird_data_onebird[!duplicated(bird_data_onebird$kmsquare),] #remove duplicates based on kmsquare (for nicer visualization)

bound_nl=list("sp.polygons",nl)
spplot(bird_data_onebird,"present",col.regions =c("red", "blue"),legendEntries = c("absence","presence"),cuts = 2,pch=c(4,16),sp.layout = list(bound_nl),key.space=list(x=0.05,y=0.95,corner=c(0,1)))

####### Plot ndvi (vegetation index), lst (surface temperature during the day), srtm (topo) #######

# Import
ndvi = raster("NDVI.tif")
lst = raster('LST.tif')
srtm = raster('srtm.tif')

# Clipping for NL - it's not working
nl_wgs84=spTransform(nl,CRS("+init=epsg:4326"))

ndvi_nl = raster::crop(ndvi, nl_wgs84)
lst_nl = raster::crop(lst, nl_wgs84)
srtm_nl = raster::crop(srtm, nl_wgs84)

plot(ndvi_nl)
plot(nl_wgs84,add=TRUE)

plot(lst_nl)
plot(nl_wgs84,add=TRUE)

plot(srtm_nl)
plot(nl_wgs84,add=TRUE)

####### Plot Digital Surface Model (DSM) LiDAR #######

dsm = raster('dsm.tif')
dsm_wgs84 = projectRaster(dsm, crs="+init=epsg:4326")

plot(dsm_wgs84)
plot(nl_wgs84,add=TRUE)

####### Simulate Species Distribution Modelling #######

# resampling and give the same extent -- still not cropped in a right way...

ndvi_resamp = resample(ndvi,dsm_wgs84,method="ngb")
lst_resamp = resample(lst,dsm_wgs84,method="ngb")
srtm_resamp = resample(srtm,dsm_wgs84,method="ngb")

min_ext = ndvi_resamp+dsm_wgs84

dsm_forstack = crop(dsm_wgs84,min_ext)
ndvi_forstack = crop(ndvi_resamp,min_ext)
lst_forstack = crop(lst_resamp,min_ext)
srtm_forstack = crop(srtm_resamp,min_ext)

# stacking

rasters_stacked <- stack(dsm_forstack,ndvi_forstack,lst_forstack,srtm_forstack)
plot(rasters_stacked)

# extract value from rasters

pts = extract(rasters_stacked, bird_data_onebird, method="bilinear")
pts_dataframe<- data.frame(cbind(coordinates(bird_data_onebird),pts,bird_data_onebird@data))

# GLM modelling

glm_model=glm(present~dsm+NDVI+LST+srtm,family="binomial",data=pts_dataframe)
map=predict(rasters_stacked,glm_model,type="response")
plot(map)