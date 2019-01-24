"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("raster")

# Set working dirctory
workingdirectory="C:/Koma/Paper1/ALS/"

setwd(paste(workingdirectory,"ground/",sep=""))

ground_ctg <- catalog(paste(workingdirectory,"ground/",sep=""))

opt_chunk_buffer(ground_ctg) <- 0
opt_cores(ground_ctg) <- 3

# Homogenize the point cloud

orig_pdens=grid_density(ground_ctg)
plot(orig_pdens)
writeRaster(orig_pdens, "orig_pdens.tif",overwrite=TRUE)

opt_output_files(ground_ctg) <- paste(workingdirectory,"homogenized/{XLEFT}_{YBOTTOM}",sep="")

homogenized_ctg=lasfilterdecimate(ground_ctg,homogenize(10,1))

opt_output_files(homogenized_ctg)=""

hom_pdens=grid_density(homogenized_ctg)
plot(hom_pdens)
writeRaster(hom_pdens, "hom_pdens.tif",overwrite=TRUE)

# DTM
dtm = grid_metrics(homogenized_ctg,min(Z),res=2.5)
crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(dtm, "dtm.tif",overwrite=TRUE)

plot(dtm)

# Hillshade

slope <- terrain(dtm, opt='slope')
aspect <- terrain(dtm, opt='aspect')
dtm_shd <- hillShade(slope, aspect, 40, 270)

plot(dtm_shd, col=grey(0:100/100))

writeRaster(dtm_shd, "dtm_shd.tif",overwrite=TRUE)

# Normalize
opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized/{XLEFT}_{YBOTTOM}",sep="")
normalized_ctg=lasnormalize(homogenized_ctg,knnidw(k=50))

# Check DSMs
opt_output_files(homogenized_ctg) <- ""
opt_output_files(normalized_ctg) <- ""

dsm_whnorm = grid_metrics(homogenized_ctg,range(Z),res=2.5)
dsm_wnorm = grid_metrics(normalized_ctg,max(Z),res=2.5)

plot(dsm_whnorm)
plot(dsm_wnorm)

plot(dsm_whnorm-dsm_wnorm)
hist(dsm_whnorm-dsm_wnorm)

