"
@author: Zsofia Koma, UvA
Aim: build a raster based classification workflow for processing LiDAR data
  
Input: las and shp files
Output: classified raster

Function:
1. Import ALS (las) file
2. Create features
3. Classify based on training data (Random Forest)
4. Plot the classification results
  
Example usage (from command line):   
  
ToDo: 
1. How to drop the NaN values

Question:
1. 

"

library(lidR)
library(rgdal)
library(sp)

# Set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

# Import data
las = readLAS("lauwermeer_example.las")

# Calculate features
metrics=las %>% grid_metrics(.stdmetrics)
#nanvalues=sapply(metrics, function(x) all(is.nan(x)))
#metrics_filt=metrics[,!nanvalues]

metrics_clean = metrics[,c(1:39)] 

# Intersection for getting training areas

