"
@author: Zsofia Koma, UvA
Aim: small mini-workshop ENMtools + sdm
"

library(ENMTools)

library(dismo)
library(rgeos)
library(rgdal)

library(ggplot2)

library(usdm)
library(sdm)

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_4/"
#full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_4/"

birdfile_baardman="Baardman_bird_data_forSDM.shp"
lidarfile="lidarmetrics_forSDM.grd"

setwd(full_path)

#Import data

lidarmetrics=stack(lidarfile)

bird_baardman <- readOGR(dsn=birdfile_baardman)

latlong_proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
bird_baardman_wgs84 <- spTransform(bird_baardman, latlong_proj)

bird_baardman_wgs84.df <- as(bird_baardman_wgs84, "data.frame")
names(bird_baardman_wgs84.df ) <- c("occurrence","Longitude","Latitude")

crs(lidarmetrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
lidarmetrics_wgs84 <-projectRaster(from = lidarmetrics, crs=crs("+proj=longlat +ellps=WGS84 +datum=WGS84"))

# Correlation analysis
#raster.cor.matrix(lidarmetrics)
raster.cor.plot(lidarmetrics)

v <- vifstep(lidarmetrics,th=10)
v
lidarmetrics2 <- exclude(lidarmetrics,v)

# SDM with ENMtools

baardman_onlypres <- enmtools.species()
baardman_onlypres

baardman_onlypres$species.name <- "Panurus biarmicus"
baardman_onlypres$presence.points <- bird_baardman_wgs84.df[ which(bird_baardman_wgs84.df$occurrence==1),2:3]

interactive.plot.enmtools.species(baardman_onlypres)

baardman_onlypres$range <- background.raster.buffer(baardman_onlypres$presence.points,5000,mask=lidarmetrics_wgs84)
baardman.glm <- enmtools.glm(species = baardman_onlypres, env = lidarmetrics_wgs84, test.prop = 0.3)
visualize.enm(baardman.glm, lidarmetrics_wgs84, layers = c("roughness.1", "pulse_pen_ratio_all"), plot.test.data = TRUE)

baardman.glm$test.evaluation

# Prepare SDM with true pres-abs
baardman <- enmtools.species()

baardman$species.name <- "Panurus biarmicus"
baardman$presence.points <- bird_baardman.df[ which(bird_baardman.df$occurrence==1),2:3]
baardman$background.points <- bird_baardman.df[ which(bird_baardman.df$occurrence==0),2:3]

baardman.glm <- enmtools.glm(species = baardman, env = lidarmetrics, test.prop = 0.3,rts.reps=5)

baardman.glm$response.plots$pulse_pen_ratio_all
baardman.glm$response.plots$roughness.1
baardman.glm$response.plots$max_z__nonground

visualize.enm(baardman.glm, lidarmetrics, layers = c("roughness.1", "pulse_pen_ratio_all"), plot.test.data = TRUE)

#Hypho testing
#Breath
raster.breadth(baardman.glm)