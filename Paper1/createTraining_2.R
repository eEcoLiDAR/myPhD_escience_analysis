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
full_path="D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/"
polygon_file="recategorized3.shp"
building_file="buldings.shp"
level1=27

setwd(full_path)

# Import
polygon=readOGR(dsn=paste(full_path,polygon_file,sep=""))
building=readOGR(dsn=paste(full_path,building_file,sep=""))


# Create trainings per classes
classes=unique(polygon@data[,level1])

for (cat in classes) { 
  print(cat)
  sel_poly <- polygon[polygon@data[,level1] == cat,]
  sel_poly_invbuf=gBuffer(sel_poly, width=-5, byid=TRUE )
  points_inpoly=spsample(sel_poly_invbuf, n = 50, "random")
  points_inpoly_df=as.data.frame(points_inpoly)
  points_inpoly_df$level=cat
  write.table(points_inpoly_df, file = paste(cat,"_selpolyper",names(polygon@data)[level1],"v2.csv",sep="_"),row.names=FALSE,col.names=FALSE,sep=",")
}

# Add building training

#buildpoints_inpoly=spsample(building, n = 50, "random")
#buildpoints_inpoly_df=as.data.frame(buildpoints_inpoly)
#buildpoints_inpoly_df$level='B'
#write.table(buildpoints_inpoly_df, file = paste('B',"_selpolyper",names(polygon@data)[level1],"v2.csv",sep="_"),row.names=FALSE,col.names=FALSE,sep=",")

# Reorganize
files <- list.files(pattern = paste("_selpolyper",names(polygon@data)[level1],"v2.csv",sep="_"))

allcsv <- lapply(files,function(i){
  read.csv(i, header=FALSE)
})

allcsv_df <- do.call(rbind.data.frame, allcsv)

#allcsv_df_V=allcsv_df[allcsv_df$V3=='V',]
#allcsv_df_O1=allcsv_df[allcsv_df$V3=='O',]
#allcsv_df_O1=allcsv_df_O1[sample(nrow(allcsv_df_O1), 25), ]
#allcsv_df_O2=allcsv_df[allcsv_df$V3=='B',]
#allcsv_df_O2=allcsv_df_O2[sample(nrow(allcsv_df_O2), 25), ]

#allcsv_df_mod <- rbind(allcsv_df_V, allcsv_df_O1, allcsv_df_O2) 
#allcsv_df_mod$V3[allcsv_df_mod$V3 == "B"] <- "O"

coordinates(allcsv_df)=~V1+V2
proj4string(allcsv_df)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Add buffer zone

allcsv_df_buff <- gBuffer( allcsv_df, width=2.5, byid=TRUE )

# Export shapefile
rgdal::writeOGR(allcsv_df_buff, '.', paste("selpolyper",names(polygon@data)[level1],"v4",sep="_"), 'ESRI Shapefile',overwrite_layer = TRUE)