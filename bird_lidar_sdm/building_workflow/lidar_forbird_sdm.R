"
@author: Zsofia Koma, UvA
Aim: explore the intersection of bird and lidar data 
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("gridExtra")

library("ggplot2")
library("spatial.tools")

# Set global variables
#full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

lidarfile="Lidarmetrics_forMScCourse.grd"
landcoverfile="LGN7.tif"
lidarfile_sel_file="lidarmetrics_sel.grd"

setwd(full_path)

# Import LiDAR metrics
lidarmetrics=stack(lidarfile)
landcover=stack(landcoverfile)

# Habitat selection
formask <- setValues(raster(landcover), NA)
formask[landcover==30 | landcover==45 | landcover==41 | landcover==42] <- 1

formask=crop(formask,extent(lidarmetrics))
formask_resampled=resample(formask,lidarmetrics)

lidarmetrics_sel <- mask(lidarmetrics, formask_resampled)
writeRaster(lidarmetrics_sel, "lidarmetrics_sel.grd",overwrite=TRUE)

# Aggregation
lidarmetrics_sel=stack(lidarfile_sel_file)

lidarmetrics_1km <- aggregate(lidarmetrics_sel, fact = 10, fun = mean)
writeRaster(lidarmetrics_1km, "lidarmetrics_1km.grd",overwrite=TRUE)

lidarmetrics_200m <- aggregate(lidarmetrics_sel, fact = 2, fun = mean)
writeRaster(lidarmetrics_200m, "lidarmetrics_200m.grd",overwrite=TRUE)

rough_perc90_nonground=terrain(lidarmetrics_sel[[22]],opt="roughness",neighbors=4)
sd_perc90_nonground=focal(lidarmetrics_sel[[22]], w=matrix(1,3,3), fun=sd)
names(sd_perc90_nonground) <- "sd_perc90_nonground"
var_perc90_nonground=focal(lidarmetrics_sel[[22]], w=matrix(1,3,3), fun=var)
names(var_perc90_nonground) <- "var_perc90_nonground"

rough_perc90_ground=terrain(lidarmetrics_sel[[8]],opt="roughness",neighbors=4)
sd_perc90_ground=focal(lidarmetrics_sel[[8]], w=matrix(1,3,3), fun=sd)
names(sd_perc90_ground) <- "sd_perc90_ground"
var_perc90_ground=focal(lidarmetrics_sel[[8]], w=matrix(1,3,3), fun=var)
names(var_perc90_ground) <- "var_perc90_ground"

lidarmetrics_sel_exp=stack(lidarmetrics_sel,rough_perc90_nonground,sd_perc90_nonground,var_perc90_nonground,rough_perc90_ground,sd_perc90_ground,var_perc90_ground)
writeRaster(lidarmetrics_sel_exp, "lidarmetrics_wetlands_expanded.grd",overwrite=TRUE)

lidarmetrics_sel_exp2=stack(lidarmetrics_sel,rough_perc90_nonground,rough_perc90_ground)
writeRaster(lidarmetrics_sel_exp2, "lidarmetrics_wetlands_expanded2.grd",overwrite=TRUE)

#Parallelize focal
sd_perc90_nonground=focal_hpc(lidarmetrics_sel[[22]], window_dims=c(3,3), fun=sd)