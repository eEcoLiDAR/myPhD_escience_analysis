"
@author: Zsofia Koma, UvA
Aim: Calculate LiDAR metrics
"
library("lidR")
#source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions.R")
#source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions.R")
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions.R")

# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/01_test/ground/"

setwd(workingdirectory)

dtm_file="dtm.tif"
dsm_file="dsm.tif"

resolution=2.5

pdf("lidarmetrics.pdf")

# Set up catalog
ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 0
opt_cores(ctg) <- 18

# Calculate metrics into separate files per feature groups and classes -- point cloud based

coveragemetrics = grid_metrics(ctg, CoverageMetrics(Z,Classification),res=resolution)
plot(coveragemetrics)

writeRaster(coveragemetrics,"coveragemetrics.grd",overwrite=TRUE)

shapemetrics = grid_metrics(ctg, ShapeMetrics(X,Y,Z),res=resolution) 
plot(shapemetrics)

writeRaster(shapemetrics,"shapemetrics.grd",overwrite=TRUE)

vertdistr_metrics = grid_metrics(ctg, VegStr_VertDistr_Metrics(Z),res=resolution)
plot(vertdistr_metrics)

writeRaster(vertdistr_metrics,"vertdistr_metrics.grd",overwrite=TRUE)

heightmetrics = grid_metrics(ctg, HeightMetrics(Z),res=resolution)
plot(heightmetrics)

writeRaster(heightmetrics,"heightmetrics.grd",overwrite=TRUE)

# Calculate metrics into separate files per feature groups and classes -- raster-based 
dtm=raster(dtm_file)

slope_dtm=terrain(dtm,opt="slope",unit="degrees",neighbors=4)
aspect_dtm=terrain(dtm,opt="aspect",unit="degrees",neighbors=4)
rough_dtm=terrain(dtm,opt="roughness",neighbors=4)
tpi_dtm=terrain(dtm,opt="TPI",neighbors=4)
tri_dtm=terrain(dtm,opt="TRI",neighbors=4)

dtm_metrics=stack(slope_dtm,aspect_dtm,rough_dtm,tpi_dtm,tri_dtm) 
plot(dtm_metrics)

writeRaster(dtm_metrics,"dtm_metrics.grd",overwrite=TRUE)

dsm=raster(dsm_file)

rough_dsm=terrain(dsm,opt="roughness",neighbors=4)
tpi_dsm=terrain(dsm,opt="TPI",neighbors=4)
tri_dsm=terrain(dsm,opt="TRI",neighbors=4)
sd_dsm=focal(dsm, w=matrix(1,3,3), fun=sd)
names(sd_dsm) <- "sd_dsm"
var_dsm=focal(dsm, w=matrix(1,3,3), fun=var)
names(var_dsm) <- "var_dsm"

dsm_metrics=stack(rough_dsm,tpi_dsm,tri_dsm,sd_dsm,var_dsm) 
plot(dsm_metrics)

writeRaster(dsm_metrics,"dsm_metrics.grd",overwrite=TRUE)

# Normalization
heightmetrics$n_zmax=(heightmetrics$zmax+500)-(dtm+500)
heightmetrics$n_zmean=(heightmetrics$zmean+500)-(dtm+500)
heightmetrics$n_zmedian=(heightmetrics$zmedian+500)-(dtm+500)
heightmetrics$n_z025quantile=(heightmetrics$z025quantile+500)-(dtm+500)
heightmetrics$n_z075quantile=(heightmetrics$z075quantile+500)-(dtm+500)
heightmetrics$n_z090quantile=(heightmetrics$z090quantile+500)-(dtm+500)

plot(heightmetrics)

# Merge, organize files
lidar_metrics=stack(coveragemetrics,shapemetrics,vertdistr_metrics,dsm_metrics,heightmetrics$n_zmax,heightmetrics$n_zmean,heightmetrics$n_zmedian,heightmetrics$n_z025quantile,heightmetrics$n_z075quantile,
                    heightmetrics$n_z090quantile,dtm_metrics)
crs(lidar_metrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

writeRaster(lidar_metrics, "lidar_metrics.grd", overwrite=TRUE)

dev.off()
