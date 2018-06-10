"
@author: Zsofia Koma, UvA
Aim: build a raster based classification workflow 

Input: PCA raster layers and shp files
Output: classified raster

Function:


Example usage (from command line):   

ToDo: 

Question:


"

library(lidR)
library(rgdal)
library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)

# Set global variables
setwd("C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

# Import data


classes = rgdal::readOGR("training_classes2.shp")