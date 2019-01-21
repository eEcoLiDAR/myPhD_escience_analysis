"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("rgdal")
#source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions.R")

VegStr_VertDistr_Metrics = function(z)
{
  library("e1071")
  vertdistr_metrics = list(
    zstd = sd(z[z>quantile(z, 0.25)]),
    zvar = var(z[z>quantile(z, 0.25)]),
    zskew = skewness(z[z>quantile(z, 0.25)]),
    zkurto = kurtosis(z[z>quantile(z, 0.25)]),
    zentropy2=entropy(z[z>quantile(z, 0.25)]+500, by = 0.5,zmax=NULL)
  )
  return(vertdistr_metrics)
}

HeightMetrics = function(z)
{
  heightmetrics = list(
    zmax = max(z[z>quantile(z, 0.25)]), 
    zmean = mean(z[z>quantile(z, 0.25)]),
    zmedian = median(z[z>quantile(z, 0.25)]),
    z025quantile = quantile(z[z>quantile(z, 0.25)], 0.25),
    z075quantile = quantile(z[z>quantile(z, 0.25)], 0.75),
    z090quantile = quantile(z[z>quantile(z, 0.25)], 0.90)
  )
  return(heightmetrics)
}

# Set working dirctory

workdirectories=list("D:/Koma/Paper1/ALS/02gz2/","D:/Koma/Paper1/ALS/02hz1/","D:/Koma/Paper1/ALS/06en2/","D:/Koma/Paper1/ALS/06fn1/")

for (workingdirectory in workdirectories){
  
  print(workingdirectory)
  
  setwd(workingdirectory)
  
  resolution=2.5
  
  pdf("LiDAR_process2.pdf")
  
  # Create Catalog
  setwd(paste(workingdirectory,"ground/",sep=""))
  
  ground_ctg <- catalog(paste(workingdirectory,"ground/",sep=""))
  
  ground_ctg@input_options$filter <- ""
  opt_chunk_buffer(ground_ctg) <- 0
  opt_cores(ground_ctg) <- 18
  
  # Calculate metrics into separate files per feature groups and classes -- point cloud based -- above 0.25 percentiles
  
  vertdistr_metrics_whoutgr = grid_metrics(ground_ctg, VegStr_VertDistr_Metrics(Z),res=resolution)
  plot(vertdistr_metrics_whoutgr)
  
  writeRaster(vertdistr_metrics_whoutgr,"vertdistr_metrics_whoutgr2.grd",overwrite=TRUE)
  
  heightmetrics_whoutgr = grid_metrics(ground_ctg, HeightMetrics(Z),res=resolution)
  plot(heightmetrics_whoutgr)
  
  writeRaster(heightmetrics_whoutgr,"heightmetrics_whoutgr2.grd",overwrite=TRUE)
  
  dtm_whoutgr = grid_metrics(ground_ctg,min(Z),res=resolution)
  crs(dtm_whoutgr) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  writeRaster(dtm_whoutgr, "dtm_whoutgr2.tif",overwrite=TRUE)
  
  plot(dtm_whoutgr)
  
  # Normalization
  
  heightmetrics_whoutgr$n_zmax=(heightmetrics_whoutgr$zmax+500)-(dtm_whoutgr+500)
  heightmetrics_whoutgr$n_zmean=(heightmetrics_whoutgr$zmean+500)-(dtm_whoutgr+500)
  heightmetrics_whoutgr$n_zmedian=(heightmetrics_whoutgr$zmedian+500)-(dtm_whoutgr+500)
  heightmetrics_whoutgr$n_z025quantile=(heightmetrics_whoutgr$z025quantile+500)-(dtm_whoutgr+500)
  heightmetrics_whoutgr$n_z075quantile=(heightmetrics_whoutgr$z075quantile+500)-(dtm_whoutgr+500)
  heightmetrics_whoutgr$n_z090quantile=(heightmetrics_whoutgr$z090quantile+500)-(dtm_whoutgr+500)
  
  plot(heightmetrics_whoutgr)
  
  # Merge, organize files
  
  lidar_metrics_whoutgr=stack(vertdistr_metrics_whoutgr,heightmetrics_whoutgr)
  crs(lidar_metrics_whoutgr) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  
  writeRaster(lidar_metrics_whoutgr, "lidar_metrics_whoutgr2.grd", overwrite=TRUE)
  
  dev.off()
  
}