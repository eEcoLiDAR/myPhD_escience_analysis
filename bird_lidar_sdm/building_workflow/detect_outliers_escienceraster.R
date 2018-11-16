"
@author: Zsofia Koma, UvA
Aim: Detect outliers on a filtered dataset for the Global Ecology and Biodiversity course
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
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
filename="terrainData100m_run1_filtered_lidarmetrics.rds"
#filename="terrainData100m_run1_filtered.tif"

setwd(full_path)

# Import data
lidar_data=readRDS(file = filename)

# Boxplot
sel_attr=5
colnames=names(lidar_data)

par(mfrow=c(1,2))
boxplot(lidar_data[,sel_attr],ylab=colnames[sel_attr],col="darkgreen")
boxplot(lidar_data[,sel_attr],outline=FALSE, ylab=colnames[sel_attr],col="darkgreen")
title(paste(colnames[sel_attr],"with and without outliers",sep=" "), outer = TRUE,line = -2.5)

for (i in 3:16){
  print(colnames[i])
  
  jpeg(paste(colnames[i],'_boxplot.jpg',sep=''))
  
  par(mfrow=c(1,2))
  boxplot(lidar_data[,i],ylab=colnames[i],col="darkgreen")
  boxplot(lidar_data[,i],outline=FALSE, ylab=colnames[i],col="darkgreen")
  title(paste(colnames[i],"with and without outliers",sep=" "), outer = TRUE,line = -2.5)
  
  dev.off()
}

# Boxplot per landcover classes
sel_attr=5
colnames=names(lidar_data)

par(mfrow=c(1,2))
boxplot(lidar_data[[colnames[sel_attr]]]~landcover_class,data=lidar_data,ylab=colnames[sel_attr],col=c("gold","darkgreen","darkblue"))
legend(x = "top",inset = c(0,0), title="Land cover classes",
       c("agricult.","forest","nature"), fill=c("gold","darkgreen","darkblue"), horiz=TRUE,xpd = TRUE)
boxplot(lidar_data[[colnames[sel_attr]]]~landcover_class,data=lidar_data,outline=FALSE, ylab=colnames[sel_attr],col=c("gold","darkgreen","darkblue"))
title(paste(colnames[sel_attr],"with and without outliers",sep=" "), outer = TRUE,line = -2.5)

for (i in 3:16){
  print(colnames[i])
  
  jpeg(paste(colnames[i],'_boxplot_landcover.jpg',sep=''))
  
  par(mfrow=c(1,2))
  boxplot(lidar_data[[colnames[i]]]~landcover_class,data=lidar_data,ylab=colnames[i],col=c("gold","darkgreen","darkblue"))
  legend(x = "top",inset = c(0,0), title="Land cover classes",
         c("agricult.","forest","nature"), fill=c("gold","darkgreen","darkblue"), horiz=TRUE,xpd = TRUE)
  boxplot(lidar_data[[colnames[i]]]~landcover_class,data=lidar_data,outline=FALSE, ylab=colnames[i],col=c("gold","darkgreen","darkblue"))
  title(paste(colnames[i],"with and without outliers",sep=" "), outer = TRUE,line = -2.5)
  
  dev.off()
}

# Map outliers per lidar metrics using the outlier estimae from boxplot 
