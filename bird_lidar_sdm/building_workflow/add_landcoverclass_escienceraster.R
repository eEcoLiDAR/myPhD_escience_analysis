"
@author: Zsofia Koma, UvA
Aim: Add landcover classes to lidar metrics raster for the Global Ecology and Biodiversity course
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
filename="terrainData100m_run2_filtered.tif"
#filename="terrainData100m_run1_filtered.tif"
landcoverfile="LGN7.tif"

setwd(full_path)

# Import data
lidar_data=stack(filename)
plot(lidar_data)

landcover=stack(landcoverfile)
plot(landcover)

# Analyse values per main landcover classes

# Agrar
formask_agrar <- setValues(raster(landcover), NA)
formask_agrar[landcover==1 | landcover==2 | landcover==3 | landcover==4 | landcover==5 | landcover==6 | landcover==8 | landcover==9 | landcover==10 | landcover==26
              | landcover==61 | landcover==62] <- 1

plot(formask_agrar, col="dark green", legend = FALSE)

formask_agrar=crop(formask_agrar,extent(lidar_data))
formask_agrar_resampled=resample(formask_agrar,lidar_data)

lidarmetrics_agrar <- mask(lidar_data, formask_agrar_resampled)

lidarmetrics_agrar_pt = rasterToPoints(lidarmetrics_agrar)
lidarmetrics_agrar_df = data.frame(lidarmetrics_agrar_pt)
colnames(lidarmetrics_agrar_df) <- c("x", "y","kurto_z","mean_z","max_z","perc_10","perc_30","perc_50","perc_70","perc_90","point_density","skew_z","std_z","var_z","pulse_pen_ratio","density_absolute_mean")
lidarmetrics_agrar_df["landcover_class"] <- 1

print(summary(lidarmetrics_agrar_df))

# Forest
formask_forest <- setValues(raster(landcover), NA)
formask_forest[landcover==11 | landcover==12] <- 1

plot(formask_forest, col="dark green", legend = FALSE)

formask_forest=crop(formask_forest,extent(lidar_data))
formask_forest_resampled=resample(formask_forest,lidar_data)

lidarmetrics_forest <- mask(lidar_data, formask_forest_resampled)

lidarmetrics_forest_pt = rasterToPoints(lidarmetrics_forest)
lidarmetrics_forest_df = data.frame(lidarmetrics_forest_pt)
colnames(lidarmetrics_forest_df) <- c("x", "y","kurto_z","mean_z","max_z","perc_10","perc_30","perc_50","perc_70","perc_90","point_density","skew_z","std_z","var_z","pulse_pen_ratio","density_absolute_mean")
lidarmetrics_forest_df["landcover_class"] <- 2

print(summary(lidarmetrics_forest_df))

# Nature
formask_nature <- setValues(raster(landcover), NA)
formask_nature[landcover==30 | landcover==31 | landcover==32 | landcover==33 | landcover==34 | landcover==35 | landcover==36 | landcover==37 | landcover==38 | landcover==39
               | landcover==40 | landcover==41 | landcover==42 | landcover==43 | landcover==45] <- 1

plot(formask_nature, col="dark green", legend = FALSE)

formask_nature=crop(formask_nature,extent(lidar_data))
formask_nature_resampled=resample(formask_nature,lidar_data)

lidarmetrics_nature <- mask(lidar_data, formask_nature_resampled)

lidarmetrics_nature_pt = rasterToPoints(lidarmetrics_nature)
lidarmetrics_nature_df = data.frame(lidarmetrics_nature_pt)
colnames(lidarmetrics_nature_df) <- c("x", "y","kurto_z","mean_z","max_z","perc_10","perc_30","perc_50","perc_70","perc_90","point_density","skew_z","std_z","var_z","pulse_pen_ratio","density_absolute_mean")
lidarmetrics_nature_df["landcover_class"] <- 3

print(summary(lidarmetrics_nature_df))

# add lancover classes
lidarmetrics_wlandcover <- rbind(lidarmetrics_agrar_df, lidarmetrics_forest_df) 
lidarmetrics_wlandcover <- rbind(lidarmetrics_wlandcover, lidarmetrics_nature_df) 

# Export
saveRDS(lidarmetrics_wlandcover, file = paste(substr(filename, 1, nchar(filename)-4) ,"_lidarmetrics.rds",sep=""))

# Clean up the memory
rm("lidarmetrics_agrar_df","lidarmetrics_agrar_pt","lidarmetrics_agrar")
rm("lidarmetrics_forest_df","lidarmetrics_forest_pt","lidarmetrics_forest")
rm("lidarmetrics_nature_df","lidarmetrics_nature_pt","lidarmetrics_nature")

rm("formask","formask_nature","formask_forest","formask_agrar","formask_nature_resampled","formask_forest_resampled","formask_agrar_resampled")
gc()
