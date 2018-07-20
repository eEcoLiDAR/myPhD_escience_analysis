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
setwd("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled/") # working directory

##########################
# Import                 #
##########################

las = readLAS("tile_00005.las")
plot(las)

hist(las@data$Z)

dtm = raster("dtm.tif")
dtm[is.na(dtm)] <- 0 # I fill up with 0 where DTM do not give velues back
plot(dtm)

##########################
# Preprocess - Normalize #
##########################

lasnormalize(las, dtm)
hist(las@data$Z)

#############################
# LiDAR metrics calculation #
#############################

myMetrics = function(z)
{
  metrics = list(
    zmean = mean(z),
    zmax = max(z)
  )
  
  return(metrics)
}

metrics = grid_metrics(las, myMetrics(Z), 2.5)
plot(metrics)