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
filename="Bird atlas numbers per atlassquare.csv"

atlas_poly ="Atlassquares.shp"

nl="Boundary_NL_RDNew.shp"

setwd(full_path)

# Import
bird_data=read.csv(file=filename,header=TRUE,sep=";")

nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

atlas = readOGR(dsn=atlas_poly)
atlas@data$id = rownames(atlas@data)
atlas.points = fortify(atlas, region="id")
atlas.df = join(atlas.points, atlas@data, by="id")

# Process data

species=c("Kleine Karekiet","Roerdomp","Snor","Baardman","Grote Karekiet")

for (bird_species in species) {
  print(bird_species)
  
  bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]
  
  # Join - add absence
  colnames(atlas.df)[colnames(atlas.df)=="ATLASNUM"] <- "atlassquare"
  atlas_agr.df=ddply(atlas.df,~atlassquare+X+Y,summarise,sum=length(atlassquare))
  
  observation_presabs=merge(atlas_agr.df,bird_data_onebird,by="atlassquare",all = TRUE)
  
  observation_presabs = within(observation_presabs, {
    occurrence = ifelse(min >0, 1, 0)
  })
  
  observation_presabs[is.na(observation_presabs)] <- 0
  observation_presabs=select(observation_presabs, atlassquare, X, Y, species,occurrence)
  
  # Visualize
  p6=ggplot() + 
    geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
    geom_path(color="white") +
    coord_equal() +
    geom_point(data=observation_presabs, aes(x=X,y=Y,color=as.factor(occurrence)),inherit.aes = FALSE) +
    scale_color_manual(values=c('#6666FF','#990000'))+
    labs(x="x",y="y",color="Presence-Absence") +
    ggtitle(paste("Aggregated atlas data of",bird_species,"2013-2016",sep=" ")) +
    theme_bw()
  
  p6
  ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.jpg',sep=''),p6)
  
  # Export
  write.csv(observation_presabs, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.csv',sep=''),row.names=FALSE)
}

# Overall stat.
overall_atlasstat <- bird_data %>%
  group_by(species) %>%
  summarise(nofsp = length(species))

p<-ggplot(overall_atlasstat, aes(x=species, y=nofsp, fill=species)) +
  geom_bar(stat="identity")+scale_fill_manual(values=c("#493829", "#A9A18C", "#613318","#B99C6B","#D57500")) +
  geom_text(aes(label=nofsp), vjust=1.6, color="white", size=3.5)
p

ggsave(paste(substr(filename, 1, nchar(filename)-4),'_overallatlas.jpg',sep=''),p)
