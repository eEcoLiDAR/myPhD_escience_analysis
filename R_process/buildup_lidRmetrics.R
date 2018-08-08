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
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testmetrics/"
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
    zstd_0_1 = sd(z[z>0 & z<1]),
    zstd_1_25 = sd(z[z>1 & z<2.5]),
    zstd_25_5 = sd(z[z>2.5 & z<5]),
    zstd_5_75 = sd(z[z>5 & z<7.5]),
    zstd_75_1 = sd(z[z>7.5 & z<10]),
    zstd_a10 = sd(z[z>10]),
    
    zvar = var(z),
    zskew = skewness(z),
    
    zkurto = kurtosis(z),
    zkurto_0_1 = kurtosis(z[z>0 & z<1]),
    zkurto_1_25 = kurtosis(z[z>1 & z<2.5]),
    zkurto_25_5 = kurtosis(z[z>2.5 & z<5]),
    zkurto_5_75 = kurtosis(z[z>5 & z<7.5]),
    zkurto_75_1 = kurtosis(z[z>7.5 & z<10]),
    zkurto_a10 = kurtosis(z[z>10])
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
  
  height_mean_r <- rasterFromXYZ(heightmetrics[,c(1,2,4)])
  writeRaster(height_mean_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_heightmean.tif",sep=""),overwrite=TRUE)
  
  coveragemetrics = grid_metrics(las, CoverageMetrics(Z,Classification),res=1)
  plot(coveragemetrics)
  
  vertdistr_metrics = grid_metrics(las, VegStr_VertDistr_Metrics(Z),res=1)
  plot(vertdistr_metrics) 
  
  end_time <- Sys.time()
  print(end_time - start_time)
}