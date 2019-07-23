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
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_3/"
setwd(workingdirectory)

rlist=list.files(path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/lidar/escience_metrics/", pattern="*_masked.tif$", full.names=TRUE)

lidar=stack(rlist)
names(lidar) <- c("C_amean","H_90perc","VV_20perc","VV_80perc","VV_med","VV_sd","VV_shan","VV_skew")

ext=extent(190764,210747,511441,530924)
lidar_sel=crop(lidar,ext)

## BReed
BReed=readOGR(dsn="BReed_presabs.shp")

# Prep. data for SDM
data_forsdm_BReed <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=BReed, predictors=lidar)
data_forsdm_BReed

# Modelling

BReed_rf <- sdm(occurrence~.,data=data_forsdm_BReed,methods=c('rf'),replication=c('boot'),n=1,test.percent=30)
BReed_rf

# Prediction

BReed_rf_pred <- predict(BReed_rf,newdata=lidar_sel,filename='BReed_rf',method="rf")

# Niche plot
niche(x=lidar_sel,h=BReed_rf_pred,n=c("H_90perc","VV_sd"))

## GreedW
GreedW=readOGR(dsn="GreedW_presabs.shp")

# Prep. data for SDM
data_forsdm_GreedW <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=GreedW, predictors=lidar)
data_forsdm_GreedW

# Modelling

GreedW_rf <- sdm(occurrence~.,data=data_forsdm_GreedW,methods=c('rf'),replication=c('boot'),n=1,test.percent=30)
GreedW_rf

# Prediction

GreedW_rf_pred <- predict(GreedW_rf,newdata=lidar_sel,filename='GreedW_rf',method="rf")

# Niche plot
niche(x=lidar_sel,h=GreedW_rf_pred,n=c("H_90perc","VV_sd"))

## SaviW
SaviW=readOGR(dsn="SaviW_presabs.shp")

# Prep. data for SDM
data_forsdm_SaviW <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=SaviW, predictors=lidar)
data_forsdm_SaviW

# Modelling

SaviW_rf <- sdm(occurrence~.,data=data_forsdm_SaviW,methods=c('rf'),replication=c('boot'),n=1,test.percent=30)
SaviW_rf

# Prediction

SaviW_rf_pred <- predict(SaviW_rf,newdata=lidar_sel,filename='SaviW_rf',method="rf")

# Niche plot
niche(x=lidar_sel,h=SaviW_rf_pred,n=c("H_90perc","VV_sd"))

## ReedW
ReedW=readOGR(dsn="ReedW_presabs.shp")

# Prep. data for SDM
data_forsdm_ReedW <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=ReedW, predictors=lidar)
data_forsdm_ReedW

# Modelling

ReedW_rf <- sdm(occurrence~.,data=data_forsdm_ReedW,methods=c('rf'),replication=c('boot'),n=1,test.percent=30)
ReedW_rf

# Prediction

ReedW_rf_pred <- predict(ReedW_rf,newdata=lidar_sel,filename='ReedW_rf',method="rf")

# Niche plot
niche(x=lidar_sel,h=ReedW_rf_pred,n=c("H_90perc","VV_sd"))

## SedgeW
SedgeW=readOGR(dsn="SedgeW_presabs.shp")

# Prep. data for SDM
data_forsdm_SedgeW <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=SedgeW, predictors=lidar)
data_forsdm_SedgeW

# Modelling

SedgeW_rf <- sdm(occurrence~.,data=data_forsdm_SedgeW,methods=c('rf'),replication=c('boot'),n=1,test.percent=30)
SedgeW_rf

# Prediction

SedgeW_rf_pred <- predict(SedgeW_rf,newdata=lidar_sel,filename='SedgeW_rf',method="rf")

# Niche plot
niche(x=lidar_sel,h=SedgeW_rf_pred,n=c("H_90perc","VV_sd"))

## Niche plot 2D
BReed_niche=niche(x=lidar_sel,h=BReed_rf_pred,n=c("H_90perc","VV_sd"),plot=FALSE)
BReed_niche_raster <- as(BReed_niche@nicheRaster, "SpatialPixelsDataFrame")
BReed_niche_raster.df <- as.data.frame(BReed_niche_raster)

GreedW_niche=niche(x=lidar_sel,h=GreedW_rf_pred,n=c("H_90perc","VV_sd"),plot=FALSE)
GreedW_niche_raster <- as(GreedW_niche@nicheRaster, "SpatialPixelsDataFrame")
GreedW_niche_raster.df <- as.data.frame(GreedW_niche_raster)

SaviW_niche=niche(x=lidar_sel,h=SaviW_rf_pred,n=c("H_90perc","VV_sd"),plot=FALSE)
SaviW_niche_raster <- as(SaviW_niche@nicheRaster, "SpatialPixelsDataFrame")
SaviW_niche_raster.df <- as.data.frame(SaviW_niche_raster)

ReedW_niche=niche(x=lidar_sel,h=ReedW_rf_pred,n=c("H_90perc","VV_sd"),plot=FALSE)
ReedW_niche_raster <- as(ReedW_niche@nicheRaster, "SpatialPixelsDataFrame")
ReedW_niche_raster.df <- as.data.frame(ReedW_niche_raster)

SedgeW_niche=niche(x=lidar_sel,h=SedgeW_rf_pred,n=c("H_90perc","VV_sd"),plot=FALSE)
SedgeW_niche_raster <- as(SedgeW_niche@nicheRaster, "SpatialPixelsDataFrame")
SedgeW_niche_raster.df <- as.data.frame(SedgeW_niche_raster)

p1=ggplot(BReed_niche_raster.df, aes(x=x, y=y)) + geom_tile(aes(fill = niche),show.legend=TRUE) + coord_equal() + 
  scale_colour_gradient2(name="Suitability",low="blue",high="red",mid = "white",aesthetics = "fill",midpoint = 0.5,limits=c(0,1)) +
  theme_bw(base_size = 20) + xlab("H_90p [m]") + ylab("VV_sd [m]")+ggtitle("Bearded reedling")+
  scale_x_continuous(labels =c(0,25.3*0.25,25.3*0.5,25.3*0.75,25.3)) + scale_y_continuous(labels =c(0,59.1*0.25,59.1*0.5,59.1*0.75,59.1))

p2=ggplot(GreedW_niche_raster.df, aes(x=x, y=y)) + geom_tile(aes(fill = niche),show.legend=TRUE) + coord_equal() + 
  scale_colour_gradient2(name="Suitability",low="blue",high="red",mid = "white",aesthetics = "fill",midpoint = 0.5,limits=c(0,1)) +
  theme_bw(base_size = 20) + xlab("H_90p [m]") + ylab("VV_sd [m]")+ ggtitle("Great Reed Warbler")+
  scale_x_continuous(labels =c(0,25.3*0.25,25.3*0.5,25.3*0.75,25.3)) + scale_y_continuous(labels =c(0,59.1*0.25,59.1*0.5,59.1*0.75,59.1))

p3=ggplot(SaviW_niche_raster.df, aes(x=x, y=y)) + geom_tile(aes(fill = niche),show.legend=TRUE) + coord_equal() + 
  scale_colour_gradient2(name="Suitability",low="blue",high="red",mid = "white",aesthetics = "fill",midpoint = 0.5,limits=c(0,1)) +
  theme_bw(base_size = 20) + xlab("H_90p [m]") + ylab("VV_sd [m]")+ ggtitle("Savi's Warbler")+
  scale_x_continuous(labels =c(0,25.3*0.25,25.3*0.5,25.3*0.75,25.3)) + scale_y_continuous(labels =c(0,59.1*0.25,59.1*0.5,59.1*0.75,59.1))

p4=ggplot(ReedW_niche_raster.df, aes(x=x, y=y)) + geom_tile(aes(fill = niche),show.legend=TRUE) + coord_equal() + 
  scale_colour_gradient2(name="Suitability",low="blue",high="red",mid = "white",aesthetics = "fill",midpoint = 0.5,limits=c(0,1)) +
  theme_bw(base_size = 20) + xlab("H_90p [m]") + ylab("VV_sd [m]")+ ggtitle("Reed Warbler")+
  scale_x_continuous(labels =c(0,25.3*0.25,25.3*0.5,25.3*0.75,25.3)) + scale_y_continuous(labels =c(0,59.1*0.25,59.1*0.5,59.1*0.75,59.1))

p5=ggplot(SedgeW_niche_raster.df, aes(x=x, y=y)) + geom_tile(aes(fill = niche),show.legend=TRUE) + coord_equal() + 
  scale_colour_gradient2(name="Suitability",low="blue",high="red",mid = "white",aesthetics = "fill",midpoint = 0.5,limits=c(0,1)) +
  theme_bw(base_size = 20) + xlab("H_90p [m]") + ylab("VV_sd [m]")+ ggtitle("Sedge Warbler")+ 
  scale_x_continuous(labels =c(0,25.3*0.25,25.3*0.5,25.3*0.75,25.3)) + scale_y_continuous(labels =c(0,59.1*0.25,59.1*0.5,59.1*0.75,59.1))

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  ncol=3,
  nrow=2,
  layout_matrix=rbind(c(1,2,3),c(4,5,NA))
)