library("raster")
library("maptools")
library("data.table")

# global variables

workingdirectory="D:/Koma/lidar_bird_dsm_workflow/escience_test/"
filename="tile0_1"
#filename="tile0_1_norm"

setwd(workingdirectory)

# Export

pc_fea = fread(paste(filename ,"_cell_10m.ply",sep=""), header = F, sep = ' ',skip=27)
#print(head(pc_fea))

pc_fea_var_z <- rasterFromXYZ(pc_fea[,c(1,2,8)])
writeRaster(pc_fea_var_z, paste(filename,"_max_z.tif",sep=""),overwrite=TRUE)

pc_fea_var_z <- rasterFromXYZ(pc_fea[,c(1,2,7)])
writeRaster(pc_fea_var_z, paste(filename,"_kurto_z.tif",sep=""),overwrite=TRUE)
