"
@author: Zsofia Koma, UvA
Aim: create presence-absence data from observation + aggregated kmsquare data
"

library(rgdal)
library(raster)
library(dplyr)

library(ggplot2)

# Set global variables
#full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/"

birdobsfile="Breeding_bird_atlas_individual_observations.csv"
birdkmfile="Breeding_bird_atlas_aggregated_data_kmsquares.csv"

ahn3="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/lidar/ahn3.shp"
ahn3="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/lidar/ahn3.shp"

landcoverfile="LGN7.tif"

setwd(full_path)

# Import
ahn3_poly = readOGR(dsn=ahn3)

bird_data_obs=read.csv(file=paste(full_path,"bird_data/",birdobsfile,sep=""),header=TRUE,sep=";")
bird_data_obs<-bird_data_obs[!(bird_data_obs$species=="Roerdomp"),] #delete Roerdomp because it is not needed

birdspecies=unique(bird_data_obs$species)

landcover=stack(paste(full_path,"landcover/3_LGN7/Data/",landcoverfile,sep=""))
proj4string(landcover) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Create presence-only data 
names(bird_data_obs)[14]<-"X"
names(bird_data_obs)[15]<-"Y"
names(bird_data_obs)[17]<-"occurrence"

bird_onlypresence=bird_data_obs[c("X","Y","species","occurrence","kmsquare")]

# Create shapefile
bird_onlypresence$X_obs=bird_onlypresence$X
bird_onlypresence$Y_obs=bird_onlypresence$Y

bird_presonly_shp=bird_onlypresence[c("X","Y","X_obs","Y_obs","kmsquare","species","occurrence")]
coordinates(bird_presonly_shp)=~X_obs+Y_obs
proj4string(bird_presonly_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

raster::shapefile(bird_presonly_shp, "bird_presonly.shp",overwrite=TRUE)

# Select one species

greatwarbler.only <- subset(bird_presonly_shp, species %in% c('Grote Karekiet'))
raster::shapefile(greatwarbler.only, "greatwarbler.shp",overwrite=TRUE)


# Check intersection with LGN7
lgn7_birdprs_intersect=extract(landcover,bird_presonly_shp)

bird_onlypresence$landcover_lgn7=lgn7_birdprs_intersect

cols <- rainbow(unique(bird_onlypresence$landcover_lgn7))

p1<-ggplot(bird_onlypresence, aes(x=landcover_lgn7,fill=factor(landcover_lgn7)))+
  geom_histogram(bins=62)+
  facet_grid(species ~ .) +
  scale_x_continuous(breaks=seq(1,62,1))+
  scale_fill_manual(values=cols,name="LGN7",labels=c("1-Agrarisch gras","2-Mais", "3-Aardappelen","4-Bieten","5-Granen","6-Overige landbouwgewassen","9-Boomgaard","10-Bollen","11-Loofbos","12-Naaldbos","16-Zoet water","17-Zout water",
                                         "18-Bebouwing in primair","19-Bebouwing in secundair","20-Bos in primair bebouwd","22-Bos in secundair bebouwd","23-Gras in primair bebouwd","24-Kale grond in bebouwd","25-Hoofdwegen & spoorwegen","26-Bebouwing in buitengebied",
                                         "28-Gras in secundair bebouwd","30-Kwelders","32-Duinen met lage","36-Heide","41-Moerasvegetatie","42-Rietvegetatie","43-Bos in moerasgebied","45-Natuurgraslanden","61-Boomkwekerijen","62-Fruitkwekerijen"))
p1

# Mask for area of interest
formask <- setValues(raster(landcover), NA)
formask[landcover==16 |landcover==30 | landcover==41 | landcover==42 | landcover==43 | landcover==45] <- 1

proj4string(formask)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
writeRaster(formask,"req_lgn7_classes.grd",overwrite=TRUE)

# Create a required AHN3 tile list

intersected=raster::intersect(ahn3_poly,greatwarbler.only)
intersected_df=intersected@data

req_ahn3 <- intersected_df %>%
  group_by(bladnr) %>%
  summarise(nofobs = length(bladnr))

req_ahn3$bladnr_up=toupper(req_ahn3$bladnr)

req_ahn3$list=paste("https://geodata.nationaalgeoregister.nl/ahn3/extract/ahn3_laz/C_",req_ahn3$bladnr_up,".LAZ",sep="")

write.table(req_ahn3$list, file = "greatwarbler_ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 
