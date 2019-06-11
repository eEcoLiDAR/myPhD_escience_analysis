"
@author: Zsofia Koma, UvA
Aim: get required AHN3 list for the manually selected wetlands
"

library("rgdal")
library("raster")
library("rgeos")
library("spatialEco")
library("dplyr")
library("maptools")
library("sf")

library("ggplot2")

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"

birdpresfile="bird_presonly.shp"
ahn3="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/lidar/ahn3.shp"
maskfile="req_lgn7_classes.grd"
selwetlandfile="sel_wetlands.shp"


setwd(full_path)

# Import
ahn3_poly = readOGR(dsn=ahn3)
selwetlandfile_poly = readOGR(dsn=selwetlandfile)
birdpres = readOGR(dsn=birdpresfile)

landcovermask=stack(maskfile)

# Extract intersected AHN3 files
intersected=raster::intersect(ahn3_poly,selwetlandfile_poly)
intersected_df=intersected@data

req_ahn3 <- intersected_df %>%
  group_by(bladnr) %>%
  summarise(nofobs = length(bladnr))

req_ahn3$bladnr_up=toupper(req_ahn3$bladnr)

req_ahn3$list=paste("https://geodata.nationaalgeoregister.nl/ahn3/extract/ahn3_laz/C_",req_ahn3$bladnr_up,".LAZ",sep="")

write.table(req_ahn3$list, file = "ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

# Create area of interest 
areofint <- st_bbox(selwetlandfile_poly)

xrange <- areofint$xmax - areofint$xmin
yrange <- areofint$ymax - areofint$ymin

grid_spacing <- 1000

grid_net <- c(xrange/grid_spacing , yrange/grid_spacing) %>% ceiling()

selwetland_gridded <- st_make_grid(selwetlandfile_poly, square = T, n = grid_net)
selwetland_gridded <- sf:::as_Spatial(selwetland_gridded)
selwetland_grid=raster::intersect(selwetland_gridded,selwetlandfile_poly)

raster::shapefile(selwetland_grid, "selwetland_grid.shp",overwrite=TRUE)

# Mask with lgn7 mask - within and I do not know how to expand to include one more cellsaround the edges
landcovermask_red=crop(landcovermask,extent(selwetland_grid))
landcovermask_red_1km<-aggregate(landcovermask_red, fact=10, fun=mean)

beginCluster()
selwetland_grid_masked <- extract(landcovermask_red_1km, selwetland_grid, fun = max, na.rm = TRUE, sp = TRUE)
endCluster()

selwetland_grid_masked_true <- subset(selwetland_grid_masked, layer==1) 
raster::shapefile(selwetland_grid_masked_true, "selwetland_grid_masked_true.shp",overwrite=TRUE)

# Get only the cells where we have presence data
selwetland_grid_birdpres=raster::intersect(selwetland_grid,birdpres)
raster::shapefile(selwetland_grid_birdpres, "selwetland_grid_birdpres.shp",overwrite=TRUE)
