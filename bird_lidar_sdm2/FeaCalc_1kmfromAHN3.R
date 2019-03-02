"
@author: Zsofia Koma, UvA
Aim: This script is aimed the pre-process AHN2 data (tile, homogenize, extract ground points, create DTM and apply point neighborhood based normalization)
"

# Import required R packages
library("lidR")
library("rgdal")
source("D:/Koma/GitHub/myPhD_escience_analysis/bird_lidar_sdm2/Functions_FeaCalc.R")

# Set working directory
workingdirectory="D:/Koma/Paper3/Baardman_1km/" ## set this directory where your input las files are located
setwd(workingdirectory)

cores=18
resolution=10

rasterOptions(maxmemory = 200000000000)

# Set cataloges

ctg <- catalog(workingdirectory)

opt_cores(ctg) <- cores

covermetrics = grid_metrics(ctg,  coverageMetrics(Z,Classification), res = resolution)
#plot(covermetrics)

vertdistr_metrics = grid_metrics(ctg, vertDistr_Metrics(Z),res=resolution)
#plot(vertdistr_metrics)

heightmetrics = grid_metrics(ctg, HeightMetrics(Z),res=resolution)
#plot(heightmetrics)

rough_dsm=terrain(heightmetrics$zmax,opt="roughness",neighbors=4)
tpi_dsm=terrain(heightmetrics$zmax,opt="TPI",neighbors=4)
tri_dsm=terrain(heightmetrics$zmax,opt="TRI",neighbors=4)

horizontal_metrics=stack(rough_dsm,tpi_dsm,tri_dsm) 
#plot(horizontal_metrics)

opt_filter(ctg) <- "-keep_class 1"

vertdistr_metrics_whgr = grid_metrics(ctg, vertDistr_Metrics(Z),res=resolution)
#plot(vertdistr_metrics_whgr)
writeRaster(vertdistr_metrics_whgr,"vertdistr_metrics_whgr.grd",overwrite=TRUE)

heightmetrics_whgr = grid_metrics(ctg, HeightMetrics(Z),res=resolution)
#plot(heightmetrics_whgr)
writeRaster(heightmetrics_whgr,"heightmetrics_whgr.grd",overwrite=TRUE)

lidarmetrics=stack(covermetrics,vertdistr_metrics,heightmetrics,horizontal_metrics)
writeRaster(lidarmetrics,"lidarmetrics.grd",overwrite=TRUE)

lidarmetrics_whgr=stack(vertdistr_metrics_whgr,heightmetrics_whgr)
writeRaster(lidarmetrics_whgr,"lidarmetrics_whgr.grd",overwrite=TRUE)
