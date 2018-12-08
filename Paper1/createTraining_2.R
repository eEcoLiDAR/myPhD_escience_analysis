"
@author: Zsofia Koma, UvA
Aim: create training data
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
full_path="D:/Koma/Paper1/ALS/forClassification/"
polygon_file="vlakken_union_structuur.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))

# Modify the classes for the paper

# level 4
polygon@data$level4=NA

polygon@data$level4[polygon@data$StructDef=='W']="W"
polygon@data$level4[polygon@data$StructDef=='A']="A"
polygon@data$level4[polygon@data$StructDef=='Rkd']="Rkd"
polygon@data$level4[polygon@data$StructDef=='Rko']="Rko"
polygon@data$level4[polygon@data$StructDef=='Rld']="Rld"
polygon@data$level4[polygon@data$StructDef=='Rlo']="Rlo"
polygon@data$level4[polygon@data$StructDef=='Rwd']="Rwd"
polygon@data$level4[polygon@data$StructDef=='Rwo']="Rwo"
polygon@data$level4[polygon@data$StructDef=='U']="U"
polygon@data$level4[polygon@data$StructDef=='Gl' | polygon@data$StructDef=='Gh' | 
                  polygon@data$StructDef=='K' | polygon@data$StructDef=='P']="G"
polygon@data$level4[polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld' | polygon@data$StructDef=='Smo' 
                  | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'] = "S"
polygon@data$level4[polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="B"

unique(polygon@data$level4)

# level 3
polygon@data$level3=NA

polygon@data$level3[polygon@data$StructDef=='W']="W"
polygon@data$level3[polygon@data$StructDef=='A']="A"
polygon@data$level3[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko']="Rk"
polygon@data$level3[polygon@data$StructDef=='Rld' | polygon@data$StructDef=='Rlo']="Rl"
polygon@data$level3[polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo']="Rw"
polygon@data$level3[polygon@data$StructDef=='U']="U"
polygon@data$level3[polygon@data$StructDef=='Gl' | polygon@data$StructDef=='Gh' | 
                      polygon@data$StructDef=='K' | polygon@data$StructDef=='P']="G"
polygon@data$level3[polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld' | polygon@data$StructDef=='Smo' 
                    | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'] = "S"
polygon@data$level3[polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="B"

unique(polygon@data$level3)

# level 2
polygon@data$level2=NA

polygon@data$level2[polygon@data$StructDef=='W']="W"
polygon@data$level2[polygon@data$StructDef=='A']="A"
polygon@data$level2[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko' | polygon@data$StructDef=='Rld'
                    | polygon@data$StructDef=='Rlo' | polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo'
                    | polygon@data$StructDef=='U']="R"
polygon@data$level2[polygon@data$StructDef=='Gl' | polygon@data$StructDef=='Gh' | 
                      polygon@data$StructDef=='K' | polygon@data$StructDef=='P']="G"
polygon@data$level2[polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld' | polygon@data$StructDef=='Smo' 
                    | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'] = "S"
polygon@data$level2[polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="B"

unique(polygon@data$level2)

# level 1
polygon@data$level1=NA

polygon@data$level1[polygon@data$StructDef=='W']="W"
polygon@data$level1[polygon@data$StructDef=='A']="A"
polygon@data$level1[polygon@data$StructDef=='Rkd' | polygon@data$StructDef=='Rko' | polygon@data$StructDef=='Rld'
                    | polygon@data$StructDef=='Rlo' | polygon@data$StructDef=='Rwd' | polygon@data$StructDef=='Rwo'
                    | polygon@data$StructDef=='U' | polygon@data$StructDef=='Gl' | polygon@data$StructDef=='Gh'
                    | polygon@data$StructDef=='K' | polygon@data$StructDef=='P' | polygon@data$StructDef=='Slo' | polygon@data$StructDef=='Sld'
                    | polygon@data$StructDef=='Smo' | polygon@data$StructDef=='Smd' | polygon@data$StructDef=='Sho' | polygon@data$StructDef=='Shd'
                    | polygon@data$StructDef=='Bo' | polygon@data$StructDef=='Bd']="V"

unique(polygon@data$level1)

# Create trainings per classes
classes=unique(polygon@data$StructDef)

for (cat in classes) { 
  print(cat)
  sel_poly <- polygon[polygon@data$StructDef == cat,]
  points_inpoly=spsample(sel_poly, n = 25, "random")
  points_inpoly_df=as.data.frame(points_inpoly)
  points_inpoly_df$level3=cat
  write.table(points_inpoly_df, file = paste(cat,"_selpolyperclass.csv",sep="_"),row.names=FALSE,col.names=FALSE,sep=",")
}

# Reorganize
files <- list.files(pattern = "_selpolyperclass.csv")

allcsv <- lapply(files,function(i){
  read.csv(i, header=FALSE)
})

allcsv_df <- do.call(rbind.data.frame, allcsv)

coordinates(allcsv_df)=~V1+V2
proj4string(allcsv_df)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Add levels and buffer zone

allcsv_df@data$V4=NA
allcsv_df@data$V4[allcsv_df@data$V3=='W']="W"
allcsv_df@data$V4[allcsv_df@data$V3=='A']="A"
allcsv_df@data$V4[allcsv_df@data$V3=='Rwo' | allcsv_df@data$V3=='Rwd' | allcsv_df@data$V3=='Rlo' 
                  | allcsv_df@data$V3=='Rld' | allcsv_df@data$V3=='Rko' | allcsv_df@data$V3=='Rkd' 
                  | allcsv_df@data$V3=='U']="R"
allcsv_df@data$V4[allcsv_df@data$V3=='Gl' | allcsv_df@data$V3=='Gh' | 
                    allcsv_df@data$V3=='K' | allcsv_df@data$V3=='P']="G"
allcsv_df@data$V4[allcsv_df@data$V3=='Slo' | allcsv_df@data$V3=='Sld' | allcsv_df@data$V3=='Smo' 
                  | allcsv_df@data$V3=='Smd' | allcsv_df@data$V3=='Sho' | allcsv_df@data$V3=='Shd'] = "S"
allcsv_df@data$V4[allcsv_df@data$V3=='Bo' | allcsv_df@data$V3=='Bd']="B"

allcsv_df@data$V5=as.numeric(factor(allcsv_df@data$V4))

allcsv_df_buff5 <- gBuffer( allcsv_df, width=5, byid=TRUE )

# Export shapefile
rgdal::writeOGR(allcsv_df_buff5, '.', 'training', 'ESRI Shapefile',overwrite_layer = TRUE)