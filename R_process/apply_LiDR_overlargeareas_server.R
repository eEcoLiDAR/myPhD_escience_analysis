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

ctg = catalog("D:/Koma/Paper1_ReedStructure/Data/ALS/06en2_tiles/")

cores(ctg) <- 15L
tiling_size(ctg) <- 1000
buffer(ctg) <- 50

#new_ctg = catalog_retile(ctg, "D:/Koma/Paper1_ReedStructure/Data/ALS/06en2_tiles/", "06en2_tile_") # if the tiling is not done yet this function should run

##########################
# Preprocess - Normalize #
##########################

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

