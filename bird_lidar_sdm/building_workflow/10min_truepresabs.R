"
@author: Zsofia Koma, UvA
Aim: preprocess bird data for Macroecology conference
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

# Set global variables
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"
filename="Breeding_bird_atlas_aggregated_data_10_minute_point_counts.csv"

nl="Boundary_NL_RDNew.shp"

setwd(full_path)

# Import
bird_data=read.csv(file=filename,header=TRUE,sep=";")

nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

# Pre-processing

# Filter species
bird_species="Kleine Karekiet"
#bird_species="Roerdomp" #not enough occurance:10
#bird_species="Snor" #not enough occurance:19
#bird_species="Baardman" #not enough occurance:6
#bird_species="Grote Karekiet"  #not enough occurance:4

bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

#Presence-only
observationmap=ddply(bird_data_onebird,~pointid+species+x_point+y_point,summarise,sum=sum(number))
observationmap = within(observationmap, {
  occurrence = ifelse(sum >0, 1, 0)
})

pres=observationmap[which(observationmap$occurrence==1),]
length(pres$occurrence)

#observationmap$sum <- NULL

# Visualize
p6=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=observationmap, aes(x=x_point,y=y_point,color=as.factor(occurrence)),inherit.aes = FALSE) +
  scale_color_manual(values=c('#6666FF','#990000'))+
  labs(x="x",y="y",color="Presence-Absence") +
  ggtitle(paste("10min observation of",bird_species,"2013-2016",sep=" ")) +
  theme_bw()

p6
ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.jpg',sep=''),p6)

# Export
write.csv(observationmap, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.csv',sep=''),row.names=FALSE)