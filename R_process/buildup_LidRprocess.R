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

##########################
# Preprocess - Normalize #
##########################

