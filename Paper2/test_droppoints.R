"
@author: Zsofia Koma, UvA
Aim: Modelling drop out points
"
library("lidR")
library("rgdal")

library("dplyr")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"

setwd(workingdirectory)

#Import 
las=readLAS("tile_61.laz")

options(digits = 20)
head(las$gpstime)

#Get one flight line
get_flightlines=unique(las@data$PointSourceID)
las_oneline=lasfilter(las,PointSourceID==get_flightlines[1])
writeLAS(las_oneline,"las_oneline.laz")

# Order by GPStime and get the difference - it is slow switch to data.table?
las_oneline_ord=las_oneline@data[order(las_oneline@data$gpstime),]

las_oneline_ord_gpsdiff=transform(las_oneline_ord, diff_gpstime = c(NA, diff(gpstime)))

# Get attributes where the difference is bigger then 0.00001 10^-5
sel_las_oneline=las_oneline_ord_gpsdiff[las_oneline_ord_gpsdiff$diff_gpstime>0.00001,]
write.csv(sel_las_oneline,"test_dropout1.txt")

las_oneline_ord_gpsdiff$isdrop <- 0
las_oneline_ord_gpsdiff$isdrop[las_oneline_ord_gpsdiff$diff_gpstime>0.00001] <- 1

index <- las_oneline_ord_gpsdiff$isdrop == 1
las_oneline_ord_gpsdiff$isdrop[which(las_oneline_ord_gpsdiff$isdrop==TRUE)-1] <- 1

sel_las_oneline_beaft=las_oneline_ord_gpsdiff[las_oneline_ord_gpsdiff$isdrop==1,]
write.csv(sel_las_oneline_beaft,"test_dropout2.txt")

#Fill water points