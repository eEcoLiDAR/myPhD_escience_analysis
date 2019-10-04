library(readxl)
library(data.table)
library(rgdal)

filename="tisza"
#filename="balaton"
#filename="ferto"

maxdist=1000

workingdir="D:/Sync/_Amsterdam/11_AndrasProject/"
setwd(paste(workingdir,"/",filename,"/",sep=""))

# Separate shapefile
shp=readOGR(".",filename)
shp.df <- as(shp, "data.frame")

controlid=grep("control", shp.df$point_name)

for (g in seq(1,length(controlid))) {
  print(g)
  
  shp.df$distcont <- sqrt((shp.df$coords.x1[controlid[g]]-shp.df$coords.x1)^2+(shp.df$coords.x2[controlid[g]]-shp.df$coords.x2)^2)
  control=shp.df[which(shp.df$distcont<maxdist),]
  
  control$groupid <- g
  
  write.csv(control,paste(g,"_",filename,'_',paste(as.character(control$water_temp),collapse="_"),"formaster.csv",sep=""))
  
  print(g)
  print(paste(as.character(control$water_temp),collapse="_") )
}



