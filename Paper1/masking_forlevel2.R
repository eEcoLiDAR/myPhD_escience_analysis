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
setwd("D:/Koma/Paper1/ALS/forClassification4/")

mask_file="classified_level1_v2.tif"
lidar_file="lidarmetrics_forClassification.grd"
polygon_file="recategorized.shp"
building_file="buldings.shp"

# Import
level1_mask=stack(mask_file)
lidarmetrics=stack(lidar_file)

polygon=readOGR(dsn=polygon_file)
buildings=readOGR(dsn=building_file)

# Mask LiDAR
formask <- setValues(raster(level1_mask), NA)
formask[level1_mask==2] <- 1
plot(formask, col="dark green", legend = FALSE)

lidarmetrics_masked <- mask(lidarmetrics,formask)
#plot(lidarmetrics_masked)
writeRaster(lidarmetrics_masked, filename="lidarmetrics_forlevel2.grd",overwrite=TRUE)

# Mask polygon and add level2 classes
# drop "O" from level 1
polygon_forlevel2=polygon[polygon@data$level1=="V",]
plot(polygon_forlevel2)

# Create level 2 classes
buildings@data$level1="O"
buildings@data$StructDef="Bu"
polygon_forlevel2_wbuildings=union(polygon_forlevel2,buildings)
plot(polygon_forlevel2_wbuildings)

polygon_forlevel2_wbuildings@data$level2=NA

polygon_forlevel2_wbuildings@data$level2[polygon_forlevel2_wbuildings@data$StructDef=='Bu']="Bu"
polygon_forlevel2_wbuildings@data$level2[polygon_forlevel2_wbuildings@data$StructDef=='Rkd' | polygon_forlevel2_wbuildings@data$StructDef=='Rld']="R"
polygon_forlevel2_wbuildings@data$level2[polygon_forlevel2_wbuildings@data$StructDef=='Rwd']="Rw"
polygon_forlevel2_wbuildings@data$level2[polygon_forlevel2_wbuildings@data$StructDef=='Gh']="G"
polygon_forlevel2_wbuildings@data$level2[polygon_forlevel2_wbuildings@data$StructDef=='Sld'| polygon_forlevel2_wbuildings@data$StructDef=='Smd'| polygon_forlevel2_wbuildings@data$StructDef=='Shd'] = "S"
polygon_forlevel2_wbuildings@data$level2[polygon_forlevel2_wbuildings@data$StructDef=='Bd']="B"

sort(unique(polygon_forlevel2_wbuildings@data$level2))

polygon_forlevel2_wbuildings=polygon_forlevel2_wbuildings[!is.na(polygon_forlevel2_wbuildings@data$level2),]

rgdal::writeOGR(polygon_forlevel2_wbuildings, '.', 'recategorized_level2', 'ESRI Shapefile',overwrite_layer = TRUE)
