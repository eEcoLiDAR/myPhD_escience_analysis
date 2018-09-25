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

full_path="C:/zsofia/Amsterdam/Paper1/"
setwd(full_path) # working directory

las = readLAS("tile_00015.laz")

hmax = grid_metrics(las, max(Z),res=2.5)
plot(hmax)

hmin = grid_metrics(las, min(Z),res=10)
plot(hmin)
plot3d(hmin)

lasnormalize(las, hmin)
plot(las)

hmax = grid_metrics(las, max(Z),res=2.5)
plot(hmax)

writeLAS(las, "las_norm.laz")
