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
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

# Import data
las = readLAS("lauwermeer_merged.las")

hist(las@data$Z)
print(min(las@data$Z))
print(max(las@data$Z))

##########################
# Preprocess - Normalize #
##########################

las_ground=lasfilter(las, Classification == 2)
plot(las_ground)
writeLAS(las_ground,'las_ground.las')

dtm = grid_metrics(las_ground, mean(Z),res=1)
plot(dtm, zlim=c(-1,1))

lasnormalize(las, dtm)
hist(las@data$Z)