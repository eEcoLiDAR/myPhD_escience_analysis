"
@author: Zsofia Koma, UvA
Aim: Organizing the bird data across NL
  
Input: 
Output: 

Function:
1. Import bird database
2. Filter out by year
3. Export 
  
Example usage (from command line):   
  
ToDo: 
1.

Question:
1. coordinate uncertainity problem
"

# call the required libraries

library("sp")
library("rgdal")
library("raster")

# set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/birddata") # working directory

year_min=2008
year_max=2010

# import data
bird_data=read.csv(file="avimap_observations_reedland_birds.csv",header=TRUE,sep=";")

# introduce filters

bird_data_filtered=bird_data[ which(bird_data$year>year_min & bird_data$year<year_max),]

# Export the point data

coordinates(bird_data_filtered)=~x+y
proj4string(bird_data_filtered)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_filtered, "bird_points.shp",overwrite=TRUE)
