# Import required libraries
library("lidR")

##########################
# Label ground points    #
##########################

las_ground = readLAS("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/g02gz2.laz",filter="-set_classification 2")
writeLAS(las_ground, "D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/g02gz2_ground.laz")

##########################
# Create catalog         #
##########################

ctg = catalog("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/classified/")

cores(ctg) <- 4L
tiling_size(ctg) <- 1000
buffer(ctg) <- 5

ctg = catalog_retile(ctg, "D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/tiled/", "tile_",ext="laz") 