"
@author: Zsofia Koma, UvA
Aim: This script is aimed the pre-process AHN2 data (tile, homogenize, extract ground points, create DTM and apply point neighborhood based normalization)
"

# Import required R packages
library("lidR")
library("rgdal")
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_LiDARMetricsCalc.R")

# Set working directory
workingdirectory="D:/Koma/Paper1_v2/ALS/" ## set this directory where your input las files are located
setwd(workingdirectory)

cores=18
chunksize=1000
buffer=2.5
resolution=2.5

rasterOptions(maxmemory = 200000000000)

# Set cataloges

ground_ctg <- catalog(paste(workingdirectory,"test_ground/",sep=""))

opt_chunk_buffer(ground_ctg) <- buffer
opt_chunk_size(ground_ctg) <- chunksize
opt_cores(ground_ctg) <- cores

normalized_ctg <- catalog(paste(workingdirectory,"test_normalized_neibased/",sep=""))

opt_chunk_buffer(normalized_ctg) <- buffer
opt_chunk_size(normalized_ctg) <- chunksize
opt_cores(normalized_ctg) <- cores

covermetrics = grid_metrics(ground_ctg,  coverageMetrics(Z,Classification), res = resolution)
plot(covermetrics)

shapemetrics = grid_metrics(normalized_ctg,  eigenmetrics(X,Y,Z), res = resolution)
plot(shapemetrics)

vertdistr_metrics = grid_metrics(normalized_ctg, vertDistr_Metrics(Z),res=resolution)
plot(vertdistr_metrics)

