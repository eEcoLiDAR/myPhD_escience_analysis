"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/test/"
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

opt_chunk_size(ctg) <- 1000
opt_cores(ctg) <- 2
#plot(ctg, chunk = TRUE)

opt_output_files(ctg) <- "D:/Koma/Paper1/ALS/test/ground/{XLEFT}_{YBOTTOM}_ground"

ground_output <- lasground(ctg, pmf(3,1.5))
