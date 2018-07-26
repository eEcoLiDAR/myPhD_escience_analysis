"
@author: Zsofia Koma, UvA
Aim: test preprocessing steps

input:
output:

fuction:
Preprocessing
1. create DTM
2. normalize
3. create and export DTM, DSM


"
# Import required libraries
library("lidR")
library("rlas")
library("raster")

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/02gz2_lidr/tiled/") # working directory

##########################
# Import                 #
##########################

writelax("tile_00011.laz")
las = readLAS("tile_00011.laz")
plot(las)

hist(las@data$Z)

##########################
# DTM                    #
##########################

start_time <- Sys.time()

las_ground = lasfilter(las, Classification == 2)
dtm = grid_terrain(las_ground, 5, method = "knnidw", k = 10L)

end_time <- Sys.time()
print(end_time - start_time)

plot(dtm)
plot3d(dtm)

dtm_2 = grid_canopy(las_ground, 2.5, subcircle = 0.2)
plot(dtm_2)

##########################
# Normalize              #
##########################

start_time <- Sys.time()

lasnormalize(las, dtm)
hist(las@data$Z)

end_time <- Sys.time()
print(end_time - start_time)

##########################
# DSM                    #
##########################

chm = grid_canopy(las, 2.5, subcircle = 0.2)
plot(chm)
plot3d(chm)