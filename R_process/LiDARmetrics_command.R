"
@author: Zsofia Koma, UvA
Aim: calculate LiDAR metrics related to the total vegetation coloumn with different resolutions

input:
output:

Fuctions:

Example: 
for f in *_land.las; do Rscript.exe D:/Koma/GitHub/myPhD_escience_analysis/R_process/LiDARmetrics_command.R C:/Koma/ $f;done
"

# Import required libraries
library("lidR")
library("rlas")
library("raster")
library("maptools")

library("e1071")

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
    zvar = var(z),
    zskew = skewness(z),
    zkurto = kurtosis(z)
  )
  return(vertdistr_metrics)
}

#####################################################

args = commandArgs(trailingOnly=TRUE)

full_path=args[1]
filename=args[2]

start_time <- Sys.time()

setwd(full_path)

print(filename)
writelax(filename)

las = readLAS(filename)

heightmetrics = grid_metrics(las, HeightMetrics(Z),res=1)
#plot(heightmetrics)

height_max_r <- rasterFromXYZ(heightmetrics[,c(1,2,3)])
writeRaster(height_max_r, paste(substr(filename, 1, nchar(filename)-4) ,"_heightmax.tif",sep=""),overwrite=TRUE)

height_mean_r <- rasterFromXYZ(heightmetrics[,c(1,2,4)])
writeRaster(height_mean_r, paste(substr(filename, 1, nchar(filename)-4) ,"_heightmean.tif",sep=""),overwrite=TRUE)

height_median_r <- rasterFromXYZ(heightmetrics[,c(1,2,5)])
writeRaster(height_median_r, paste(substr(filename, 1, nchar(filename)-4) ,"_heightmedian.tif",sep=""),overwrite=TRUE)

height_q025_r <- rasterFromXYZ(heightmetrics[,c(1,2,6)])
writeRaster(height_q025_r, paste(substr(filename, 1, nchar(filename)-4) ,"_heightq025.tif",sep=""),overwrite=TRUE)

height_q075_r <- rasterFromXYZ(heightmetrics[,c(1,2,7)])
writeRaster(height_q075_r, paste(substr(filename, 1, nchar(filename)-4) ,"_heightq075.tif",sep=""),overwrite=TRUE)

height_q090_r <- rasterFromXYZ(heightmetrics[,c(1,2,8)])
writeRaster(height_q090_r, paste(substr(filename, 1, nchar(filename)-4) ,"_heightq090.tif",sep=""),overwrite=TRUE)

coveragemetrics = grid_metrics(las, CoverageMetrics(Z,Classification),res=1)
#plot(coveragemetrics)

cover_pulsepenrat_r <- rasterFromXYZ(coveragemetrics[,c(1,2,3)])
writeRaster(cover_pulsepenrat_r, paste(substr(filename, 1, nchar(filename)-4) ,"_cover_pulsepenrat.tif",sep=""),overwrite=TRUE)

vertdistr_metrics = grid_metrics(las, VegStr_VertDistr_Metrics(Z),res=1)
#plot(vertdistr_metrics)

vertdistr_heightstd_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,3)])
writeRaster(vertdistr_heightstd_r, paste(substr(filename, 1, nchar(filename)-4) ,"_vertdistr_heightstd.tif",sep=""),overwrite=TRUE)

vertdistr_heightvar_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,4)])
writeRaster(vertdistr_heightvar_r, paste(substr(filename, 1, nchar(filename)-4) ,"_vertdistr_heightvar.tif",sep=""),overwrite=TRUE)

vertdistr_heightskew_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,5)])
writeRaster(vertdistr_heightskew_r, paste(substr(filename, 1, nchar(filename)-4) ,"_vertdistr_heightskew.tif",sep=""),overwrite=TRUE)

vertdistr_heightkurto_r <- rasterFromXYZ(vertdistr_metrics[,c(1,2,6)])
writeRaster(vertdistr_heightkurto_r, paste(substr(filename, 1, nchar(filename)-4) ,"_vertdistr_heightkurto.tif",sep=""),overwrite=TRUE)

end_time <- Sys.time()
print(end_time - start_time)

