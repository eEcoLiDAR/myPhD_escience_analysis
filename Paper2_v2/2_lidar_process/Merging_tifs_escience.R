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

req_ahn3tiles_esciencefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/req_ahn3tiles_escience.shp"
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

write.table(sel_2014tifs$listname, file = "for2014_mosaic.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double"))

sel_2015tifs=req_ahn3tiles_escience_acqtime[req_ahn3tiles_escience_acqtime$Jaar==2015,]

write.table(sel_2015tifs$listname, file = "for2015_mosaic.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double"))

#Flipping
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/tifs/lidar_2015/"
setwd(workingdirectory)

tif_file.names <- dir("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/tifs/lidar_2015/", pattern =".tif")

for (i in 1:length(tif_file.names)) {
  
  lidar_data=stack(tif_file.names[i])
  lidar_data=flip(lidar_data,direction = 'y')
  
  writeRaster(lidar_data,paste(tif_file.names[i],"_flip.tif",sep=""))
  
}