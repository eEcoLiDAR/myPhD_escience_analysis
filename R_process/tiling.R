"
@author: Zsofia Koma, UvA
Aim: Apply and test LidR over large areas

Input: 
Output: 

Function:

Example usage:   

ToDo: 

Question:

"
# Import required libraries
library("lidR")
library("rlas")
library("raster")

# Set global variables

##########################
# Create catalog         #
##########################

ctg = catalog("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/")

cores(ctg) <- 4L
tiling_size(ctg) <- 1000
buffer(ctg) <- 5

ctg = catalog_retile(ctg, "D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled/", "tile_") 

##########################
# Create DTM             #
##########################

writelax("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/g02gz2.laz")
ctg_dtm = catalog("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/g02gz2.laz")

cores(ctg_dtm) <- 4L
tiling_size(ctg_dtm) <- 1000
buffer(ctg_dtm) <- 5

ctg_dtm = catalog_retile(ctg_dtm, "D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled_fordtm/", "fordtm_") 

file.names <- dir("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled_fordtm/", pattern =".las")
for(i in 1:length(file.names)){
  print(paste("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled_fordtm/",file.names[i],sep=""))
  writelax(paste("D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/tiled_fordtm/",file.names[i],sep=""))
}

createDTM <- function(las) 
{
  las@data$Classification=2
  dtm = grid_metrics(las, mean(Z), 10)
  return(dtm)
}

dtm_tiles <- catalog_apply(ctg_dtm, createDTM)
dtm <- data.table::rbindlist(dtm_tiles)

dtm_r <- rasterFromXYZ(dtm)
writeRaster(dtm_r, filename="D:/Paper1_ReedbedStructure/Data/ALS/ForProcess/dtm.tif", format="GTiff",overwrite=TRUE)

plot(dtm_r,colorPalette = terrain.colors(100))