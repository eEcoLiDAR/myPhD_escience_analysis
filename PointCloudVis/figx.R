library(rgdal)
library(rgeos)
library(raster)

library(lidR)
library(plot3D)

setwd("D:/Sync/_Amsterdam/07_Paper_escience_software/")

raster=stack("D:/Sync/_Amsterdam/07_Paper_escience_software/ahn3_2019_01_08_1x1m_features_100m_subtile_0.tif")

raster=flip(raster,direction = 'y')

plot(raster)
summary(raster)

writeRaster(raster$ahn3_2019_01_08_1x1m_features_100m_subtile_0.10,"zmean_100.tif")

ctg=catalog("D:/Sync/_Amsterdam/07_Paper_escience_software/")

opt_chunk_buffer(ctg) <- 0
opt_chunk_size(ctg) <- 100
opt_output_files(ctg) <- "D:/Sync/_Amsterdam/07_Paper_escience_software/tile_{ID}"

newctg=catalog_retile(ctg)

las=readLAS("D:/Sync/_Amsterdam/07_Paper_escience_software/tile_9.las")

scatter3D(las@data$X, las@data$Y, las@data$Z, pch = 16,  theta = -35, phi = 10, bty="u",
          cex = 0.4,expand =0.35,colkey = FALSE,col.panel ="white",col.grid = "black", colvar=las@data$Classification,col=ramp.col(c("darkgreen","orange","blue","blue","blue","blue","blue","blue","blue")))

grid.lines = 1
x.pred <- seq(min(las@data$X), max(las@data$X), length.out = grid.lines)
y.pred <- seq(min(las@data$Y), max(las@data$Y), length.out = grid.lines)
xy <- expand.grid( x = x.pred, y = y.pred)
z.pred <- matrix(mean(las@data$Z),nrow = grid.lines, ncol = grid.lines)

scatter3D(las@data$X, las@data$Y, las@data$Z, pch = 16,  theta = -35, phi = 10, bty="u",
          cex = 0.4,expand =0.35,colkey = FALSE,col.panel ="white",col.grid = "black", colvar=las@data$Classification,col=ramp.col(c("darkgreen","orange","blue","blue","blue","blue","blue","blue","blue")),
          surf = list(x = c(min(las@data$X),max(las@data$X)), y = c(min(las@data$Y),max(las@data$Y)), z = matrix(mean(las@data$Z),nrow = 2, ncol = 2), facets = TRUE, border = NA, alpha=0.5,lwd = 2,colkey=NA,col ="#7570B3"))

x0 <- c(min(las@data$X), max(las@data$X),  max(las@data$X), min(las@data$X))
x1 <- c(max(las@data$X), max(las@data$X),  min(las@data$X), min(las@data$X))
 
y0 <- c(min(las@data$Y), min(las@data$Y),  max(las@data$Y), min(las@data$Y))
y1 <- c(min(las@data$Y), max(las@data$Y),  max(las@data$Y), max(las@data$Y))

z0 <- c(mean(las@data$Z), mean(las@data$Z), mean(las@data$Z), mean(las@data$Z))

scatter3D(las@data$X, las@data$Y, las@data$Z, pch = 16,  theta = -35, phi = 10, bty="u",
          cex = 0.4,expand =0.35,colkey = FALSE,col.panel ="white",col.grid = "black", colvar=las@data$Classification,col=ramp.col(c("darkgreen","orange","blue","blue","blue","blue","blue","blue","blue")))
segments3D(x0, y0, z0, x1, y1, z1 = z0, col = "red", lwd = 6,pch = 16,  theta = -35, phi = 10, bty="u", cex = 0.4,expand =0.35,add=TRUE)


las_big=readLAS("D:/Sync/_Amsterdam/07_Paper_escience_software/Transect_785.laz")

meanz=grid_metrics(las_big,mean(Z),res = 100)
plot(meanz)

writeRaster(meanz,"D:/Sync/_Amsterdam/07_Paper_escience_software/meanz_100small.tif",overwrite=TRUE)

las_dsm=grid_metrics(las_big,max(Z),res=1)

#hillshade
crs(las_dsm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

slope <- terrain(las_dsm, opt='slope')
aspect <- terrain(las_dsm, opt='aspect')
dsm_shd <- hillShade(slope, aspect, 40, 270)

writeRaster(dsm_shd,"D:/Sync/_Amsterdam/07_Paper_escience_software/meanz_shd.tif")