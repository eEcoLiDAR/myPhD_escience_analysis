"
@author: Zsofia Koma, UvA
Aim: Apply and test LidR over large areas

Input: 
Output: 

Function:

Example usage:   

ToDo: 

Question:

"
# Import required libraries
library("lidR")
library("raster")

# Set global variables

##########################
# Create catalog         #
##########################

ctg = catalog("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled/")
plot(ctg)

##########################
# Preprocess - Normalize #
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

##########################
# Feature calculation    #
##########################

myAnalyze <- function(las) 
{
  metrics = grid_metrics(las, list(hmean = mean(Z), hmax = max(Z)), res=5)
  return(metrics)
}

output <- catalog_apply(ctg, myAnalyze, select = "xyz")
output <- data.table::rbindlist(output)

# convert data table into raster

try_r <- rasterFromXYZ(output)
plot(try_r)

