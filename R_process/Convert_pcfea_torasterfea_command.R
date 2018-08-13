"
@author: Zsofia Koma, UvA
Aim: convert Berend's result into raster

input:
output:

fuctions:

Example: Rscript.exe D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/R_process/Convert_pcfea_torasterfea_command.R D:/Koma/Paper1_ReedStructure/Data/TestFeatureResults/ tile_00001_land_ascii.csv
"

# Import required libraries
library("lidR")
library("rlas")
library("raster")
library("maptools")
library("data.table")

args = commandArgs(trailingOnly=TRUE)

full_path=args[1]
filename=args[2]

setwd(full_path)

start_time <- Sys.time()

vertdistr_3Dshape_res = fread(filename, header = T, sep = ',')
print(head(vertdistr_3Dshape_res))

lin_r <- rasterFromXYZ(vertdistr_3Dshape_res[,c(1,2,7)])
writeRaster(lin_r, paste(substr(filename, 1, nchar(filename)-4) ,"_lin.tif",sep=""),overwrite=TRUE)

end_time <- Sys.time()
print(end_time - start_time)