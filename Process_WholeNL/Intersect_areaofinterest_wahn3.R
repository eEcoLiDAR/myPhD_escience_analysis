"
@author: Zsofia Koma, UvA
Aim: overlay butterfly transect with LiDAR 
"

# Import libraries
library("rgdal")
library("raster")
library("rgeos")
library("dplyr")


# Set global variables
full_path="D:/Sync/_Amsterdam/10_ProcessWholeNL/"

areaofintfile="tiles_scheme_forprocess.shp"
ahnfile="ahn3.shp"

setwd(full_path)

# Import 

ahn2 = readOGR(dsn=ahnfile)
areaofint=readOGR(dsn=areaofintfile)

# Intersection
intersected=raster::intersect(ahn2,areaofint)
intersected_df=intersected@data

intersected_df$bladnr_up=toupper(intersected_df$bladnr)

intersected_df$list=paste("https://geodata.nationaalgeoregister.nl/ahn3/extract/ahn3_laz/C_",intersected_df$bladnr_up,".LAZ",sep="")

# Export list per id
ids=unique(intersected_df$id)

for (i in ids) {
  print(i)
  
  intersected_df_selid=intersected_df[intersected_df$id==i,]
  
  write.table(intersected_df_selid$list, file = paste("TileGroup_",i,"_reqahn3.txt",sep=""), append = FALSE, quote = FALSE, sep = "", 
              eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
              col.names = FALSE, qmethod = c("escape", "double")) 
  
}
