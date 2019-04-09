library(lidR)
library(plot3D)

setwd("C:/Koma/Sync/_Amsterdam/07_Paper_escience_software/")

#Import
las=readLAS("g32hz1rect2.las")

#Vis
scatter3D(las@data$X, las@data$Y, las@data$Z, pch = 16,  theta = 25, phi = 25, bty="u",
          cex = 0.4,expand =0.3,colkey = FALSE,col.panel ="white",col.grid = "black")



