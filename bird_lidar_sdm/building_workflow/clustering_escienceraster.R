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

library("sp")
library("spatialEco")
library("randomForest")
library("caret")

# Set global variables
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
filename="terrainData100m_run1_filtered_lidarmetrics.rds"

raster="terrainData100m_run1_filtered.tif"
training="training.shp"

setwd(full_path)

# Import 
lidar_data=readRDS(file = filename)
print(summary(lidar_data))

classes = rgdal::readOGR(training)
lidarmetrics_r=stack(raster)
crs(lidarmetrics_r)="+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

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

# Random Forest

# Prepare dataset
vals <- extract(lidarmetrics_r,classes)

classes$terrainData100m_run1_filtered.1 <- vals[,1]
classes$terrainData100m_run1_filtered.2 <- vals[,2]
classes$terrainData100m_run1_filtered.3 <- vals[,3]
classes$terrainData100m_run1_filtered.4 <- vals[,4]
classes$terrainData100m_run1_filtered.5 <- vals[,5]
classes$terrainData100m_run1_filtered.6 <- vals[,6]
classes$terrainData100m_run1_filtered.7 <- vals[,7]
classes$terrainData100m_run1_filtered.8 <- vals[,8]
classes$terrainData100m_run1_filtered.9 <- vals[,9]
classes$terrainData100m_run1_filtered.10 <- vals[,10]
classes$terrainData100m_run1_filtered.11 <- vals[,11]
classes$terrainData100m_run1_filtered.12 <- vals[,12]
classes$terrainData100m_run1_filtered.13 <- vals[,13]
classes$terrainData100m_run1_filtered.14 <- vals[,14]

trainclassifier <- as(classes, "data.frame")
trainclassifier <- na.omit(trainclassifier)

# Accuracy assessment
first_seed <- 3
accuracies <-c()

for (i in 1:3){
  set.seed(first_seed)
  first_seed <- first_seed+1
  
  trainIndex <- createDataPartition(y=trainclassifier$id, p=0.5, list=FALSE)
  trainingSet<- trainclassifier[trainIndex,]
  testingSet<- trainclassifier[-trainIndex,]
  
  modelFit <- randomForest(x=trainclassifier[ ,c(3:16)], y=factor(trainclassifier$id))
  prediction <- predict(modelFit,testingSet[ ,c(3:16)])
  testingSet$rightPred <- prediction == testingSet$id
  conf_m<-table(prediction, testingSet$id)
  print(conf_m)
  
  accuracy <- sum(testingSet$rightPred)/nrow(testingSet)
  print(accuracy)
}

# Classify

modelRF <- randomForest(x=trainclassifier[ ,c(4,5,8,9,10)], y=factor(trainclassifier$id),importance = TRUE)
class(modelRF)
varImpPlot(modelRF)

# Crop
crop_poly <- as(extent(xmin, xmax, ymin, ymax), 'SpatialPolygons')
crs(crop_poly) <- crs("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

lidarmetrics_r_cropped <- crop(lidarmetrics_r, crop_poly)
plot(lidarmetrics_r_cropped)

writeRaster(lidarmetrics_r_cropped, filename="cropped.tif", format="GTiff",overwrite=TRUE)

predLC <- predict(lidarmetrics_r_cropped, model=modelRF, na.rm=TRUE)
plot(predLC,col=rainbow(3))

writeRaster(predLC, filename="classified.tif", format="GTiff",overwrite=TRUE)
