"
@author: Zsofia Koma, UvA
Aim: Modelling drop out points
"
library("lidR")
library("rgdal")

library(dplyr)

# Set working dirctory
workingdirectory="C:/Koma/Paper2/Test/"

setwd(workingdirectory)

#Import 
las=readLAS("tile_5.las")
las_oneline=lasfilter(las,PointSourceID==17148)
las_oneline_onetime=lasfilter(las,PointSourceID==17148 & gpstime<121805.5)

lasdata=las_oneline_onetime@data

sel_las=select(lasdata, X, Y)

for (i in seq(1,13603)){ 
  print(mean(sqrt((sel_las$X[i]-sel_las$X[i+1])^2+(sel_las$Y[i]-sel_las$Y[i+1])^2)))
  
  }
dist=sqrt((sel_las$X[1]-sel_las$X[2])^2+(sel_las$Y[1]-sel_las$Y[2])^2)
