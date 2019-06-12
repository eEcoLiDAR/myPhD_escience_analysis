"
@author: Zsofia Koma, UvA
Aim: escience raster
"
library("raster")
library("rgdal")

library("dplyr")
library("mapview")

# Set global variables
full_path="C:/Koma/Paper2/escience_test/"

rasterfile="ahn3_2019_01_08_1x1m_features_10m_subtile_7.tif"

setwd(full_path)

# Import
onlyveg_fea=stack(rasterfile)
onlyveg_fea=flip(onlyveg_fea,direction = 'y')

proj4string(onlyveg_fea) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
names(onlyveg_fea) <- c("coeff_var_norm_z","density_absolute_mean_norm_z","entropy_norm_z","entropy_z","gps_time", 
                       "intensity","kurto_norm_z","kurto_z","max_norm_z","mean_norm_z","median_norm_z","min_norm_z",
                       "perc_10_norm_z", "perc_10_z", "perc_20_norm_z", "perc_20_z", "perc_40_norm_z", "perc_40_z", "perc_60_norm_z",
                       "perc_60_z", "perc_80_norm_z", "perc_80_z", "perc_90_norm_z", "perc_90_z", "point_density", "pulse_penetration_ratio", 
                       "range_norm_z", "skew_norm_z", "skew_z", "std_norm_z", "std_z", "var_norm_z", "var_z")

summary(onlyveg_fea)

mapview(onlyveg_fea[["perc_90_norm_z"]])