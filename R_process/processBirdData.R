"
@author: Zsofia Koma, UvA
Aim: Organizing the bird data across NL
  
Input: 
Output: 

Function:
1. Import bird database
2. Filter out by year
3. Create atlas data??? 
4. Export 
  
Example usage (from command line):   
  
ToDo: 
1.

Question:
1. coordinate uncertainity problem
2. ONe bird was observed more time -- can we distanguish or indicate that that bird is the same?
"

# call the required libraries

library("sp")
library("rgdal")
library("raster")

# Set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/birddata") # working directory

year_min=2000
year_max=2010

bird_species="Kleine Karekiet"

# Import data
bird_data=read.csv(file="avimap_observations_reedland_birds.csv",header=TRUE,sep=";")

# Introduce filters

bird_data_filtered=bird_data[ which(bird_data$year>year_min & bird_data$year<year_max),]

# Export the point data

coordinates(bird_data_filtered)=~x+y
proj4string(bird_data_filtered)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
raster::shapefile(bird_data_filtered, "bird_points.shp",overwrite=TRUE)

# Create atlas-like data

bird_data_onebird=bird_data_filtered[ which(bird_data_filtered$species==bird_species),]

onebird_atlas_rst = raster(ncols = 100, nrows = 100, 
                       crs = projection(bird_data_onebird), 
                       ext = extent(bird_data_onebird))

onebird_atlas = rasterize(bird_data_onebird, onebird_atlas_rst,bird_data_onebird$number)
plot(onebird_atlas)

writeRaster(onebird_atlas, filename="onebird.tif", format="GTiff", overwrite=TRUE)
