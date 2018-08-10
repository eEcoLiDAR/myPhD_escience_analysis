"
@author: Zsofia Koma, UvA
Aim: calculate LiDAR metrics with different resolutions

input:
output:

Fuctions:


Question:
"

# Import required libraries
library("lidR")
library("rlas")
library("raster")

library("e1071")

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testtiled/"
setwd(full_path) # working directory

# calculate LiDAR metrics

HeightMetrics = function(z)
{
  heightmetrics = list(
    zmax = max(z), 
    zmean = mean(z),
    zmedian = median(z),
    z025quantile = quantile(z, 0.25),
    z075quantile = quantile(z, 0.75),
    z090quantile = quantile(z, 0.90)
  )
  return(heightmetrics)
}

CoverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    pulsepenrat = length(z[classification==2])/length(z)
  )
  return(coveragemetrics)
}

VegStr_VertDistr_Metrics = function(z)
{
  vertdistr_metrics = list(
    zstd = sd(z),
    zstd_0_1 = sd(z[z>-5 & z<1]),
    zstd_1_25 = sd(z[z>1 & z<2.5]),
    zstd_25_5 = sd(z[z>2.5 & z<5]),
    zstd_5_75 = sd(z[z>5 & z<7.5]),
    zstd_75_1 = sd(z[z>7.5 & z<10]),
    
    zvar = var(z),
    zskew = skewness(z),
    
    zkurto = kurtosis(z),
    zkurto_0_1 = kurtosis(z[z>-5 & z<1]),
    zkurto_1_25 = kurtosis(z[z>1 & z<2.5]),
    zkurto_25_5 = kurtosis(z[z>2.5 & z<5]),
    zkurto_5_75 = kurtosis(z[z>5 & z<7.5]),
    zkurto_75_1 = kurtosis(z[z>7.5 & z<10])
  )
  return(vertdistr_metrics)
}

#executation

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  
  start_time <- Sys.time()
  
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
  
  las = readLAS(file.names[i])
  
  heightmetrics = grid_metrics(las, HeightMetrics(Z),res=1)
  plot(heightmetrics)
  
  height_max_r <- rasterFromXYZ(heightmetrics[,c(1,2,3)])
  writeRaster(height_max_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightmax.tif",sep=""),overwrite=TRUE)
  
  height_mean_r <- rasterFromXYZ(heightmetrics[,c(1,2,4)])
  writeRaster(height_mean_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightmean.tif",sep=""),overwrite=TRUE)
  
  height_median_r <- rasterFromXYZ(heightmetrics[,c(1,2,5)])
  writeRaster(height_median_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightmedian.tif",sep=""),overwrite=TRUE)
  
  height_q025_r <- rasterFromXYZ(heightmetrics[,c(1,2,6)])
  writeRaster(height_q025_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightq025.tif",sep=""),overwrite=TRUE)
  
  height_q075_r <- rasterFromXYZ(heightmetrics[,c(1,2,7)])
  writeRaster(height_q075_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightq075.tif",sep=""),overwrite=TRUE)
  
  height_q090_r <- rasterFromXYZ(heightmetrics[,c(1,2,8)])
  writeRaster(height_q090_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightq090.tif",sep=""),overwrite=TRUE)
  
  coveragemetrics = grid_metrics(las, CoverageMetrics(Z,Classification),res=1)
  plot(coveragemetrics)
  
  cover_pulsepenrat_r <- rasterFromXYZ(coveragemetrics[,c(1,2,3)])
  writeRaster(cover_pulsepenrat_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_cover_pulsepenrat.tif",sep=""),overwrite=TRUE)
  
  vertdistr_metrics = grid_metrics(las, VegStr_VertDistr_Metrics(Z),res=1)
  plot(vertdistr_metrics)
  
  vertdistr_heightstd_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,3)])
  writeRaster(vertdistr_heightstd_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightstd.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightstd_0_1_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,4)])
  writeRaster(vertdistr_heightstd_0_1_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightstd_0_1.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightstd_1_25_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,5)])
  writeRaster(vertdistr_heightstd_1_25_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightstd_1_25.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightstd_25_5_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,6)])
  writeRaster(vertdistr_heightstd_25_5_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightstd_25_5.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightstd_5_75_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,7)])
  writeRaster(vertdistr_heightstd_5_75_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightstd_5_75.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightstd_75_10_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,8)])
  writeRaster(vertdistr_heightstd_75_10_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightstd_75_10.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightvar_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,9)])
  writeRaster(vertdistr_heightvar_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightvar.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightskew_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,10)])
  writeRaster(vertdistr_heightskew_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightskew.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightkurto_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,11)])
  writeRaster(vertdistr_heightkurto_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightkurto.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightkurto_0_1_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,12)])
  writeRaster(vertdistr_heightkurto_0_1_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightkurto_0_1.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightkurto_1_25_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,13)])
  writeRaster(vertdistr_heightkurto_1_25_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightkurto_1_25.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightkurto_25_5_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,14)])
  writeRaster(vertdistr_heightkurto_25_5_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightkurto_25_5.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightkurto_5_75_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,15)])
  writeRaster(vertdistr_heightkurto_5_75_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightkurto_5_75.tif",sep=""),overwrite=TRUE)
  
  vertdistr_heightkurto_75_10_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,16)])
  writeRaster(vertdistr_heightkurto_75_10_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_vertdistr_heightkurto_75_10.tif",sep=""),overwrite=TRUE)
  
  end_time <- Sys.time()
  print(end_time - start_time)
}