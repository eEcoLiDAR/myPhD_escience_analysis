"
@author: Zsofia Koma, UvA
Aim: create presence-absence data from observation + aggregated kmsquare data
"

library(rgdal)
library(raster)

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"

birdobsfile="Breeding_bird_atlas_individual_observations.csv"
birdkmfile="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

ahn3="ahn3.shp"

landcoverfile="LGN7.tif"

setwd(full_path)

# Import
bird_data_obs=read.csv(file=paste(full_path,"bird_data/",birdobsfile,sep=""),header=TRUE,sep=";")
bird_data_obs<-bird_data_obs[!(bird_data_obs$species=="Roerdomp"),] #delete Roerdomp because it is not needed

birdspecies=unique(bird_data_obs$species)

landcover=stack(paste(full_path,"landcover/3_LGN7/Data/",landcoverfile,sep=""))
proj4string(landcover) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Create presence-only data 
names(bird_data_obs)[14]<-"X"
names(bird_data_obs)[15]<-"Y"
names(bird_data_obs)[17]<-"occurrence"

bird_onlypresence=bird_data_obs[c("X","Y","species","occurrence","kmsquare")]

# Create shapefile
bird_onlypresence$X_obs=bird_onlypresence$X
bird_onlypresence$Y_obs=bird_onlypresence$Y

bird_presonly_shp=bird_onlypresence[c("X","Y","X_obs","Y_obs","kmsquare","species","occurrence")]
coordinates(bird_presonly_shp)=~X_obs+Y_obs
proj4string(bird_presonly_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

raster::shapefile(bird_presonly_shp, "bird_presonly.shp",overwrite=TRUE)

# Check intersection with LGN7
lgn7_birdprs_intersect=extract(landcover,bird_presonly_shp)

bird_onlypresence$landcover_lgn7=lgn7_birdprs_intersect
intersected=unique(bird_onlypresence$landcover_lgn7)
