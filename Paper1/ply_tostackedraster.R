"
@author: Zsofia Koma, UvA
Aim: convert ply into stacked raster including dtm features
"

library("raster")
library("maptools")
library("data.table")

# global variables

args = commandArgs(trailingOnly=TRUE)

workingdirectory=args[1]
filename=args[2]

#workingdirectory="D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/"
#filename="tile_1_0.las_ground"

setwd(workingdirectory)

# Metrics

pc_fea_veg = fread(paste(filename ,"2.5m_cell.ply",sep=""), header = F, sep = ' ',skip=43)

dtm_tifs = list.files(path=workingdirectory,pattern=paste(filename,".las_ground_dtm*.tif",sep=''))
fea_dtm = stack(dtm_tifs)
#plot(fea_dtm)

# Normalize (based on a minimum value)

pc_fea_veg$V27=(pc_fea_veg$V11+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V28=(pc_fea_veg$V12+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V29=(pc_fea_veg$V13+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V30=(pc_fea_veg$V15+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V31=(pc_fea_veg$V16+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V32=(pc_fea_veg$V17+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V33=(pc_fea_veg$V18+500)-(pc_fea_veg$V14+500)
pc_fea_veg$V34=(pc_fea_veg$V19+500)-(pc_fea_veg$V14+500)


# Export only vegetation metrics

pc_fea_veg_r=rasterFromXYZ(pc_fea_veg, digits = 8)

crs(pc_fea_veg_r) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

writeRaster(pc_fea_veg_r, paste(filename ,"_fea_veg.tif",sep=""),overwrite=TRUE)

# Export metrics all together

fea_dtm_ext=formask_agrar_resampled=resample(fea_dtm,pc_fea_veg_r)
lidarmetrics_raster= stack(pc_fea_veg_r,fea_dtm_ext)
#plot(lidarmetrics_raster)

crs(lidarmetrics_raster) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

writeRaster(lidarmetrics_raster, paste(filename ,"_allfea.tif",sep=""),overwrite=TRUE)


