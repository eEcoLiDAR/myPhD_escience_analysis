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
print(summary(lidar_data))

colnames=names(lidar_data)

# Boxplot

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

# Just one metrics plot

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
# Based on max_z
sel_attr="max_z"
min=0
max=35

print(summary(lidar_data[,sel_attr]))

lidar_oulier_above=lidar_data[ which(lidar_data[,sel_attr]>max),]
ggplot() + geom_raster(data=lidar_oulier_above,aes(x,y,fill=lidar_oulier_above[,sel_attr])) + coord_equal() + scale_fill_gradientn(colours=topo.colors(7),na.value = "transparent",limits=c(min((lidar_oulier_below[,sel_attr])),max(lidar_oulier_above[,sel_attr])))

lidar_oulier_below=lidar_data[ which(lidar_data[,sel_attr]<min),]
ggplot() + geom_raster(data=lidar_oulier_below,aes(x,y,fill=lidar_oulier_below[,sel_attr])) + coord_equal() + scale_fill_gradientn(colours=topo.colors(7),na.value = "transparent",limits=c(min((lidar_oulier_below[,sel_attr])),max(lidar_oulier_below[,sel_attr])))

# Export
lidar_outlier <- rbind(lidar_oulier_above, lidar_oulier_below) 

outlier_hmax <- rasterFromXYZ(lidar_outlier)
writeRaster(outlier_hmax, paste(substr(filename, 1, nchar(filename)-4) ,"_maxh_out.tif",sep=""),overwrite=TRUE)

# Delete max_z related outliers
lidar_whoutoulier=lidar_data[ which(lidar_data[,sel_attr]<max & lidar_data[,sel_attr]>min),]
print(summary(lidar_whoutoulier))

# Based on var_z -seems to be not outlier - stdz is normal already
sel_attr2="var_z"
max2=14

lidar_oulier_above2=lidar_whoutoulier[ which(lidar_whoutoulier[,sel_attr2]>max),]
ggplot() + geom_raster(data=lidar_oulier_above2,aes(x,y,fill=lidar_oulier_above2[,sel_attr2])) + coord_equal() + scale_fill_gradientn(colours=topo.colors(7),na.value = "transparent",limits=c(min((lidar_oulier_above2[,sel_attr2])),max(lidar_oulier_above2[,sel_attr2])))

# Do boxplot without outliers

for (i in 3:16){
  print(colnames[i])
  
  jpeg(paste(colnames[i],'_boxplot_whoutoutliers.jpg',sep=''))
  
  par(mfrow=c(1,2))
  boxplot(lidar_whoutoulier[,i],ylab=colnames[i],col="darkgreen")
  boxplot(lidar_whoutoulier[[colnames[i]]]~landcover_class,data=lidar_whoutoulier,ylab=colnames[i],col=c("gold","darkgreen","darkblue"))
  title(paste(colnames[i],"without outliers",sep=" "), outer = TRUE,line = -2.5)
  
  dev.off()
}

# Export

writeWorksheetToFile(paste(substr(filename, 1, nchar(filename)-4) ,"_summarytable.xlsx",sep=""), 
                     data = data.frame(unclass(summary(lidar_whoutoulier)), check.names = FALSE, stringsAsFactors = FALSE), 
                     sheet = "masked_stat", 
                     header = TRUE,
                     clearSheets = TRUE)

lidar_whoutoulier_r <- rasterFromXYZ(lidar_whoutoulier)
writeRaster(lidar_whoutoulier_r, paste(substr(filename, 1, nchar(filename)-4) ,"_lidar_whoutoulier.tif",sep=""),overwrite=TRUE)
