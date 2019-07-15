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
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
#workingdirectory="C:/Koma/Paper2/Paper2_PreProcess/"
setwd(workingdirectory)

lidar=stack("D:/Koma/Paper2/lidar_merged_sovonwetland_10m.tif")
names(lidar) <- c("H_90perc","VV_sd","VV_skew","VV_shan","VV_20perc","VV_med","VV_80perc","C_amean")

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

model1 <- sdm(occurrence~.,data=data_forsdm_BReed,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=2,test.percent=30)
model1

# Visualize 1D
model1@data@features$occ_extra <- 0
model1@data@features$occ_extra[1:length(model1@data@species$occurrence@presence)] <- 1

response_rf=getResponseCurve(model1,id=7)
response_gam=getResponseCurve(model1,id=3)
response_glm=getResponseCurve(model1,id=1)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_sd, aes(x=VV_sd, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_sd, aes(x=VV_sd, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_sd, aes(x=VV_sd, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)

