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
landcoverfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/3_LGN7/Data/LGN7.tif"

# Import
lidar_forfilter=stack(lidarfile)
landcover=stack(landcoverfile)

# Create vegetation filter
mask_lidar <- setValues(raster(lidar_forfilter), NA)
mask_lidar[lidar_forfilter>0.5] <- 1

plot(mask_lidar, col="dark green", legend = FALSE)

# LGN 7 filter species specific
wetland_mask <- setValues(raster(landcover), NA)
wetland_mask[landcover==16 | landcover==17 | landcover==30 | landcover==41 | landcover==42 | landcover==43 | landcover==45] <- 1

plot(wetland_mask, col="dark green", legend = FALSE)

writeRaster(wetland_mask, "wetland_mask.grd",overwrite=TRUE)

#wetland_mask_poly <- rasterToPolygons(wetland_mask, fun=function(x){x==1})
