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
#full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

birdfile="Snor_presabs_perkmsquare_geommean.csv"
lidarfile="lidarmetrics_wetlands_expanded2.grd"

setwd(full_path)

#Import
lidarmetrics=stack(lidarfile)
lidarmetrics <- dropLayer(lidarmetrics,c("density_absolute_mean_all","point_density"))

bird_data=read.csv(file=birdfile,header=TRUE,sep=",")

bird_obs=bird_data[c("X","Y","occurrence")]
coordinates(bird_obs)=~X+Y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

data_forsdm <- sdmData(formula=occurrence~., train=bird_obs, predictors=lidarmetrics)
data_forsdm

model1 <- sdm(occurrence~.,data=data_forsdm,methods=c('glm','rf','maxent'),replication=c('boot'),n=2)
model1

save(model1,file = "Snor_model1.RData")
load("Snor_model1.RData")

roc(model1)
rcurve(model1,id = 1)
rcurve(model1,id = 3)
rcurve(model1,id = 5)

feaimp_rf=getVarImp(model1,id = 3)
feaimp_maxent=getVarImp(model1,id = 5)

feaimp_rf_ord <- feaimp_rf@varImportance[ order(feaimp_rf@varImportance[,3]), ]
feaimp_maxent_ord <- feaimp_maxent@varImportance[ order(feaimp_maxent@varImportance[,3]), ]

feaimp_rf_ord
feaimp_maxent_ord

p1 <- predict(model1,newdata=lidarmetrics,filename='model3.img')
plot(p1)

writeRaster(p1,"Snor_sdm_predict_2.tif",overwrite=TRUE)
writeRaster(p1[[3]],"Snor_sdm_predict_rf_2.tif",overwrite=TRUE)
writeRaster(p1[[5]],"Snor_sdm_predict_maxent_2.tif",overwrite=TRUE)