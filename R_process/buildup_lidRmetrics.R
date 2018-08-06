"
@author: Zsofia Koma, UvA
Aim: calculate LiDAR metrics with different resolutions

input:
output:

Fuctions:


Question:



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