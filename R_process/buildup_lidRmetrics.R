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
    zmedian = median(z)
  )
  return(heightmetrics)
}

CoverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    nofveg=length(z[classification!=2]),
    nofpoints=length(z),
    pulsepenrat = length(z[classification!=2])/length(z)
  )
  return(coveragemetrics)
}

VegStr_VertDistr_Metrics = function(z)
{
  vertdistr_metrics = list(
    zstd = sd(z),
    zvar = var(z),
    zskew = skewness(z),
    zkurto = kurtosis(z)
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
  
  #heightmetrics = grid_metrics(las, HeightMetrics(Z),res=1)
  #plot(heightmetrics)
  
  #coveragemetrics = grid_metrics(las, CoverageMetrics(Z,Classification),res=1)
  #plot(coveragemetrics)
  
  vertdistr_metrics = grid_metrics(las, VegStr_VertDistr_Metrics(Z),res=1)
  plot(vertdistr_metrics)  
  
  end_time <- Sys.time()
  print(end_time - start_time)
}