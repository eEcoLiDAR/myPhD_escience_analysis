library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)
library(sdm)

workingdir="C:/Koma/Sync/_Amsterdam/11_AndrasProject/balaton-20191002T063108Z-001/balaton/"
setwd(workingdir)

shp=readOGR(".","w_point_balaton")
shp.df <- as(shp, "data.frame")

shp_sel=subset(shp.df, select=c("coords.x1","coords.x2","class","OBJNAME"))

coordinates(shp_sel)=~coords.x1+coords.x2
proj4string(shp_sel)<- CRS("+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs")

filelist=list.files(pattern = "*.tif")

id=sub("_.*", "", filelist)
id=unique(id)

feaname=substring(filelist, 10)
feaname=sub('\\..*', "", feaname)

feaname=unique(feaname)

for (i in id) {
  print(i)
  
  rastlist=list.files(pattern=paste("^",i,".*\\.tif$",sep=""))
  
  rasters=stack(rastlist)
  
  crs(rasters) <- "+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs"
  names(rasters) <- feaname
  
  writeRaster(rasters,paste(i,"merged.grd",sep=""),overwrite=TRUE)
  
}

grdlist=list.files(pattern = "*.grd")

for (j in grdlist) {
  print(j)
  
  raster=stack(j)
  
  d <- sdmData(class~.,train=shp_sel,predictors = raster)
  data=d@features
  
  intersect_data=merge(x = data, y = shp.df, by = c("OBJNAME"), all.x = TRUE)
  
  name=sub('\\..*', "", j)
  write.csv(intersect_data,paste(name,"intersected.csv",sep=""))
}

files <- list.files(pattern = "*intersected.csv")

allcsv <- lapply(files,function(g){
  read.csv(g, header=TRUE)
})

allcsv_df <- do.call(rbind.data.frame, allcsv)

write.csv(allcsv_df,"balaton.csv")