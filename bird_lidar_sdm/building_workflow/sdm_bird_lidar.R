"
@author: Zsofia Koma, UvA
Aim: explore sdm modelling for Global Ecology and Biodiversity course
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

library("sdm")
library("corrplot")
library("Hmisc")
library(usdm)

# Set global variables
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
#birdfile="Breeding_bird_atlas_aggregated_data_kmsquaresKleine Karekiet_grouped_presabs_lidar.rds"
birdfile="Breeding_bird_atlas_aggregated_data_kmsquaresRoerdomp_grouped_presabs_lidar.rds"
lidarfile="terrainData100m_run1_filtered_lidarmetrics_lidar_whoutoulier.tif"

setwd(full_path)

# Import LiDAR and bird observations
birdand_lidar=readRDS(file = birdfile)
lidarmetrics=stack(lidarfile)

v <- vifstep(lidarmetrics)
v
lidarmetrics2 <- exclude(lidarmetrics,v)

v <- vifcor(extract(lidarmetrics,bird_obs),th=0.9)



# Correlations in bird-lidar dataset
corr_m <- rcorr(as.matrix(birdand_lidar[,7:20]))

corrplot(corr_m$r, type="upper", order="hclust", 
         p.mat = corr_m$P, sig.level = 0.01, insig = "blank")

# Data prep. for SDM

bird_obs=birdand_lidar[c("x","y","presence")]
coordinates(bird_obs)=~x+y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

data_forsdm <- sdmData(formula=presence~., train=bird_obs, predictors=lidarmetrics2)
data_forsdm
#getmethodNames()
# Modelling
model1 <- sdm(presence~.,data=data_forsdm,methods=c('glm','brt','rf','svm','mars','mlp','glmnet'),replication=c('boot'),n=2)
model1

roc(model1)



# Predict
p1 <- predict(model1,newdata=lidarmetrics,filename='p3m.img')
plot(p1)

e1 <- ensemble(model1,newdata=lidarmetrics,filename='e3m.img',setting=list(method="weighted",stat="AUC"))

#GUI
gui(model1)
rcurve(model1)
