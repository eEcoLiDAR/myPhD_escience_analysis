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
library(gridExtra)

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

ggplot(all_data_df, aes(coeff_var_z)) + 
  geom_histogram(binwidth = 25, col = "black", fill = "cornflowerblue")

p1=ggplot(all_data_df, aes(y=coeff_var_z)) + geom_boxplot()
p2=ggplot(all_data_df, aes(y=coeff_var_z)) + geom_boxplot(outlier.shape = NA) + scale_y_continuous(limits=c(0,10))
grid.arrange(p1,p2)

# Explore for Lauwersmeer