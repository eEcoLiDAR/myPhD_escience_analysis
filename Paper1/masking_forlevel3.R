"
@author: Zsofia Koma, UvA
Aim: masking
"
library(raster)
library(sp)
library(spatialEco)
library(rgdal)

# Set global variables
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory
setwd("D:/Koma/Paper1/ALS/forClassification2/")

mask_file="classified_level2.tif"
lidar_file="lidarmetrics_forlevel2.grd"
polygon_file="recategorized_level2.shp"

# Import
level1_mask=stack(mask_file)
lidarmetrics=stack(lidar_file)

polygon=readOGR(dsn=polygon_file)

# Mask LiDAR
formask <- setValues(raster(level1_mask), NA)
formask[level1_mask==4] <- 1
plot(formask, col="dark green", legend = FALSE)

lidarmetrics_masked <- mask(lidarmetrics,formask)
#plot(lidarmetrics_masked)
writeRaster(lidarmetrics_masked, filename="lidarmetrics_forlevel3.grd",overwrite=TRUE)

# Mask polygon and add level2 classes
# only R
polygon_forlevel3=polygon[polygon@data$level2=="R",]
plot(polygon_forlevel3)

# Create level 3 classes
polygon_forlevel3@data$level3=NA

polygon_forlevel3@data$level3[polygon_forlevel3@data$StructDef=='Rkd']="Rk"
polygon_forlevel3@data$level3[polygon_forlevel3@data$StructDef=='Rld']="Rl"
polygon_forlevel3@data$level3[polygon_forlevel3@data$StructDef=='Rwd']="Rw"

rgdal::writeOGR(polygon_forlevel3, '.', 'recategorized_level3', 'ESRI Shapefile',overwrite_layer = TRUE)