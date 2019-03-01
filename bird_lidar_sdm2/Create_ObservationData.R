"
@author: Zsofia Koma, UvA
Aim: create presence-absence data from observation + aggregated kmsquare
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("gridExtra")

library("ggplot2")
library("sdm")
library("sf")

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_2/"

birdobsfile="Baardman_indobs_presonly_nl.csv"
birdkmfile="Baardman_kmsquare_presabs_nl.csv"

ahn3="ahn3.shp"

landcoverfile="LGN7.tif"

setwd(full_path)

# Import 

bird_data_obs=read.csv(file=birdobsfile,header=TRUE,sep=",")
bird_data_km=read.csv(file=birdkmfile,header=TRUE,sep=",")

ahn3_poly = readOGR(dsn=ahn3)

landcover=stack(landcoverfile)

# Presence

names(bird_data_obs)[14]<-"X"
names(bird_data_obs)[15]<-"Y"
names(bird_data_obs)[17]<-"occurrence"

bird_presence_forjoin=bird_data_obs[c("X","Y","species","occurrence","kmsquare")]

# Absence

birdkmfile_onlynull=bird_data_km[ which(bird_data_km$occurrence==0),]
birdkmfile_onlynull_org <- data.frame("X" = birdkmfile_onlynull$X, "Y" = birdkmfile_onlynull$Y, "species"=birdkmfile_onlynull$species,"occurrence"=birdkmfile_onlynull$occurrence,
                                      "kmsquare"=birdkmfile_onlynull$kmsquare)

# Pres-Absence
bird_presabs <- rbind(bird_presence_forjoin, birdkmfile_onlynull_org) 
write.csv(bird_presabs, file = 'Baardman_indpres_kmsquareabs_joined.csv',row.names=FALSE)

# Create point shape from it
bird_data_obs$X=bird_data_obs$x_observation
bird_data_obs$Y=bird_data_obs$y_observation

bird_presabs$X_obs=bird_presabs$X
bird_presabs$Y_obs=bird_presabs$Y

bird_presabs_shp=bird_presabs[c("X","Y","X_obs","Y_obs","kmsquare","species","occurrence")]
coordinates(bird_presabs_shp)=~X_obs+Y_obs
proj4string(bird_presabs_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Filter by ahn3 data

bird_presabs_ahn3 = point.in.poly(bird_presabs_shp, ahn3_poly)
bird_presabs_ahn3=bird_presabs_ahn3@data

bird_presabs_ahn3_hasdata=bird_presabs_ahn3[ which(bird_presabs_ahn3$has_data=="true"),]

bird_presabs_ahn3_hasdata$X_obs=bird_presabs_ahn3_hasdata$X
bird_presabs_ahn3_hasdata$Y_obs=bird_presabs_ahn3_hasdata$Y

bird_presabs_ahn3_hasdata_shp=bird_presabs_ahn3_hasdata[c("X","Y","X_obs","Y_obs","kmsquare","species","occurrence","bladnr")]
coordinates(bird_presabs_ahn3_hasdata_shp)=~X_obs+Y_obs
proj4string(bird_presabs_ahn3_hasdata_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Filter by landuse
formask <- setValues(raster(landcover), NA)
formask[landcover==30 | landcover==45 | landcover==41 | landcover==42] <- 1

proj4string(formask)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

vals <- extract(formask,bird_presabs_ahn3_hasdata_shp)
bird_presabs_ahn3_hasdata_shp$landcovermask <- vals

bird_presabs_ahn3_hasdata_wlandc=bird_presabs_ahn3_hasdata_shp@data
bird_presabs_ahn3_hasdata_wlandc=bird_presabs_ahn3_hasdata_wlandc[ which(bird_presabs_ahn3_hasdata_wlandc$landcovermask==1),]
nrow(bird_presabs_ahn3_hasdata_wlandc)

write.csv(bird_presabs_ahn3_hasdata_wlandc, file = 'fulllist_wahn3.csv',row.names=FALSE)

pres=bird_presabs_ahn3_hasdata_wlandc[ which(bird_presabs_ahn3_hasdata_wlandc$occurrence==1),]
abs=bird_presabs_ahn3_hasdata_wlandc[ which(bird_presabs_ahn3_hasdata_wlandc$occurrence==0),]

nofpres=nrow(bird_presabs_ahn3_hasdata_wlandc[ which(bird_presabs_ahn3_hasdata_wlandc$occurrence==1),])

abs_sampled=abs[sample(nrow(abs), 48), ] #nof kmsquare with presence

presabs_bird <- rbind(pres, abs_sampled) 

# Groupby kmsquare
bird_presabs_ahn3_hasdata_wlandc_bykmsquare=ddply(presabs_bird,~kmsquare+species+bladnr,summarise,sum=sum(occurrence))
bird_presabs_ahn3_hasdata_wlandc_bykmsquare = within(bird_presabs_ahn3_hasdata_wlandc_bykmsquare, {
  occurrence = ifelse(sum >0, 1, 0)
})

listahn3=ddply(bird_presabs_ahn3_hasdata_wlandc_bykmsquare,~bladnr,summarise,sum=sum(occurrence))
nrow(listahn3)

listahn3$bladnr_up=toupper(listahn3$bladnr)

write.csv(listahn3, file = 'listahn3.csv',row.names=FALSE)