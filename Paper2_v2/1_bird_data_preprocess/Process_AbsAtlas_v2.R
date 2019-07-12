"
@author: Zsofia Koma, UvA
Aim: Pre-process atlas true absence data and add individual observations
"

library(rgdal)
library(raster)

library(dplyr) #ggplot2 and plyr effected on group_by()

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
setwd(workingdirectory)

kmsquares="kmsquares.shp"
km_obs_file="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

ahn3_actimefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3_measuretime.shp"
sovonwetlandfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/Sovon/Moeras_gaten_gevuld_100m.shp"
landcoverfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/Data/LGN7.tif"

#Import
birds_ind=read.csv(birdfile,sep=";")
ahn3_poly = readOGR(dsn=ahn3)

ahn3_actime = readOGR(dsn=ahn3_actimefile)
sovonwetland = readOGR(dsn=sovonwetlandfile)
landcover=stack(landcoverfile)
proj4string(landcover) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

km_obs=read.csv(file=km_obs_file,header=TRUE,sep=";")
#kmsquares_poly = readOGR(dsn=kmsquares)

km_obs=km_obs[ which(km_obs$year>2013 & km_obs$species!="Roerdomp"),]

# Convert poly to df
#kmsquares_poly.df=ConvertPolytoDf(kmsquares_poly)
#write.csv(kmsquares_poly.df, file = "kmsquare_aslist.csv",row.names=FALSE)

kmsquares_poly.df=read.csv(file="kmsquare_aslist.csv",header=TRUE,sep=",")

colnames(kmsquares_poly.df)[colnames(kmsquares_poly.df)=="sum"] <- "nofkmsquare"

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

## Year of acquision fit

birds_ahn3ac_abs=raster::intersect(birds_abs_shp,ahn3_actime)
birds_ahn3ac_abs_df=birds_ahn3ac_abs@data

birds_ahn3ac_abs_df$acq_sync <- birds_ahn3ac_abs_df$year == birds_ahn3ac_abs_df$Jaar
birds_ahn3ac_abs_df_true=birds_ahn3ac_abs_df[birds_ahn3ac_abs_df$acq_sync==TRUE,]

birds_ahn3ac_abs_shp=CreateShape(birds_ahn3ac_abs_df_true)
raster::shapefile(birds_ahn3ac_abs_shp, "birds_wahn3ac_absatl.shp",overwrite=TRUE)

# report counts

birds_ahn3ac_abs_df_true_r <- birds_ahn3ac_abs_df_true %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## Sovon wetland filter

bird_abs_swet=raster::intersect(birds_abs_shp,sovonwetland)
bird_abs_swet_df=bird_abs_swet@data

bird_abs_swet_shp=CreateShape(bird_abs_swet_df)
raster::shapefile(bird_abs_swet_shp, "birds_swet_absatl.shp",overwrite=TRUE)

# report counts

bird_abs_swet_df_r <- bird_abs_swet_df %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## Sovon wetland filter with time acq sync

bird_abs_swet_acqsync=raster::intersect(birds_ahn3ac_abs_shp,sovonwetland)
bird_abs_swet_df_acqsync=bird_abs_swet_acqsync@data

bird_abs_swet_acqsync_shp=CreateShape(bird_abs_swet_df_acqsync)
raster::shapefile(bird_abs_swet_acqsync_shp, "birds_swet_acqsync_absatl.shp",overwrite=TRUE)

# report counts

bird_abs_swet_df_acqsync_r <- bird_abs_swet_df_acqsync %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## LGN7 filter

birds_lgn7_abs_int=extract(landcover,birds_abs_shp)
birds_abs_shp$landcover_lgn7=birds_lgn7_abs_int[,1]

raster::shapefile(birds_abs_shp, "birds_lgn7_absatl.shp",overwrite=TRUE)

birds_lgn7_abs=birds_abs_shp@data[(birds_abs_shp@data$landcover_lgn7==16 |birds_abs_shp@data$landcover_lgn7==17 | birds_abs_shp@data$landcover_lgn7==30
                                         | birds_abs_shp@data$landcover_lgn7==41 | birds_abs_shp@data$landcover_lgn7==42 | birds_abs_shp@data$landcover_lgn7==43 
                                         | birds_abs_shp@data$landcover_lgn7==45),]

# error here
#birds_lgn7_abs_shp=CreateShape(birds_lgn7_abs)
#raster::shapefile(birds_lgn7_abs_shp, "birds_lgn7_appl_absatl.shp",overwrite=TRUE)

# report counts

birds_lgn7_abs_r <- birds_lgn7_abs %>%
  group_by(species) %>%
  summarise(nofobs = length(species))

## LGN7 filter with time acq sync

birds_lgn7_abs_acqsync_int=extract(landcover,birds_ahn3ac_abs_shp)
birds_ahn3ac_abs_shp$landcover_lgn7=birds_lgn7_abs_acqsync_int[,1]

raster::shapefile(birds_ahn3ac_abs_shp, "birds_lgn7_absatl_acqsync.shp",overwrite=TRUE)

birds_lgn7_abs_acqsync=birds_ahn3ac_abs_shp@data[(birds_ahn3ac_abs_shp@data$landcover_lgn7==16 |birds_ahn3ac_abs_shp@data$landcover_lgn7==17 | birds_ahn3ac_abs_shp@data$landcover_lgn7==30
                                   | birds_ahn3ac_abs_shp@data$landcover_lgn7==41 | birds_ahn3ac_abs_shp@data$landcover_lgn7==42 | birds_ahn3ac_abs_shp@data$landcover_lgn7==43 
                                   | birds_ahn3ac_abs_shp@data$landcover_lgn7==45),]

# error here
#birds_lgn7_abs_shp=CreateShape(birds_lgn7_abs)
#raster::shapefile(birds_lgn7_abs_shp, "birds_lgn7_appl_absatl.shp",overwrite=TRUE)

# report counts

birds_lgn7_abs_acqsync_r <- birds_lgn7_abs_acqsync %>%
  group_by(species) %>%
  summarise(nofobs = length(species))