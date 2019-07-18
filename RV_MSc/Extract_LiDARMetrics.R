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
dpcloudfea_exp_df <- data.frame(matrix(ncol = 32, nrow = 0))
x <- c("Transect", "Transect_ID", "nofret_pheightlay_b02","nofret_pheightlay_02_05","nofret_pheightlay_05_1","nofret_pheightlay_1_2","nofret_pheightlay_2_5",
       "nofret_pheightlay_5_10","nofret_pheightlay_10_20","nofret_pheightlay_a20","zmean","z090quantile","zmean_undst","echovar","int_mean","int_sd","pulsepen",
       "zkurto","zsd","z025quantile","z050quantile","z075quantile","shannon","v_prof_2o5","v_prof_5","v_prof_7o5","v_prof_10","v_prof_12o5","v_prof_15",
       "v_prof_17o5","v_prof_20","v_prof_a20")
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
    
    p1=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>0 & las_norm_veg@data$Z<2.5)])/length(las_norm_veg@data$Z))*100
    p2=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>2.5 & las_norm_veg@data$Z<5)])/length(las_norm_veg@data$Z))*100
    p3=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>5 & las_norm_veg@data$Z<7.5)])/length(las_norm_veg@data$Z))*100
    p4=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>7.5 & las_norm_veg@data$Z<10)])/length(las_norm_veg@data$Z))*100
    p5=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>10 & las_norm_veg@data$Z<12.5)])/length(las_norm_veg@data$Z))*100
    p6=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>12.5 & las_norm_veg@data$Z<15)])/length(las_norm_veg@data$Z))*100
    p7=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>15 & las_norm_veg@data$Z<17.5)])/length(las_norm_veg@data$Z))*100
    p8=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>17.5 & las_norm_veg@data$Z<20)])/length(las_norm_veg@data$Z))*100
    p9=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>20)])/length(las_norm_veg@data$Z))*100
    
   v=c(p1,p2,p3,p4,p5,p6,p7,p8,p9)
    
    p <- table(v)
    p <- p/sum(p)
    shannon=sum(-p*log(p))
    
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
                              shannon=shannon,
                              v_prof_2o5=p1,
                              v_prof_5=p2,
                              v_prof_7o5=p3,
                              v_prof_10=p4,
                              v_prof_12o5=p5,
                              v_prof_15=p6,
                              v_prof_17o5=p7,
                              v_prof_20=p8,
                              v_prof_a20=p9)))
    
    dpcloudfea_exp_df <- rbind(dpcloudfea_exp_df, newline)
    
  }
  
}

write.csv(dpcloudfea_exp_df,"dpcloudfea_exp_df.csv")