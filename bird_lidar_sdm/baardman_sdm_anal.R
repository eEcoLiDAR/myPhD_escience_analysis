"
@author: Zsofia Koma, UvA
Aim: SDM
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("gridExtra")

library("ggplot2")
library("sdm")
library("usdm")

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_3/"

birdfile="Baardman_indpres_kmsquareabs_joined.csv"
lidarfile="lidarmetrics_wetlands_expanded2.grd"

setwd(full_path)

#LiDAR
lidarmetrics=stack(lidarfile)
lidarmetrics <- dropLayer(lidarmetrics,c("density_absolute_mean_all","point_density"))

v <- vifstep(lidarmetrics,th=2)
v
lidarmetrics2 <- exclude(lidarmetrics,v)

polygon_100mcell <- rasterToPolygons(lidarmetrics[[1]])
polygon_100mcell@data$lidarmetrics_100m_ID=seq(from=1,to=nrow(polygon_100mcell@data),by=1)

#Bird
bird_data=read.csv(file=birdfile,header=TRUE,sep=",")

bird_data$x_observation=bird_data$X
bird_data$y_observation=bird_data$Y

bird_data_shp=bird_data[c("X","Y","x_observation","y_observation","species","occurrence")]
coordinates(bird_data_shp)=~x_observation+y_observation
proj4string(bird_data_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

intersect_poly_birdobs = point.in.poly(bird_data_shp, polygon_100mcell)

bird_data_intersect=intersect_poly_birdobs@data

bird_data_presabs=bird_data_intersect[complete.cases(bird_data_intersect), ]

#Check Pres-Absence ratio

print(paste("Absence:",nrow(bird_data_presabs[ which(bird_data_presabs$occurrence==0),]),sep=" "))
print(paste("Presence:",nrow(bird_data_presabs[ which(bird_data_presabs$occurrence==1),]),sep=" "))

pres=bird_data_presabs[ which(bird_data_presabs$occurrence==1),]
abs=bird_data_presabs[ which(bird_data_presabs$occurrence==0),]

nofpres=nrow(bird_data_presabs[ which(bird_data_presabs$occurrence==1),])

abs_sampled=abs[sample(nrow(abs), nofpres), ]

presabs_bird <- rbind(pres, abs_sampled) 

bird_obs=presabs_bird[c("X","Y","occurrence")]
coordinates(bird_obs)=~X+Y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

data_forsdm <- sdmData(formula=occurrence~., train=bird_obs, predictors=lidarmetrics2)
data_forsdm

model1 <- sdm(occurrence~.,data=data_forsdm,methods=c('glm','gam','brt','rf','svm','mars','mlp','glmnet'),replication=c('boot'),n=2)
model1

rcurve(model1,id = 1)
rcurve(model1,id = 3)
rcurve(model1,id = 5)
rcurve(model1,id = 7)
rcurve(model1,id = 9)
rcurve(model1,id = 11)
rcurve(model1,id = 13)
rcurve(model1,id = 15)

roc(model1)

p1 <- predict(model1,newdata=lidarmetrics2,filename='')
plot(p1)

writeRaster(p1,"Baardman_sdm_predict2.tif",overwrite=TRUE)

ens1 <- ensemble(model1, newdata=lidarmetrics2, filename="",setting=list(method='weighted',stat='AUC',opt=2))
writeRaster(ens1,"Baardman_ensemble_auc.tif",overwrite=TRUE)