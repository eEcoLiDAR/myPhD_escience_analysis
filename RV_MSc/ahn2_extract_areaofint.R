"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
workingdirectory="D:/Reinier/"
#workingdirectory="D:/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/"
setwd(workingdirectory)

#Import shapefile for intersecting lidar
areaofintfile="transect_poly_union.shp"
areaofint=readOGR(dsn=areaofintfile)

ctg = catalog(workingdirectory)

#lake = areaofint[areaofint$gen_id==163,]
#subset = lasclip(ctg, lake)


for (i in seq(from=174,to=max(areaofint$gen_id))){ 
  print(i)
  
  subset = lasclip(ctg, areaofint[areaofint$gen_id==i,])
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste("GenID_",i,".laz",sep=""))
  }
  
}