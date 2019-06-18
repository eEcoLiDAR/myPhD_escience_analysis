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

birdfile="bird_presonly.shp"
birds=readOGR(dsn=birdfile)

birds@data$id <- seq(1,length(birds$X),1)

for (i in seq(1,length(birds$id),1)){ 
  print(birds@data$id[i]) 
  print(birds@data$X[i])
  print(birds@data$Y[i])
}

ctg = catalog(workingdirectory)

# Extract 1km squares

for (i in seq(1,length(areaofint$id_2),1)){ 
  print(areaofint$id_2[i]) 
  subset = lasclip(ctg, areaofint[areaofint$id_2==areaofint$id_2[i],])
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste("tile_",areaofint$id_2[i],".laz",sep=""))
  }
}

raster::shapefile(areaofint, "selwetland_areaofint.shp",overwrite=TRUE)

# Extract pcloud around the bird observation

for (i in seq(1,length(birds$id),1)){ 
  print(birds@data$id[i]) 
  
  subset = lasclipCircle(ctg,birds@data$X[i],birds@data$Y[i],250)
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste(birds@data$species[i],"_",birds@data$id[i],"_",birds@data$kmsquare[i],".laz",sep=""))
  }
}