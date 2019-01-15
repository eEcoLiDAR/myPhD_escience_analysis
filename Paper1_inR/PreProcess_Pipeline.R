"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/01_test/"
setwd(workingdirectory)

# Set filenames and dwnload and unzip the required dataset
req_tile=list("02gz2","02hz1","06en2","06fn1")

for (tile in req_tile){
  download.file(paste("http://geodata.nationaalgeoregister.nl/ahn2/extract/ahn2_","gefilterd/g",tile,".laz.zip",sep=""),
                                     paste("g",tile,".laz.zip",sep=""))
  download.file(paste("http://geodata.nationaalgeoregister.nl/ahn2/extract/ahn2_","uitgefilterd/u",tile,".laz.zip",sep=""),
                paste("u",tile,".laz.zip",sep=""))
  
  unzip(paste("g",tile,".laz.zip",sep=""))
  unzip(paste("u",tile,".laz.zip",sep=""))
  }

# Create catalog
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_chunk_size(ctg) <- 500
opt_cores(ctg) <- 18
opt_output_files(ctg) <- "D:/Koma/Paper1/ALS/01_test/tiled/{XLEFT}_{YBOTTOM}"

# Retile catalog
newctg = catalog_retile(ctg)

opt_chunk_buffer(newctg) <- 5
opt_cores(newctg) <- 18
opt_output_files(newctg) <- "D:/Koma/Paper1/ALS/01_test/ground/{XLEFT}_{YBOTTOM}_ground"

# Extract ground points
ground_ctg <- lasground(newctg, csf(sloop_smooth = TRUE))

# Create DTM
setwd(paste(workingdirectory,"ground/",sep=""))

pdf("pre_process.pdf")

ground_ctg <- catalog(paste(workingdirectory,"ground/",sep=""))

ground_ctg@input_options$filter <- "-keep_class 2"
opt_chunk_buffer(ground_ctg) <- 0
opt_cores(ground_ctg) <- 18

dtm = grid_metrics(ground_ctg,min(Z),res=2.5)
crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(dtm, "dtm.tif",overwrite=TRUE)

plot(dtm)

# Hillshade

slope <- terrain(dtm, opt='slope')
aspect <- terrain(dtm, opt='aspect')
dtm_shd <- hillShade(slope, aspect, 40, 270)

plot(dtm_shd, col=grey(0:100/100))

writeRaster(dtm_shd, "dtm_shd.tif",overwrite=TRUE)

# Create DSM
ground_ctg@input_options$filter <- ""

dsm = grid_metrics(ground_ctg,max(Z),res=2.5)
crs(dsm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(dsm, "dsm.tif",overwrite=TRUE)

plot(dsm)

# Hillshade

slope <- terrain(dsm, opt='slope')
aspect <- terrain(dsm, opt='aspect')
dsm_shd <- hillShade(slope, aspect, 40, 270)

plot(dsm_shd, col=grey(0:100/100))

writeRaster(dsm_shd, "dsm_shd.tif",overwrite=TRUE)

dev.off()
