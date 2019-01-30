"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"

library("raster")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/forClassification_run4/"
setwd(workingdirectory)

# Get the name of the colomns

col_names=names(stack("02gz2_lidar_metrics_updated.grd"))

# Read and merge data

files <- list.files(pattern = ".grd")

alltiff <- lapply(files,function(i){
  stack(i)
})

alltiff$fun <- mean
alltiff$na.rm <- TRUE
lidar_metrics <- do.call(mosaic, alltiff)

names(lidar_metrics) <- col_names

# Drop layers which are wrong

lidar_metrics=dropLayer(lidar_metrics, c(16,17,18,19,20,21,22))

# Export

crs(lidar_metrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(lidar_metrics, "lidar_metrics.grd",overwrite=TRUE)
