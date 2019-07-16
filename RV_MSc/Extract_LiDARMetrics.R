"
@author: Zsofia Koma, UvA
Aim: LiDAR metrics extraction for the butterfly project
"
library(dplyr)
library(lidR)
library(rgdal)
library(raster)

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/lidarmetrics_calc/"
setwd(workingdirectory)

butterflyspfile="Melitaea_AnalysisData.shp"

#Import
butterflysp = readOGR(dsn=butterflyspfile)
butterflysp_df=butterflysp@data

butterflysp_df_gr <- butterflysp_df %>%
  group_by(Transect) %>%
  summarise(nofobs = length(Transect))

# Direct point cloud based metrics
Transect=c(123,362,698,1244)

for (i in Transect) {
  print(i)
  
  las=readLAS(paste("Transect_",i,".laz",sep=""))
  
  butterflysp_df_sel=butterflysp_df[butterflysp_df$Transect==i,]
  
  for (j in seq(from=1,to=length(butterflysp_df_sel$x))) {
    
    las_clip=lasclipCircle(las,butterflysp_df_sel$x[j],butterflysp_df_sel$y[j],25)
    
    las_vegetation=lasfilter(las_clip, Classification == 1L)
    
    plot(las_vegetation)
    
    print(mean(las_vegetation@data$Z))
    
  }
  
}