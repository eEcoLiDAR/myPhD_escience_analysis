"
@author: Zsofia Koma, UvA
Aim: pre-processing of lidar data

input:
output:

fuctions:
Preprocessing
1. create DTM
2. normalize
3. create and export DTM, DSM

"

# Import required libraries
library("lidR")
library("rlas")
library("raster")

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/02gz2_lidr/tiled_test/"

##########################
# Create catalog         #
##########################

ctg = catalog(full_path)
plot(ctg)

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
}

