"
@author: Zsofia Koma, UvA
Aim: Feature caculation AHN2 data
"
library("lidR")
library("rgdal")
#source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions_sTristan.R")
#source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions_sTristan.R")
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions_sTristan.R")

# Set working dirctory
#workingdirectory="D:/Koma/Paper1/ALS/"
#setwd(workingdirectory)

workdirectories=list("D:/Koma/Paper1/ALS/02gz2/ground/","D:/Koma/Paper1/ALS/02hz1/ground/","D:/Koma/Paper1/ALS/06en2/ground/","D:/Koma/Paper1/ALS/06fn1/ground/")

for (workingdirectory in workdirectories){
  
  print(workingdirectory)
  
  setwd(workingdirectory)
  
  resolution=2.5
  core=18
  
  pdf("LiDAR_process.pdf")
  
  # Set cataloge
  
  gr_hom_ctg <- catalog(paste(workingdirectory,"homogenized/",sep=""))
  
  opt_chunk_buffer(gr_hom_ctg) <- resolution
  opt_cores(gr_hom_ctg) <- core
  
  coveragemetrics = grid_metrics(gr_hom_ctg, CoverageMetrics(Z,Classification),res=resolution)
  plot(coveragemetrics)
  writeRaster(coveragemetrics,"coveragemetrics.grd",overwrite=TRUE)
  
  heightmetrics = grid_metrics(gr_hom_ctg, HeightMetrics(Z,Classification),res=resolution)
  plot(heightmetrics)
  writeRaster(heightmetrics,"heightmetrics.grd",overwrite=TRUE)
  
  shapemetrics = grid_metrics(gr_hom_ctg, ShapeMetrics(X,Y,Z),res=resolution) 
  plot(shapemetrics)
  writeRaster(shapemetrics,"shapemetrics.grd",overwrite=TRUE)
  
  gr_hom_ctg@input_options$filter <- "-keep_class 1"
  
  shapemetrics_whgr = grid_metrics(gr_hom_ctg, ShapeMetrics(X,Y,Z),res=resolution) 
  plot(shapemetrics_whgr)
  writeRaster(shapemetrics_whgr,"shapemetrics_whgr.grd",overwrite=TRUE)
  
  gr_hom_ctg@input_options$filter <- ""
  
  vertdistr_metrics = grid_metrics(gr_hom_ctg, VegStr_VertDistr_Metrics(Z),res=resolution)
  plot(vertdistr_metrics)
  writeRaster(vertdistr_metrics,"vertdistr_metrics.grd",overwrite=TRUE)
  
  gr_hom_ctg@input_options$filter <- "-keep_class 1"
  
  vertdistr_metrics_whgr = grid_metrics(gr_hom_ctg, VegStr_VertDistr_Metrics(Z),res=resolution)
  plot(vertdistr_metrics_whgr)
  writeRaster(vertdistr_metrics_whgr,"vertdistr_metrics_whgr.grd",overwrite=TRUE)
  
  gr_hom_ctg@input_options$filter <- "-keep_class 2"
  
  dtm= grid_metrics(gr_hom_ctg,min(Z),res=resolution)
  crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
  writeRaster(dtm, "dtm.tif",overwrite=TRUE)
  
  plot(dtm)
  
  slope_dtm=terrain(dtm,opt="slope",unit="degrees",neighbors=4)
  aspect_dtm=terrain(dtm,opt="aspect",unit="degrees",neighbors=4)
  rough_dtm=terrain(dtm,opt="roughness",neighbors=4)
  tpi_dtm=terrain(dtm,opt="TPI",neighbors=4)
  tri_dtm=terrain(dtm,opt="TRI",neighbors=4)
  
  dtm_metrics=stack(slope_dtm,aspect_dtm,rough_dtm,tpi_dtm,tri_dtm) 
  plot(dtm_metrics)
  writeRaster(dtm_metrics,"dtm_metrics.grd",overwrite=TRUE)
  
  rough_dsm=terrain(heightmetrics$zmax,opt="roughness",neighbors=4)
  tpi_dsm=terrain(heightmetrics$zmax,opt="TPI",neighbors=4)
  tri_dsm=terrain(heightmetrics$zmax,opt="TRI",neighbors=4)
  
  sd_dsm=focal(heightmetrics$zmax, w=matrix(1,3,3), fun=sd)
  names(sd_dsm) <- "sd_dsm"
  var_dsm=focal(heightmetrics$zmax, w=matrix(1,3,3), fun=var)
  names(var_dsm) <- "var_dsm"
  
  sd_cover=focal(coveragemetrics$pulsepen_ground, w=matrix(1,3,3), fun=sd)
  names(sd_cover) <- "sd_cover"
  sd_midcover=focal(coveragemetrics$dens_perc_b2, w=matrix(1,3,3), fun=sd)
  names(sd_midcover) <- "sd_midcover"
  
  sd_verdenrat=focal(vertdistr_metrics$vertdenrat, w=matrix(1,3,3), fun=sd)
  names(sd_verdenrat) <- "sd_verdenrat"
  
  horizontal_metrics=stack(rough_dsm,tpi_dsm,tri_dsm,sd_dsm,var_dsm,sd_cover,sd_midcover,sd_verdenrat) 
  plot(horizontal_metrics)
  
  writeRaster(horizontal_metrics,"horizontal_metrics.grd",overwrite=TRUE)
  
  dev.off()

}