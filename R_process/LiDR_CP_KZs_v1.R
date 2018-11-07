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
plot(las,color="Classification",colorPalette=random.colors(24))

ground = lasfilter(las, Classification == 2)
plot(ground)

######################## Execise 2. ########################

# Create DTM and normlaize the point cloud
nonvegetation = lasfilter(las, Classification != 1)

dtm = grid_terrain(nonvegetation, res = 5, method = "knnidw", k = 25L)
plot(dtm)

lasnormalize(las, dtm)

hist(las@data$Z)

# Calculate maximum height
hmax = grid_metrics(las, max(Z), res=1)
plot(hmax)

# Exclude extra objects (bulding, water, bridges)
filteres_pc = lasfilter(las, Classification < 3)

hmax_filt = grid_metrics(filteres_pc, max(Z), res=1)
plot(hmax_filt)

