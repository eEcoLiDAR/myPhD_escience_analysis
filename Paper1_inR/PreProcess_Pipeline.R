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
opt_output_files(newctg) <- "D:/Koma/Paper1/ALS/01_test/tiled/{XLEFT}_{YBOTTOM}_ground"

# Extract ground points
ground_output <- lasground(newctg, csf(sloop_smooth = TRUE))

# Create DTM
opt_output_files(ground_output) <- "D:/Koma/Paper1/ALS/01_test/tiled/{XLEFT}_{YBOTTOM}_ground_dtm"
ground_output@input_options$filter <- "-keep_class 2"

dtm_output = grid_metrics(ground_output,min(Z),res=1.25) #somehow an windows error message occur related to usage gdal -- should accept and restart the program from here

# Hillshade
setwd(paste(workingdirectory,"tiled/",sep=""))
dtmfiles <- list.files(pattern = "_ground_dtm.tif")

alltiff <- lapply(dtmfiles,function(i){
  stack(i)
})

alltiff$fun <- mean
alltiff$na.rm <- TRUE
dtm <- do.call(mosaic, alltiff)

plot(dtm)

crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

writeRaster(dtm, "dtm.tif",overwrite=TRUE)

slope <- terrain(dtm, opt='slope')
aspect <- terrain(dtm, opt='aspect')
dtm_shd <- hillShade(slope, aspect, 40, 270)

plot(dtm_shd, col=grey(0:100/100))

writeRaster(dtm_shd, "dtm_shd.tif",overwrite=TRUE)

