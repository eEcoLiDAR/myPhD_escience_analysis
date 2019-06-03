"
@author: Zsofia Koma, UvA
Aim: extract only area of interest from the 10 m dataset
"

# Import libraries
library(raster)
library(ggplot2)
library(gridExtra)
library(dplyr)

library(XLConnect)

library(sp)
library(spatialEco)

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/"
filename="ahn3_2019_01_08_1x1m_features_10m_subtile_7.tif"

landcoverfile="C:/Koma/Sync/_Amsterdam/00_PhD/Teaching/MScCourse_GlobEcol_Biodiv/Project_dataset/ProjectData/3_LGN7/Data/LGN7.tif"

setwd(full_path)

# Import data
lidar_data=stack(filename)
lidar_data=flip(lidar_data,direction = 'y')
plot(lidar_data)

landcover=stack(landcoverfile)
plot(landcover)