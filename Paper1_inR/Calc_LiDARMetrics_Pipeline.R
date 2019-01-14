"
@author: Zsofia Koma, UvA
Aim: Calculate LiDAR metrics
"
library("lidR")
source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions.R")

# Set working dirctory
workingdirectory="C:/Koma/Paper1/ALS/"
#workingdirectory="D:/Koma/Paper1/ALS/test/"

setwd(workingdirectory)

# Set up catalog
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_cores(ctg) <- 3

# Calculate metrics into separate files per feature groups and classes

coveragemetrics = grid_metrics(ctg, CoverageMetrics(Z,Classification),res=10)
plot(coveragemetrics)

writeRaster(coveragemetrics,"coveragemetrics.grd",overwrite=TRUE)

#shapemetrics = grid_metrics(ctg, ShapeMetrics(X,Y,Z),res=10)
#plot(shapemetrics)

#writeRaster(shapemetrics,"shapemetrics.grd",overwrite=TRUE)

vertdistr_metrics = grid_metrics(ctg, VegStr_VertDistr_Metrics(Z),res=10)
plot(vertdistr_metrics)

heightmetrics = grid_metrics(ctg, HeightMetrics(Z),res=10)
plot(heightmetrics)

writeRaster(heightmetrics,"heightmetrics.grd",overwrite=TRUE)

# Merge and reorganize features into one file