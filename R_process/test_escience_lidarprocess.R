"
@author: Zsofia Koma, UvA
Aim: Check feature values

input:
output:

Fuctions:


Example: 

"
library(raster)
library(ggplot2)

# Set global variables
setwd("D:/Koma/escience/NL_features")

# Import

# escience gtiff
all_data=stack("terrainData1km_v2.tif")
all_data=flip(all_data,direction = 'y')

# Lauwersmeer



# Explore escience

all_data_df=as.data.frame(all_data,xy=TRUE)
colnames(all_data_df) <- c("x", "y", "coeff_var_z","density_absolute_mean","eigv_1","eigenv_2","eigenv_3","gps_time","intensity","kurto_z","max_z","mean_z",
                      "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40","perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
                      "pulse_pen_ratio","range","skew_z","std_z","var_z")

print(summary(all_data_df))

qplot(all_data_df$terrainData1km_v2.1, geom="histogram") + xlim(0,50)

#par(mfrow=c(1,2))
#hist(all_data[[9]],breaks=10,col = "grey")
#plot(all_data[[9]])

#summary(all_data[[9]])

# Explore for Lauwersmeer