library(lidR)
library(plot3D)

#setwd("C:/Koma/Sync/_Amsterdam/07_Paper_escience_software/")
setwd("D:/Sync/_Amsterdam/07_Paper_escience_software/")

#Import
las=readLAS("g32hz1rect2.las")

las.classified <- lasground(las, csf())

#Vis
scatter3D(las.classified@data$X, las.classified@data$Y, las.classified@data$Z, pch = 16,  theta = 25, phi = 10, bty="u",
          cex = 0.4,expand =0.35,colkey = FALSE,col.panel ="white",col.grid = "black", colvar=las.classified@data$Classification,col=ramp.col(c("darkgreen","brown")))

#Raster

hsd <- grid_metrics(las.classified, sd(Z), 1)
plot(hsd,col=jet.col())

#Voxel
myMetrics = function(i)
   {
      ret = list(
      npoints = length(i),
      imean   = mean(i))

    return(ret)
}





#Sphere
scatter3D(las.classified@data$X, las.classified@data$Y, las.classified@data$Z, pch = 16,  theta = 25, phi = 10, bty="u",
          cex = 0.4,expand =0.35,colkey = FALSE,col.panel ="white",col.grid = "black",col=jet.col(),ticktype = "detailed")