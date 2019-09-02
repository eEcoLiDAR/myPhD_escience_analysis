install.packages("sf")
install.packages("stars")
install.packages("gstat")
install.packages("units")
install.packages("tidyverse")
install.packages("xts")
install.packages("viridis")
install.packages("abind")

library(tidyverse)
library(sf)

#Ex1
nc = read_sf(system.file("gpkg/nc.gpkg", package="sf")) 

rowan=nc[ which(nc$NAME=='Rowan'),]
nonrowan=nc[ which(nc$NAME!='Rowan'),]

i = st_intersection(nonrowan, rowan) #it will be a matrix (0,1) -- able to handle huge datasets

methods(class = "sgbp")

#Ex2

library(stars)

tif = system.file("tif/L7_ETMs.tif", package = "stars")
x = read_stars(tif)
plot(x)

plot(x,rgb=c(3,2,1))
plot(x,rgb = c(4,3,2))

x6 = split(x, "band")
plot(x6)

x6$mean=(x6$X1+x6$X2+x6$X3+x6$X4+x6$X5+x6$X6)/6
plot(x6$mean)

mean_l = function(x) (mean(x))
mean_landsat = st_apply(x, c("x", "y"), mean_l)
