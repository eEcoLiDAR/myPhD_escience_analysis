"
@author: Zsofia Koma, UvA
Aim: Helping unctions for organizing bird observation data
"

CreateShape = function(data) {
  
  library(sp)
  
  data$X_obs=data$x
  data$Y_obs=data$y
  
  shp=data
  coordinates(shp)=~X_obs+Y_obs
  proj4string(shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
  
  return(shp)
  
}

Create_reqahn3 = function(ahn3,data) {
  
  library(dplyr)
  
  intersected=raster::intersect(ahn3,data)
  intersected_df=intersected@data
  
  req_ahn3 <- intersected_df %>%
    group_by(bladnr) %>%
    summarise(nofobs = length(bladnr))
  
  req_ahn3$bladnr_up=toupper(req_ahn3$bladnr)
  
  req_ahn3$list=paste("https://geodata.nationaalgeoregister.nl/ahn3/extract/ahn3_laz/C_",req_ahn3$bladnr_up,".LAZ",sep="")
  
  return(req_ahn3)
  
}

ConvertPolytoDf = function(kmsquares_poly) {
  
  library(plyr)
  library(dplyr)
  library(ggplot2)
  
  kmsquares_poly@data$id = rownames(kmsquares_poly@data)
  kmsquares_poly.points = fortify(kmsquares_poly, region="id")
  kmsquares_poly.df = join(kmsquares_poly.points, kmsquares_poly@data, by="id")
  
  as.numeric(kmsquares_poly.df$KMHOK)
  colnames(kmsquares_poly.df)[colnames(kmsquares_poly.df)=="KMHOK"] <- "kmsquare"
  kmsquares_poly.df=ddply(kmsquares_poly.df,~kmsquare+X+Y,summarise,sum=length(kmsquare))
  
  return(kmsquares_poly.df)
}