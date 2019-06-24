"
@author: Zsofia Koma, UvA
Aim: Exploration plots
"
library("lidR")
library("rgdal")
library("sdm")
library("raster")

library("e1071")
library("factoextra")

library("ggplot2")
library("corrplot")

# Feature calc. function
proportion = function(z, by = 1)
{
  z_norm=z-min(z)
  bk = seq(0, ceiling(50/by)*by, by)
  hist = hist(z_norm,bk,plot=FALSE)
  p=(hist$counts/length(z_norm))
  
  return(p)
}

FeaCalc = function(z,i,e)
{
  
  p=proportion(z, by = 1)
  p_whnull=p[p>0]
  
  metrics = list(
    cancov = (length(z[z>mean(z)])/length(z))*100,
    dens_perc_b2 = (length(z[z<2])/length(z))*100,
    dens_perc_b5 = (length(z[z>2 & z<5])/length(z))*100,
    zmean = mean(z),
    zmedian = median(z),
    z025quantile = quantile(z, 0.25),
    z075quantile = quantile(z, 0.75),
    z095quantile = quantile(z, 0.95),
    zstd = sd(z),
    zkurto = kurtosis(z),
    simpson = 1/sum(sqrt(p)),
    shannon = -sum(p_whnull*log(p_whnull)),
    istd = sd(i),
    nofret_std=sd(e),
    zmax=max(z)
  )
  return(metrics)
}

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/"
#workingdirectory="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/"
setwd(workingdirectory)

birdfile="bird_presonly.shp"

# Import 
birds=readOGR(dsn=birdfile)
birds@data$id <- seq(1,length(birds$X),1)

ctg=catalog(workingdirectory)

cores=3 
chunksize=2000
buffer=1 
resolution=5 

rasterOptions(maxmemory = 200000000000) 

# Pre-process catalog

opt_chunk_buffer(ctg) <- buffer
opt_chunk_size(ctg) <- chunksize
opt_cores(ctg) <- cores
opt_output_files(ctg) <- paste(workingdirectory,"normalized/{ID}_normalized",sep="")

normalizedctg = lasnormalize(ctg, knnidw(k=20,p=2))

# Calc metrics

# Topography
ctg@input_options$filter <- "-keep_class 2"
opt_output_files(ctg)=""

dtm = grid_metrics(ctg,min(Z),res=resolution)
crs(dtm) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

slope=terrain(dtm, opt='slope',neighbors=4)
aspect=terrain(dtm, opt='aspect',neighbors=4)
rough_dtm=terrain(dtm,opt="roughness",neighbors=4)

# Water
ctg@input_options$filter <- "-keep_class 9"
opt_output_files(ctg)=""

dws = grid_metrics(ctg,mean(Z),res=resolution)
crs(dws) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

birds_propdws <- extract(dws,birds,buffer = 50,fun=length, df=TRUE)   
birds@data$propdws <- birds_propdws$V1
birds@data$propdws[is.na(birds@data$propdws)]<-0

# Vegetation metrics
normalizedctg=catalog("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/normalized")

opt_output_files(normalizedctg)=""
opt_filter(normalizedctg) <- "-keep_class 1"

vegmetrics = grid_metrics(normalizedctg, FeaCalc(Z,Intensity,NumberOfReturns),res = resolution)
crs(vegmetrics) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"

# Horizontal

rough_dsm=terrain(vegmetrics$z095quantile,opt="roughness",neighbors=4)

# Proportion metrics
height_class=reclassify(vegmetrics$z095quantile, c(-Inf,5,1, 5,Inf,2))
height_class[height_class == 1] <- NA

birds_freqhighveg <- extract(height_class,birds,buffer = 150,fun=length, df=TRUE)   
birds@data$freqhighveg <- birds_freqhighveg$layer
birds@data$freqhighveg[is.na(birds@data$freqhighveg)]<-0

# Merge metrics together
metrics_all=stack(vegmetrics,rough_dsm,slope,aspect,rough_dtm)
crs(metrics_all) <- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
writeRaster(metrics_all,"metricsall.grd",overwrite=TRUE)

# Intersect
metrics_int <- sdmData(formula=occurrence~species+X+Y+cancov+dens_perc_b2+dens_perc_b5+zmean+zmedian+z025quantile+z075quantile+z095quantile+zstd+zkurto+
                        simpson+shannon+istd+nofret_std+roughness.1+slope+aspect+roughness.2+freqhighveg+propdws+zmax, train=birds, predictors=metrics_all)

metrics_int <- metrics_int@features
write.csv(metrics_int,"metrics_intersected.csv")

onlyfea=metrics_int[c("cancov","dens_perc_b2","dens_perc_b5","zmean","zmedian","z025quantile","z075quantile","z095quantile","zstd","zkurto","simpson","shannon","istd","nofret_std","roughness.1",
                      "slope","aspect","roughness.2","freqhighveg","propdws")]

# Boxplot
ggplot(metrics_int, aes(x=species, y=cancov,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=dens_perc_b2,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=dens_perc_b5,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=zmean,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=zmedian,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=z025quantile,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=z075quantile,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=z095quantile,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=zstd,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=zkurto,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=simpson,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=shannon,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=istd,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=nofret_std,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=roughness.1,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=slope,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=aspect,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=roughness.2,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=freqhighveg,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=propdws,fill=species)) + geom_boxplot()
ggplot(metrics_int, aes(x=species, y=zmax,fill=species)) + geom_boxplot()

#PCA
fit <- prcomp(x = onlyfea, 
              center = TRUE, 
              scale = TRUE)

fviz_pca(fit, 
         repel = TRUE,
         labelsize = 3,
         habillage=metrics_int$species) + 
  theme_bw()

fviz_pca_ind(fit, label="none", habillage=metrics_int$species,
             addEllipses=TRUE, ellipse.level=0.95)

fviz_pca_biplot(fit, label="var", habillage=metrics_int$species,
                addEllipses=TRUE, ellipse.level=0.95)

# Crossplot
ggplot(metrics_int, aes(x=zmean, y=cancov,color=species)) + geom_point()
ggplot(metrics_int, aes(x=simpson, y=roughness.1,color=species)) + geom_point()
ggplot(metrics_int, aes(x=zmedian, y=nofech,color=species)) + geom_point()
ggplot(metrics_int, aes(x=z095quantile, y=shannon,color=species)) + geom_point()

# Correlation
onlyfea_corr=cor(onlyfea,method="s")
corrplot(onlyfea_corr,title = "Correlation Plot", method = "square", outline = T, addgrid.col = "darkgray", 
         order="hclust", mar = c(4,0,4,0), addrect = 4, rect.col = "black", rect.lwd = 5,cl.pos = "b", 
         tl.col = "indianred4", tl.cex = 1.5, cl.cex = 1.5)
