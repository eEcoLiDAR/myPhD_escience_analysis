"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN3 data
"
library("lidR")
library("rgdal")
library("snow")

library("ggplot2")
library("viridis")
library("ggthemes")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"
#workingdirectory="D:/Koma/SelectedWetlands/"
setwd(workingdirectory)

lasfile="Snor_115_165541.laz"

#Import 
las=readLAS(lasfile)
lasnormalize(las, knnidw(k=20,p=2))

las_veg=lasfilter(las,Classification==1)

vegheight_10=grid_metrics(las_veg,quantile(Z, 0.95),res=10)
plot(vegheight_10)

beginCluster(3)

sd_dsm=clusterR(vegheight_10, focal, args=list(w=matrix(1,5,5), fun=sd, pad=TRUE,na.rm = TRUE))

endCluster()

plot(sd_dsm)

# Visulaize with ggplot
vegheight_10_spdf <- as(vegheight_10, "SpatialPixelsDataFrame")
vegheight_10_df <- as.data.frame(vegheight_10_spdf)
colnames(vegheight_10_df) <- c("value", "x", "y")

ggplot() +  
  geom_tile(data=vegheight_10_df, aes(x=x, y=y, fill=value), alpha=0.8) + 
  scale_fill_viridis() +
  coord_equal() +
  theme_map() +
  theme(legend.position="bottom") +
  theme(legend.key.width=unit(2, "cm"))