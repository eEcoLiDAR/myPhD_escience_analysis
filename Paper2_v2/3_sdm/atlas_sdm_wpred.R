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
workingdirectory="D:/Koma/metrics_wlgn7filter/"
setwd(workingdirectory)

rlist=list.files(path="D:/Koma/metrics_wlgn7filter/", pattern="*_masked.tif$", full.names=TRUE)

lidar=stack(rlist)
names(lidar) <- c("C_amean","H_90perc","VV_20perc","VV_80perc","VV_med","VV_sd","VV_shan","VV_skew")

BReed=readOGR(dsn="BReed_presabs.shp")

# Prep. data for SDM
data_forsdm_BReed <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=BReed, predictors=lidar)
data_forsdm_BReed

# Modelling

model1 <- sdm(occurrence~.,data=data_forsdm_BReed,methods=c('rf'),replication=c('boot'),n=1,test.percent=30)
model1

# Prediction

ext=extent(190764,210747,511441,530924)
lidar_sel=crop(lidar,ext)

p1 <- predict(model1,newdata=lidar_sel,filename='',method="rf",nc=18)