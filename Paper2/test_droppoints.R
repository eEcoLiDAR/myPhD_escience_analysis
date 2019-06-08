"
@author: Zsofia Koma, UvA
Aim: Modelling drop out points
"
library("lidR")
library("rgdal")

library(dplyr)

# Set working dirctory
workingdirectory="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/"

setwd(workingdirectory)

#Import 
las=readLAS("Transect_1495.las")

options(digits = 20)
head(las$gpstime)

las_oneline=lasfilter(las,PointSourceID==17148)
las_oneline_onetime=lasfilter(las,PointSourceID==17148 & gpstime<121805.5)

lasdata=las_oneline_onetime@data

sel_las=select(lasdata, X, Y)

for (i in seq(1,13603)){ 
  print(mean(sqrt((sel_las$X[i]-sel_las$X[i+1])^2+(sel_las$Y[i]-sel_las$Y[i+1])^2)))
  
  }
dist=sqrt((sel_las$X[1]-sel_las$X[2])^2+(sel_las$Y[1]-sel_las$Y[2])^2)
