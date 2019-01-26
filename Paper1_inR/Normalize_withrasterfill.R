"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("raster")
library("zoo")

# Set working dirctory
workingdirectory="C:/Koma/Paper1/ALS/"

setwd(paste(workingdirectory,"homogenized/",sep=""))

homogenized_ctg <- catalog(paste(workingdirectory,"homogenized/",sep=""))

opt_chunk_buffer(homogenized_ctg) <- 2.5
opt_cores(homogenized_ctg) <- 3

# DTM
dtm = grid_terrain(homogenized_ctg, algorithm = knnidw(k = 10, p=10), res=2.5)
crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(dtm, "dtm.tif",overwrite=TRUE)

# Fill gaps
dtm_m=as.matrix(dtm)

dtm_m_f=na.locf(dtm_m)
dtm_m_f_r=raster(dtm_m_f)
extent(dtm_m_f_r) <- extent(dtm)

# Normalize
opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized2/{XLEFT}_{YBOTTOM}_1",sep="")
normalized_ctg=lasnormalize(homogenized_ctg,tin())

# with CC
las=readLAS("C:/Koma/Paper1/ALS/homogenized/205000_600000.las")
dtm_cc=stack("C:/Koma/Paper1/ALS/raster.tif")

crs(dtm_cc) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
crs(las) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

las = lasmergespatial(las,dtm_cc$raster,"dtm")
las@data$Z=las@data$Z-las@data$dtm

las@header@PHB$`Max Z`=max(las@data$Z)
las@header@PHB$`Min Z`=min(las@data$Z)

writeLAS(las,"test_las.las")


