"
@author: Zsofia Koma, UvA
Aim: Pre-process atlas individual observation data
"

library(rgdal)
library(raster)

library(dplyr) #ggplot2 and plyr effected on group_by()

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
setwd(workingdirectory)

birdfile="Breeding_bird_atlas_individual_observations.csv" # using the individual observation data

ahn3_actimefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3_measuretime.shp"
sovonwetlandfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/Sovon/Moeras_gaten_gevuld_100m.shp"
landcoverfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/Data/LGN7.tif"

#Import
birds=read.csv(birdfile,sep=";")

ahn3_actime = readOGR(dsn=ahn3_actimefile)
sovonwetland = readOGR(dsn=sovonwetlandfile)
landcover=stack(landcoverfile)
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

## Year of acquision fit

birds_ahn3ac=raster::intersect(birds_wfilt_presatl_shp,ahn3_actime)
birds_ahn3ac_df=birds_ahn3ac@data

birds_ahn3ac_df$acq_sync <- birds_ahn3ac_df$year == birds_ahn3ac_df$Jaar
birds_ahn3ac_df_true=birds_ahn3ac_df[birds_ahn3ac_df$acq_sync==TRUE,]

birds_wahn3ac_shp=CreateShape(birds_ahn3ac_df_true)
raster::shapefile(birds_wahn3ac_shp, "birds_wahn3ac_presatl.shp",overwrite=TRUE)

# report counts

birds_wahn3ac_presatl_r <- birds_ahn3ac_df_true %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## Sovon wetland filter

birds_swet=raster::intersect(birds_wfilt_presatl_shp,sovonwetland)
birds_swet_df=birds_swet@data

birds_swet_shp=CreateShape(birds_swet_df)
raster::shapefile(birds_swet_shp, "birds_swet_presatl.shp",overwrite=TRUE)

# report counts

birds_swet_presatl_r <- birds_swet_df %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## LGN7 filter

birds_lgn7_int=extract(landcover,birds_wfilt_presatl_shp)
birds_wfilt_presatl_shp$landcover_lgn7=birds_lgn7_int[,1]

raster::shapefile(birds_wfilt_presatl_shp, "birds_lgn7_presatl.shp",overwrite=TRUE)

birds_lgn7=birds_wfilt_presatl_shp@data[(birds_wfilt_presatl_shp@data$landcover_lgn7==16 | birds_wfilt_presatl_shp@data$landcover_lgn7==17 | birds_wfilt_presatl_shp@data$landcover_lgn7==30
                                           | birds_wfilt_presatl_shp@data$landcover_lgn7==41 | birds_wfilt_presatl_shp@data$landcover_lgn7==42 | birds_wfilt_presatl_shp@data$landcover_lgn7==43 
                                           | birds_wfilt_presatl_shp@data$landcover_lgn7==45),]

birds_lgn7_shp=CreateShape(birds_lgn7)
raster::shapefile(birds_lgn7_shp, "birds_lgn7_appl_presatl.shp",overwrite=TRUE)

# report counts

birds_lgn7_r <- birds_lgn7 %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

