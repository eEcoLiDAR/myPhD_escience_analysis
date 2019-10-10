"
@author: Zsofia Koma, UvA
Aim: process wetland OTKA project data step 1.: convert shp to csv and indicate the sensorid-s for match. Before run this step the shape files should be separated per measuremnt location (manually in QGIS). 
"

library(readxl)
library(data.table)
library(rgdal)

#workingdir="C:/Koma/Sync/_Amsterdam/11_AndrasProject/balaton/"
workingdir="D:/Sync/_Amsterdam/11_AndrasProject/balaton/"
locations=c("fuzfo","mariafurdo","sajkod","szantod","szigliget")

for (filename in locations) {
  print(filename)
  
  setwd(paste(workingdir,"/",filename,"/",sep=""))
  
  # Separate shapefile
  shp=readOGR(".",filename)
  shp.df <- as(shp, "data.frame")
  
  controlid=grep("control", shp.df$point_name)
  
  for (g in seq(1,length(controlid))) {
    print(g)
    
    shp.df$distcont <- sqrt((shp.df$coords.x1[controlid[g]]-shp.df$coords.x1)^2+(shp.df$coords.x2[controlid[g]]-shp.df$coords.x2)^2)
    
    shp.df$groupid <- g
    
    write.csv(shp.df,paste(g,"_",filename,'_',paste(as.character(shp.df$water_temp),collapse="_"),"formaster.csv",sep=""))
    
    print(g)
    print(paste(as.character(shp.df$water_temp),collapse="_") )
  }
}


