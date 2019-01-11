"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/01_test/"
setwd(workingdirectory)

# Set filenames
req_tile="02gz2"

# Download the required files
download.file(paste("http://geodata.nationaalgeoregister.nl/ahn2/extract/ahn2_","gefilterd/g",req_tile,".laz.zip",sep=""),
              paste("g",req_tile,".laz.zip",sep=""))
download.file(paste("http://geodata.nationaalgeoregister.nl/ahn2/extract/ahn2_","uitgefilterd/u",req_tile,".laz.zip",sep=""),
              paste("u",req_tile,".laz.zip",sep=""))

# Unzip
unzip(paste("g",req_tile,".laz.zip",sep=""))
unzip(paste("u",req_tile,".laz.zip",sep=""))

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
opt_output_files(newctg) <- "D:/Koma/Paper1/ALS/01_test/tiled/ground/{XLEFT}_{YBOTTOM}_ground"

# Extract ground points
ground_output <- lasground(newctg, csf(sloop_smooth = TRUE))

# Create DTM
opt_output_files(ground_output) <- "D:/Koma/Paper1/ALS/01_test/tiled/{XLEFT}_{YBOTTOM}_ground_dtm"

dtm_output = grid_metrics(ground_output,mean(Z),res=1.25)



