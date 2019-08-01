library(lidR)
library(future)
library(e1071)

#Global settings
workdir="D:/Sync/_Amsterdam/10_ProcessWholeNL/Test/normalized_neibased/"
#workdir="D:/Koma/ProcessWholeNL/TileGroup_10/"
setwd(workdir)

chunksize=2500
buffer=10
resolution=10
groupid=10

rasterOptions(maxmemory = 200000000000)

# Set up cataloge
plan(multisession, workers = 2L)
set_lidr_threads(2L)

ctg <- catalog(workdir)

opt_chunk_buffer(ctg) <- buffer
opt_chunk_size(ctg) <- chunksize
opt_output_files(ctg) <- ""

h95p = grid_metrics(ctg, ~quantile(Z, 0.95),res=resolution, filter = ~Classification == 1L)
proj4string(h95p) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(h95p,paste("h95p_",groupid,".tif",sep=""),overwrite=TRUE)

isd = grid_metrics(ctg, ~sd(Intensity),res=resolution)
proj4string(isd) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(isd,paste("isd_",groupid,".tif",sep=""),overwrite=TRUE)

hsd = grid_metrics(ctg, ~sd(Z),res=resolution, filter = ~Classification == 1L)
proj4string(hsd) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(hsd,paste("hsd_",groupid,".tif",sep=""),overwrite=TRUE)

hskew = grid_metrics(ctg, ~skewness(Z),res=resolution, filter = ~Classification == 1L)
proj4string(hskew) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(hskew,paste("hskew_",groupid,".tif",sep=""),overwrite=TRUE)

h25p = grid_metrics(ctg, ~quantile(Z, 0.25),res=resolution, filter = ~Classification == 1L)
proj4string(h25p) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(h25p,paste("h25p_",groupid,".tif",sep=""),overwrite=TRUE)

h50p = grid_metrics(ctg, ~quantile(Z, 0.50),res=resolution, filter = ~Classification == 1L)
proj4string(h50p) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(h50p,paste("h50p_",groupid,".tif",sep=""),overwrite=TRUE)

h75p = grid_metrics(ctg, ~quantile(Z, 0.75),res=resolution, filter = ~Classification == 1L)
proj4string(h75p) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(h75p,paste("h75p_",groupid,".tif",sep=""),overwrite=TRUE)

echomean = grid_metrics(ctg, ~mean(ReturnNumber),res=resolution)
proj4string(echomean) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(echomean,paste("echomean_",groupid,".tif",sep=""),overwrite=TRUE)

lb1dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z<1])/length(Z))*100,res=resolution)
proj4string(lb1dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(lb1dense,paste("lb1dense_",groupid,".tif",sep=""),overwrite=TRUE)

l12dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>1 & Z<2])/length(Z))*100,res=resolution)
proj4string(l12dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l12dense,paste("l12dense_",groupid,".tif",sep=""),overwrite=TRUE)

l23dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>2 & Z<3])/length(Z))*100,res=resolution)
proj4string(l23dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l23dense,paste("l23dense_",groupid,".tif",sep=""),overwrite=TRUE)

l34dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>3 & Z<4])/length(Z))*100,res=resolution)
proj4string(l34dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l34dense,paste("l34dense_",groupid,".tif",sep=""),overwrite=TRUE)

l45dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>4 & Z<5])/length(Z))*100,res=resolution)
proj4string(l45dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l45dense,paste("l45dense_",groupid,".tif",sep=""),overwrite=TRUE)

l510dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>5 & Z<10])/length(Z))*100,res=resolution)
proj4string(l510dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l510dense,paste("l510dense_",groupid,".tif",sep=""),overwrite=TRUE)

l1015dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>10 & Z<15])/length(Z))*100,res=resolution)
proj4string(l1015dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l1015dense,paste("l1015dense_",groupid,".tif",sep=""),overwrite=TRUE)

l1520dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>15 & Z<20])/length(Z))*100,res=resolution)
proj4string(l1520dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(l1520dense,paste("l1520dense_",groupid,".tif",sep=""),overwrite=TRUE)

la20dense = grid_metrics(ctg, ~(length(Z[Classification==1 & Z>20])/length(Z))*100,res=resolution)
proj4string(la20dense) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(la20dense,paste("la20dense_",groupid,".tif",sep=""),overwrite=TRUE)

pulsepen = grid_metrics(ctg, ~(length(Z[Classification==2])/length(Z))*100,res=resolution)
proj4string(pulsepen) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(pulsepen,paste("pulsepen_",groupid,".tif",sep=""),overwrite=TRUE)

nofretamean = grid_metrics(ctg, ~(length(Z[Z>mean(Z)])/length(Z))*100,res=resolution,filter = ~Classification == 1L)
proj4string(nofretamean) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(nofretamean,paste("nofretamean_",groupid,".tif",sep=""),overwrite=TRUE)