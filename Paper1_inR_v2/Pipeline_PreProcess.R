"
@author: Zsofia Koma, UvA
Aim: This script is aimed the pre-process AHN2 data (tile, homogenize, extract ground points, create DTM and apply point neighborhood based normalization)
"

# Import required R packages
library("lidR")
library("rgdal")

# Set working directory
workingdirectory="D:/Koma/Paper1_v2/ALS/" ## set this directory where your input las files are located
setwd(workingdirectory)

# Create catalog and homogenize the point cloud (overlapping areas -> 10 pt/m2)
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_chunk_size(ctg) <- 2000
opt_cores(ctg) <- 18
opt_output_files(ctg) <- paste(workingdirectory,"homogenized/{XLEFT}_{YBOTTOM}_homo",sep="")

homogenized_ctg=lasfilterdecimate(ctg,homogenize(10,1))

