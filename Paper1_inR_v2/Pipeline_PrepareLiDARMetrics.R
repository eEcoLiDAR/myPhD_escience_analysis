"
@author: Zsofia Koma, UvA
Aim: This script is aimed to oganize the derived metrics into one single lidarmetrics file
"

# Import required R packages
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("gridExtra")

library("ggplot2")


# Set working directory
workingdirectory="D:/Koma/Paper1_v2/Run1_2019March/LiDAR_metrics/" ## set this directory where your input las files are located
#workingdirectory="C:/Koma/Paper1/Paper1_DataProcess/"
setwd(workingdirectory)

# Read the separate lidarmetrics files into memory

covermetrics=stack("covermetrics_gr.grd")
proj4string(covermetrics)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

heightmetrics=stack("height_metrics_gr.grd")
proj4string(heightmetrics)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

heightmetrics_wgr=stack("height_metrics_whgr_gr_norm.grd")
proj4string(heightmetrics_wgr)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

horizontalmetrics=stack("horizontal_metrics_gr.grd")
proj4string(horizontalmetrics)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

horizontalmetrics_wgr=stack("horizontal_metrics_whgr_gr_norm.grd")
proj4string(horizontalmetrics_wgr)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

shapemetrics=stack("shapemetrics_gr.grd")
proj4string(shapemetrics)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

shapemetrics_wgr=stack("shapemetrics_whgr_gr_norm.grd")
proj4string(shapemetrics_wgr)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

vertdistrmetrics=stack("vertdistr_metrics_gr.grd")
proj4string(vertdistrmetrics)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

vertdistrmetrics_wgr=stack("vertdistr_metrics_whgr_gr_norm.grd")
proj4string(vertdistrmetrics_wgr)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Combine gr and wgr

#Height
ex = extent(heightmetrics_wgr)
heightmetrics_m = crop(heightmetrics, ex)

heightmetrics_mod <- overlay(heightmetrics_m, heightmetrics_wgr, fun = function(x, y) {
  y[is.na(y[])] <- x[is.na(y[])]
  return(y)
})

names(heightmetrics_mod) <- names(heightmetrics_wgr)
#writeRaster(heightmetrics_mod,"heightmetrics_merged.grd",overwrite=TRUE)

# Shape
ex = extent(shapemetrics_wgr)
shapemetrics_m = crop(shapemetrics, ex)

shapemetrics_mod <- overlay(shapemetrics_m, shapemetrics_wgr, fun = function(x, y) {
  y[is.na(y[])] <- x[is.na(y[])]
  return(y)
})

names(shapemetrics_mod) <- names(shapemetrics_wgr)
#writeRaster(shapemetrics_mod,"shapemetrics_merged.grd",overwrite=TRUE)

# vert. distr
ex = extent(vertdistrmetrics_wgr)
vertdistrmetrics_m = crop(vertdistrmetrics, ex)

vertdistrmetrics_mod <- overlay(vertdistrmetrics_m, vertdistrmetrics_wgr, fun = function(x, y) {
  y[is.na(y[])] <- x[is.na(y[])]
  return(y)
})

names(vertdistrmetrics_mod) <- names(vertdistrmetrics_wgr)
#writeRaster(vertdistrmetrics_mod,"vertdistrmetrics_merged.grd",overwrite=TRUE)

#horizontal

ex = extent(horizontalmetrics_wgr)
horizontalmetrics_m = crop(horizontalmetrics, ex)

horizontalmetrics_mod <- overlay(horizontalmetrics_m, horizontalmetrics_wgr, fun = function(x, y) {
  y[is.na(y[])] <- x[is.na(y[])]
  return(y)
})

names(horizontalmetrics_mod) <- names(horizontalmetrics_wgr)

# Merge files into one lidarmetrics file
ex_m=extent(shapemetrics_mod)

covermetrics_m=crop(covermetrics,ex_m)
heightmetrics_mod_m=crop(heightmetrics_mod,ex_m)
horizontalmetrics_mod_m=crop(horizontalmetrics_mod,ex_m)
vertdistrmetrics_mod_m=crop(vertdistrmetrics_mod,ex_m)

lidarmetrics=stack(covermetrics_m,shapemetrics_mod,vertdistrmetrics_mod_m,horizontalmetrics_mod_m,heightmetrics_mod_m)
#writeRaster(lidarmetrics,"lidarmetrics.grd",overwrite=TRUE)

# Exclude buildings
buildings=readOGR(dsn="buldings.shp")

building_rast <- rasterize(buildings, lidarmetrics[[1]],field="DN")
formask <- setValues(raster(lidarmetrics[[1]]), 1)
formask[building_rast>0] <- NA

lidarmetrics_masked <- mask(lidarmetrics, formask)
writeRaster(lidarmetrics_masked,"lidarmetrics_masked.grd",overwrite=TRUE)

