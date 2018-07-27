"
@author: Zsofia Koma, UvA
Aim: pre-processing of lidar data

input:
output:

fuctions:
Preprocessing
1. create DTM
2. normalize
3. create nDSM
3. create and export DTM, DSM

Question:
1. DTM generation is failing with error message:
Error in UseMethod('grid_metrics', x) : 
  no applicable method for 'grid_metrics' applied to an object of class 'NULL'

"

# Import required libraries
library("lidR")
library("rlas")
library("raster")

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/02gz2_lidr/tiled_test/"
setwd(full_path) # working directory

##########################
# Create catalog         #
##########################

ctg = catalog(full_path)
cores(ctg) <- 15L
buffer(ctg) <- 5

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
}

##########################
# DTM                    #
##########################

create_meanDTM <- function(las) 
{
  las_ground = lasfilter(las, Classification == 2)
  dtm2 = grid_metrics(las_ground, mean(Z), res=2.5)
  return(dtm2)
}

dtm2_tiles <- catalog_apply(ctg, create_meanDTM)
dtm2 <- data.table::rbindlist(dtm2_tiles)

dtm2_r <- rasterFromXYZ(dtm2)
writeRaster(dtm2_r, "dtm2.tif")

##########################

createDTM <- function(las) 
{
  las_ground = lasfilter(las, Classification == 2)
  dtm = grid_terrain(las_ground, 2.5, method = "knnidw", k = 10L)
  return(dtm)
}

dtm_tiles <- catalog_apply(ctg, createDTM)
dtm <- data.table::rbindlist(dtm_tiles)

dtm_r <- rasterFromXYZ(dtm)
writeRaster(dtm_r, "dtm.tif")

##########################
# Normalize              #
##########################

normalize <- function(las,dtm)
{
  lasnormalize(las, dtm)
}

writeLAS(las, "tile_00011_norm.laz")

##########################
# DSM                    #
##########################

create_chm <- function(las) 
{
  chm = grid_canopy(las, 2.5, subcircle = 0.2)
  return(chm)
}

chm_tiles <- catalog_apply(ctg, create_chm)
chm <- data.table::rbindlist(chm_tiles)

chm_r <- rasterFromXYZ(chm)
writeRaster(chm_r, "chm.tif")