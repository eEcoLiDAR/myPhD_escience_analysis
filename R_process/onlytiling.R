# Import required libraries
library("lidR")

##########################
# Label ground points    #
##########################

#las_ground = readLAS("D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/g02gz2.laz",filter="-set_classification 2")
#writeLAS(las_ground, "D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/g02gz2_ground.laz")

#las_ground = readLAS("D:/Koma/Paper1_ReedStructure/Data/ALS/02hz1/g02hz1.laz",filter="-set_classification 2")
#writeLAS(las_ground, "D:/Koma/Paper1_ReedStructure/Data/ALS/02hz1/g02hz1_ground.laz")

#las_ground = readLAS("D:/Koma/Paper1_ReedStructure/Data/ALS/06en2/g06en2.laz",filter="-set_classification 2")
#writeLAS(las_ground, "D:/Koma/Paper1_ReedStructure/Data/ALS/06en2/g06en2_ground.laz")

#las_ground = readLAS("D:/Koma/Paper1_ReedStructure/Data/ALS/06fn1/g06fn1.laz",filter="-set_classification 2")
#writeLAS(las_ground, "D:/Koma/Paper1_ReedStructure/Data/ALS/06fn1/g06fn1_ground.laz")

##########################
# Create catalog         #
##########################

ctg = catalog("D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/")

cores(ctg) <- 15L
tiling_size(ctg) <- 1000

ctg = catalog_retile(ctg, "D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/tiled/", "tile_",ext="laz") 