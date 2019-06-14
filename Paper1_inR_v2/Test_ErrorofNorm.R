"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN3 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"
workingdirectory="D:/Koma/Paper1/normalized_neibased/"
setwd(workingdirectory)

#Import 

filter_below0 = function(chunk)
{
  las = readLAS(chunk)
  if (is.empty(las)) return(NULL)
  
  las <- lasfilter(las, Z<0)
  return(las)
}

project = catalog(workingdirectory)

opt_chunk_buffer(project) <- 0
opt_chunk_size(project)   <- 2000

output <- catalog_apply(project, filter_below0)