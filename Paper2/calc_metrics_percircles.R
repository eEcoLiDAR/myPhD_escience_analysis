"
@author: Zsofia Koma, UvA
Aim: Exploration plots
"
library("lidR")
library("rgdal")
library("sdm")
library("raster")

library("e1071")

# Feature calc. function
proportion = function(z, by = 1)
{
  z_norm=z-min(z)
  bk = seq(0, ceiling(50/by)*by, by)
  hist = hist(z_norm,bk,plot=FALSE)
  p=(hist$counts/length(z_norm))
  
  return(p)
}

FeaCalc = function(z,i,e)
{
  
  p=proportion(z, by = 1)
  p_whnull=p[p>0]
  
  metrics = list(
    cancov = (length(z[z>mean(z)])/length(z))*100,
    dens_perc_b2 = (length(z[z<2])/length(z))*100,
    dens_perc_b5 = (length(z[z>2 & z<5])/length(z))*100,
    zmean = mean(z),
    zmedian = median(z),
    z025quantile = quantile(z, 0.25),
    z075quantile = quantile(z, 0.75),
    z095quantile = quantile(z, 0.95),
    zstd = sd(z),
    zkurto = kurtosis(z),
    simpson = 1/sum(sqrt(p)),
    shannon = -sum(p_whnull*log(p_whnull)),
    istd = sd(i),
    nofret_std=sd(e)
  )
  return(metrics)
}

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/"
#workingdirectory="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/"
setwd(workingdirectory)

files <- list.files(pattern = "\\.laz$")

for (file in files) {
  print(file)
  
  las=readLAS(file)
  
  lasnormalize(las, knnidw(k=20,p=2))
  
  writeLAS(las,paste(substr(file,1,nchar(file)-4),"norm.laz",sep=""))
  
}

# Vegetation metrics

normfiles <- list.files(pattern = "norm.laz$")
resolution=10

for (normfile in normfiles) {
  print(normfile)
  
  las=readLAS(normfile)
  
  las_veg=lasfilter(las,Classification==1)
  
  vegmetrics = grid_metrics(las_veg, FeaCalc(Z,Intensity,NumberOfReturns),res = resolution)
  crs(vegmetrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  writeRaster(vegmetrics,paste(normfile,"_vegmetrics_",resolution,".grd",sep=""),overwrite=TRUE)
  
}