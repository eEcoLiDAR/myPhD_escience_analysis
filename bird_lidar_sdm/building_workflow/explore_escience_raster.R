"
@author: Zsofia Koma, UvA
Aim: Explore laserchicken output for the Global Ecology and Biodiversity course

Input file (geotiff):
    100 m resolution
    LiDAR metrics based on Classification == 1 -- unclassified category (by ASPRS standard)
"

# Import libraries
library(raster)
library(ggplot2)
library(gridExtra)
library(dplyr)

library(XLConnect)

# Set global variables
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
filename="terrainData100m_run2.tif"

setwd(full_path)

# Import data
all_data=stack(filename)
all_data=flip(all_data,direction = 'y')

# Save as dataframe and print statistics
lidarmetrics = rasterToPoints(all_data)
lidarmetrics = data.frame(lidarmetrics)
colnames(lidarmetrics) <- c("x", "y", "coeff_var_z","density_absolute_mean","eigv_1","eigenv_2","eigenv_3","gps_time","intensity","kurto_z","max_z","mean_z",
                           "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40","perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
                           "pulse_pen_ratio","range","skew_z","std_z","var_z")

print(summary(lidarmetrics))

writeWorksheetToFile(paste(substr(filename, 1, nchar(filename)-4) ,"_summarytable.xlsx",sep=""), 
                     data = data.frame(unclass(summary(lidarmetrics)), check.names = FALSE, stringsAsFactors = FALSE), 
                     sheet = "summary", 
                     header = TRUE,
                     clearSheets = TRUE)

# Boxplot
sel_attr=5

par(mfrow=c(1,2))
boxplot(cleaned_lidarmetrics[,sel_attr])
boxplot(cleaned_lidarmetrics[,sel_attr],outline=FALSE)

lidar_filtoulier=cleaned_lidarmetrics[ which(cleaned_lidarmetrics[,sel_attr]>0 & cleaned_lidarmetrics[,sel_attr]<35),]
lidar_oulier_below=cleaned_lidarmetrics[ which(cleaned_lidarmetrics[,sel_attr]<0),]
lidar_oulier_above=cleaned_lidarmetrics[ which(cleaned_lidarmetrics[,sel_attr]>35),]

ggplot() + geom_raster(data=lidar_filtoulier,aes(x,y,fill=lidar_filtoulier[,sel_attr])) + coord_equal()
ggplot() + geom_raster(data=lidar_oulier_below,aes(x,y,fill=lidar_oulier_below[,sel_attr])) + coord_equal()
ggplot() + geom_raster(data=lidar_oulier_above,aes(x,y,fill=lidar_oulier_above[,sel_attr])) + coord_equal()
