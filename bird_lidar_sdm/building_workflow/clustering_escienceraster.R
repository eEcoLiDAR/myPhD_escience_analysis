"
@author: Zsofia Koma, UvA
Aim: test clustering for Global Ecology and Biodiversity course
"

# Import libraries
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

library("sdm")
library("corrplot")
library("Hmisc")
library("scatterplot3d")

# Set global variables
full_path="C:/Users/zsofi/Google Drive/_Amsterdam/xOther/lidar_bird_dsm_workflow/birdatlas/"
filename="terrainData100m_run1_filtered_lidarmetrics.rds"

setwd(full_path)

# Import LiDAR 
lidar_data=readRDS(file = filename)
print(summary(lidar_data))

# Make a spatial selection
xmin=165000
xmax=170000
ymin=500000
ymax=506250

lidar_filt=lidar_data[ which(lidar_data[,"x"]<xmax & lidar_data[,"x"]>xmin & lidar_data[,"y"]<ymax & lidar_data[,"y"]>ymin),]
ggplot() + 
  geom_path(color="white") +
  coord_equal() +
  geom_raster(data=lidar_filt,aes(x,y,fill=max_z))

# Plot feature space
ggplot(lidar_filt, aes(x=density_absolute_mean, y=kurto_z)) + geom_point()

scatterplot3d(x=lidar_filt$max_z, y=lidar_filt$density_absolute_mean, z=lidar_filt$kurto_z)

# K-means
clusters <- kmeans(lidar_filt[,c(3,15,16,13)], 2)
lidar_filt$cluster <- as.factor(clusters$cluster)

p1=ggplot() + 
  geom_path(color="white") +
  coord_equal() +
  geom_raster(data=lidar_filt,aes(x,y,fill=max_z))

p2=ggplot() + 
  geom_path(color="white") +
  coord_equal() +
  geom_raster(data=lidar_filt,aes(x,y,fill=factor(cluster)))

grid.arrange(p1, p2, ncol = 2)

# Hierarhical clustering
hclust_avg <- hclust(dist(lidar_filt[,c(3,16)], method = 'euclidean'), method = 'average')
plot(hclust_avg)

cut_avg <- cutree(hclust_avg, k = 10)
lidarmetrics_clust <- mutate(lidar_filt[,c(1,2)], cluster = cut_avg)

p1=ggplot() + 
  geom_path(color="white") +
  coord_equal() +
  geom_raster(data=lidar_filt,aes(x,y,fill=max_z))

p2=ggplot() + 
  geom_path(color="white") +
  coord_equal() +
  geom_raster(data=lidarmetrics_clust,aes(x,y,fill=factor(cluster)))

grid.arrange(p1, p2, ncol = 2)

# Export
lidarmetrics_r=rasterFromXYZ(lidarmetrics_clust[,c(1,2,3)])
writeRaster(lidarmetrics_r, paste(substr(lidarfile, 1, nchar(lidarfile)-4) ,"_clustered.tif",sep=""),overwrite=TRUE)