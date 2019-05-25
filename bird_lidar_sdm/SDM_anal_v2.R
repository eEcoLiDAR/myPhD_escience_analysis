"
@author: Zsofia Koma, UvA
Aim: SDM
"

library(sdm)
library(rgdal)
library(raster)

library(gridExtra)
library(ggplot2)

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_4/"

snorfile="Snor_bird_data_forSDM.shp"
baardmanfile="Baardman_bird_data_forSDM.shp"

setwd(full_path)

# Import
Snor=readOGR(dsn=snorfile)
bird_snor.df <- as(Snor, "data.frame")

Baardman=readOGR(dsn=baardmanfile)
bird_baardman.df <- as(Baardman, "data.frame")

load("snor_model.RData")
load("baardman_model.RData")

lidarmetrics=stack("lidarmetrics_forSDM.grd")

# Visualize training data
snor_model@data@features$occ_extra <- 0
snor_model@data@features$occ_extra[1:193] <- 1

ggplot(data=snor_model@data@features, aes(x=pulse_pen_ratio_all, y=occ_extra, color=factor(occ_extra)))+ geom_point()

ggplot(snor_model@data@features, aes(x=pulse_pen_ratio_all,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra))) + geom_density()

ggplot(data=snor_model@data@features) + geom_point(aes(x=pulse_pen_ratio_all, y=occ_extra, color=factor(occ_extra))) +
  geom_density(aes(x=pulse_pen_ratio_all,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)))

baardman_model@data@features$occ_extra <- 0
baardman_model@data@features$occ_extra[1:172] <- 1

ggplot(data=baardman_model@data@features, aes(x=pulse_pen_ratio_all, y=occ_extra, color=factor(occ_extra)))+ geom_point()

ggplot(baardman_model@data@features, aes(x=pulse_pen_ratio_all,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra))) + geom_density()

ggplot(data=baardman_model@data@features) + geom_point(aes(x=pulse_pen_ratio_all, y=occ_extra, color=factor(occ_extra))) +
  geom_density(aes(x=pulse_pen_ratio_all,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)))

# Get response curves

response_snor_svm=getResponseCurve(snor_model,id = c(seq(from=201,to=225,by=1)))
response_baardman_svm=getResponseCurve(baardman_model,id = c(seq(from=201,to=225,by=1)))

# pulsepen

response_snor_svm@response$pulse_pen_ratio_all$sd=apply(response_snor_svm@response$pulse_pen_ratio_all[,2:25],1, sd, na.rm = TRUE)
response_snor_svm@response$pulse_pen_ratio_all$mean=apply(response_snor_svm@response$pulse_pen_ratio_all[,2:25],1, mean, na.rm = TRUE)
response_snor_svm@response$pulse_pen_ratio_all$species <- "Savi's Warbler"

response_baardman_svm@response$pulse_pen_ratio_all$sd=apply(response_baardman_svm@response$pulse_pen_ratio_all[,2:25],1, sd, na.rm = TRUE)
response_baardman_svm@response$pulse_pen_ratio_all$mean=apply(response_baardman_svm@response$pulse_pen_ratio_all[,2:25],1, mean, na.rm = TRUE)
response_baardman_svm@response$pulse_pen_ratio_all$species <- "Bearded Reedling"

pulse_pen=rbind(response_snor_svm@response$pulse_pen_ratio_all,response_baardman_svm@response$pulse_pen_ratio_all)

# rough

response_snor_svm@response$roughness.1$sd=apply(response_snor_svm@response$roughness.1[,2:25],1, sd, na.rm = TRUE)
response_snor_svm@response$roughness.1$mean=apply(response_snor_svm@response$roughness.1[,2:25],1, mean, na.rm = TRUE)
response_snor_svm@response$roughness.1$species <- "Savi's Warbler"

response_baardman_svm@response$roughness.1$sd=apply(response_baardman_svm@response$roughness.1[,2:25],1, sd, na.rm = TRUE)
response_baardman_svm@response$roughness.1$mean=apply(response_baardman_svm@response$roughness.1[,2:25],1, mean, na.rm = TRUE)
response_baardman_svm@response$roughness.1$species <- "Bearded Reedling"

roughness=rbind(response_snor_svm@response$roughness.1,response_baardman_svm@response$roughness.1)

# max

response_snor_svm@response$max_z__nonground$sd=apply(response_snor_svm@response$max_z__nonground[,2:25],1, sd, na.rm = TRUE)
response_snor_svm@response$max_z__nonground$mean=apply(response_snor_svm@response$max_z__nonground[,2:25],1, mean, na.rm = TRUE)
response_snor_svm@response$max_z__nonground$species <- "Savi's Warbler"

response_baardman_svm@response$max_z__nonground$sd=apply(response_baardman_svm@response$max_z__nonground[,2:25],1, sd, na.rm = TRUE)
response_baardman_svm@response$max_z__nonground$mean=apply(response_baardman_svm@response$max_z__nonground[,2:25],1, mean, na.rm = TRUE)
response_baardman_svm@response$max_z__nonground$species <- "Bearded Reedling"

max_z__nonground=rbind(response_snor_svm@response$max_z__nonground,response_baardman_svm@response$max_z__nonground)

# plot

p1=ggplot(data=pulse_pen, aes(x=pulse_pen_ratio_all, y=mean,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  geom_ribbon(aes(x=pulse_pen$pulse_pen_ratio_all,ymin=pulse_pen$mean-pulse_pen$sd, ymax=pulse_pen$mean+pulse_pen$sd), linetype=2, alpha=0.1,show.legend = FALSE) +
  xlab("Pulse penetration ratio [%]") + ylab("Response") + theme_bw(base_size = 30) + ylim(0.1, 1)

p2=ggplot(data=roughness, aes(x=roughness.1, y=mean,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) +
  geom_ribbon(aes(x=roughness$roughness.1,ymin=roughness$mean-roughness$sd, ymax=roughness$mean+roughness$sd), linetype=2, alpha=0.1,show.legend = FALSE) +
  xlab("Surface roughness [m]") + ylab("Response") + theme_bw(base_size = 30) + ylim(0.1, 1)

p3=ggplot(data=max_z__nonground, aes(x=max_z__nonground, y=mean,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) +
  geom_ribbon(aes(x=max_z__nonground["max_z__nonground"],ymin=max_z__nonground["mean"]-max_z__nonground["sd"], ymax=max_z__nonground["mean"]+max_z__nonground["sd"]), linetype=2, alpha=0.1,show.legend = FALSE) +
  xlab("Vegetation height [m]") + ylab("Response") + theme_bw(base_size = 30) + ylim(0.1, 1)

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)

# Together with Training data
#pulse
ggplot() + geom_density(data=baardman_model@data@features,aes(x=pulse_pen_ratio_all,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=1.5,show.legend = FALSE,linetype="dashed") +
  geom_line(data=pulse_pen[pulse_pen$species=="Bearded Reedling",], aes(x=pulse_pen_ratio_all, y=mean,color=species),size=3,show.legend = FALSE) + 
  theme_bw(base_size = 30) + xlab("Proxy for vegetation coverage [%]") + ylab("Response") +
  scale_color_manual(values = c("Bearded Reedling"="chocolate4","0"="blue","1"="red"))

ggplot() + geom_density(data=snor_model@data@features,aes(x=pulse_pen_ratio_all,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=1.5,show.legend = FALSE,linetype="dashed") +
  geom_line(data=pulse_pen[pulse_pen$species=="Savi's Warbler",], aes(x=pulse_pen_ratio_all, y=mean,color=species),size=3,show.legend = FALSE) + 
  theme_bw(base_size = 30) + xlab("Proxy for vegetation coverage [%]") + ylab("Response") +
  scale_color_manual(values = c("Savi's Warbler"="tan2","0"="blue","1"="red"))

#rough
ggplot() + geom_density(data=baardman_model@data@features,aes(x=roughness.1,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=1.5,show.legend = FALSE,linetype="dashed") +
  geom_line(data=roughness[roughness$species=="Bearded Reedling",], aes(x=roughness.1, y=mean,color=species),size=3,show.legend = FALSE) + 
  theme_bw(base_size = 30) + xlab("Proxy for vegetation coverage [%]") + ylab("Response") +
  scale_color_manual(values = c("Bearded Reedling"="chocolate4","0"="blue","1"="red"))

ggplot() + geom_density(data=snor_model@data@features,aes(x=roughness.1,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=1.5,show.legend = FALSE,linetype="dashed") +
  geom_line(data=roughness[roughness$species=="Savi's Warbler",], aes(x=roughness.1, y=mean,color=species),size=3,show.legend = FALSE) + 
  theme_bw(base_size = 30) + xlab("Proxy for vegetation coverage [%]") + ylab("Response") +
  scale_color_manual(values = c("Savi's Warbler"="tan2","0"="blue","1"="red"))

#maxh
ggplot() + geom_density(data=baardman_model@data@features,aes(x=max_z__nonground,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=1.5,show.legend = FALSE,linetype="dashed") +
  geom_line(data=max_z__nonground[max_z__nonground$species=="Bearded Reedling",], aes(x=max_z__nonground, y=mean,color=species),size=3,show.legend = FALSE) + 
  theme_bw(base_size = 30) + xlab("Proxy for vegetation coverage [%]") + ylab("Response") +
  scale_color_manual(values = c("Bearded Reedling"="chocolate4","0"="blue","1"="red"))

ggplot() + geom_density(data=snor_model@data@features,aes(x=max_z__nonground,y=..scaled..,group=factor(occ_extra),color=factor(occ_extra)),size=1.5,show.legend = FALSE,linetype="dashed") +
  geom_line(data=max_z__nonground[max_z__nonground$species=="Savi's Warbler",], aes(x=max_z__nonground, y=mean,color=species),size=3,show.legend = FALSE) + 
  theme_bw(base_size = 30) + xlab("Proxy for vegetation coverage [%]") + ylab("Response") +
  scale_color_manual(values = c("Savi's Warbler"="tan2","0"="blue","1"="red"))

# 2D dimensional environmental space plot - niche plot
Baardman_data_forsdm <- sdmData(formula=occurrence~., train=Baardman, predictors=lidarmetrics)
Baardman_model1 <- sdm(occurrence~.,data=Baardman_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=2)
Baardman_ens1 <- ensemble(Baardman_model1, newdata=lidarmetrics, filename="",setting=list(method='weighted',stat='AUC',opt=2))

#niche(x=lidarmetrics,h=Baardman_data_forsdm,n=c("roughness.1","max_z__nonground","occurrence"))

niche(x=lidarmetrics,h=Baardman_ens1,n=c("roughness.1","max_z__nonground"),xlab="Canopy roughness [m]",ylab="Vegetation height [m]",main="Bearded Reedling")
niche(x=lidarmetrics,h=Baardman_ens1,n=c("pulse_pen_ratio_all","max_z__nonground"))
niche(x=lidarmetrics,h=Baardman_ens1,n=c("pulse_pen_ratio_all","roughness.1"))

Snor_data_forsdm <- sdmData(formula=occurrence~., train=Snor, predictors=lidarmetrics)
Snor_model1 <- sdm(occurrence~.,data=Snor_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=2)
Snor_ens1 <- ensemble(Snor_model1, newdata=lidarmetrics, filename="",setting=list(method='weighted',stat='AUC',opt=2))

niche(x=lidarmetrics,h=Snor_data_forsdm,n=c("roughness.1","max_z__nonground","occurrence"))

niche(x=lidarmetrics,h=Snor_ens1,n=c("roughness.1","max_z__nonground"),xlab="Canopy roughness [m]",ylab="Vegetation height [m]",main="Savi's Warbler")
niche(x=lidarmetrics,h=Snor_ens1,n=c("pulse_pen_ratio_all","max_z__nonground"))
niche(x=lidarmetrics,h=Snor_ens1,n=c("pulse_pen_ratio_all","roughness.1"))

#
nraster <- as(np1@nicheRaster, "SpatialPixelsDataFrame")
nraster.df <- as.data.frame(nraster)
head(nraster.df)

ggplot(nraster.df, aes(x=x, y=y)) + geom_tile(aes(fill = niche)) + coord_equal() + scale_colour_gradient2(low="blue",high="red",mid = "white",aesthetics = "fill",midpoint = 0.5)
