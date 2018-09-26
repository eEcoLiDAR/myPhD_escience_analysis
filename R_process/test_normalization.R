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

full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testiled2/"
setwd(full_path) # working directory

# simple

las = readLAS("tile_00001.laz")

hmax = grid_metrics(las, max(Z),res=2.5)
plot(hmax)

hmin = grid_metrics(las, min(Z),res=0.25)
plot(hmin)
plot3d(hmin)

lasnormalize(las, hmin)
plot(las)

hmax = grid_metrics(las, max(Z),res=2.5)
plot(hmax)

writeLAS(las, "las_norm.laz")

dtm = grid_terrain(las, res = 0.25, method = "delaunay")
plot(dtm)

lasnormalize(las, dtm)

writeLAS(las, "las_norm.laz")

# for

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
  
  las = readLAS(file.names[i])
  
  hmin = grid_metrics(las, min(Z),res=0.5)
  lasnormalize(las, hmin)
  
  writeLAS(las, paste(substr(filename, 1, nchar(filename)-4) ,"_norm.laz",sep=""))
  
}
