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
dtm_cc=stack("C:/Koma/Paper1/ALS/dtm_fromcc.tif")
plot(dtm_cc)

opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized2/{XLEFT}_{YBOTTOM}_1",sep="")
normalized_ctg=lasnormalize(homogenized_ctg,knnidw(k=5,p=6))

opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized2/{XLEFT}_{YBOTTOM}_2",sep="")
normalized_ctg2=lasnormalize(homogenized_ctg,knnidw(k=5,p=2))

opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized2/{XLEFT}_{YBOTTOM}_3",sep="")
normalized_ctg3=lasnormalize(homogenized_ctg,knnidw(k=10,p=10))

# Check back
opt_output_files(normalized_ctg) <- ""
norm_error1 = grid_metrics(normalized_ctg,length(Z[Z<0]),res=2.5)
plot(norm_error1)
hist(norm_error1)

opt_output_files(normalized_ctg2) <- ""
norm_error2 = grid_metrics(normalized_ctg2,length(Z[Z<0]),res=2.5)
plot(norm_error2)
hist(norm_error2)

opt_output_files(normalized_ctg3) <- ""
norm_error3 = grid_metrics(normalized_ctg3,length(Z[Z<0]),res=2.5)
plot(norm_error3)
hist(norm_error3)
