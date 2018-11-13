"
@author: Zsofia Koma, UvA
Aim: Classification of AHN2 non-vegetation data
"

# Import required libraries
library("lidR")
library("rlas")
library("raster")
library("maptools")

library("e1071")

# Set global variables
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS_orig/02gz2/"
lidarfile="u02gz2.laz"

setwd(full_path)

# Import lidar data and build up the catalog

nonground_ctg = catalog(paste(full_path,lidarfile,sep=""))
nonground_ctg@crs = sp::CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
plot(nonground_ctg)

cores(nonground_ctg) <- 3L
buffer(nonground_ctg) <- 1

# Calculate features
create_hrange <- function(las) 
{
  hrange = grid_metrics(las, range(Z), res=2.5)
  return(hrange)
}

hrange_fea <- catalog_apply(nonground_ctg, create_hrange)
hrange <- data.table::rbindlist(hrange_fea)

hrange_r <- rasterFromXYZ(hrange)
writeRaster(hrange_r, paste(substr(lidarfile, 1, nchar(lidarfile)-4) ,"_hrange.tif",sep=""))