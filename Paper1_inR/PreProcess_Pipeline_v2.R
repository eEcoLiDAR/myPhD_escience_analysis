"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("raster")

resolution=2.5
core=18

workdirectories=list("D:/Koma/Paper1/ALS/02gz2/ground/","D:/Koma/Paper1/ALS/02hz1/ground/","D:/Koma/Paper1/ALS/06en2/ground/","D:/Koma/Paper1/ALS/06fn1/ground/")

for (workingdirectory in workdirectories){
  
  print(workingdirectory)
  
  setwd(workingdirectory)
  
  # Extract ground points
  ctg <- catalog(workingdirectory)
  
  opt_chunk_buffer(ctg) <- 2.5
  opt_cores(ctg) <- core
  opt_output_files(ctg) <- paste(workingdirectory,"ground/{XLEFT}_{YBOTTOM}_ground",sep="")
  
  ground_ctg <- lasground(ctg, pmf(0.5,0.2))
  
  ground_ctg@input_options$filter <- "-keep_class 2"
  opt_chunk_buffer(ground_ctg) <- 0
  opt_cores(ground_ctg) <- core
  
  dtm = grid_metrics(ground_ctg,min(Z),res=resolution)
  crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  writeRaster(dtm, "dtm.tif",overwrite=TRUE)
  
  #plot(dtm)
  
  # Hillshade
  
  slope <- terrain(dtm, opt='slope')
  aspect <- terrain(dtm, opt='aspect')
  dtm_shd <- hillShade(slope, aspect, 40, 270)
  
  #plot(dtm_shd, col=grey(0:100/100))
  
  writeRaster(dtm_shd, "dtm_shd.tif",overwrite=TRUE)
  
  # Homogenize the point cloud
  
  ground_ctg@input_options$filter <- ""
  opt_output_files(ground_ctg)=""
  
  orig_pdens=grid_density(ground_ctg)
  crs(orig_pdens) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  writeRaster(orig_pdens, "orig_pdens.tif",overwrite=TRUE)
  
  opt_output_files(ground_ctg) <- paste(workingdirectory,"homogenized/{XLEFT}_{YBOTTOM}",sep="")
  
  homogenized_ctg=lasfilterdecimate(ground_ctg,homogenize(10,1))
  
  opt_output_files(homogenized_ctg)=""
  opt_cores(homogenized_ctg) <- core
  
  hom_pdens=grid_density(homogenized_ctg)
  crs(hom_pdens) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  writeRaster(hom_pdens, "hom_pdens.tif",overwrite=TRUE)
  
  # Normalize
  opt_output_files(homogenized_ctg) <- paste(workingdirectory,"normalized/{XLEFT}_{YBOTTOM}",sep="")
  normalized_ctg=lasnormalize(homogenized_ctg,knnidw(k=50))
  
}