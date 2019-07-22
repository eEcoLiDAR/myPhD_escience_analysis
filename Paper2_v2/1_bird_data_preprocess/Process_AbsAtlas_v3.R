"
@author: Zsofia Koma, UvA
Aim: Pre-process atlas true absence data and add individual observations
"

library(rgdal)
library(raster)

library(dplyr) #ggplot2 and plyr effected on group_by()

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_3/"
setwd(workingdirectory)

kmsquares="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/kmsquares.shp"
km_obs_file="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/Breeding_bird_atlas_aggregated_data_kmsquares.csv"

landcoverfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/Data/LGN7.tif"
lidarvegfile="D:/Koma/Paper2/vegetation_height.tif"

#Import
landcover=stack(landcoverfile)
proj4string(landcover) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

km_obs=read.csv(file=km_obs_file,header=TRUE,sep=";")
#kmsquares_poly = readOGR(dsn=kmsquares)

km_obs=km_obs[ which(km_obs$year>2013 & km_obs$species!="Roerdomp"),]

# Convert poly to df
#kmsquares_poly.df=ConvertPolytoDf(kmsquares_poly)
#write.csv(kmsquares_poly.df, file = "kmsquare_aslist.csv",row.names=FALSE)

kmsquares_poly.df=read.csv(file="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/kmsquare_aslist.csv",header=TRUE,sep=",")

colnames(kmsquares_poly.df)[colnames(kmsquares_poly.df)=="sum"] <- "nofkmsquare"

lidarveg=stack(lidarvegfile)
proj4string(lidarveg) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Processing add kmsquare coordinates

birds_abs=km_obs[ which(km_obs$present==0),]

birds_abs_kmcoord=merge(birds_abs,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
names(birds_abs_kmcoord)[4]<-"x_5km"
names(birds_abs_kmcoord)[5]<-"y_5km"
names(birds_abs_kmcoord)[14]<-"occurrence"

names(birds_abs_kmcoord)[15]<-"x"
names(birds_abs_kmcoord)[16]<-"y"

## Without spatial filter

birds_abs_shp=CreateShape(birds_abs_kmcoord)
raster::shapefile(birds_abs_shp, "birds_whfilt_absatl.shp",overwrite=TRUE)

# report counts

birds_abs_kmcoord_r <- birds_abs_kmcoord %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## LiDAR filter

birds_lidar_int=extract(lidarveg,birds_abs_shp)
birds_abs_shp$lidar=birds_lidar_int[,1]

birds_abs_shp$lidar[birds_abs_shp$lidar>=0] <- 1
birds_abs_shp$lidar[is.na(birds_abs_shp$lidar)] <- 0

raster::shapefile(birds_abs_shp, "birds_lidar_abssatl.shp",overwrite=TRUE)

birds_inlidar=birds_abs_shp@data[(birds_abs_shp$lidar==1),]

birds_inlidar_shp=CreateShape(birds_inlidar)
raster::shapefile(birds_inlidar_shp, "birds_inlidar_shp_appl_presatl.shp",overwrite=TRUE)

# report counts

birds_inlidar_r <- birds_inlidar %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## LGN7 filter

birds_lgn7_abs_int=extract(landcover,birds_inlidar_shp)
birds_inlidar_shp$landcover_lgn7=birds_lgn7_abs_int[,1]

raster::shapefile(birds_inlidar_shp, "birds_lgn7_absatl.shp",overwrite=TRUE)

birds_lgn7_abs=birds_inlidar_shp@data[(birds_inlidar_shp@data$landcover_lgn7==16 |birds_inlidar_shp@data$landcover_lgn7==17 | birds_inlidar_shp@data$landcover_lgn7==30
                                   | birds_inlidar_shp@data$landcover_lgn7==41 | birds_inlidar_shp@data$landcover_lgn7==42 | birds_inlidar_shp@data$landcover_lgn7==43 
                                   | birds_inlidar_shp@data$landcover_lgn7==45),]

# error here
birds_lgn7_abs_shp=CreateShape(birds_lgn7_abs)
raster::shapefile(birds_lgn7_abs_shp, "birds_lgn7_appl_absatl.shp",overwrite=TRUE)

# report counts

birds_lgn7_abs_r <- birds_lgn7_abs %>%
  group_by(species) %>%
  summarise(nofobs = length(species))