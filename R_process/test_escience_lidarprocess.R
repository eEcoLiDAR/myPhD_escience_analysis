"
@author: Zsofia Koma, UvA
Aim: Check feature values

input:
output:

Fuctions:


Example: 

"
library(raster)

# Set global variables
setwd("D:/Koma/escience/NL_features")

# Import

all_data=stack("terrainData1km_v2.tif")
all_data=flip(all_data,direction = 'y')

# Explore

par(mfrow=c(1,2))
hist(all_data[[1]],breaks=50,col = "grey")
plot(all_data[[1]])

summary(all_data[[1]])