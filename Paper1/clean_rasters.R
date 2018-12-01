"
@author: Zsofia Koma, UvA
Aim: Clean up and merge LiDAR metrics
"
#install.packages(c("sp","rgdal","raster","spatialEco","rgeos","plyr","dplyr","maptools","gridExtra","ggplot2","ggmap","maps","mapdata"))

library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

# global variables

#args = commandArgs(trailingOnly=TRUE)

#workingdirectory=args[1]
#filename=args[2]

workingdirectory="D:/Koma/Paper1/ALS/forClassification/"
filename_tile1="06en2_allfea_2o5m.tif"

setwd(workingdirectory)

# Import
lidar_tile1=stack(filename_tile1)
names(lidar_tile1) <- c('z','dens_ab_mean','eigv1','eigv2','eigv3','gpstime','int','kurto_z','max_z',
                        'mean_z','median_z','min_z','perc_10','perc_30','perc_50','perc_70','perc_90',
                        'pdens','pulsepenratio','class','skew_z','std_z','var_z','z_entrop',
                        'n_max_z','n_mean_z','n_median_z','n_perc_10','n_perc_30','n_perc_50',
                        'n_perc_70','_n_perc_90','dtm','aspect','roughness','shd','slope')

#lidar_tile1@layers

# Select menaingful layers
cleaned_lidar_tile1 <- subset(lidar_tile1, c(2,3,4,5,8,18,19,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37), drop=FALSE)
plot(cleaned_lidar_tile1)

#Print statistics
cleaned_lidar_tile1_df  <- as.data.frame(cleaned_lidar_tile1, xy = TRUE)
summary(cleaned_lidar_tile1_df)
