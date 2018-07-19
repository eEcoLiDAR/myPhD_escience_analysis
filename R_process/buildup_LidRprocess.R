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
setwd("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess") # working directory

# Import data
las_gorund = readLAS("g02gz2.laz")
plot(las_ground)

las_objects = readLAS("u02gz2.laz")
plot(las_objects)

##########################
# Preprocess - Normalize #
##########################

las_ground=lasfilter(las, Classification == 2)
plot(las_ground)
writeLAS(las_ground,'las_ground.las')

dtm = grid_terrain(las, 5, method = "kriging", k = 10L)

dtm = grid_metrics(las_ground, mean(Z),res=1)
plot(dtm, zlim=c(-1,1))

lasnormalize(las, dtm)
hist(las@data$Z)