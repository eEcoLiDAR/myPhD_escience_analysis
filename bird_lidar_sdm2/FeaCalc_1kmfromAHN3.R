"
@author: Zsofia Koma, UvA
Aim: This script is aimed the pre-process AHN2 data (tile, homogenize, extract ground points, create DTM and apply point neighborhood based normalization)
"

# Import required R packages
library("lidR")
library("rgdal")
source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/bird_lidar_sdm2/Functions_FeaCalc.R")

# Set working directory
workingdirectory="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_2/ALS/" ## set this directory where your input las files are located
setwd(workingdirectory)

cores=18
resolution=10

rasterOptions(maxmemory = 200000000000)

# Set cataloges

ctg <- catalog(workingdirectory)

opt_cores(ctg) <- cores

covermetrics = grid_metrics(ctg,  coverageMetrics(Z,Classification), res = resolution)
plot(covermetrics)

vertdistr_metrics = grid_metrics(ctg, vertDistr_Metrics(Z),res=resolution)
plot(vertdistr_metrics)

heightmetrics = grid_metrics(ctg, HeightMetrics(Z),res=resolution)
plot(heightmetrics)

rough_dsm=terrain(heightmetrics$zmax,opt="roughness",neighbors=4)
tpi_dsm=terrain(heightmetrics$zmax,opt="TPI",neighbors=4)
tri_dsm=terrain(heightmetrics$zmax,opt="TRI",neighbors=4)

sd_dsm=focal(heightmetrics$zmax, w=matrix(1,3,3), fun=sd)
names(sd_dsm) <- "sd_dsm"
var_dsm=focal(heightmetrics$zmax, w=matrix(1,3,3), fun=var)
names(var_dsm) <- "var_dsm"

sd_cover=focal(covermetrics$pulsepen_ground, w=matrix(1,3,3), fun=sd)
names(sd_cover) <- "sd_cover"

horizontal_metrics=stack(rough_dsm,tpi_dsm,tri_dsm,sd_dsm,var_dsm,sd_cover) 
plot(horizontal_metrics)

opt_filter(ctg) <- "-keep_class 1"

vertdistr_metrics_whgr = grid_metrics(ctg, vertDistr_Metrics(Z),res=resolution)
plot(vertdistr_metrics_whgr)

heightmetrics_whgr = grid_metrics(ctg, HeightMetrics(Z),res=resolution)
plot(heightmetrics_whgr)

lidarmetrics=stack(covermetrics,vertdistr_metrics,heightmetrics,horizontal_metrics)
writeRaster(lidarmetrics,"lidarmetrics.grd",overwrite=TRUE)

lidarmetrics_whgr=stack(vertdistr_metrics_whgr,heightmetrics_whgr)
writeRaster(lidarmetrics_whgr,"lidarmetrics_whgr.grd",overwrite=TRUE)
