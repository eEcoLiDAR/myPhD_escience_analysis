"
@author: Zsofia Koma, UvA
Aim: SDM modelling
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

library(sdm)
library(ggplot2)

# Set working dirctory
#workingdirectory="D:/Koma/Paper2/forSDM/"
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_3/"
setwd(workingdirectory)

rlist=list.files(path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/escience_metrics/", pattern="*_masked.tif$", full.names=TRUE)

lidar=stack(rlist)
names(lidar) <- c("C_amean","H_90perc","VV_20perc","VV_80perc","VV_med","VV_sd","VV_shan","VV_skew")

BReed=readOGR(dsn="BReed_presabs.shp")

# Prep. data for SDM
data_forsdm_BReed <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=BReed, predictors=lidar)
data_forsdm_BReed

model1 <- sdm(occurrence~.,data=data_forsdm_BReed,methods=c('glm','gam','brt','rf','svm','maxent','bioclim'),replication=c('boot'),n=2,test.percent=30)
model1

# Visualize 1D
model1@data@features$occ_extra <- 0
model1@data@features$occ_extra[1:length(model1@data@species$occurrence@presence)] <- 1

response_rf=getResponseCurve(model1,id=7)
response_gam=getResponseCurve(model1,id=3)
response_glm=getResponseCurve(model1,id=1)
response_maxent=getResponseCurve(model1,id=11)
response_bioclim=getResponseCurve(model1,id=13)

# Prediction 

p1 <- predict(model1,newdata=lidar,filename='BReed_rf',method="rf")