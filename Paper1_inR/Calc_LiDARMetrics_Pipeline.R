"
@author: Zsofia Koma, UvA
Aim: Calculate LiDAR metrics
"
library("lidR")

#Functions
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

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/test/"

setwd(workingdirectory)

# Set up catalog
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_cores(ctg) <- 3

heightmetrics = grid_metrics(ctg, HeightMetrics(Z),res=10)
plot(heightmetrics)

writeRaster(heightmetrics,"heightmetrics.grd",overwrite=TRUE)