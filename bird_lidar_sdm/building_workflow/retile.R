"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="D:/Koma/lidar_bird_dsm_workflow/testsite/"
workingdirectory="D:/Koma/lidar_bird_dsm_workflow/testsite1/"
setwd(workingdirectory)

ctg = catalog(workingdirectory)
subset = lasclipRectangle(ctg, 70460, 374853, 73832, 376945)

writeLAS(subset,"kwelder.laz")
