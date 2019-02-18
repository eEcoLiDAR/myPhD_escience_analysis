"
@author: Zsofia Koma, UvA
Aim: Organizing the Dutch vegetation database 

Input: 
Output: 

"

# call the required libraries
library("stringr")

library("sp")
library("rgdal")
library("raster")
library("dplyr")

# set global variables
setwd("D:/Sync/_Amsterdam/04_Paper3_LargeScaleReedbed/fromStephanHennekens/PhragmitesAustralis_Febr2018/") # working directory

## Import data
landcover=stack("LGN7_wgs84.tif")
#plot(lgn7)

## Get training areas

# Agrar
formask_agrar <- setValues(raster(landcover), NA)
formask_agrar[landcover==1 | landcover==2 | landcover==3 | landcover==4 | landcover==5 | landcover==6 | landcover==8 | landcover==9 | landcover==10 | landcover==26
              | landcover==61 | landcover==62] <- 1

plot(formask_agrar, col="dark green", legend = FALSE)
writeRaster(formask_agrar, filename="formask_agrar.tif", format="GTiff",overwrite=TRUE)

gc()

# Bos
formask_bos <- setValues(raster(landcover), NA)
formask_bos[landcover==11 | landcover==12] <- 1

plot(formask_bos, col="dark green", legend = FALSE)
writeRaster(formask_bos, filename="formask_bos.tif", format="GTiff",overwrite=TRUE)

gc()

# Water
formask_water <- setValues(raster(landcover), NA)
formask_water[landcover==16 | landcover==17] <- 1

plot(formask_water, col="dark green", legend = FALSE)
writeRaster(formask_water, filename="formask_water.tif", format="GTiff",overwrite=TRUE)

gc()

# Cities
formask_cities <- setValues(raster(landcover), NA)
formask_cities[landcover==18 | landcover==19 | landcover==20 | landcover==22 | landcover==23 | landcover==24 | landcover==28 | landcover==25] <- 1

plot(formask_cities, col="dark green", legend = FALSE)
writeRaster(formask_cities, filename="formask_cities.tif", format="GTiff",overwrite=TRUE)

gc()

# Natur
formask_natur <- setValues(raster(landcover), NA)
formask_natur[landcover==30 | landcover==31 | landcover==32 | landcover==33 | landcover==34 | landcover==35 | landcover==36 | landcover==37 | landcover==38 | landcover==45] <- 1

plot(formask_natur, col="dark green", legend = FALSE)
writeRaster(formask_natur, filename="formask_natur.tif", format="GTiff",overwrite=TRUE)

gc()
