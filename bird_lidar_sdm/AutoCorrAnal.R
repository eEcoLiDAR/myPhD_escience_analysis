"
@author: Zsofia Koma, UvA
Aim: SDM
"

library(sdm)
library(rgdal)
library(raster)

library(gridExtra)
library(ggplot2)

library(dplyr)

library(spdep)
library(sp)

# Set global variables
#full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_4/"
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_4/"

snorfile="Snor_bird_data_forSDM.shp"
baardmanfile="Baardman_bird_data_forSDM.shp"

setwd(full_path)

# Import
Snor=readOGR(dsn=snorfile)
bird_snor.df <- as(Snor, "data.frame")

Baardman=readOGR(dsn=baardmanfile)
bird_baardman.df <- as(Baardman, "data.frame")

lidarmetrics=stack("lidarmetrics_forSDM.grd")

# Build GLM
Baardman_data_forsdm <- sdmData(formula=occurrence~.+coords(coords.x1+coords.x2), train=Baardman, predictors=lidarmetrics)
Baardman_model1 <- sdm(occurrence~.,data=Baardman_data_forsdm,methods=c('glm'),replication=c('boot'),n=2)

summary(Baardman_model1@models[["occurrence"]][["glm"]][["1"]]@object)
plot(Baardman_model1@models[["occurrence"]][["glm"]][["1"]]@object)

# Correlogram - get xy back ... not easy
res <- data.frame(Residuals = Baardman_model1@models[["occurrence"]][["glm"]][["1"]]@object$residuals)

# From skretch
data=data.frame(Baardman_data_forsdm@info@coords)
data2=Baardman_data_forsdm@features

dataset=cbind(data,data2)

dataset$occ <- 0
dataset$occ[1:172] <-1

f1 <- occ ~ kurto_z_all + pulse_pen_ratio_all + max_z__nonground + roughness.1
m1 <- glm(f1, data = dataset)
summary(m1)
plot(m1)

res <- m1$residuals
res <- data.frame(Residuals = res, x = dataset$coords.x1, y = dataset$coords.x2)

dat <- SpatialPointsDataFrame(cbind(dataset$coords.x1, dataset$coords.x2), dataset)
lstw  <- nb2listw(knn2nb(knearneigh(dat, k = 10)))

morantest=moran.test(residuals.glm(m1), lstw) 
moran.plot(residuals.glm(m1), lstw)
