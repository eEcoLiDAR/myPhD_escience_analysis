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

# Response plots
p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_sd, aes(x=VV_sd, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_sd, aes(x=VV_sd, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_sd, aes(x=VV_sd, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$VV_sd, aes(x=VV_sd, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_sd, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$VV_sd, aes(x=VV_sd, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_sd,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_sd [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_skew, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_skew, aes(x=VV_skew, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_skew,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_skew [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_skew, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_skew, aes(x=VV_skew, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_skew,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_skew [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_skew, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_skew, aes(x=VV_skew, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_skew,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_skew [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_skew, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$VV_skew, aes(x=VV_skew, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_skew,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_skew [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_skew, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$VV_skew, aes(x=VV_skew, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_skew,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_skew [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_shan, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_shan, aes(x=VV_shan, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_shan,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_shan [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_shan, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_shan, aes(x=VV_shan, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_shan,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_shan [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_shan, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_shan, aes(x=VV_shan, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_shan,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_shan [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_shan, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$VV_shan, aes(x=VV_shan, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_shan,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_shan [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_shan, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$VV_shan, aes(x=VV_shan, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_shan,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_shan [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_20perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_20perc, aes(x=VV_20perc, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_20perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_20perc [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_20perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_20perc, aes(x=VV_20perc, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_20perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_20perc [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_20perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_20perc, aes(x=VV_20perc, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_20perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_20perc [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_20perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$VV_20perc, aes(x=VV_20perc, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_20perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_20perc [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_20perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$VV_20perc, aes(x=VV_20perc, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_20perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_20perc [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_med, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_med, aes(x=VV_med, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_med,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_med [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_med, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_med, aes(x=VV_med, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_med,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_med [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_med, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_med, aes(x=VV_med, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_med,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_med [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_med, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$VV_med, aes(x=VV_med, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_med,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_med [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_med, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$VV_med, aes(x=VV_med, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_med,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_med [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_80perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$VV_80perc, aes(x=VV_80perc, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_80perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_80perc [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_80perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$VV_80perc, aes(x=VV_80perc, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_80perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_80perc [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_80perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$VV_80perc, aes(x=VV_80perc, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_80perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_80perc [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_80perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$VV_80perc, aes(x=VV_80perc, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_80perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_80perc [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=VV_80perc, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$VV_80perc, aes(x=VV_80perc, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=VV_80perc,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("VV_80perc [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

p1=ggplot()+ geom_point(data=model1@data@features, aes(x=C_amean, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_rf@response$C_amean, aes(x=C_amean, y=`rf_ID-7`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=C_amean,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("C_amean [m]") + ylab("Occurrence")
p2=ggplot()+ geom_point(data=model1@data@features, aes(x=C_amean, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_gam@response$C_amean, aes(x=C_amean, y=`gam_ID-3`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=C_amean,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("C_amean [m]") + ylab("Occurrence")
p3=ggplot()+ geom_point(data=model1@data@features, aes(x=C_amean, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_glm@response$C_amean, aes(x=C_amean, y=`glm_ID-1`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=C_amean,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("C_amean [m]") + ylab("Occurrence")
p4=ggplot()+ geom_point(data=model1@data@features, aes(x=C_amean, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_maxent@response$C_amean, aes(x=C_amean, y=`maxent_ID-11`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=C_amean,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("C_amean [m]") + ylab("Occurrence")
p5=ggplot()+ geom_point(data=model1@data@features, aes(x=C_amean, y=occ_extra, color=factor(occ_extra)),show.legend = FALSE) + geom_line(data=response_bioclim@response$C_amean, aes(x=C_amean, y=`bioclim_ID-13`),size=1.5,show.legend = FALSE)+
  geom_density(data=model1@data@features,aes(x=C_amean,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=0.5,show.legend = FALSE,linetype="dashed")+
  theme_bw(base_size = 20) + xlab("C_amean [m]") + ylab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  nrow = 1
)

#Boxplot pres-abs
p1=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=VV_sd, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("VV_sd [m]") + xlab("Occurrence")
p2=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=VV_skew, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("VV_skew [m]") + xlab("Occurrence")
p3=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=VV_shan, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("VV_shan [m]") + xlab("Occurrence")
p4=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=VV_20perc, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("VV_20perc [m]") + xlab("Occurrence")
p5=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=VV_med, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("VV_med [m]") + xlab("Occurrence")
p6=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=VV_80perc, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("VV_80perc [m]") + xlab("Occurrence")
p7=ggplot()+geom_boxplot(data=model1@data@features, aes(x=occ_extra, y=C_amean, color=factor(occ_extra)),show.legend = FALSE)+theme_bw(base_size = 20) + ylab("C_amean [m]") + xlab("Occurrence")

grid.arrange(
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
  p7,
  ncol=4,
  nrow=2,
  layout_matrix=rbind(c(1,2,3,4),c(5,6,7,NA))
)