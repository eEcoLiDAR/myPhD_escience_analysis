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
sovonwetlandfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/filters/Sovon/Moeras_gaten_gevuld_100m.shp"
ahn3tiles_esciencefile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3_escience.shp"
ahn3tilesfile="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/ahn3.shp"

# Import
lidar_forfilter=stack(lidarfile)
landcover=stack(landcoverfile)
sovonwetland = readOGR(dsn=sovonwetlandfile)
ahn3tiles_escience = readOGR(dsn=ahn3tiles_esciencefile)
ahn3tiles = readOGR(dsn=ahn3tilesfile)

# LGN 7 filter species specific
wetland_mask <- setValues(raster(landcover), NA)
wetland_mask[landcover==16 | landcover==17 | landcover==30 | landcover==41 | landcover==42 | landcover==43 | landcover==45] <- 1

plot(wetland_mask, col="dark green", legend = FALSE)

writeRaster(wetland_mask, "wetland_mask.grd",overwrite=TRUE)

#wetland_mask_poly <- rasterToPolygons(wetland_mask, fun=function(x){x==1})

# select required LiDAR tiles

req_ahn3tiles_escience=raster::intersect(ahn3tiles_escience,sovonwetland)
raster::shapefile(req_ahn3tiles_escience, "req_ahn3tiles_escience.shp",overwrite=TRUE)

req_ahn3tiles=raster::intersect(ahn3tiles,sovonwetland)
raster::shapefile(req_ahn3tiles, "req_ahn3tiles.shp",overwrite=TRUE)