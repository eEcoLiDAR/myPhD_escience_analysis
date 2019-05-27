"
@author: Zsofia Koma, UvA
Aim: analyse wetland bird SDMs with ENMtools
"

library(ENMTools)

library(dismo)
library(rgeos)
library(rgdal)

library(ggplot2)

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_4/"

birdfile_baardman="Baardman_bird_data_forSDM.shp"
lidarfile="lidarmetrics_forSDM.grd"

setwd(full_path)

#Import data

lidarmetrics=stack(lidarfile)

bird_baardman <- readOGR(dsn=birdfile_baardman)
bird_baardman.df <- as(bird_baardman, "data.frame")
names(bird_baardman.df) <- c("occurrence","Longitude","Latitude")

# Baardman
# Prepare
baardman <- enmtools.species()

baardman$species.name <- "Panurus biarmicus"
baardman$presence.points <- bird_baardman.df[ which(bird_baardman.df$occurrence==1),2:3]
baardman$background.points <- bird_baardman.df[ which(bird_baardman.df$occurrence==0),2:3]

#Corr
#raster.cor.matrix(lidarmetrics)
raster.cor.plot(lidarmetrics)

#GLM
baardman.glm <- enmtools.glm(species = baardman, env = lidarmetrics, test.prop = 0.3)

baardman.glm$response.plots$pulse_pen_ratio_all
baardman.glm$response.plots$roughness.1
baardman.glm$response.plots$max_z__nonground

visualize.enm(baardman.glm, lidarmetrics, layers = c("roughness.1", "pulse_pen_ratio_all"), plot.test.data = TRUE)

#GLM with selection
baardman.glm <- enmtools.glm(species = baardman, env = lidarmetrics, test.prop = 0.3, f=pres ~ poly(kurto_z_all,2)+poly(skew_z_nonground,2)+poly(pulse_pen_ratio_all,2)+poly(roughness.1,2))

baardman.glm$response.plots

visualize.enm(baardman.glm, lidarmetrics, layers = c("roughness.1", "pulse_pen_ratio_all"), plot.test.data = TRUE)

#Maxent - NA in presneces - cannot handle
baardman.maxent <- enmtools.maxent(species = baardman, env = lidarmetrics, test.prop = 0.2)

baardman.maxent$response.plots$pulse_pen_ratio_all
baardman.maxent$response.plots$roughness.1
baardman.maxent$response.plots$max_z__nonground

visualize.enm(baardman.maxent, lidarmetrics, layers = c("roughness.1", "pulse_pen_ratio_all"), plot.test.data = TRUE)

#RF
baardman.rf <- enmtools.rf(species = baardman, env = lidarmetrics, test.prop = 0.2)

baardman.rf$response.plots$pulse_pen_ratio_all
baardman.rf$response.plots$roughness.1
baardman.rf$response.plots$max_z__nonground

visualize.enm(baardman.rf, lidarmetrics, layers = c("roughness.1", "pulse_pen_ratio_all"), plot.test.data = TRUE)

