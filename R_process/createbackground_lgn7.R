"
@author: Zsofia Koma, UvA
Aim: Organizing the Dutch vegetation database 

Input: 
Output: 

"

# call the required libraries
library("stringr")

library("sp")
library("rgdal")
library("raster")
library("dplyr")
library("dismo")

# set global variables
setwd("D:/Sync/_Amsterdam/04_Paper3_LargeScaleReedbed/fromStephanHennekens/PhragmitesAustralis_Febr2018/") # working directory

## Import data
forest=stack("formask_bos.tif")

# Generate random points per classes
forest_points=randomPoints(forest,100,tryf=100)

forest_points_df=as.data.frame(forest_points)
forest_points_df["class"]<-"Forest"

coordinates(forest_points_df)=~x+y
proj4string(forest_points_df)<- CRS("+proj=longlat +datum=WGS84")
raster::shapefile(forest_points_df, "Forest_points.shp",overwrite=TRUE)