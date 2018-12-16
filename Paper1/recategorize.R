"
@author: Zsofia Koma, UvA
Aim: re-categorize field polygon to classes which we would like to use
"

# Import libraries
library(raster)
library(sp)
library(spatialEco)
library(rgdal)

# Set global variables
#full_path="D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/"
full_path="D:/Koma/Paper1/ALS/forClassification3/"

polygon_file="vlakken_union_structuur.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=polygon_file)

# Add Level 1
polygon@data$level1=NA

polygon@data$level1[polygon@data$StructDef=='W' | polygon@data$StructDef=='K' | polygon@data$StructDef=='P' | polygon@data$StructDef=='Gl' | polygon@data$StructDef=='A']="O"
polygon@data$level1[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko' | polygon@data$StructDef=='Rld'
                    | polygon@data$StructDef=='Rlo' | polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo'
                    | polygon@data$StructDef=='U' | polygon@data$StructDef=='Gh'
                    | polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld'
                    | polygon@data$StructDef=='Smo' | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'
                    | polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="V"

sort(unique(polygon@data$level1))

rgdal::writeOGR(polygon, '.', 'recategorized', 'ESRI Shapefile',overwrite_layer = TRUE)