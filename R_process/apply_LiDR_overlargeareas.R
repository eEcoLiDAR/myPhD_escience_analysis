"
@author: Zsofia Koma, UvA
Aim: Apply and test LidR over large areas

Input: 
Output: 

Function:

Example usage (from command line):   

ToDo: 

Question:

"
# Import required libraries
library("lidR")

# Set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/") # set working directory

##################################################################################################################
# Apply LidR over large areas                                                                                    #
##################################################################################################################

ctg = catalog("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/lidar/")

cores(ctg) <- 4L
tiling_size(ctg) <- 500
buffer(ctg) <- 50

new_ctg = catalog_retile(ctg, "D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data/lidar/tiled/", "tile_")