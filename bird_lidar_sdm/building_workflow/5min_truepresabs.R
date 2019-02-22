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
filename="Breeding_bird_atlas_aggregated_data_5_minute_point_counts.csv"

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
  ggsave(paste(bird_species,'_5mincount_nl.jpg',sep=''),p6)
  
  # Export
  write.csv(observationmap, file = paste(bird_species,'_5mincount_nl.csv',sep=''),row.names=FALSE)
}

# Stat

bird_data_notnull=bird_data[ which(bird_data$number>0),]
bird_data_notnull_grouped=ddply(bird_data_notnull,~pointid+species+x_point+y_point,summarise,sum=sum(number))

overall_10minstat <- bird_data_notnull_grouped %>%
  group_by(species) %>%
  summarise(nofsp = length(species))

p1<-ggplot(overall_10minstat, aes(x=species, y=nofsp, fill=species)) +
  geom_bar(stat="identity")+scale_fill_manual(values=c("#493829", "#A9A18C", "#613318","#B99C6B","#D57500")) +
  geom_text(aes(label=nofsp), vjust=1.6, color="white", size=3.5)
p1

ggsave(paste('5minstat.jpg',sep=''),p1)

# per year

bird_data_notnull=bird_data[ which(bird_data$number>0),]
bird_data_notnull_grouped_pyear=ddply(bird_data_notnull,~pointid+species+x_point+y_point+year,summarise,sum=sum(number))

overall_10minstat_pyear <- bird_data_notnull_grouped_pyear %>%
  group_by(species,year) %>%
  summarise(nofsp = length(species))

p2<-ggplot(overall_10minstat_pyear, aes(x=species, y=nofsp, fill=factor(year))) +
  geom_bar(stat="identity",position=position_dodge())
p2

ggsave(paste('5minstat_pyear.jpg',sep=''),p2)