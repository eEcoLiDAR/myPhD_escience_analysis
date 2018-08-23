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

# escience gtiff
all_data=stack("terrainData1km_v2.tif")
all_data=flip(all_data,direction = 'y')

# Lauwersmeer



# Explore escience

par(mfrow=c(1,2))
hist(all_data[[9]],breaks=50,col = "grey")
plot(all_data[[9]])

summary(all_data[[9]])

# Explore for Lauwersmeer