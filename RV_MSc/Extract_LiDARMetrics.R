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
Transect=c(123,362)
dpcloudfea_exp_df <- data.frame(matrix(ncol = 3, nrow = 0))
x <- c("Transect", "Transect_ID", "H_mean_25m")
colnames(dpcloudfea_exp_df) <- x

for (i in Transect) {
  print(i)
  
  las=readLAS(paste("Transect_",i,".laz",sep=""))
  
  butterflysp_df_sel=butterflysp_df[butterflysp_df$Transect==i,]
  
  for (j in seq(from=1,to=length(butterflysp_df_sel$x))) {
    
    las_clip=lasclipCircle(las,butterflysp_df_sel$x[j],butterflysp_df_sel$y[j],25)
    
    las_norm=lasnormalize(las_clip, knnidw(k=10,p=2))
    
    nofret_pheightlay_b02=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<0.2)])/length(las_norm@data$Z))*100
    nofret_pheightlay_02_05=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<0.5 & las_norm@data$Z>0.2)])/length(las_norm@data$Z))*100
    nofret_pheightlay_05_1=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<1 & las_norm@data$Z>0.5)])/length(las_norm@data$Z))*100
    nofret_pheightlay_1_2=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<2 & las_norm@data$Z>1)])/length(las_norm@data$Z))*100
    nofret_pheightlay_2_5=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<5 & las_norm@data$Z>2)])/length(las_norm@data$Z))*100
    nofret_pheightlay_5_10=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<10 & las_norm@data$Z>5)])/length(las_norm@data$Z))*100
    nofret_pheightlay_10_20=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<20 & las_norm@data$Z>10)])/length(las_norm@data$Z))*100
    nofret_pheightlay_a20=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z>20)])/length(las_norm@data$Z))*100
    
    newline <- data.frame(t(c(Transect=i,Transect_ID=paste(butterflysp_df_sel$Tr_sec[j],sep=""),H_mean_25m = mean(las_vegetation@data$Z))))
    dpcloudfea_exp_df <- rbind(dpcloudfea_exp_df, newline)
    
  }
  
}