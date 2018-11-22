"
@author: Zsofia Koma, UvA
Aim: convert ply into raster
"

library("raster")
library("maptools")
library("data.table")

# global variables

workingdirectory="D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/"
filename="tile_1_0.las_ground"

setwd(workingdirectory)

# Metrics without normalization

pc_fea_veg = fread(paste(filename ,"2.5m_cell.ply",sep=""), header = F, sep = ' ',skip=31)
#print(head(pc_fea))

pc_fea_veg_dens_amean <- rasterFromXYZ(pc_fea_veg[,c(1,2,4)])
writeRaster(pc_fea_veg_dens_amean, paste(filename,"_dens_amean.tif",sep=""),overwrite=TRUE)

pc_fea_veg_eigv1 <- rasterFromXYZ(pc_fea_veg[,c(1,2,5)])
writeRaster(pc_fea_veg_eigv1, paste(filename,"_eigv1.tif",sep=""),overwrite=TRUE)

pc_fea_veg_eigv2 <- rasterFromXYZ(pc_fea_veg[,c(1,2,6)])
writeRaster(pc_fea_veg_eigv2, paste(filename,"_eigv2.tif",sep=""),overwrite=TRUE)

pc_fea_veg_eigv3 <- rasterFromXYZ(pc_fea_veg[,c(1,2,7)])
writeRaster(pc_fea_veg_eigv3, paste(filename,"_eigv3.tif",sep=""),overwrite=TRUE)

pc_fea_veg_kurto_z <- rasterFromXYZ(pc_fea_veg[,c(1,2,10)])
writeRaster(pc_fea_veg_kurto_z, paste(filename,"_kurto_z.tif",sep=""),overwrite=TRUE)

pc_fea_veg_pdens <- rasterFromXYZ(pc_fea_veg[,c(1,2,11)])
writeRaster(pc_fea_veg_pdens, paste(filename,"_pdens.tif",sep=""),overwrite=TRUE)

pc_fea_veg_pulsepen <- rasterFromXYZ(pc_fea_veg[,c(1,2,12)])
writeRaster(pc_fea_veg_pulsepen, paste(filename,"_pulsepen.tif",sep=""),overwrite=TRUE)

pc_fea_veg_skew_z <- rasterFromXYZ(pc_fea_veg[,c(1,2,14)])
writeRaster(pc_fea_veg_skew_z, paste(filename,"_skew_z.tif",sep=""),overwrite=TRUE)

pc_fea_veg_std_z <- rasterFromXYZ(pc_fea_veg[,c(1,2,15)])
writeRaster(pc_fea_veg_std_z, paste(filename,"_std_z.tif",sep=""),overwrite=TRUE)

pc_fea_veg_var_z <- rasterFromXYZ(pc_fea_veg[,c(1,2,16)])
writeRaster(pc_fea_veg_var_z, paste(filename,"_var_z.tif",sep=""),overwrite=TRUE)

pc_fea_veg_z_entropy <- rasterFromXYZ(pc_fea_veg[,c(1,2,17)])
writeRaster(pc_fea_veg_z_entropy, paste(filename,"_z_entropy.tif",sep=""),overwrite=TRUE)

# Metrics with normalization

pc_fea_veg_norm = fread(paste(filename ,".las_ground_norm2.5m_cell.ply",sep=""), header = F, sep = ' ',skip=24)
#print(head(pc_fea))

pc_fea_veg_max_z <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,6)])
writeRaster(pc_fea_veg_max_z, paste(filename,"_max_z_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_mean_z <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,7)])
writeRaster(pc_fea_veg_mean_z, paste(filename,"_mean_z_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_median_z <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,8)])
writeRaster(pc_fea_veg_median_z, paste(filename,"_median_z_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_perc_10 <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,9)])
writeRaster(pc_fea_veg_perc_10, paste(filename,"_perc_10_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_perc_30 <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,10)])
writeRaster(pc_fea_veg_perc_30, paste(filename,"_perc_30_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_perc_50 <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,11)])
writeRaster(pc_fea_veg_perc_50, paste(filename,"_perc_50_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_perc_70 <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,12)])
writeRaster(pc_fea_veg_perc_70, paste(filename,"_perc_70_norm.tif",sep=""),overwrite=TRUE)

pc_fea_veg_perc_90 <- rasterFromXYZ(pc_fea_veg_norm[,c(1,2,13)])
writeRaster(pc_fea_veg_perc_90, paste(filename,"_perc_90_norm.tif",sep=""),overwrite=TRUE)