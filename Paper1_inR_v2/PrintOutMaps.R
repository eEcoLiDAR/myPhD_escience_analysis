"
@author: Zsofia Koma, UvA
Aim: plot lidar metrics
"

library(raster)
library(rgdal)

full_path="D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/2_Dataset/"
setwd(full_path)

lidarmetrics_l1=stack("lidarmetrics_l1_masked.grd")
lidarmetrics_l23=stack("lidarmetrics_l2l3_masked_wgr.grd")

#hillshade
dsm=stack("height_metrics_gr.grd")
crs(dsm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

slope <- terrain(dsm$zmax, opt='slope')
aspect <- terrain(dsm$zmax, opt='aspect')
dsm_shd <- hillShade(slope, aspect, 30, 270)


pdf("Metrics_l1.pdf") 

par(mfrow=c(1,1))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$pulsepen_ground, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Pulse penetration ratio [%]',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$cancov, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Canopy cover []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$curvature, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Curvature []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$linearity, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Linearity []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$planarity, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Planarity []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$sphericity, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Sphericity []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$anisotrophy, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Aniztrophy []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zstd, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Standard deviation of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zvar, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Variance of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zskew, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Skewness of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zkurto, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Kurtosis of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$canrelrat, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Canopy relative ratio []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$vertdenrat, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Vertical density ratio []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$simpson, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Simpson []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$shannon, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Shannon []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$roughness, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Roughness []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$tpi, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='TPI []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$tri, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='TRI []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$sd_dsm, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Standard deviation of DSM []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$var_dsm, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Variance of DSM []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zmax, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Maximum of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zmean, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Mean of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$zmedian, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Median of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$z025quantile, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='25th percentiles of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$z075quantile, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='75th percentiles of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l1$z090quantile, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='90th percentiles of Z []',side=4,line=2.5))

dev.off() 

pdf("Metrics_l2.pdf") 

par(mfrow=c(1,1))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$pulsepen_ground, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Pulse penetration ratio [%]',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$cancov, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Canopy cover []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$curvature, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Curvature []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$linearity, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Linearity []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$planarity, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Planarity []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$sphericity, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Sphericity []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$anisotrophy, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Aniztrophy []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zstd, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Standard deviation of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zvar, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Variance of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zskew, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Skewness of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zkurto, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Kurtosis of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$canrelrat, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Canopy relative ratio []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$vertdenrat, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Vertical density ratio []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$simpson, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Simpson []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$shannon, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Shannon []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$roughness, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Roughness []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$tpi, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='TPI []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$tri, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='TRI []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$sd_dsm, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Standard deviation of DSM []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$var_dsm, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Variance of DSM []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zmax, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Maximum of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zmean, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Mean of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$zmedian, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='Median of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$z025quantile, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='25th percentiles of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$z075quantile, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='75th percentiles of Z []',side=4,line=2.5))

plot(dsm_shd, col=grey(0:100/100),legend=FALSE)
plot(lidarmetrics_l23$z090quantile, col=rainbow(25, alpha=0.35), add=TRUE,legend.args=list(text='90th percentiles of Z []',side=4,line=2.5))

dev.off() 