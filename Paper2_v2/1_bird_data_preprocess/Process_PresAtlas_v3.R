"
@author: Zsofia Koma, UvA
Aim: Pre-process atlas individual observation data
"

library(rgdal)
library(raster)

library(dplyr) #ggplot2 and plyr effected on group_by()

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_3/"
setwd(workingdirectory)

birdfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/Breeding_bird_atlas_individual_observations.csv" # using the individual observation data

lidarvegfile="D:/Koma/Paper2/vegetation_height.tif"
landcoverfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/Data/LGN7.tif"
landcovercopfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/Copernicus/globandcover_gref.tif"

#Import
birds=read.csv(birdfile,sep=";")

lidarveg=stack(lidarvegfile)
proj4string(lidarveg) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

landcover=stack(landcoverfile)
proj4string(landcover) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

landcovercop=stack(landcovercopfile)
proj4string(landcover) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Preproc
species=unique(birds$species)

names(birds)[14]<-"x"
names(birds)[15]<-"y"
names(birds)[17]<-"occurrence"

## Without spatial filter

birds<-birds[!(birds$species=="Roerdomp"),]

birds_wfilt_presatl=birds[birds$year>"2013",]

birds_wfilt_presatl_shp=CreateShape(birds_wfilt_presatl)
raster::shapefile(birds_wfilt_presatl_shp, "birds_whfilt_presatl.shp",overwrite=TRUE)

# report counts

birds_wfilt_presatl_r <- birds_wfilt_presatl %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## LiDAR filter

birds_lidar_int=extract(lidarveg,birds_wfilt_presatl_shp)
birds_wfilt_presatl_shp$lidar=birds_lidar_int[,1]

birds_wfilt_presatl_shp$lidar[birds_wfilt_presatl_shp$lidar>=0] <- 1
birds_wfilt_presatl_shp$lidar[is.na(birds_wfilt_presatl_shp$lidar)] <- 0

raster::shapefile(birds_wfilt_presatl_shp, "birds_lidar_presatl.shp",overwrite=TRUE)

birds_inlidar=birds_wfilt_presatl_shp@data[(birds_wfilt_presatl_shp$lidar==1),]

birds_inlidar_shp=CreateShape(birds_inlidar)
raster::shapefile(birds_inlidar_shp, "birds_inlidar_shp_appl_presatl.shp",overwrite=TRUE)

# report counts

birds_inlidar_r <- birds_inlidar %>%
  group_by(species) %>%
  summarise(nofobs = length(species))


## LGN7 filter

birds_lgn7_int=extract(landcover,birds_inlidar_shp)
birds_inlidar_shp$landcover_lgn7=birds_lgn7_int[,1]

raster::shapefile(birds_inlidar_shp, "birds_lgn7_presatl.shp",overwrite=TRUE)

birds_lgn7=birds_inlidar_shp@data[(birds_inlidar_shp@data$landcover_lgn7==16 | birds_inlidar_shp@data$landcover_lgn7==17 | birds_inlidar_shp@data$landcover_lgn7==30
                                         | birds_inlidar_shp@data$landcover_lgn7==41 | birds_inlidar_shp@data$landcover_lgn7==42 | birds_inlidar_shp@data$landcover_lgn7==43 
                                         | birds_inlidar_shp@data$landcover_lgn7==45),]

birds_lgn7_shp=CreateShape(birds_lgn7)
raster::shapefile(birds_lgn7_shp, "birds_lgn7_appl_presatl.shp",overwrite=TRUE)

# report counts

birds_lgn7_r <- birds_lgn7 %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## Land cover copernucus filter

birds_coper_int=extract(landcovercop,birds_inlidar_shp)
birds_inlidar_shp$landcover_coper=birds_coper_int[,1]

raster::shapefile(birds_inlidar_shp, "birds_coper_presatl.shp",overwrite=TRUE)

birds_coper=birds_inlidar_shp@data[(birds_inlidar_shp$landcover_coper==200 | birds_inlidar_shp$landcover_coper==90 | birds_inlidar_shp$landcover_coper==126),]

birds_coper_shp=CreateShape(birds_coper)
raster::shapefile(birds_coper_shp, "birds_coper_appl_presatl.shp",overwrite=TRUE)

# report counts

birds_coper_r <- birds_coper %>%
  group_by(species) %>%
  summarise(nofobs = length(species))