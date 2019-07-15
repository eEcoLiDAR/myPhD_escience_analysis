"
@author: Zsofia Koma, UvA
Aim: prepare data for SDM modelling - intersection
"
library(gdalUtils)
library(rgdal)
library(raster)
library(dplyr)

library(sdm)

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
#workingdirectory="C:/Koma/Paper2/Paper2_PreProcess/"
setwd(workingdirectory)

lidar=stack("D:/Koma/Paper2/lidar_merged_sovonwetland_10m.tif")
names(lidar) <- c("H_90perc","VV_sd","VV_skew","VV_shan","VV_20perc","VV_med","VV_80perc","C_amean")

# Presence only

birdsp="BReed"

pres=readOGR(dsn=paste("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/Processed/presonly/lidar_time_filter/",birdsp,"_avi_wacq.shp",sep=""))

pres_forsdm=pres[,c(6,7,23)]
names(pres_forsdm) <- c("x","y","occurrence")

data_forsdm_pres <- sdmData(formula=occurrence~H_90perc+VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=pres_forsdm, predictors=lidar)
data_forsdm_pres

# Atlas

pres=readOGR(dsn="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/Processed/presabs/sovon_wetland_filter/birds_swet_presatl.shp")
abs=readOGR(dsn="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/_Input_Datasets/bird_data/Processed/presabs/sovon_wetland_filter/birds_swet_absatl.shp")

abs_forsdm=abs[,c(14,12)]
names(abs_forsdm) <- c("occurrence","species")
pres_forsdm=pres[,c(17,3)]
names(pres_forsdm) <- c("occurrence","species")

presabs <- bind(pres_forsdm, abs_forsdm)

BReed_presabs=presabs[presabs@data$species=="Baardman",]
GreedW_presabs=presabs[presabs@data$species=="Grote Karekiet",]
ReedW_presabs=presabs[presabs@data$species=="Kleine Karekiet",]
SedgeW_presabs=presabs[presabs@data$species=="Rietzanger",]
SaviW_presabs=presabs[presabs@data$species=="Snor",]

# Prep. data for SDM
data_forsdm_BReed <- sdmData(formula=occurrence~VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=BReed_presabs, predictors=lidar)
data_forsdm_BReed

data_forsdm_GreedW <- sdmData(formula=occurrence~VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=GreedW_presabs, predictors=lidar)
data_forsdm_GreedW

data_forsdm_ReedW <- sdmData(formula=occurrence~VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=ReedW_presabs, predictors=lidar)
data_forsdm_ReedW

data_forsdm_SedgeW <- sdmData(formula=occurrence~VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=SedgeW_presabs, predictors=lidar)
data_forsdm_SedgeW

data_forsdm_SaviW <- sdmData(formula=occurrence~VV_sd+VV_skew+VV_shan+VV_20perc+VV_med+VV_80perc+C_amean, train=SaviW_presabs, predictors=lidar)
data_forsdm_SaviW


