"
@author: Zsofia Koma, UvA
Aim: Explore laserchicken output for the Global Ecology and Biodiversity course

Input file (geotiff):
    100 m resolution
    LiDAR metrics based on Classification == 1 -- unclassified category (by ASPRS standard)
"

# Import libraries
library(raster)
library(ggplot2)
library(gridExtra)
library(dplyr)

library(XLConnect)

library(sp)
library(spatialEco)

# Set global variables
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
filename="terrainData100m_run2.tif"
landcoverfile="LGN7.tif"

setwd(full_path)

# Import data
lidar_data=stack(filename)
lidar_data=flip(lidar_data,direction = 'y')
plot(lidar_data)

landcover=stack(landcoverfile)
plot(landcover)

# Save as dataframe and print statistics
lidarmetrics = rasterToPoints(lidar_data)
lidarmetrics = data.frame(lidarmetrics)
colnames(lidarmetrics) <- c("x", "y", "coeff_var_z","density_absolute_mean","eigv_1","eigenv_2","eigenv_3","gps_time","intensity","kurto_z","max_z","mean_z",
                           "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40","perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
                           "pulse_pen_ratio","range","skew_z","std_z","var_z")

print(summary(lidarmetrics))

writeWorksheetToFile(paste(substr(filename, 1, nchar(filename)-4) ,"_summarytable.xlsx",sep=""), 
                     data = data.frame(unclass(summary(lidarmetrics)), check.names = FALSE, stringsAsFactors = FALSE), 
                     sheet = "summary", 
                     header = TRUE,
                     clearSheets = TRUE)

ggplot() + geom_raster(data=lidarmetrics,aes(x,y,fill=lidarmetrics[,"max_z"])) + coord_equal() + scale_fill_gradientn(colours=topo.colors(7),na.value = "transparent",limits=c(0,35))

# Exclude cities
formask <- setValues(raster(landcover), 1)
formask[landcover==16 | landcover==17 | landcover==18 | landcover==19 | landcover==20 | landcover==22 | landcover==23 | landcover==24 | landcover==28 | landcover==25] <- NA
plot(formask, col="dark green", legend = FALSE)

formask=crop(formask,extent(lidar_data))
formask_resampled=resample(formask,lidar_data)
plot(formask_resampled)

lidarmetrics_masked <- mask(lidar_data, formask_resampled)

lidarmetrics_masked_pt = rasterToPoints(lidarmetrics_masked)
lidarmetrics_masked_df = data.frame(lidarmetrics_masked_pt)
colnames(lidarmetrics_masked_df) <- c("x", "y", "coeff_var_z","density_absolute_mean","eigv_1","eigenv_2","eigenv_3","gps_time","intensity","kurto_z","max_z","mean_z",
                            "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40","perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
                            "pulse_pen_ratio","range","skew_z","std_z","var_z")

print(summary(lidarmetrics_masked_df))

ggplot() + geom_raster(data=lidarmetrics_masked_df,aes(x,y,fill=lidarmetrics_masked_df[,"max_z"])) + coord_equal() + scale_fill_gradientn(colours=topo.colors(7),na.value = "transparent",limits=c(0,35))

myvars <- c("x", "y","kurto_z","mean_z","max_z","perc_10","perc_30","perc_50","perc_70","perc_90","point_density","skew_z","std_z","var_z")
filtered_lidarmetrics=lidarmetrics_masked_df[myvars]

filtered_lidarmetrics_r=rasterFromXYZ(filtered_lidarmetrics, digits = 3)
plot(filtered_lidarmetrics_r)
crs(filtered_lidarmetrics_r) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

writeRaster(filtered_lidarmetrics_r, paste(substr(filename, 1, nchar(filename)-4) ,"_filtered.tif",sep=""),overwrite=TRUE)

writeWorksheetToFile(paste(substr(filename, 1, nchar(filename)-4) ,"_summarytable_filtered.xlsx",sep=""), 
                     data = data.frame(unclass(summary(filtered_lidarmetrics)), check.names = FALSE, stringsAsFactors = FALSE), 
                     sheet = "summary", 
                     header = TRUE,
                     clearSheets = TRUE)

