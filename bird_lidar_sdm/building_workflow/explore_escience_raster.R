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

# Set global variables
full_path="D:/Koma/lidar_bird_dsm_workflow/"
filename="terrainData100m_run2.tif"

setwd(full_path)

# Import data
all_data=stack(filename)
all_data=flip(all_data,direction = 'y')

# Check LiDAR metrics
plot(all_data[[5]],colNA="black")

# Save as dataframe and print statistics
all_data_df=as.data.frame(all_data,xy=TRUE)
colnames(all_data_df) <- c("x", "y", "coeff_var_z","density_absolute_mean","eigv_1","eigenv_2","eigenv_3","gps_time","intensity","kurto_z","max_z","mean_z",
                           "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40","perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
                           "pulse_pen_ratio","range","skew_z","std_z","var_z")

print(summary(all_data_df))

# Exclude data which are obviosly wrong (all values are null)
myvars <- c("x", "y", "eigv_1","eigenv_2","eigenv_3","kurto_z","max_z","mean_z",
            "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40",
            "perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
            "skew_z","std_z","var_z")

cleaned_lidarmetrics = all_data_df[myvars]
print(summary(cleaned_lidarmetrics))

# Check LiDAR metrics
plot(all_data[[5]],colNA="black")

# Boxplot
par(mfrow=c(1,2))
boxplot(all_data_df[,5])
boxplot(all_data_df[,5], outline = FALSE)