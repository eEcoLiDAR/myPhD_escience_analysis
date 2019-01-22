"
@author: Zsofia Koma, UvA
Aim: Plot point cloud related to training data
"
library("lidR")
library("rgdal")
library("rgl")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/wholestudyarea/ground/"
setwd(workingdirectory)

# Required files

#classes = rgdal::readOGR("selpolyper_level1_v4.shp")
#classes = rgdal::readOGR("selpolyper_level2_v4.shp")
classes = rgdal::readOGR("selpolyper_level3_v4.shp")

unique(classes@data$V3)

# Get points per classes

#Class_1= subset(classes, V3 == "O")
#Class_2= subset(classes, V3 == "V")

#Class_1= subset(classes, V3 == "Rw")
#Class_2= subset(classes, V3 == "B")
#Class_3= subset(classes, V3 == "S")

Class_1= subset(classes, V3 == "Rk")
Class_2= subset(classes, V3 == "Rl")
Class_3= subset(classes, V3 == "Rw")

# Create catalog
ctg <- catalog(workingdirectory)

# Intersection

las1=lasclip(ctg, Class_1@polygons[[10]]@Polygons[[1]], inside = TRUE)
las2=lasclip(ctg, Class_2@polygons[[10]]@Polygons[[1]], inside = TRUE)
las3=lasclip(ctg, Class_3@polygons[[10]]@Polygons[[1]], inside = TRUE)

plot(las1,color = "Classification",bg="white", size=2)
decorate3d(box = TRUE, axes = TRUE,xlab = "x", ylab = "y", zlab = "z")

plot(las2,color = "Classification",bg="white", size=2)
decorate3d(box = TRUE, axes = TRUE,xlab = "x", ylab = "y", zlab = "z")

plot(las3,color = "Classification",bg="white", size=2)
decorate3d(box = TRUE, axes = TRUE,xlab = "x", ylab = "y", zlab = "z")