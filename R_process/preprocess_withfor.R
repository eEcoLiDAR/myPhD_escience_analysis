"
@author: Zsofia Koma, UvA
Aim: pre-processing of lidar data one-by-one with for circle after tiling

input:
output:

fuctions:
Preprocessing
1. create DTM
2. normalize
3. create nDSM
4. create and export DTM, DSM
"

# Import required libraries
library("lidR")
library("rlas")
library("raster")

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/02gz2_lidr/tiled_test/"
setwd(full_path) # working directory

# Workflow
start_time <- Sys.time()

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
  
  las = readLAS(file.names[i])
  las_ground = lasfilter(las, Classification == 2)
  
  dtm_mean = grid_metrics(las_ground, mean(Z), res=2.5)
  dtm_mean_r <- rasterFromXYZ(dtm_mean)
  writeRaster(dtm_mean_r, paste(file.names[i],"_meandtm.tif",sep=""))
  
}

end_time <- Sys.time()
print(end_time - start_time)
