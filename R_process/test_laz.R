library("lidR")
library("rlas")

setwd("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/tiled/")

las = readLAS("tile_00010_1.laz",filter="-set_classification 2")

print(min(las@data$Classification))
print(max(las@data$Classification))