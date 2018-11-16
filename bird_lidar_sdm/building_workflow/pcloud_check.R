"
@author: Zsofia Koma, UvA
Aim: Check the point cloud for outliers for the Global Ecology and Biodiversity course
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
full_path="D:/Koma/lidar_bird_dsm_workflow/"
lidarfile="C_15FN2.LAZ"

setwd(full_path)

# Import
ctg = catalog(paste(full_path,lidarfile,sep=""))
ctg@crs = sp::CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
plot(ctg)

cores(ctg) <- 3L

# Calculate multiple metrics with parallelization
Metrics = function(Z)
{
  metrics = list(
    zrange = range(Z), 
    zstd = sd(Z),
    pdens = length(Z)/6.25
  )
  return(metrics)
}

create_metrics <- function(las) 
{
  metrics = grid_metrics(las, Metrics(Z), res=100)
  return(metrics)
}

lidar_fea <- catalog_apply(ctg, create_metrics)

lidar_fea_db <- data.table::rbindlist(lidar_fea)

zrange_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,3)])
zstd_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,4)])
pdens_r <- rasterFromXYZ(lidar_fea_db[,c(1,2,5)])

lidarmetrics_raster= stack(zrange_r, zstd_r, pdens_r) 
plot(lidarmetrics_raster)

crs(lidarmetrics_raster) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs" 
writeRaster(lidarmetrics_raster, paste(substr(lidarfile, 1, nchar(lidarfile)-4) ,"_metrics.tif",sep=""),overwrite=TRUE)