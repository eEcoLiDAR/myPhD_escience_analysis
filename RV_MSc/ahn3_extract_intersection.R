"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="D:/Reinier/"
workingdirectory="C:/Koma/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/ahn3/"
setwd(workingdirectory)

#Import 
areaofintfile="req_transect_250buffer.shp"
areaofint=readOGR(dsn=areaofintfile)

# Extract
ctg = catalog(workingdirectory)

for (i in areaofint@data[["Transect"]]){ 
  print(i) 
  subset = lasclip(ctg, areaofint[areaofint$Transect==i,])
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste("C:/Koma/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/Transect_",i,".laz",sep=""))
  }
}