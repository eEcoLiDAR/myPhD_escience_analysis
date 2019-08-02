library(lidR)
library(future)
library(e1071)

#Global settings
#workdir="D:/Sync/_Amsterdam/10_ProcessWholeNL/Test/normalized_neibased/"
workdir="D:/Koma/ProcessWholeNL/TileGroup_10/norm/"
setwd(workdir)

chunksize=2500
resolution=10
groupid=10

rasterOptions(maxmemory = 200000000000)

# Set up cataloge
plan(multisession, workers = 12L)
set_lidr_threads(12L)

# Set cataloge
ctg <- catalog(workdir)

opt_chunk_size(ctg) <- chunksize
opt_output_files(ctg) <- ""

# Calc metrics related to both ground and vegetation points

opt_filter(ctg) <- "-keep_class 1 2"

myMetrics = function(Z,I,R,Classification) 
{
  metrics = list(
    isd=sd(I),
    echomean=mean(R),
    lb1dense=(length(Z[Classification==1 & Z<1])/length(Z))*100,
    l12dense=(length(Z[Classification==1 & Z>1 & Z<2])/length(Z))*100,
    l23dense=(length(Z[Classification==1 & Z>1 & Z<2])/length(Z))*100,
    l34dense=(length(Z[Classification==1 & Z>3 & Z<4])/length(Z))*100,
    l45dense=(length(Z[Classification==1 & Z>4 & Z<5])/length(Z))*100,
    l510dense=(length(Z[Classification==1 & Z>5 & Z<10])/length(Z))*100,
    l1015dense=(length(Z[Classification==1 & Z>10 & Z<15])/length(Z))*100,
    l1520dense=(length(Z[Classification==1 & Z>15 & Z<20])/length(Z))*100,
    la20dense=(length(Z[Classification==1 & Z>20])/length(Z))*100,
    pulsepen=(length(Z[Classification==2])/length(Z))*100
    
  )  
  
  return(metrics)
}

Metrics = grid_metrics(ctg, ~myMetrics(Z,Intensity,ReturnNumber,Classification), res=10)
proj4string(Metrics ) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(Metrics ,paste("Metrics_",groupid,".tif",sep=""),overwrite=TRUE)

# Calc vegetation related metrics

opt_filter(ctg) <- "-keep_class 1"

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

VegMetrics = grid_metrics(ctg, ~myVegMetrics(Z), res=10)
proj4string(VegMetrics) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(VegMetrics,paste("VegMetrics_",groupid,".tif",sep=""),overwrite=TRUE)