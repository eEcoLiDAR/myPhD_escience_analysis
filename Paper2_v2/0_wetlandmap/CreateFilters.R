"
@author: Zsofia Koma, UvA
Aim: Create filters
"

library(rgdal)
library(raster)

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
setwd(workingdirectory)

lidarfile=""

# Import
lidar_forfilter=stack(lidarfile)

# Create vegetation filter
mask_lidar <- setValues(raster(lidar_forfilter), NA)
mask_lidar[lidar_forfilter>0.5] <- 1

plot(mask_lidar, col="dark green", legend = FALSE)

# LGN 7 filter species specific
