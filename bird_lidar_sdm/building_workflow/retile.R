"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="D:/Koma/lidar_bird_dsm_workflow/testsite/"
workingdirectory="D:/Koma/lidar_bird_dsm_workflow/testsite1/"
setwd(workingdirectory)

# Create catalog
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_chunk_size(ctg) <- 1000
opt_cores(ctg) <- 3
opt_output_files(ctg) <- paste(workingdirectory,"tiled/{XLEFT}_{YBOTTOM}",sep="")

# Retile catalog
newctg = catalog_retile(ctg)
