library(lidR)
library(future)
library(mapview)

#Global settings
#workdir="D:/Sync/_Amsterdam/10_ProcessWholeNL/Test/"
workdir="D:/Koma/ProcessWholeNL/TileGroup_9/"
setwd(workdir)

chunksize=2500
buffer=10
resolution=10

rasterOptions(maxmemory = 200000000000)

# Set up cataloge
plan(multisession, workers = 5L)
set_lidr_threads(5L)

# Retile
ctg <- catalog(workdir)

opt_chunk_buffer(ctg) <- buffer
opt_chunk_size(ctg) <- chunksize
opt_output_files(ctg) <- paste(workdir,"retiled/{XLEFT}_{YBOTTOM}_",sep="")
opt_filter(ctg) <- "-drop_class 6 9"

newctg = catalog_retile(ctg)

# Normalization
newctg <- catalog(paste(workdir,"retiled/",sep=""))

opt_chunk_buffer(newctg) <- buffer
opt_chunk_size(newctg) <- chunksize
opt_output_files(newctg) <- paste(workdir,"norm/{XLEFT}_{YBOTTOM}_norm",sep="")

normalized_ctg=lasnormalize(newctg,knnidw(k=25,p=2))
