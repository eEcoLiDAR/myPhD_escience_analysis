install.packages("devtools")
install.packages("ecospat")
library(devtools)
install_github("danlwarren/ENMTools",ref="develop")

library(ENMTools)

library(dismo)
library(rgeos)
library(rgbif)

# Download required datasets (worldclim, records from gbif)

ibm <- occ_search(scientificName = "Iberolacerta monticola",limit=1500)

ibm$data

ibm <- subset(ibm$data,select=c('species','decimalLatitude','decimalLongitude'))

head(ibm)

ibm <- as.data.frame(ibm)

ibm <- ibm[complete.cases(ibm),]
colnames(ibm) <- c("species","lat","long")


all.worldclim <- raster::getData("worldclim",res=10,var="bio")

spain.worldclim <- crop(all.worldclim,extent(-10,4,35,45))
x11()
plot(spain.worldclim[[1]])
points(ibm[,c("long","lat")],pch=16)

ibm.bc <- bioclim(spain.worldclim,ibm[,c("long","lat")]) 
plot(ibm.bc)

# Set up presence-absence

monticola <- enmtools.species()
monticola

monticola$species.name <- "Monticola"
monticola$presence.points <- ibm
monticola <- check.species(monticola)

interactive.plot.enmtools.species(monticola)

monticola$range <- background.raster.buffer(monticola$presence.points,50000,mask=spain.worldclim)

# Build SDM

monticola.bc <- enmtools.bc(monticola,env=spain.worldclim)
plot(monticola.bc)

monticola.gam <- enmtools.gam(monticola,env=spain.worldclim)
plot(monticola.gam)

monticola.dm <- enmtools.dm(monticola,env=spain.worldclim)
plot(monticola.dm)

#Niche plot
visualize.enm(model=monticola.bc,env=spain.worldclim,layers=c("bio1","bio2"))
visualize.enm(model=monticola.dm,env=spain.worldclim,layers=c("bio1","bio2"))

# Evaulation + response
monticola.dm$training.evaluation
monticola.dm$response.plots

monticola.dm <- enmtools.dm(monticola,env=spain.worldclim,test.prop = 0.3)
monticola.dm$test.evaluation

monticola.dm

#GLM
monticola.glm <- enmtools.glm(monticola,env=spain.worldclim,test.prop = 0.3, f= pres ~ bio3 + bio8 + bio11)
monticola.glm$test.evaluation

visualize.enm(monticola.glm,env=spain.worldclim,layers=c("bio3","bio8"))
monticola.glm$response.plots

#GAM

monticola.gam <- enmtools.gam(monticola,env=spain.worldclim,test.prop = 0.3,f=pres ~ s(bio3) + s(bio8) +bio11)
monticola.gam
visualize.enm(monticola.gam,env=spain.worldclim,layers=c("bio3","bio8"))

monticola.ppm <- enmtools.ppmlasso(monticola,env=spain.worldclim,test.prop = 0.3,f=pres ~ poly(bio3,2)+poly(bio8,2)+poly(bio11,2))
monticola.ppm

#RF
monticola.rf <- enmtools.rf(monticola,env=spain.worldclim,test.prop=0.3)
monticola.rf$test.evaluation
monticola.rf$response.plots

# autocorrelation
rando <- monticola
rando$presence.points <- sampleRandom(spain.worldclim[[1]],size=100,xy=TRUE)
rando$range <- background.raster.buffer(rando$presence.points,radius=5000,mask=spain.worldclim)
rando <- check.species(rando)

#get maxent work

#Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211/")
Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211/")
library(rJava)

monticola.mx <- enmtools.maxent(monticola,env=spain.worldclim,test.prop = 0.3)
plot(monticola.mx)
