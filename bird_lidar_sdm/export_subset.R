
library("rgdal")
library("raster")


lidarmetrics=stack("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_3/lidarmetrics_wetlands_expanded2.grd")

writeRaster(lidarmetrics[[19]],"D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_3/lidarmetrics_perc30.tif",overwrite=TRUE)