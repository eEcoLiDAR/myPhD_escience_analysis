library(readxl)
library(data.table)
library(rgdal)

workingdir="C:/Koma/Sync/_Amsterdam/11_AndrasProject/FieldData/"
setwd(workingdir)

filename="tisza"
#filename="balaton"
#filename="ferto"

# Separate shapefile
shp=readOGR(".",filename)
shp.df <- as(shp, "data.frame")

controlid=grep("control", shp.df$point_name)

for (g in seq(1,length(controlid))) {
  print(g)
  
  shp.df$distcont <- sqrt((shp.df$coords.x1[controlid[g]]-shp.df$coords.x1)^2+(shp.df$coords.x2[controlid[g]]-shp.df$coords.x2)^2)
  control=shp.df[which(shp.df$distcont<1000),]
  
  control$groupid <- g
  
  write.csv(control,paste(g,"_",filename,".csv",sep=""))
}

files <- list.files(pattern = paste("_",filename,".csv",sep=""))

allcsv <- lapply(files,function(i){
  read.csv(i, header=TRUE)
})

allcsv_df <- do.call(rbind.data.frame, allcsv)

coordinates(allcsv_df)=~coords.x1+coords.x2
proj4string(allcsv_df)<- CRS("+proj=utm +zone=34 +datum=WGS84 +units=m +no_defs")

# Export shapefile
rgdal::writeOGR(allcsv_df, '.', paste(filename,"_grouped",sep=""), 'ESRI Shapefile',overwrite_layer = TRUE)

