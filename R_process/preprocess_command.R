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

args = commandArgs(trailingOnly=TRUE)

full_path=args[1]
filename=args[2]

start_time <- Sys.time()

setwd(full_path)

print(paste(full_path,filename,sep=""))
writelax(paste(full_path,filename,sep=""))

las = readLAS(filename)
las_ground = lasfilter(las, Classification == 2)

dtm_mean = grid_metrics(las_ground, mean(Z), res=2.5)
dtm_mean_r <- rasterFromXYZ(dtm_mean)
writeRaster(dtm_mean_r, paste(substr(filename, 1, nchar(filename)-4) ,"_meandtm.tif",sep=""),overwrite=TRUE)

ground_mask <- setValues(raster(dtm_mean_r), NA)
ground_mask[dtm_mean_r>-1] <- 1

dtm_boundary = rasterToPolygons(ground_mask,dissolve=TRUE)
writeSpatialShape(dtm_boundary, paste(substr(filename, 1, nchar(filename)-4) ,"_bounddtm.shp",sep=""))

lasclassify(las, dtm_boundary, field="layer")
land = lasfilter(las, layer == 1)

lasnormalize(land, dtm= NULL, method = "knnidw", k = 10L)
writeLAS(land, paste(substr(filename, 1, nchar(filename)-4) ,"_norm.las",sep=""))

chm = grid_canopy(land, 2.5, subcircle = 0.2)
chm_r <- rasterFromXYZ(chm)
writeRaster(chm_r, paste(substr(filename, 1, nchar(filename)-4) ,"_chm.tif",sep=""),overwrite=TRUE)

end_time <- Sys.time()
print(end_time - start_time)
