"
@author: Zsofia Koma, UvA
Aim: Plot point cloud related to training data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/wholestudyarea/ground/"
setwd(workingdirectory)

# Required files

classes = rgdal::readOGR("selpolyper_level1_v4.shp")

# Get points per classes

Class_1= subset(classes, V3 == "Bu")
Class_2= subset(classes, V3 == "O")
Class_3= subset(classes, V3 == "V")

# Create catalog
ctg <- catalog(workingdirectory)

# Intersection

las1=lasclip(ctg, Class_1@polygons[[1]]@Polygons[[1]], inside = TRUE)
las2=lasclip(ctg, Class_2@polygons[[1]]@Polygons[[1]], inside = TRUE)
las3=lasclip(ctg, Class_3@polygons[[1]]@Polygons[[1]], inside = TRUE)

writeLAS(las1,"Bu.las")
writeLAS(las2,"O.las")
writeLAS(las3,"V.las")