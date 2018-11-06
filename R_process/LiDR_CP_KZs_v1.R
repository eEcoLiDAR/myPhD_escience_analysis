"
@author: Zsofia Koma, UvA
Aim: Global ecology and biodiversity MSc course, LiDAR execise solution
"

# Import required libraries

library("lidR")
library("raster")
library("maptools")

library("e1071")

# Set global variables (workspace)

full_path="D:/Koma/MSc_course/"
filename="flavopark_forCP.las"

setwd(full_path)

######################## Execise 1. ########################
# Import data

las = readLAS(filename)

# Explore briefly
print(las@header@PHB$`Number of point records`)
print(las@header@PHB$`Min Z`)
print(las@header@PHB$`Max Z`)

hist(las@data$Z)

plot(las)

ground = lasfilter(las, Classification == 2)
plot(ground)

