"
@author: Zsofia Koma, UvA
Aim: LiDAR metrics extraction for the butterfly project
"
library(dplyr)
library(lidR)
library(rgdal)
library(raster)

library(e1071)

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
dpcloudfea_exp_df <- data.frame(matrix(ncol = 23, nrow = 0))
x <- c("Transect", "Transect_ID", "nofret_pheightlay_b02","nofret_pheightlay_02_05","nofret_pheightlay_05_1","nofret_pheightlay_1_2","nofret_pheightlay_2_5",
       "nofret_pheightlay_5_10","nofret_pheightlay_10_20","nofret_pheightlay_a20","zmean","z090quantile","zmean_undst","echovar","int_mean","int_sd","pulsepen",
       "zkurto","zsd","z025quantile","z050quantile","z075quantile","shannon")
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
    
    las_norm_veg=lasfilter(las_norm,Classification==1L)
    
    zmean= mean(las_norm_veg@data$Z)
    z090quantile = quantile(las_norm_veg@data$Z, 0.90)
    zmean_undst=mean(las_norm_veg@data$Z[las_norm_veg@data$Z<5])
    echovar=var(las_norm_veg@data$ReturnNumber)
    int_mean=mean(las_norm_veg@data$Intensity)
    int_sd=sd(las_norm_veg@data$Intensity)
    
    pulsepen = (nrow(las_norm@data[las_norm@data$Classification==1L])/length(las_norm@data$Z))*100
    
    zkurto = kurtosis(las_norm_veg@data$Z)
    zsd = sd(las_norm_veg@data$Z)
    z025quantile = quantile(las_norm_veg@data$Z, 0.25)
    z050quantile = quantile(las_norm_veg@data$Z, 0.50)
    z075quantile = quantile(las_norm_veg@data$Z, 0.75)
    
    p=c(nofret_pheightlay_b02,nofret_pheightlay_02_05,nofret_pheightlay_05_1,nofret_pheightlay_1_2,nofret_pheightlay_2_5,nofret_pheightlay_5_10,nofret_pheightlay_10_20,nofret_pheightlay_a20)
    p_whnull=p[p>0]
    shannon = -sum(p_whnull*log(p_whnull))
    
    newline <- data.frame(t(c(Transect=i,Transect_ID=paste(butterflysp_df_sel$Tr_sec[j],sep=""),
                              nofret_pheightlay_b02=nofret_pheightlay_b02,
                              nofret_pheightlay_02_05 = nofret_pheightlay_02_05,
                              nofret_pheightlay_05_1 = nofret_pheightlay_05_1,
                              nofret_pheightlay_1_2 = nofret_pheightlay_1_2,
                              nofret_pheightlay_2_5=nofret_pheightlay_2_5,
                              nofret_pheightlay_5_10=nofret_pheightlay_5_10,
                              nofret_pheightlay_10_20=nofret_pheightlay_10_20,
                              nofret_pheightlay_a20=nofret_pheightlay_a20,
                              zmean=zmean,
                              z090quantile=z090quantile,
                              zmean_undst=zmean_undst,
                              echovar=echovar,
                              int_mean=int_mean,
                              int_sd=int_sd,
                              pulsepen=pulsepen,
                              zkurto=zkurto,
                              zsd=zsd,
                              z025quantile=z025quantile,
                              z050quantile=z050quantile,
                              z075quantile=z075quantile,
                              shannon=shannon)))
    
    dpcloudfea_exp_df <- rbind(dpcloudfea_exp_df, newline)
    
  }
  
}