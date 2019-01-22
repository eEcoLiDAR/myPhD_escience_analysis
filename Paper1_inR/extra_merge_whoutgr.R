"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"

library("raster")

workdirectories=list("D:/Koma/Paper1/ALS/02gz2/ground/","D:/Koma/Paper1/ALS/02hz1/ground/","D:/Koma/Paper1/ALS/06en2/ground/","D:/Koma/Paper1/ALS/06fn1/ground/")

for (workingdirectory in workdirectories){
  
  setwd(workingdirectory)
  
  lidar_metrics_wgr=stack(paste(workingdirectory,"run3/lidar_metrics.grd",sep=""))
  lidar_metrics_whgr=stack(paste(workingdirectory,"run4/lidar_metrics_whoutgr2.grd",sep=""))
  
  lidar_metrics=stack(lidar_metrics_wgr,lidar_metrics_whgr)
  names(lidar_metrics)
  
  crs(lidar_metrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  
  writeRaster(lidar_metrics, "lidar_metrics_updated.grd", overwrite=TRUE)
}
