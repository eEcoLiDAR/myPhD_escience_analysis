"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN3 data
"
library("lidR")
library("rgdal")
library("snow")

library("ggplot2")
library("viridis")
library("ggthemes")

library("rgl")
library("sp")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"
#workingdirectory="D:/Koma/SelectedWetlands/"
setwd(workingdirectory)

lasfile="Snor_115_165541.laz"
birdfile="bird_presonly.shp"

#Import 
las=readLAS(lasfile)
birds=readOGR(dsn=birdfile)

birds@data$id <- seq(1,length(birds$X),1)

#Visualize point cloud

col = c("gray", "gray", "blue", "darkgreen", "darkgreen", "darkgreen", "red", "gray", "cyan", "darkgray", "gray", "pink", "pink", "purple", "pink")
plot(las,color="Classification",colorPalette = col)

# raster with 1 m resolution

las_dsm=grid_metrics(las,max(Z),res=1)
plot(las_dsm)

crs(las_dsm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

slope <- terrain(las_dsm, opt='slope')
aspect <- terrain(las_dsm, opt='aspect')
dsm_shd <- hillShade(slope, aspect, 40, 270)

plot(dsm_shd, col=grey(0:100/100), legend=FALSE, main='plot1')
plot(las_dsm, col=rainbow(25, alpha=0.35), add=TRUE)
plot(birds,pch=1,add=TRUE,cex=3,lwd = 3)

#Vertical

las_cross_hor=lasclipRectangle(las,200422.78-0.5,526136.46-100,200422.78+0.5,526136.46+100)
plot(las_cross_hor)

coords = matrix(c(200422.78-0.5, 526136.46-100,
                  200422.78+0.5, 526136.46+100), 
                ncol = 2, byrow = TRUE)


P1 = Polygon(coords)
line_cr = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"))
plot(line_cr, axes = TRUE)

#relative
las_cross_hor@data$Y_cross=las_cross_hor@data$Y-526136.46+100

plot(x = las_cross_hor@data$Y_cross, y = las_cross_hor@data$Z, col = c("green", "orange", "blue","blue","blue","blue","blue","blue","blue","blue")[las_cross_hor@data$Classification], frame = FALSE, xlab = "Y", ylab = "Height",pch=19,ylim=c(-5,20))

#Horizontal

las_cross_ver=lasclipRectangle(las,200422.78-100,526136.46-0.5,200422.78+100,526136.46+0.5)
plot(las_cross_ver)

coords2 = matrix(c(200422.78-100, 526136.46-0.5,
                  200422.78+100, 526136.46+0.5), 
                ncol = 2, byrow = TRUE)


P12 = Polygon(coords2)
line_cr2 = SpatialPolygons(list(Polygons(list(P12), ID = "a")), proj4string=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"))
plot(line_cr2, axes = TRUE)

#relative
las_cross_ver@data$X_cross=las_cross_ver@data$X-200422.78+100

plot(x = las_cross_ver@data$X_cross, y = las_cross_ver@data$Z, col = c("green", "orange", "blue","blue","blue","blue","blue","blue","blue","blue")[las_cross_ver@data$Classification], frame = FALSE, xlab = "Y", ylab = "Height",pch=19,ylim=c(-5,20))

#put all together

dev.copy(png,'myplot_above.png',width = 1080,height = 1080)

par(mfrow=c(1,1)) 

plot(dsm_shd, col=grey(0:100/100), legend=FALSE, main='Snor')
plot(las_dsm, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Height [m]', side=4, font=2, line=2.5, cex=1.5))
plot(birds,pch=1,add=TRUE,cex=3,lwd = 3)
plot(line_cr, lwd=3,add=TRUE)
plot(line_cr2, lwd=3,add=TRUE)

dev.off()

dev.copy(png,'myplot_cross.png',width = 1300,height = 1080)

par(mfrow=c(2,1)) 

plot(x = las_cross_hor@data$Y_cross, y = las_cross_hor@data$Z, col = c("green", "orange", "blue","blue","blue","blue","blue","blue","blue","blue")[las_cross_hor@data$Classification], frame = FALSE, xlab = "Disctance[m]", ylab = "Height[m]",pch=19,ylim=c(-5,20),main="Observation point [vertical crossplot]")
abline(v=100,lty=3)
legend("topright",legend=c("Vegetation","Ground","Water"),xpd=TRUE,pch=19,col = c("orange", "green","blue"))

plot(x = las_cross_ver@data$X_cross, y = las_cross_ver@data$Z, col = c("green", "orange", "blue","blue","blue","blue","blue","blue","blue","blue")[las_cross_ver@data$Classification], frame = FALSE, xlab = "Distance[m]", ylab = "Height[m]",pch=19,ylim=c(-5,20),main="Observation point [horizontal crossplot]")
abline(v=100,lty=3)
legend("topright",legend=c("Vegetation","Ground","Water"),xpd=TRUE,pch=19,col = c("orange", "green","blue"))

dev.off()


