"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN3 data and visualize
"
library("lidR")
library("rgdal")
library("sp")

# Set working dirctory
#workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"
workingdirectory="D:/Koma/SelectedWetlands/greatwarbler/"
setwd(workingdirectory)

#Import 

birdfile="greatwarbler.shp"
birds=readOGR(dsn=birdfile)

nl_file="Boundary_NL_RDNew.shp"
nl=readOGR(dsn=nl_file)

birds@data$id <- seq(1,length(birds$X),1)

writeOGR(birds,".","greatwarbler_wid", driver="ESRI Shapefile")

ctg = catalog(workingdirectory)

# Extract pcloud around the bird observation
#length(birds$id)

for (i in seq(1,length(birds$id),1)){ 
  print(birds@data$id[i]) 
  
  subset = lasclipCircle(ctg,birds@data$X[i],birds@data$Y[i],250)
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    
    las_dsm=grid_metrics(subset,max(Z),res=1)
    
    #hillshade
    crs(las_dsm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
    
    slope <- terrain(las_dsm, opt='slope')
    aspect <- terrain(las_dsm, opt='aspect')
    dsm_shd <- hillShade(slope, aspect, 40, 270)
    
    #vertical
    las_cross_hor=lasclipRectangle(subset,birds@data$X[i]-0.5,birds@data$Y[i]-100,birds@data$X[i]+0.5,birds@data$Y[i]+100)
    
    coords = matrix(c(birds@data$X[i]-0.5, birds@data$Y[i]-100,
                      birds@data$X[i]+0.5, birds@data$Y[i]+100), 
                    ncol = 2, byrow = TRUE)
    
    
    P1 = Polygon(coords)
    line_cr = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"))
    
    las_cross_hor@data$Y_cross=las_cross_hor@data$Y-birds@data$Y[i]+100
    
    #horizontal
    las_cross_ver=lasclipRectangle(subset,birds@data$X[i]-100,birds@data$Y[i]-0.5,birds@data$X[i]+100,birds@data$Y[i]+0.5)
    
    coords2 = matrix(c(birds@data$X[i]-100, birds@data$Y[i]-0.5,
                       birds@data$X[i]+100, birds@data$Y[i]+0.5), 
                     ncol = 2, byrow = TRUE)
    
    
    P12 = Polygon(coords2)
    line_cr2 = SpatialPolygons(list(Polygons(list(P12), ID = "a")), proj4string=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"))
    
    las_cross_ver@data$X_cross=las_cross_ver@data$X-birds@data$X[i]+100
    
    #plot
    dev.copy(png,paste(birds@data$species[i],"_",birds@data$id[i],"_",birds@data$kmsquare[i],"above.png",sep=""),width = 1080,height = 1080)
    
    par(mfrow=c(1,1)) 
    
    plot(dsm_shd, col=grey(0:100/100), legend=FALSE, main=birds@data$species[i])
    plot(las_dsm, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Height [m]', side=4, font=2, line=2.5, cex=1.5))
    plot(birds,pch=1,add=TRUE,cex=3,lwd = 3)
    plot(line_cr, lwd=3,add=TRUE)
    plot(line_cr2, lwd=3,add=TRUE)
    
    dev.off()
    
    dev.copy(png,paste(birds@data$species[i],"_",birds@data$id[i],"_",birds@data$kmsquare[i],"cross.png",sep=""),width = 1300,height = 1080)
    
    par(mfrow=c(2,1)) 
    
    plot(x = las_cross_hor@data$Y_cross, y = las_cross_hor@data$Z, col = c("green", "orange", "blue","blue","blue","red","blue","blue","blue","blue")[las_cross_hor@data$Classification], frame = FALSE, xlab = "Disctance[m]", ylab = "Height[m]",pch=19,ylim=c(min(las_cross_hor@data$Z),min(las_cross_hor@data$Z)+30),main="Observation point [vertical crossplot]")
    abline(v=100,lty=3)
    legend("topright",legend=c("Vegetation","Ground","Water","Building"),xpd=TRUE,pch=19,col = c("orange", "green","blue","red"))
    
    plot(x = las_cross_ver@data$X_cross, y = las_cross_ver@data$Z, col = c("green", "orange", "blue","blue","blue","red","blue","blue","blue","blue")[las_cross_ver@data$Classification], frame = FALSE, xlab = "Distance[m]", ylab = "Height[m]",pch=19,ylim=c(min(las_cross_ver@data$Z),min(las_cross_ver@data$Z)+30),main="Observation point [horizontal crossplot]")
    abline(v=100,lty=3)
    legend("topright",legend=c("Vegetation","Ground","Water","Building"),xpd=TRUE,pch=19,col = c("orange", "green","blue","red"))
    
    dev.off()
    
    dev.copy(png,paste(birds@data$species[i],"_",birds@data$id[i],"_",birds@data$kmsquare[i],"map.png",sep=""),width = 1080,height = 1080)
    plot(nl,main="The location of the selected point within NL")
    plot(line_cr, lwd=8,add=TRUE)
    plot(line_cr2, lwd=8,add=TRUE)
    dev.off()
  }
}