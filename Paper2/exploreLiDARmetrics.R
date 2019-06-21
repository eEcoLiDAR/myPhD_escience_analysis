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

# Feature calc. function
proportion = function(z, by = 1)
{
  # Normalize
  
  z_norm=z-min(z)
  
  # Define the number of x meters bins from 0 to 100 m
  bk = seq(0, ceiling(50/by)*by, by)
  
  # Compute the p for each bin
  hist = hist(z_norm,bk,plot=FALSE)
  
  # Proportion
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
    nofret_std=sd(e)
  )
  return(metrics)
}

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/"
#workingdirectory="D:/Koma/SelectedWetlands/"
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

normalizedctg=catalog("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/aroundbirds/normalized")

opt_output_files(normalizedctg) <- paste(workingdirectory,"/normalized/{XLEFT}_{YBOTTOM}_height",sep="")
opt_filter(normalizedctg) <- "-keep_class 1"
normalizedctg@output_options$drivers$Raster$param$overwrite <- TRUE

height = grid_metrics(normalizedctg, FeaCalc(Z,Intensity,NumberOfReturns),res = resolution)

# Read back #merge outside: 
f <- list.files(path = paste(workingdirectory,"/normalized",sep=""), pattern = ".tif$", full.names = TRUE)
rl <- lapply(f, stack)

height_r=do.call(merge, c(rl, tolerance = 1))
plot(height_r)
names(height_r) <- c("cancov","dens_perc_b2","dens_perc_b5","zmean","zmedian","z025quantile","z075quantile","z095quantile","zstd","zkurto")

# Horizontal

rough_dsm=terrain(height_r$z095quantile,opt="roughness",neighbors=4)
rough_dsm_nei8=terrain(height_r$z095quantile,opt="roughness",neighbors=8)

# Merge metrics together

# Intersect
height_int <- sdmData(formula=occurrence~species+X+Y+cancov+dens_perc_b2+dens_perc_b5+dens_perc_b10+dens_perc_a10+zmean+zmedian+z025quantile+z075quantile+z095quantile+zstd+zkurto, train=birds, predictors=height_r)

height_int <- height_int@features

onlyfea=height_int[c("cancov","dens_perc_b2","dens_perc_b5","zmean","zmedian","z025quantile","z075quantile","z095quantile","zstd","zkurto")]

# Boxplot
ggplot(height_int, aes(x=species, y=cancov,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=dens_perc_b2,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=dens_perc_b5,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=dens_perc_b10,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=dens_perc_a10,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=zmean,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=zmedian,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=z025quantile,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=z075quantile,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=z095quantile,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=zstd,fill=species)) + geom_boxplot()
ggplot(height_int, aes(x=species, y=zkurto,fill=species)) + geom_boxplot()

#PCA
fit <- prcomp(x = onlyfea, 
              center = TRUE, 
              scale = TRUE)

fviz_pca(fit, 
         repel = TRUE,
         labelsize = 3,
         habillage=height_int$species) + 
  theme_bw()

fviz_pca_ind(fit, label="none", habillage=height_int$species,
             addEllipses=TRUE, ellipse.level=0.95)

fviz_pca_biplot(fit, label="var", habillage=height_int$species,
                addEllipses=TRUE, ellipse.level=0.95)
