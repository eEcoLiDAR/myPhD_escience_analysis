library(lidR)
library(future)

#Global settings
workdir="D:/Sync/_Amsterdam/10_ProcessWholeNL/Test/"
setwd(workdir)

chunksize=1000
buffer=10
resolution=10

rasterOptions(maxmemory = 200000000000)

# Set up cataloge
plan(multisession)
ctg <- catalog(workdir)

opt_chunk_buffer(ctg) <- buffer
opt_chunk_size(ctg) <- chunksize
opt_output_files(ctg) <- paste(workdir,"normalized_neibased/{XLEFT}_{YBOTTOM}_norm",sep="")

normalized_ctg=lasnormalize(ctg,knnidw(k=25,p=2))