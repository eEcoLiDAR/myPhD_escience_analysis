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

# Calculate metrics into separate files per feature groups and classes -- point cloud based

coveragemetrics = grid_metrics(ctg, CoverageMetrics(Z,Classification),res=2.5)
plot(coveragemetrics)

writeRaster(coveragemetrics,"coveragemetrics.grd",overwrite=TRUE)

shapemetrics = grid_metrics(ctg, ShapeMetrics(X,Y,Z),res=2.5) #the values are strangely equal - something wrong
plot(shapemetrics)

summary(shapemetrics@data@values)

writeRaster(shapemetrics,"shapemetrics.grd",overwrite=TRUE)

vertdistr_metrics = grid_metrics(ctg, VegStr_VertDistr_Metrics(Z),res=2.5)
plot(vertdistr_metrics)

writeRaster(vertdistr_metricss,"vertdistr_metrics.grd",overwrite=TRUE)

heightmetrics = grid_metrics(ctg, HeightMetrics(Z),res=2.5)
plot(heightmetrics)

writeRaster(heightmetrics,"heightmetrics.grd",overwrite=TRUE)
