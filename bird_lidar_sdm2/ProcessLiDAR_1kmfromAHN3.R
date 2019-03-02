"
@author: Zsofia Koma, UvA
Aim: This script is aimed the pre-process AHN2 data (tile, homogenize, extract ground points, create DTM and apply point neighborhood based normalization)
"

# Import required R packages
library("lidR")
library("rgdal")

# Set working directory
workingdirectory="D:/Koma/Paper3/Baardman_1km/" ## set this directory where your input las files are located
setwd(workingdirectory)

cores=18
chunksize=1000
buffer=2.5
resolution=10

rasterOptions(maxmemory = 200000000000)

# Create catalog and homogenize the point cloud (overlapping areas -> 10 pt/m2)
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_chunk_size(ctg) <- chunksize
opt_cores(ctg) <- cores
opt_output_files(ctg) <- paste(workingdirectory,"homogenized/{XLEFT}_{YBOTTOM}_homo",sep="")

homogenized_ctg=lasfilterdecimate(ctg,homogenize(10,1))

# Normalize with point neighborhood

opt_chunk_buffer(homogenized_ctg) <- buffer
opt_chunk_size(homogenized_ctg) <- chunksize
opt_cores(homogenized_ctg) <- cores
opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized_neibased/{XLEFT}_{YBOTTOM}_homo_gr_norm",sep="")

normalized_ctg=lasnormalize(homogenized_ctg,knnidw(k=20,p=2))

# Create DSM

dsm = grid_metrics(homogenized_ctg,max(Z),res=10)
crs(dsm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(dsm, "dsm.tif",overwrite=TRUE)

# Hillshade

slope <- terrain(dsm, opt='slope')
aspect <- terrain(dsm, opt='aspect')
dsm_shd <- hillShade(slope, aspect, 40, 270)

writeRaster(dsm_shd, "dsm_shd.tif",overwrite=TRUE)