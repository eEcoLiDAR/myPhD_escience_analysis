"
@author: Zsofia Koma, UvA
Aim: Classification of AHN2 non-vegetation data
"

# Import required libraries
library("lidR")
library("rlas")
library("raster")
library("maptools")

library("sp")
library("spatialEco")
library("randomForest")
library("caret")

library("e1071")

# Set global variables
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS_orig/02gz2/"
lidarfile="u02gz2.laz"
training="training.shp"

setwd(full_path)

# Import lidar data and build up the catalog

nonground_ctg = catalog(paste(full_path,lidarfile,sep=""))
nonground_ctg@crs = sp::CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
plot(nonground_ctg)

cores(nonground_ctg) <- 3L
buffer(nonground_ctg) <- 1

# Calculate multiple metrics with parallelization
Metrics = function(X,Y,Z)
{
  xyz=rbind(X,Y,Z) 
  cov_m=cov(xyz)
  eigen_m=eigen(cov_m)
  
  metrics = list(
    zrange = range(Z), 
    zstd = sd(Z),
    pdens = length(Z)/6.25,
    eigen_largest = eigen_m$values[1],
    eigen_medium = eigen_m$values[2],
    eigen_smallest = eigen_m$values[3]
  )
  return(metrics)
}

create_metrics <- function(las) 
{
  metrics = grid_metrics(las, Metrics(X,Y,Z), res=2.5)
  return(metrics)
}

lidar_fea <- catalog_apply(nonground_ctg, create_metrics)
lidar_fea_db <- data.table::rbindlist(lidar_fea)

zrange_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,3)])
zstd_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,4)])
pdens_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,5)])
eigen_largest_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,6)])
eigen_medium_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,7)])
eigen_smallest_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,8)])

lidarmetrics_raster= stack(zrange_r, zstd_r, pdens_r, eigen_largest_r, eigen_medium_r, eigen_smallest_r) 
plot(lidarmetrics_raster)

crs(lidarmetrics_raster) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs" 
writeRaster(lidarmetrics_raster, paste(substr(lidarfile, 1, nchar(lidarfile)-4) ,"_metrics.tif",sep=""),overwrite=TRUE)

# Import tarining data
classes = rgdal::readOGR(training)

# Intersect lidar metrics with training data
vals <- extract(lidarmetrics_raster,classes)

classes$zrange <- vals[,1]
classes$zstd <- vals[,2]
classes$pdens <- vals[,3]
classes$eigen_largest <- vals[,4]
classes$eigen_medium <- vals[,5]
classes$eigen_smallest <- vals[,6]

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

  modelFit <- randomForest(x=trainclassifier[ ,c(3:8)], y=factor(trainclassifier$id))
  prediction <- predict(modelFit,testingSet[ ,c(3:8)])
  testingSet$rightPred <- prediction == testingSet$id
  conf_m<-table(prediction, testingSet$id)
  print(conf_m)

  accuracy <- sum(testingSet$rightPred)/nrow(testingSet)
  print(accuracy)
}

# Classify

modelRF <- randomForest(x=trainclassifier[ ,c(3:8)], y=factor(trainclassifier$id),importance = TRUE)
class(modelRF)
varImpPlot(modelRF)

predLC <- predict(lidarmetrics_raster, model=modelRF, na.rm=TRUE)
plot(predLC)

writeRaster(predLC, filename="classified_asprs.tif", format="GTiff",overwrite=TRUE)



