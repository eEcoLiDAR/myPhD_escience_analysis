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
library("maptools")

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/tiled/"
setwd(full_path) # working directory

# Workflow

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  
  start_time <- Sys.time()
  
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
  
  las = readLAS(file.names[i])
  las_ground = lasfilter(las, Classification == 2)
  
  dtm_mean = grid_metrics(las_ground, mean(Z), res=2.5)
  dtm_mean_r <- rasterFromXYZ(dtm_mean)
  writeRaster(dtm_mean_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_meandtm.tif",sep=""),overwrite=TRUE)
  
  ground_mask <- setValues(raster(dtm_mean_r), NA)
  ground_mask[dtm_mean_r>-1] <- 1
  
  dtm_boundary = rasterToPolygons(ground_mask,dissolve=TRUE)
  writeSpatialShape(dtm_boundary, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_bounddtm.shp",sep=""))
  
  lasclassify(las, dtm_boundary, field="layer")
  land = lasfilter(las, layer == 1)
  
  lasnormalize(land, dtm= NULL, method = "knnidw", k = 10L)
  writeLAS(land, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_norm.laz",sep=""))

  chm = grid_canopy(land, 2.5, subcircle = 0.2)
  chm_r <- rasterFromXYZ(chm)
  writeRaster(chm_r, paste(substr(file.names[i], 1, nchar(file.names[i])-4) ,"_chm.tif",sep=""),overwrite=TRUE)
  
  end_time <- Sys.time()
  print(end_time - start_time)
  
}
