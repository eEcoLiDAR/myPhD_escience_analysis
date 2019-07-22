"
@author: Zsofia Koma, UvA
Aim: prepare data for SDM modelling - intersection
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_3/"
#workingdirectory="C:/Koma/Paper2/Paper2_PreProcess/"
setwd(workingdirectory)

# Atlas

pres=readOGR(dsn="birds_lgn7_appl_presatl.shp")
abs=readOGR(dsn="birds_lgn7_appl_absatl.shp")

abs_forsdm=abs[,c(14,12)]
names(abs_forsdm) <- c("occurrence","species")
pres_forsdm=pres[,c(17,3)]
names(pres_forsdm) <- c("occurrence","species")

presabs <- bind(pres_forsdm, abs_forsdm)

BReed_presabs=presabs[presabs@data$species=="Baardman",]
GreedW_presabs=presabs[presabs@data$species=="Grote Karekiet",]
ReedW_presabs=presabs[presabs@data$species=="Kleine Karekiet",]
SedgeW_presabs=presabs[presabs@data$species=="Rietzanger",]
SaviW_presabs=presabs[presabs@data$species=="Snor",]

# Export

raster::shapefile(BReed_presabs, "BReed_presabs.shp",overwrite=TRUE)
raster::shapefile(GreedW_presabs, "GreedW_presabs.shp",overwrite=TRUE)
raster::shapefile(ReedW_presabs, "ReedW_presabs.shp",overwrite=TRUE)
raster::shapefile(SedgeW_presabs, "SedgeW_presabs.shp",overwrite=TRUE)
raster::shapefile(SaviW_presabs, "SaviW_presabs.shp",overwrite=TRUE)