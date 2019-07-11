"
@author: Zsofia Koma, UvA
Aim: Create filters
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/tifs/"
setwd(workingdirectory)

req_ahn3tiles_esciencefile="req_ahn3tiles_escience.shp"
ahn3_actimefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3_measuretime.shp"

# Import
req_ahn3tiles_escience=readOGR(dsn=req_ahn3tiles_esciencefile)
ahn3_actime = readOGR(dsn=ahn3_actimefile)

# group it by lidar acqusion time
req_ahn3tiles_escience_acqtime=raster::intersect(req_ahn3tiles_escience,ahn3_actime)
req_ahn3tiles_escience_acqtime <- req_ahn3tiles_escience_acqtime[,-(10:11)]

raster::shapefile(req_ahn3tiles_escience_acqtime, "req_ahn3tiles_escience_acqtime.shp",overwrite=TRUE)

req_ahn3tiles_escience_acqtime$listname=paste(req_ahn3tiles_escience_acqtime$name,".tif",sep="")
sel_2014tifs=req_ahn3tiles_escience_acqtime[req_ahn3tiles_escience_acqtime$Jaar==2014,]

sel_2014tifslist=sel_2014tifs@data %>% mutate(listname = sapply(listname, toString))
sel_2014tifslist=list(sel_2014tifslist$listname)