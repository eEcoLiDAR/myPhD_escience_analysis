"
@author: Zsofia Koma, UvA
Aim: re-categorize field polygon to classes which we would like to use
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

# Set global variables
full_path="D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/"
polygon_file="vlakken_union_structuur.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))

# Modify the classes for the paper

# level 3
polygon@data$level3=NA

polygon@data$level3[polygon@data$StructDef=='W' | polygon@data$StructDef=='K' | polygon@data$StructDef=='P'| polygon@data$StructDef=='Gl']="P"
polygon@data$level3[polygon@data$StructDef=='A']="A"
polygon@data$level3[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko']="Rk"
polygon@data$level3[polygon@data$StructDef=='Rld' | polygon@data$StructDef=='Rlo']="Rl"
polygon@data$level3[polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo']="Rw"
polygon@data$level3[polygon@data$StructDef=='U']="U"
polygon@data$level3[polygon@data$StructDef=='Gh']="G"
polygon@data$level3[polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld' | polygon@data$StructDef=='Smo' 
                    | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'] = "S"
polygon@data$level3[polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="B"

sort(unique(polygon@data$level3))

# level 2
polygon@data$level2=NA

polygon@data$level2[polygon@data$StructDef=='W' | polygon@data$StructDef=='K' | polygon@data$StructDef=='P' | polygon@data$StructDef=='Gl']="P"
polygon@data$level2[polygon@data$StructDef=='A']="A"
polygon@data$level2[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko' | polygon@data$StructDef=='Rld'
                    | polygon@data$StructDef=='Rlo' | polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo'
                    | polygon@data$StructDef=='U']="R"
polygon@data$level2[polygon@data$StructDef=='Gh']="G"
polygon@data$level2[polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld' | polygon@data$StructDef=='Smo' 
                    | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'] = "S"
polygon@data$level2[polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="B"

sort(unique(polygon@data$level2))

# level 1
polygon@data$level1=NA

polygon@data$level1[polygon@data$StructDef=='W' | polygon@data$StructDef=='K' | polygon@data$StructDef=='P' | polygon@data$StructDef=='Gl' | polygon@data$StructDef=='A']="O"
polygon@data$level1[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko' | polygon@data$StructDef=='Rld'
                    | polygon@data$StructDef=='Rlo' | polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo'
                    | polygon@data$StructDef=='U' | polygon@data$StructDef=='Gh'
                    | polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld'
                    | polygon@data$StructDef=='Smo' | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'
                    | polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="V"

sort(unique(polygon@data$level1))

rgdal::writeOGR(polygon, '.', 'recategorized3', 'ESRI Shapefile',overwrite_layer = TRUE)