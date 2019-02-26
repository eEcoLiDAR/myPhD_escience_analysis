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

cores=18
chunksize=1000
buffer=2.5
resolution=2.5

# Create catalog and homogenize the point cloud (overlapping areas -> 10 pt/m2)
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_chunk_size(ctg) <- chunksize
opt_cores(ctg) <- cores
opt_output_files(ctg) <- paste(workingdirectory,"homogenized/{XLEFT}_{YBOTTOM}_homo",sep="")

homogenized_ctg=lasfilterdecimate(ctg,homogenize(10,1))

# Classify ground

opt_chunk_buffer(homogenized_ctg) <- buffer
opt_chunk_size(homogenized_ctg) <- chunksize
opt_cores(homogenized_ctg) <- cores
opt_output_files(homogenized_ctg) <- paste(workingdirectory,"ground/{XLEFT}_{YBOTTOM}_homo_gr",sep="")

ground_ctg <- lasground(homogenized_ctg, pmf(2.5,0.1))

# Normalize with point neighborhood

opt_chunk_buffer(ground_ctg) <- buffer
opt_chunk_size(ground_ctg) <- chunksize
opt_cores(ground_ctg) <- cores
opt_output_files(ground_ctg) <- paste(workingdirectory,"normalized_neibased/{XLEFT}_{YBOTTOM}_homo_gr_norm",sep="")

normalized_ctg=lasnormalize(ground_ctg,knnidw(k=20,p=2))