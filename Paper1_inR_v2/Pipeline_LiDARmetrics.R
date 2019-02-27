"
@author: Zsofia Koma, UvA
Aim: This script is aimed the pre-process AHN2 data (tile, homogenize, extract ground points, create DTM and apply point neighborhood based normalization)
"

# Import required R packages
library("lidR")
library("rgdal")


stdeigenmetrics = function(X,Y,Z)
{
  xyz=cbind(X,Y,Z) 
  cov_m=cov(xyz) 
  
  if(sum(is.na(cov_m))==0) {
    
    eigen_m=eigen(cov_m)
    
    shapemetrics = list(
      curvature = eigen_m$values[3]/(eigen_m$values[1]+eigen_m$values[2]+eigen_m$values[3]),
      linearity = (eigen_m$values[1]-eigen_m$values[2])/eigen_m$values[1],
      planarity = (eigen_m$values[2]-eigen_m$values[3])/eigen_m$values[1],
      sphericity = eigen_m$values[3]/eigen_m$values[1]
    )
    return(shapemetrics)
  }
}

# Set working directory
workingdirectory="D:/Koma/Paper1_v2/ALS/" ## set this directory where your input las files are located
setwd(workingdirectory)

cores=18
chunksize=1000
buffer=2.5
resolution=2.5

rasterOptions(maxmemory = 200000000000)

# Set cataloges

ground_ctg <- catalog(paste(workingdirectory,"test_ground/",sep=""))
normalized_ctg <- catalog(paste(workingdirectory,"test_normalized_neibased/",sep=""))

opt_chunk_buffer(ground_ctg) <- buffer
opt_chunk_size(ground_ctg) <- chunksize
opt_cores(ground_ctg) <- cores

shapemetrics = grid_metrics(ground_ctg,  stdeigenmetrics(X,Y,Z), res = resolution)
plot(shapemetrics)