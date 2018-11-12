"
@author: Zsofia Koma, UvA
Aim: just fast export

input:
output:

Fuctions:

Example: 

"

# Import required libraries
library("lidR")
library("rlas")

#Import
full_path="D:/Koma/Paper1_ReedStructure/TestWorkflow/justfortest/"
filename="tile_00015.laz"

setwd(full_path)

start_time <- Sys.time()

las = readLAS(filename)
las_nonground = lasfilter(las, Classification != 2)

writeLAS(las_nonground,paste(substr(filename, 1, nchar(filename)-4) ,"_nonground.las",sep=""))

end_time <- Sys.time()
print(end_time - start_time)