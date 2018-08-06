"
@author: Zsofia Koma, UvA
Aim: calculate LiDAR metrics with different resolutions

input:
output:

Fuctions:


Question:



"
# Import required libraries
library("lidR")
library("rlas")
library("raster")

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testmetrics/"
setwd(full_path) # working directory

# calculate LiDAR metrics

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  
  start_time <- Sys.time()
  
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
  
  las = readLAS(file.names[i])
  
  end_time <- Sys.time()
  print(end_time - start_time)
  
}