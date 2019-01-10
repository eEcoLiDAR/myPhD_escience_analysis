"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")

# Set working dirctory
workingdirectory="C:/Koma/Paper1/ALS/"
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

opt_chunk_size(ctg) <- 500
opt_cores(ctg) <- 3
#plot(ctg, chunk = TRUE)

opt_output_files(ctg) <- "C:/Koma/Paper1/ALS/{XLEFT}_{YBOTTOM}_ground"

output <- lasground(ctg, pmf(3,1.5))

#hmean <- grid_metrics(ctg, mean(Z), 100)
#plot(hmean)
