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
setwd("D:/Koma/escience/")

# Import

# escience gtiff
all_data=stack("terrainData100m_run2.tif")
all_data=flip(all_data,direction = 'y')

plot(all_data)

# Explore escience

all_data_df=as.data.frame(all_data,xy=TRUE)
colnames(all_data_df) <- c("x", "y", "coeff_var_z","density_absolute_mean","eigv_1","eigenv_2","eigenv_3","gps_time","intensity","kurto_z","max_z","mean_z",
                      "median_z","min_z","perc_10","perc_100","perc_20","perc_30","perc_40","perc_50","perc_60","perc_70","perc_80","perc_90", "point_density",
                      "pulse_pen_ratio","range","skew_z","std_z","var_z")

print(summary(all_data_df))


for (i in 3:28){
  print(colnames(all_data_df[i]))
  
  jpeg(paste(colnames(all_data_df[i]),'.jpg',sep=''))
  
  #title(colnames(all_data_df[i]))
  par(mfrow=c(1,2))
  boxplot(all_data_df[,i])
  boxplot(all_data_df[,i], outline = FALSE)
  dev.off()
}

par(mfrow=c(1,2))
boxplot(all_data_df[,3])
boxplot(all_data_df[,3], outline = FALSE)

