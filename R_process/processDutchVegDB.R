"
@author: Zsofia Koma, UvA
Aim: Organizing the Dutch vegetation database for reedbed delinaition
  
Input: 
Output: 

Function:
1. Import Dutch vegetation database
2. Filter out based on year and maximum coordinate uncertainity
3. Points convert into polygon based on recorded length and width
4. Visualization
5. Export as polygon for GEE
  
Example usage (from command line):   
  
ToDo: 
"

# call the required libraries
library("stringr")

library("sp")
library("rgdal")
library("ggmap")

# set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

min_year=2010
radius=5

# import data
VegDB_header=read.csv(file="Swamp_communities_header.csv",header=TRUE,sep="\t")

# introduce filters
VegDB_header$year=as.numeric(str_sub(VegDB_header$Datum.van.opname,-4,-1)) # define a numeric year attribute

VegDB_header_filtered=VegDB_header[ which(VegDB_header$year>min_year),]

# Visualize the point data

map=get_map(location = c(lon = 4.89, lat = 52.37), zoom = 7)
mapPoints <- ggmap(map) + geom_point(aes(x = Longitude, y = Latitude), data = VegDB_header_filtered, alpha = .5)
mapPoints

# Create polygon

yPlus=VegDB_header_filtered$Latitude+radius
xPlus=VegDB_header_filtered$Longitude+radius
yMinus=VegDB_header_filtered$Latitude-radius
xMinus=VegDB_header_filtered$Longitude-radius

square=cbind(xMinus,yPlus,  # NW corner
             xPlus, yPlus,  # NE corner
             xPlus,yMinus,  # SE corner
             xMinus,yMinus, # SW corner
             xMinus,yPlus)  # NW corner again - close ploygon

ID=VegDB_header_filtered$PlotID

polys <- SpatialPolygons(mapply(function(poly, id) 
{
  xy <- matrix(poly, ncol=2, byrow=TRUE)
  Polygons(list(Polygon(xy)), ID=id)
}, 
split(square, row(square)), ID),
proj4string=CRS(as.character("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")))

# Visualize polygon
