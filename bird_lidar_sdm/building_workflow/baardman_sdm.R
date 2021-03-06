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

birdfile="Baardman_bird_presabs_lidar.csv"
lidarfile="lidarmetrics_wetlands_expanded2.grd"

setwd(full_path)

#Import
lidarmetrics=stack(lidarfile)
lidarmetrics <- dropLayer(lidarmetrics,c("density_absolute_mean_all","point_density"))

bird_data=read.csv(file=birdfile,header=TRUE,sep=",")

print(paste("Absence:",nrow(bird_data[ which(bird_data$occurrence==0),]),sep=" "))
print(paste("Presence:",nrow(bird_data[ which(bird_data$occurrence==1),]),sep=" "))

pres=bird_data[ which(bird_data$occurrence==1),]
abs=bird_data[ which(bird_data$occurrence==0),]

nofpres=nrow(bird_data[ which(bird_data$occurrence==1),])

abs_sampled=abs[sample(nrow(abs), nofpres), ]

presabs_bird <- rbind(pres, abs_sampled) 

bird_obs=presabs_bird[c("X","Y","occurrence")]
coordinates(bird_obs)=~X+Y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

data_forsdm <- sdmData(formula=occurrence~., train=bird_obs, predictors=lidarmetrics)
data_forsdm

model1 <- sdm(occurrence~.,data=data_forsdm,methods=c('glm','rf','maxent'),replication=c('boot'),n=2)
model1

p1 <- predict(model1,newdata=lidarmetrics,filename='')
plot(p1)

writeRaster(p1,"Baardman_sdm_predict_2.tif",overwrite=TRUE)
writeRaster(p1[[3]],"Baardman_sdm_predict_rf_2.tif",overwrite=TRUE)
writeRaster(p1[[5]],"Baardman_sdm_predict_maxent_2.tif",overwrite=TRUE)

save(model1,file = "Baardman_model1.RData")
load("Baardman_model1.RData")

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

response_rf=getResponseCurve(model1,id = 3)

ggplot(data=response_rf@response$perc_10_nonground, aes(x=perc_10_nonground, y=`rf_ID-3`)) +
  geom_line()+
  geom_point()

ggplot(data=response_rf@response$perc_90_nonground, aes(x=perc_90_nonground, y=`rf_ID-3`)) +
  geom_line()+
  geom_point()