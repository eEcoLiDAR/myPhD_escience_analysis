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

kmsquares="kmsquare_aslist.csv"

setwd(full_path)

# Import
bird_data=read.csv(file=filename,header=TRUE,sep=";")

nl_bound = readOGR(dsn=nl)
nl_bound@data$id = rownames(nl_bound@data)
nl_bound.points = fortify(nl_bound, region="id")
nl_bound.df = join(nl_bound.points, nl_bound@data, by="id")

#kmsquares_poly = readOGR(dsn=kmsquares)
#kmsquares_poly@data$id = rownames(kmsquares_poly@data)
#kmsquares_poly.points = fortify(kmsquares_poly, region="id")
#kmsquares_poly.df = join(kmsquares_poly.points, kmsquares_poly@data, by="id")

#as.numeric(kmsquares_poly.df$KMHOK)
#colnames(kmsquares_poly.df)[colnames(kmsquares_poly.df)=="KMHOK"] <- "kmsquare"
#kmsquares_poly.df=ddply(kmsquares_poly.df,~kmsquare+X+Y,summarise,sum=length(kmsquare))

#write.csv(kmsquares_poly.df, file = "kmsquare_aslist.csv",row.names=FALSE)
kmsquares_poly.df=read.csv(file=kmsquares,header=TRUE,sep=",")
colnames(kmsquares_poly.df)[colnames(kmsquares_poly.df)=="sum"] <- "nofkmsquare"

# Processing

species=c("Kleine Karekiet","Roerdomp","Snor","Baardman","Grote Karekiet")

for (bird_species in species) {
  
  bird_data_onebird=bird_data[ which(bird_data$species==bird_species),]
  
  observationmap=ddply(bird_data_onebird,~kmsquare+species,summarise,sum=sum(present))
  observationmap = within(observationmap, {
    occurrence = ifelse(sum >0, 1, 0)
  })
  
  
  observation_presabs=merge(observationmap,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
  
  # Visualize
  p6=ggplot() + 
    geom_polygon(data=nl_bound.df,aes(long,lat,group=group),fill = NA, color="black") +
    geom_path(color="white") +
    coord_equal() +
    geom_point(data=observation_presabs, aes(x=X,y=Y,color=as.factor(occurrence)),inherit.aes = FALSE,size=1) +
    scale_color_manual(values=c('#6666FF','#990000'))+
    labs(x="x",y="y",color="Presence-Absence") +
    ggtitle(paste("Aggregated atlas data of",bird_species,"2013-2016",sep=" ")) +
    theme_bw()
  
  p6
  ggsave(paste(substr(filename, 1, nchar(filename)-4),bird_species,'_kmsquare_presabs_nl.jpg',sep=''),p6)
  
  # Export
  write.csv(observation_presabs, file = paste(substr(filename, 1, nchar(filename)-4),bird_species,'_kmsquare_presabs_nl.csv',sep=''),row.names=FALSE)
}

# Stat

bird_data_notnull=bird_data[ which(bird_data$present==1),]
bird_data_notnull_grouped=ddply(bird_data_notnull,~kmsquare+species,summarise,sum=sum(present))

overall_kmstat <- bird_data_notnull_grouped %>%
  group_by(species) %>%
  summarise(nofsp = length(species))

p1<-ggplot(overall_kmstat, aes(x=species, y=nofsp, fill=species)) +
  geom_bar(stat="identity")+scale_fill_manual(values=c("#493829", "#A9A18C", "#613318","#B99C6B","#D57500")) +
  geom_text(aes(label=nofsp), vjust=1.6, color="white", size=3.5)
p1

ggsave(paste(substr(filename, 1, nchar(filename)-4),'_kmsquarestat.jpg',sep=''),p1)