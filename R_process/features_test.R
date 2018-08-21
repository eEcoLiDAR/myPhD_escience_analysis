"
@author: Zsofia Koma, UvA
Aim: whole NL feature exploration

input:
output:

Fuctions:

Example: 

"

library(raster)

# Import

setwd("D:/Koma/escience/NL_features")

features_nl=stack("terrainData1km.tif")

for (i in 1:29) {
  jpeg(paste(i,'.jpg',sep=''))
  par(mfrow=c(2,1))
  hist(features_nl[[i]])
  plot(features_nl[[i]])
  dev.off()
} 