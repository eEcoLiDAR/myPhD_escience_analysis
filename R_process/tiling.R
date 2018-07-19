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

ctg = catalog("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/")

cores(ctg) <- 4L
tiling_size(ctg) <- 1000
buffer(ctg) <- 5

ctg = catalog_retile(ctg, "D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled/", "tile_") 