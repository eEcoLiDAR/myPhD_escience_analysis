"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN3 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"
workingdirectory="D:/Koma/SelectedWetlands/"
setwd(workingdirectory)

#Import 
areaofintfile="selwetland_grid_birdpres.shp"
areaofint=readOGR(dsn=areaofintfile)

areaofint@data$id_2 <- seq(1,length(areaofint$id),1)

for (i in seq(1,length(areaofint$id_2),1)){ 
  print(areaofint$id_2[i]) 
}

# Extract
ctg = catalog(workingdirectory)

for (i in seq(1,length(areaofint$id_2),1)){ 
  print(areaofint$id_2[i]) 
  subset = lasclip(ctg, areaofint[areaofint$id_2==areaofint$id_2[i],])
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste("tile_",areaofint$id_2[i],".laz",sep=""))
  }
}