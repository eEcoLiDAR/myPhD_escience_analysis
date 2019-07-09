"
@author: Zsofia Koma, UvA
Aim: Pre-process atlas true absence data and add individual observations
"

library(rgdal)
library(raster)

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
setwd(workingdirectory)

birdfile="Breeding_bird_atlas_individual_observations.csv" # using the individual observation data

ahn3="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/lidar/ahn3.shp"

kmsquares="kmsquares.shp"
km_obs_file="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

#Import
birds_ind=read.csv(birdfile,sep=";")
ahn3_poly = readOGR(dsn=ahn3)

km_obs=read.csv(file=km_obs_file,header=TRUE,sep=";")
#kmsquares_poly = readOGR(dsn=kmsquares)

km_obs=km_obs[ which(km_obs$year>2013),]

# Convert poly to df
#kmsquares_poly.df=ConvertPolytoDf(kmsquares_poly)
#write.csv(kmsquares_poly.df, file = "kmsquare_aslist.csv",row.names=FALSE)

kmsquares_poly.df=read.csv(file="kmsquare_aslist.csv",header=TRUE,sep=",")

colnames(kmsquares_poly.df)[colnames(kmsquares_poly.df)=="sum"] <- "nofkmsquare"

# Processing add kmsquare coordinates

GreedW_abs=km_obs[ which(km_obs$species=="Grote Karekiet" & km_obs$present==0),]
  
GreedW_abs_kmcoord=merge(GreedW_abs,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
names(GreedW_abs_kmcoord)[4]<-"x_5km"
names(GreedW_abs_kmcoord)[5]<-"y_5km"
names(GreedW_abs_kmcoord)[14]<-"occurrence"

names(GreedW_abs_kmcoord)[15]<-"x"
names(GreedW_abs_kmcoord)[16]<-"y"

GreedW_abs_shp=CreateShape(GreedW_abs_kmcoord)
raster::shapefile(GreedW_abs_shp, "GreedW_abs_atl.shp",overwrite=TRUE)

ReedW_abs=km_obs[ which(km_obs$species=="Kleine Karekiet" & km_obs$present==0),]

ReedW_abs_kmcoord=merge(ReedW_abs,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
names(ReedW_abs_kmcoord)[4]<-"x_5km"
names(ReedW_abs_kmcoord)[5]<-"y_5km"
names(ReedW_abs_kmcoord)[14]<-"occurrence"

names(ReedW_abs_kmcoord)[15]<-"x"
names(ReedW_abs_kmcoord)[16]<-"y"

ReedW_abs_shp=CreateShape(ReedW_abs_kmcoord)
raster::shapefile(ReedW_abs_shp, "ReedW_abs_atl.shp",overwrite=TRUE)

BReed_abs=km_obs[ which(km_obs$species=="Baardman" & km_obs$present==0),]

BReed_abs_kmcoord=merge(BReed_abs,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
names(BReed_abs_kmcoord)[4]<-"x_5km"
names(BReed_abs_kmcoord)[5]<-"y_5km"
names(BReed_abs_kmcoord)[14]<-"occurrence"

names(BReed_abs_kmcoord)[15]<-"x"
names(BReed_abs_kmcoord)[16]<-"y"

BReed_abs_shp=CreateShape(BReed_abs_kmcoord)
raster::shapefile(BReed_abs_shp, "BReed_abs_atl.shp",overwrite=TRUE)

SaviW_abs=km_obs[ which(km_obs$species=="Snor" & km_obs$present==0),]

SaviW_abs_kmcoord=merge(SaviW_abs,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
names(SaviW_abs_kmcoord)[4]<-"x_5km"
names(SaviW_abs_kmcoord)[5]<-"y_5km"
names(SaviW_abs_kmcoord)[14]<-"occurrence"

names(SaviW_abs_kmcoord)[15]<-"x"
names(SaviW_abs_kmcoord)[16]<-"y"

SaviW_abs_shp=CreateShape(SaviW_abs_kmcoord)
raster::shapefile(SaviW_abs_shp, "SaviW_abs_atl.shp",overwrite=TRUE)

SedgW_abs=km_obs[ which(km_obs$species=="Rietzanger" & km_obs$present==0),]

SedgW_abs_kmcoord=merge(SedgW_abs,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
names(SedgW_abs_kmcoord)[4]<-"x_5km"
names(SedgW_abs_kmcoord)[5]<-"y_5km"
names(SedgW_abs_kmcoord)[14]<-"occurrence"

names(SedgW_abs_kmcoord)[15]<-"x"
names(SedgW_abs_kmcoord)[16]<-"y"

SedgW_abs_shp=CreateShape(SedgW_abs_kmcoord)
raster::shapefile(SedgW_abs_shp, "SedgW_abs_atl.shp",overwrite=TRUE)
  
