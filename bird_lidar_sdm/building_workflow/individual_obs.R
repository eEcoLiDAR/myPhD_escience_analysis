"
@author: Zsofia Koma, UvA
Aim: preprocess bird data for Global Ecology and Biodiversity course
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
filename="Breeding_bird_atlas_individual_observations.csv"

nl="Boundary_NL_RDNew.shp"

setwd(full_path)

# Import
bird_data=read.csv(file=filename,header=TRUE,sep=";")

nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

# Processing

species=c("Kleine Karekiet","Roerdomp","Snor","Baardman","Grote Karekiet")

for (bird_species in species) {
  bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]
  
  #Presence-only
  observationmap=ddply(bird_data_onebird,~kmsquare+species+x_point+y_point,summarise,sum=sum(number))
  observationmap = within(observationmap, {
    occurrence = ifelse(sum >0, 1, 0)
  })
  
  # Visualize
  p6=ggplot() + 
    geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
    geom_path(color="white") +
    coord_equal() +
    geom_point(data=observationmap, aes(x=x_point,y=y_point,color=as.factor(occurrence)),inherit.aes = FALSE) +
    scale_color_manual(values=c('#6666FF','#990000'))+
    labs(x="x",y="y",color="Presence-only") +
    ggtitle(paste("Aggregated individual observation of",bird_species,"2013-2016",sep=" ")) +
    theme_bw()
  
  p6
  ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presonly_nl.jpg',sep=''),p6)
  
  # Export
  write.csv(bird_data_onebird, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'indobs_presonly_nl.csv',sep=''),row.names=FALSE)
  write.csv(observationmap, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presonly_nl.csv',sep=''),row.names=FALSE)
}

# Overall stat.
overall_indobsstat <- bird_data %>%
  group_by(species) %>%
  summarise(nofsp = length(species))

p1<-ggplot(overall_indobsstat, aes(x=species, y=nofsp, fill=species)) +
  geom_bar(stat="identity")+scale_fill_manual(values=c("#493829", "#A9A18C", "#613318","#B99C6B","#D57500")) +
  geom_text(aes(label=nofsp), vjust=1.6, color="white", size=3.5)
p1

ggsave(paste(substr(filename, 1, nchar(filename)-4),'_stat_sumindobs.jpg',sep=''),p1)

#
overall_kmsquaresgroup <- bird_data %>%
  group_by(kmsquare,species) %>%
  summarise(nofbird = sum(number))

overall_kmsquaresstat <- overall_kmsquaresgroup %>%
  group_by(species) %>%
  summarise(nofkmsquare = length(kmsquare))

p2<-ggplot(overall_kmsquaresstat, aes(x=species, y=nofkmsquare, fill=species)) +
  geom_bar(stat="identity")+scale_fill_manual(values=c("#493829", "#A9A18C", "#613318","#B99C6B","#D57500")) +
  geom_text(aes(label=nofkmsquare), vjust=1.6, color="white", size=3.5)
p2

ggsave(paste(substr(filename, 1, nchar(filename)-4),'_observedkmsquares.jpg',sep=''),p2)


