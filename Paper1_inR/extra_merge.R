"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"

library("raster")

workdirectories=list("D:/Koma/Paper1/ALS/02gz2/ground/","D:/Koma/Paper1/ALS/02hz1/ground/","D:/Koma/Paper1/ALS/06en2/ground/","D:/Koma/Paper1/ALS/06fn1/ground/")


for (workingdirectory in workdirectories){
  
  setwd(workingdirectory)
  
  coveragemetrics=stack(paste(workingdirectory,"coveragemetrics.grd",sep=""))
  heightmetrics=stack(paste(workingdirectory,"heightmetrics.grd",sep=""))
  shapemetrics=stack(paste(workingdirectory,"shapemetrics.grd",sep=""))
  horizontalmetrics=stack(paste(workingdirectory,"horizontal_metrics.grd",sep=""))
  verticalmetrics=stack(paste(workingdirectory,"vertdistr_metrics.grd",sep=""))
  dtm_metrics=stack(paste(workingdirectory,"/run3/dtm_metrics.grd",sep=""))
  
  lidar_metrics=stack(coveragemetrics,heightmetrics,shapemetrics,horizontalmetrics,verticalmetrics,dtm_metrics)
  names(c(coveragemetrics,heightmetrics,shapemetrics,horizontalmetrics,verticalmetrics,dtm_metrics))
  
  crs(lidar_metrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  
  writeRaster(lidar_metrics, "lidar_metrics_updated.grd", overwrite=TRUE)
}
