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

# Create catalog
ctg <- catalog(workingdirectory)

# Intersection

las=lasclip(ctg, classes@polygons[[1]]@Polygons[[1]], inside = TRUE)

writeLAS(las,"test.las")