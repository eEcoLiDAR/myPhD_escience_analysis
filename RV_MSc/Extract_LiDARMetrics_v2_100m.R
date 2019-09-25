"
@author: Zsofia Koma, UvA
Aim: LiDAR metrics extraction for the butterfly project version 2
"
library(dplyr)
library(lidR)
library(rgdal)
library(raster)
library(sp)

library(e1071)

# Set working dirctory
#workingdirectory="D:/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/lidarmetrics_calc/"
workingdirectory="D:/Reinier/Reinier_output/"
#workingdirectory="C:/Koma/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/lidarmetrics_calc/"
setwd(workingdirectory)

butterflyspfile="transects.shp"

#Import
butterflysp = readOGR(dsn=butterflyspfile)
butterflysp_df=butterflysp@data

butterflysp_df_gr <- butterflysp_df %>%
  group_by(Transect) %>%
  summarise(nofobs = length(Transect))

# Direct point cloud based metrics
Transect <- as.vector(butterflysp_df_gr$Transect)
Transect= as.numeric(Transect)
#Transect=c(1437)

dpcloudfea_exp_df <- data.frame(matrix(ncol = 38, nrow = 0))
x <- c("Transect", "Transect_sec","nofret_pheightlay_b005","nofret_pheightlay_005_01","nofret_pheightlay_01_02","nofret_pheightlay_02_05","nofret_pheightlay_05_1","nofret_pheightlay_1_2","nofret_pheightlay_2_5",
       "nofret_pheightlay_5_10","nofret_pheightlay_10_20","nofret_pheightlay_a20","nofret_pheightlay_coarse_b1","nofret_pheightlay_coarse_1_20","nofret_pheightlay_coarse_a20","zmean","z090quantile","zdens_undst","echovar","int_mean","int_sd","pulsepen",
       "zkurto","zsd","z025quantile","z050quantile","z075quantile","shannon","dtm_rough","dsm_var","dtm_slope","dtm_aspect","propofhighveg","propofbareground","int_mean_b1","int_sd_b1","int_mean_b01","int_sd_b01",
       "var_dim","var_dim_b1")
colnames(dpcloudfea_exp_df) <- x

for (i in Transect) {
  print(i)
  
  if (file.exists(paste("Transect_",i,".laz",sep=""))) {
    
    las=readLAS(paste("Transect_",i,".laz",sep=""))
    
    butterflysp_df_sel=butterflysp_df[butterflysp_df$Transect==i,]
    
    for (j in seq(from=1,to=length(butterflysp_df_sel$x))) {
      
      las_clip=lasclipCircle(las,butterflysp_df_sel$x[j],butterflysp_df_sel$y[j],100)
      
      if ((nrow(las_clip@data[las_clip@data$Classification==1L])>0) & (nrow(las_clip@data[las_clip@data$Classification==2L])>0)) {
        
        writeLAS(las_clip,paste("Transect",i,"Tr_sec",butterflysp_df_sel$Tr_sec[j],"_clip_100.laz",sep=""))
        
        las_norm=lasnormalize(las_clip, knnidw(k=10,p=2))
        las_norm_veg=lasfilter(las_norm,Classification==1L)
        
        # metrics directly calculated from point cloud
        
        nofret_pheightlay_b005=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<0.05)])/length(las_norm@data$Z))*100
        nofret_pheightlay_005_01=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<0.1 & las_norm@data$Z>0.05)])/length(las_norm@data$Z))*100
        nofret_pheightlay_01_02=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<0.2 & las_norm@data$Z>0.1)])/length(las_norm@data$Z))*100
        nofret_pheightlay_02_05=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<0.5 & las_norm@data$Z>0.2)])/length(las_norm@data$Z))*100
        nofret_pheightlay_05_1=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<1 & las_norm@data$Z>0.5)])/length(las_norm@data$Z))*100
        nofret_pheightlay_1_2=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<2 & las_norm@data$Z>1)])/length(las_norm@data$Z))*100
        nofret_pheightlay_2_5=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<5 & las_norm@data$Z>2)])/length(las_norm@data$Z))*100
        nofret_pheightlay_5_10=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<10 & las_norm@data$Z>5)])/length(las_norm@data$Z))*100
        nofret_pheightlay_10_20=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<20 & las_norm@data$Z>10)])/length(las_norm@data$Z))*100
        nofret_pheightlay_a20=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z>20)])/length(las_norm@data$Z))*100
        
        nofret_pheightlay_coarse_b1=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<1)])/length(las_norm@data$Z))*100
        nofret_pheightlay_coarse_1_20=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z<20 & las_norm@data$Z>1)])/length(las_norm@data$Z))*100
        nofret_pheightlay_coarse_a20=(nrow(las_norm@data[(las_norm@data$Classification==1L & las_norm@data$Z>20)])/length(las_norm@data$Z))*100
        
        zmean= mean(las_norm_veg@data$Z)
        z090quantile = quantile(las_norm_veg@data$Z, 0.90)
        zmean_undst=(length(las_norm_veg@data$Z[las_norm_veg@data$Z<5])/length(las_norm@data$Z))*100
        echovar=var(las_norm_veg@data$ReturnNumber)
        int_mean=mean(las_norm@data$Intensity)
        int_sd=sd(las_norm@data$Intensity)
        
        b1=las_norm@data[las_norm@data$Z<1]
        int_mean_b1=mean(b1$Intensity)
        int_sd_b1=sd(b1$Intensity)
        
        b01=las_norm@data[las_norm@data$Z<0.1]
        int_mean_b01=mean(b01$Intensity)
        int_sd_b01=sd(b01$Intensity)
        
        pulsepen = (nrow(las_norm@data[las_norm@data$Classification==2L])/length(las_norm@data$Z))*100
        
        zkurto = kurtosis(las_norm_veg@data$Z)
        zsd = sd(las_norm_veg@data$Z)
        z025quantile = quantile(las_norm_veg@data$Z, 0.25)
        z050quantile = quantile(las_norm_veg@data$Z, 0.50)
        z075quantile = quantile(las_norm_veg@data$Z, 0.75)
        
        # for a vertical profile plot
        
        p01=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>0 & las_norm_veg@data$Z<0.1)])/length(las_norm_veg@data$Z))*100
        p02=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>0.1 & las_norm_veg@data$Z<0.2)])/length(las_norm_veg@data$Z))*100
        p1=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>0.2 & las_norm_veg@data$Z<1)])/length(las_norm_veg@data$Z))*100
        p2=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>1 & las_norm_veg@data$Z<5)])/length(las_norm_veg@data$Z))*100
        p3=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>5 & las_norm_veg@data$Z<7.5)])/length(las_norm_veg@data$Z))*100
        p4=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>7.5 & las_norm_veg@data$Z<10)])/length(las_norm_veg@data$Z))*100
        p5=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>10 & las_norm_veg@data$Z<12.5)])/length(las_norm_veg@data$Z))*100
        p6=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>12.5 & las_norm_veg@data$Z<15)])/length(las_norm_veg@data$Z))*100
        p7=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>15 & las_norm_veg@data$Z<17.5)])/length(las_norm_veg@data$Z))*100
        p8=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>17.5 & las_norm_veg@data$Z<20)])/length(las_norm_veg@data$Z))*100
        p9=(nrow(las_norm_veg@data[(las_norm_veg@data$Z>20)])/length(las_norm_veg@data$Z))*100
        
        v=c(p01,p02,p1,p2,p3,p4,p5,p6,p7,p8,p9)
        v<-v[v>0]
        
        p <- v/sum(v)
        shannon=sum(-p*log(p))
        
        # Extract horizontal variability and proportion related metrics
        
        dsm = grid_metrics(las_norm_veg,~quantile(Z, 0.90),res=1)
        proj4string(dsm) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
        
        dtm=grid_metrics(las_clip,~min(Z[Classification==2L]),res=1)
        proj4string(dtm) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
        
        dim = grid_metrics(las_norm,~mean(Intensity),res=1)
        proj4string(dim) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
        
        dim_b1 = grid_metrics(las_norm,~mean(Intensity[Z<1]),res=1)
        proj4string(dim_b1) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
        
        tri_dtm=terrain(dtm,opt="TRI",neighbors=8)
        
        var_sdm=focal(dsm,w=matrix(1,3,3), fun=var, pad=TRUE,na.rm = TRUE)
        var_dim=focal(dim,w=matrix(1,3,3), fun=var, pad=TRUE,na.rm = TRUE)
        var_dim_b1=focal(dim_b1,w=matrix(1,3,3), fun=var, pad=TRUE,na.rm = TRUE)
        
        dtm_slope=terrain(dtm,opt="slope",neighbors=4,unit='degrees')
        dtm_asp=terrain(dtm,opt="aspect",neighbors=4,unit='degrees')
        
        butterflysp_df_sel_sel=butterflysp_df_sel[butterflysp_df_sel$Tr_sec==butterflysp_df_sel$Tr_sec[j],]
        
        coordinates(butterflysp_df_sel_sel)=~x+y
        proj4string(butterflysp_df_sel_sel)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
        
        extr_tri <- extract(tri_dtm, butterflysp_df_sel_sel, weights=FALSE, fun=mean)
        extr_var_sdm <- extract(var_sdm, butterflysp_df_sel_sel, weights=FALSE, fun=mean)
        extr_dtm_slope <- extract(dtm_slope, butterflysp_df_sel_sel, weights=FALSE, fun=mean)
        extr_dtm_asp <- extract(dtm_asp, butterflysp_df_sel_sel, weights=FALSE, fun=mean)
        extr_var_dim <- extract(var_dim, butterflysp_df_sel_sel, weights=FALSE, fun=mean)
        extr_var_dim_b1 <- extract(var_dim_b1, butterflysp_df_sel_sel, weights=FALSE, fun=mean)
        
        height_class=reclassify(dsm, c(-Inf,5,1, 5,Inf,2))
        height_class[height_class == 1] <- NA
        
        propofhighveg <- extract(height_class,butterflysp_df_sel_sel,buffer = 100,fun=length)
        
        if (is.na(propofhighveg)) {propofhighveg=0} else {propofhighveg=propofhighveg}
        
        totalveg = grid_metrics(las_norm,~(length(Z[(Classification==1L)])/length(Z))*100,res=1)
        totalveg_class=reclassify(totalveg, c(-Inf,0,1, 1,Inf,2))
        totalveg_class[totalveg_class == 2] <- NA
        
        propofbareground <- extract(totalveg_class,butterflysp_df_sel_sel,buffer = 100,fun=length) 
        if (is.na(propofbareground)) {propofbareground=0} else {propofbareground=propofbareground}
        
        # Export
        
        newline <- data.frame(t(c(Transect=i,Transect_sec=paste(butterflysp_df_sel$Tr_sec[j],sep=""),
                                  nofret_pheightlay_b005=nofret_pheightlay_b005,
                                  nofret_pheightlay_005_01=nofret_pheightlay_005_01,
                                  nofret_pheightlay_01_02=nofret_pheightlay_01_02,
                                  nofret_pheightlay_02_05 = nofret_pheightlay_02_05,
                                  nofret_pheightlay_05_1 = nofret_pheightlay_05_1,
                                  nofret_pheightlay_1_2 = nofret_pheightlay_1_2,
                                  nofret_pheightlay_2_5=nofret_pheightlay_2_5,
                                  nofret_pheightlay_5_10=nofret_pheightlay_5_10,
                                  nofret_pheightlay_10_20=nofret_pheightlay_10_20,
                                  nofret_pheightlay_a20=nofret_pheightlay_a20,
                                  nofret_pheightlay_coarse_b1=nofret_pheightlay_coarse_b1,
                                  nofret_pheightlay_coarse_1_20=nofret_pheightlay_coarse_1_20,
                                  nofret_pheightlay_coarse_a20=nofret_pheightlay_coarse_a20,
                                  zmean=zmean,
                                  z090quantile=z090quantile,
                                  zdens_undst=zmean_undst,
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
                                  dtm_rough=extr_tri,
                                  dsm_var=extr_var_sdm,
                                  dtm_slope=extr_dtm_slope,
                                  dtm_aspect=extr_dtm_asp,
                                  propofhighveg=propofhighveg,
                                  propofbareground=propofbareground,
                                  int_mean_b1=int_mean_b1,
                                  int_sd_b1=int_sd_b1,
                                  int_mean_b01=int_mean_b01,
                                  int_sd_b01=int_sd_b01,
                                  var_dim=extr_var_dim,
                                  var_dim_b1=extr_var_dim_b1)))
        
        dpcloudfea_exp_df <- rbind(dpcloudfea_exp_df, newline)
        
      }
    }
  }
}

write.csv(dpcloudfea_exp_df,"Butterfly_lidarmetrics_100m.csv")