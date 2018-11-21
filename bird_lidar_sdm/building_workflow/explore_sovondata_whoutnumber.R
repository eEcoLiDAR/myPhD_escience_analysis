"
@author: Zsofia Koma, UvA
Aim: preprocess atlas data for Global Ecology and Biodiversity course
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

library("RColorBrewer")

# Set global variables
full_path="D:/Koma/lidar_bird_dsm_workflow/birdatlas/"
filename="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

nl="Boundary_NL_RDNew.shp"
lidarfile="terrainData100m_run1_filtered_lidarmetrics_lidar_whoutoulier.tif"

setwd(full_path)

# Import
bird_data=read.csv(file=filename,header=TRUE,sep=";")

nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

lidarmetrics=stack(lidarfile)
lidar <- rasterToPoints(lidarmetrics[[3]])
lidar <- data.frame(lidar)
colnames(lidar) <- c("X","Y","max_z")

# Pre-processing

# Filter species
bird_species="Kleine Karekiet"
#bird_species="Roerdomp"

bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

# Reduce the data for only observations -- easier to handle
bird_data_onebird_onlypres=bird_data_onebird[ which(bird_data_onebird$present==1),]

# Visulaize observation over years
print("Years where the observations was made:")
print(unique(bird_data_onebird$year))
uniqueyears=unique(bird_data_onebird$year)

bird_data_onebird_onlypres_2013=bird_data_onebird_onlypres[ which(bird_data_onebird_onlypres$year==2013),]
bird_data_onebird_onlypres_2014=bird_data_onebird_onlypres[ which(bird_data_onebird_onlypres$year==2014),]
bird_data_onebird_onlypres_2015=bird_data_onebird_onlypres[ which(bird_data_onebird_onlypres$year==2015),]
bird_data_onebird_onlypres_2016=bird_data_onebird_onlypres[ which(bird_data_onebird_onlypres$year==2016),]

p1=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=bird_data_onebird_onlypres_2013, aes(x=x,y=y,color=factor(month)),inherit.aes = FALSE) +
  ggtitle(paste(bird_species,"2013",sep=" "))

p2=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=bird_data_onebird_onlypres_2014, aes(x=x,y=y,color=factor(month)),inherit.aes = FALSE) +
  ggtitle(paste(bird_species,"2014",sep=" "))

p3=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=bird_data_onebird_onlypres_2015, aes(x=x,y=y,color=factor(month)),inherit.aes = FALSE) +
  ggtitle(paste(bird_species,"2015",sep=" "))

p4=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=bird_data_onebird_onlypres_2016, aes(x=x,y=y,color=factor(month)),inherit.aes = FALSE) +
  ggtitle(paste(bird_species,"2016",sep=" "))

yearplot=grid.arrange(p1, p2,p3,p4, ncol = 2)
ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_years.jpg',sep=''),yearplot)

# Make presence-absence map
# Only presence - groubpy within years and add species abundance
bird_groupby=ddply(bird_data_onebird_onlypres,~kmsquare+x+y+present+species,summarise,sum=sum(present))

p5=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_raster(data=lidar,aes(X,Y,fill=max_z)) +
  geom_point(data=bird_groupby, aes(x=x,y=y,size=sum,color="red"),inherit.aes = FALSE)

ggsave(paste(substr(filename, 1, nchar(filename)-4),'_grouped_onlypres.jpg',sep=''),p5)

#Presence-absence
observationmap=ddply(bird_data_onebird,~kmsquare+species+x+y,summarise,sum=sum(present))
observationmap = within(observationmap, {
  presence = ifelse(sum >0, 1, 0)
})

p6=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=observationmap, aes(x=x,y=y,color=as.factor(presence)),inherit.aes = FALSE) +
  scale_color_manual(values=c('#6666FF','#990000'))+
  labs(x="x",y="y",color="Present-Absence") +
  ggtitle(paste("Aggregated atlas data of",bird_species,"2013-2016",sep=" ")) +
  theme_bw()

p6
ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.jpg',sep=''),p6)

# Intersection with lidar
coordinates(observationmap)=~x+y
proj4string(observationmap)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

vals <- extract(lidarmetrics,observationmap) # we do not know it is precise enough

observationmap$kurto_z <- vals[,1]
observationmap$mean_z <- vals[,2]
observationmap$max_z <- vals[,3]
observationmap$perc_10 <- vals[,4]
observationmap$perc_30 <- vals[,5]
observationmap$perc_50 <- vals[,6]
observationmap$perc_70 <- vals[,7]
observationmap$perc_90 <- vals[,8]
observationmap$point_density <- vals[,9]
observationmap$skew_z <- vals[,10]
observationmap$std_z <- vals[,11]
observationmap$var_z <- vals[,12]
observationmap$pulse_pen_ratio <- vals[,13]
observationmap$density_absolute_mean <- vals[,14]

observationmap_df=as.data.frame(observationmap)

observationmap_filt_df=observationmap_df[complete.cases(observationmap_df[7:20]), ]

# Visualize amount of presence and absence

nofpres=dim(observationmap_filt_df[ which(observationmap_filt_df$presence==1),])[1]
nofabs=dim(observationmap_filt_df[ which(observationmap_filt_df$presence==0),])[1]

print("Number of presence:")
print(nofpres)

print("Number of absence:")
print(nofabs)

p7=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=observationmap_filt_df, aes(x=x,y=y,size=sum,color=presence),inherit.aes = FALSE) +
  ggtitle(paste(bird_species,"2013-2016 intersected with LiDAR",sep=" "))

p8=ggplot(observationmap_filt_df, aes(x=factor(presence)))+
  geom_bar(stat="count", width=0.7, fill="steelblue")+
  theme_minimal()

presabs_plot=grid.arrange(p7, p8, layout_matrix=rbind(c(1,1,2),c(1,1,NA)))

ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_lidar.jpg',sep=''),presabs_plot)

# Export intersected presence absence data related to the selected bird

write.table(observationmap_filt_df, paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_lidar.csv',sep=''), sep=";") # not entirely good: because of ID shifted
saveRDS(observationmap_filt_df, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_lidar.rds',sep=''))
