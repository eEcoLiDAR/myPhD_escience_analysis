"
@author: Zsofia Koma, UvA
Aim: Create filters
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

# Set working dirctory
#workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
workingdirectory="C:/Koma/Paper2/Paper2_PreProcess/"
setwd(workingdirectory)

#req_ahn3tiles_esciencefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/req_ahn3tiles_escience.shp"
#ahn3_actimefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3_measuretime.shp"
req_ahn3tiles_esciencefile="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/req_ahn3tiles_escience.shp"
ahn3_actimefile="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3_measuretime.shp"

# Import
req_ahn3tiles_escience=readOGR(dsn=req_ahn3tiles_esciencefile)
ahn3_actime = readOGR(dsn=ahn3_actimefile)

# Group it by lidar acqusion time - required tif file list per acqusion date
req_ahn3tiles_escience_acqtime=raster::intersect(req_ahn3tiles_escience,ahn3_actime)
req_ahn3tiles_escience_acqtime <- req_ahn3tiles_escience_acqtime[,-(10:11)]

raster::shapefile(req_ahn3tiles_escience_acqtime, "req_ahn3tiles_escience_acqtime.shp",overwrite=TRUE)

req_ahn3tiles_escience_acqtime$listname=paste("https://webdav.grid.surfsara.nl:2880/pnfs/grid.sara.nl/data/projects.nl/eecolidar/02_UvA/_escience_results/Netherlands/AHN/AHN3/ahn3_2019_01_08_tile_geotiffs/ahn3_2019_01_08_1x1m_features_10m_tile_geotiffs/",req_ahn3tiles_escience_acqtime$name,".tif",sep="")

for (i in 1:length(ahn3_actime@data$OBJECTID)) {
  
  sel_tifs=req_ahn3tiles_escience_acqtime[req_ahn3tiles_escience_acqtime$OBJECTID==i,]
  
  write.table(sel_tifs$listname, file = paste(sel_tifs$Jaar[1],"_",sel_tifs$OBJECTID[1],"_for_mosaic.txt",sep=""), append = FALSE, quote = FALSE, sep = "", 
              eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
              col.names = FALSE, qmethod = c("escape", "double"))
  
}

# download required files using data acquision as groupig scheme
# mkdir lidar_2014_1 lidar_2014_2 lidar_2014_9 lidar_2015_7 lidar_2015_10 lidar_2016_3 lidar_2016_5 lidar_2017_4 lidar_2018_6 lidar_2018_8 lidar_2019_11
# while read p; do curl --insecure --fail --location --user xxx -o ${p:206:218} "${p%?}";done < xxx.txt
# for j in *.tif_; do mv -- "$j" "${j%.tif_}.tif"; done
# for j in *.tif; do mv "$j"  C:/Koma/Paper2/Paper2_PreProcess/lidar_xxxx_xx/;done

#Flipping and cleaning (export only required layers)

directories=c("C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_2/","C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_9/","C:/Koma/Paper2/Paper2_PreProcess/lidar_2015_7/",
              "C:/Koma/Paper2/Paper2_PreProcess/lidar_2015_10/","C:/Koma/Paper2/Paper2_PreProcess/lidar_2016_3/","C:/Koma/Paper2/Paper2_PreProcess/lidar_2016_5/",
              "C:/Koma/Paper2/Paper2_PreProcess/lidar_2017_4/","C:/Koma/Paper2/Paper2_PreProcess/lidar_2018_6/")

for (d in directories){
  tif_file.names <- dir(d, pattern =".tif")
  for (i in 1:length(tif_file.names)) {
    
    tif=stack(paste(d,tif_file.names[i],sep=""))
    seltif <- subset(tif, c(24,31,28,3,15,11,21,2), drop=FALSE)
    names(seltif) <- c("H_90perc","VV_sd","VV_skew","VV_shan","VV_20perc","VV_med","VV_80perc","C_amean")
    seltif=flip(seltif,direction = 'y')
    
    proj4string(seltif)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
    writeRaster(seltif,paste(d,"/flip/",tif_file.names[i],"_flip.tif",sep=""),overwrite=TRUE)
    
  }
  
}

tif_file.names <- dir("C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_1/", pattern =".tif")

for (i in 1:length(tif_file.names)) {
  
  tif=stack(paste("C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_1/",tif_file.names[i],sep=""))
  seltif <- subset(tif, c(24,31,28,3,15,11,21,2), drop=FALSE)
  names(seltif) <- c("H_90perc","VV_sd","VV_skew","VV_shan","VV_20perc","VV_med","VV_80perc","C_amean")
  seltif=flip(seltif,direction = 'y')
  
  proj4string(seltif)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
  writeRaster(seltif,paste("C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_1/flip/",tif_file.names[i],"_flip.tif",sep=""),overwrite=TRUE)
  
}

# Mosaicing the files
# If path is not working in osgeo bat: 
# gdalbuildvrt lidar_2014_1.vrt *.tif
# gdal_translate -of GTiff lidar_2014_1.vrt lidar_2014_1.tif

fliptif_file.names <- dir("C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_1/flip/", pattern =".tif")
output.vrt <- "lidar_2014_1.vrt"
gdalbuildvrt(gdalfile=paste("C:/Koma/Paper2/Paper2_PreProcess/lidar_2014_1/flip/",fliptif_file.names,sep=""),output.vrt=output.vrt)

gdal_translate(src_dataset = "lidar_2014_1.vrt", 
               dst_dataset = "lidar_2014_1.tif", 
               output_Raster = TRUE,
               options = c("BIGTIFF=YES", "COMPRESSION=LZW"))

