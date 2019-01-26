"
@author: Zsofia Koma, UvA
Aim: Feature caculation AHN2 data
"
library("lidR")
library("rgdal")
source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions_sTristan.R")

# Set working dirctory
workingdirectory="C:/Koma/Paper1/ALS/"
setwd(workingdirectory)

resolution=2.5
core=3

# Set cataloge

gr_hom_norm_ctg <- catalog(paste(workingdirectory,"normalized/",sep=""))

opt_chunk_buffer(ground_ctg) <- resolution
opt_cores(ground_ctg) <- core

coveragemetrics = grid_metrics(gr_hom_norm_ctg, CoverageMetrics(Z,Classification),res=resolution)
plot(coveragemetrics)

writeRaster(coveragemetrics,"coveragemetrics.grd",overwrite=TRUE)
plot(coveragemetrics$blow0)