"
@author: Zsofia Koma, UvA

Aim: pre-process LiDAR data

input: downloaded laz file
output: ground-vegetation laz file

Fuctions:


Example: 

"

library("lidR")
library("rlas")

library(rgdal)
library(raster)
library(sp)
library(spatialEco)

# functions

CoverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    pulsepenrat = length(z[classification==2])/length(z)
  )
  return(coveragemetrics)
}


######################################################################

full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testiled2/"
setwd(full_path) # working directory

las = readLAS("tile_00001.laz")

# try 1

coveragemetrics = grid_metrics(las, CoverageMetrics(Z,Classification),res=1)

cover_pulsepenrat_r <- rasterFromXYZ(coveragemetrics[,c(1,2,3)])

lasclassify(las, cover_pulsepenrat_r, "PulsePen")

las_land=lasfilter(las,PulsePen > 0)
#writeLAS(water, "las_other.laz")

lasnormalize(las_land, dtm= NULL, method = "knnidw", k = 10L)
writeLAS(las_land, "las_norm.laz")

# try 2

hmax = grid_metrics(las, range(Z),res=2.5)
plot(hmax)

hmean1 = grid_metrics(las, mean(Z),res=2.5)
plot(hmean1)

hmean = grid_metrics(las, mean(Z)-min(Z),res=2.5)
plot(hmean)


