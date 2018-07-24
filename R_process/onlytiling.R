# Import required libraries
library("lidR")
library("rlas")
library("raster")

# set working directory up
setwd("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/")

##########################
# Label ground points    #
##########################

las_ground = readLAS("g02gz2.laz",filter="-set_classification 2")
writeLAS(las_ground, "g02gz2_ground.laz")

##########################
# Create catalog         #
##########################

ctg = catalog("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/02gz2_lidr/")

cores(ctg) <- 15L
tiling_size(ctg) <- 1000
buffer(ctg) <- 5

ctg = catalog_retile(ctg, "D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/02gz2_lidr/tiled/", "tile_") 

##########################
# Normalize              #
##########################



##########################
# DTM, DSM, nDSM         #
##########################

createDTM <- function(las) 
{
  las_ground = lasfilter(las, Classification == 2)
  dtm = grid_terrain(las_ground, method = "knnidw", k = 10L)
  return(dtm)
}

dtm_tiles <- catalog_apply(ctg, createDTM)
dtm <- data.table::rbindlist(dtm_tiles)

dtm_r <- rasterFromXYZ(dtm)

plot(dtm_r,colorPalette = terrain.colors(100))