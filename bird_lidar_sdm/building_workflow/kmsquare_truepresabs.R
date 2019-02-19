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
filename="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

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
#bird_species="Kleine Karekiet"
#bird_species="Roerdomp" 
#bird_species="Snor" 
#bird_species="Baardman" 
bird_species="Grote Karekiet" 

bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]

# generate id from coords
bird_data_onebird$coordid <- with(bird_data_onebird, paste0(x,y))

observationmap=ddply(bird_data_onebird,~coordid+species+x+y,summarise,sum=sum(present))
observationmap = within(observationmap, {
  occurrence = ifelse(sum >0, 1, 0)
})

pres=observationmap[which(observationmap$occurrence==1),]
length(pres$occurrence)

# Visualize
p6=ggplot() + 
  geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
  geom_path(color="white") +
  coord_equal() +
  geom_point(data=observationmap, aes(x=x,y=y,color=as.factor(occurrence)),inherit.aes = FALSE) +
  scale_color_manual(values=c('#6666FF','#990000'))+
  labs(x="x",y="y",color="Presence-Absence") +
  ggtitle(paste("kmsquare observation of",bird_species,"2013-2016",sep=" ")) +
  theme_bw()

p6
ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.jpg',sep=''),p6)

# Export
write.csv(observationmap, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'_grouped_presabs_nl.csv',sep=''),row.names=FALSE)



