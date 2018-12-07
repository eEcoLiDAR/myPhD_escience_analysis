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
full_path="C:/Users/zsofi/Google Drive/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/2_Dataset/FieldData/"
polygon_file="vlakken_union_structuur.shp"

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))

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