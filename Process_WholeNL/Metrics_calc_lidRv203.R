library(lidR)
library(e1071)

# reinstall previous lidR version: require(devtools), install_version("lidR", version = "2.0.3", repos = "http://cran.us.r-project.org")

#Global settings
workdir="D:/Sync/_Amsterdam/10_ProcessWholeNL/Test/normalized_neibased/"
#workdir="D:/Koma/ProcessWholeNL/TileGroup_10/norm/"
setwd(workdir)

chunksize=2500
resolution=10
groupid=10
cores=2

rasterOptions(maxmemory = 200000000000)

# Set cataloge
ctg <- catalog(workdir)

opt_chunk_size(ctg) <- chunksize
opt_cores(ctg) <- cores
opt_output_files(ctg) <- ""
opt_filter(ctg) <- "-keep_class 1"
opt_select(ctg) <- "xyz"

# Execute

myVegMetrics = function(Z) 
{
  library(e1071)
  metrics = list(
    h95p=quantile(Z, 0.95),
    hsd=sd(Z),
    hsd_b3=sd(Z[Z<3]),
    hskew=skewness(Z),
    hskew_b3=skewness(Z[Z<3]),
    h25p=quantile(Z, 0.25),
    h50p=quantile(Z, 0.50),
    h75p=quantile(Z, 0.75),
    nofretamean=(length(Z[Z>mean(Z)])/length(Z))*100
  )  
  
  return(metrics)
}

VegMetrics = grid_metrics(ctg, myVegMetrics(Z), res=10)
proj4string(VegMetrics) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(VegMetrics,paste("VegMetrics_",groupid,".tif",sep=""),overwrite=TRUE)