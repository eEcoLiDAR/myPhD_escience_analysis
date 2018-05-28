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
1. add the importat attributes to the oolygon shape file
2. integrate species info -- fiter based on common reed coverage
3. make the polygon based on length and width

Question:
1. coordinate uncertainity?? -- plot middle in the water
"

# call the required libraries
library("stringr")

library("sp")
library("rgdal")
library("ggmap")

# set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

min_year=2010
max_uncertainity=5

radius_m=5

# import data
VegDB_header=read.csv(file="Swamp_communities_header.csv",header=TRUE,sep="\t")

# introduce filters
VegDB_header$year=as.numeric(str_sub(VegDB_header$Datum.van.opname,-4,-1)) # define a numeric year attribute

VegDB_header_filtered=VegDB_header[ which(VegDB_header$year>min_year & VegDB_header$Location.uncertainty..m.<max_uncertainity),]

# Visualize the point data

map=get_map(location = c(lon = 4.89, lat = 52.37), zoom = 7)
mapPoints <- ggmap(map) + geom_point(aes(x = Longitude, y = Latitude), data = VegDB_header_filtered, alpha = .5)
mapPoints

# Create polygon

yPlus=VegDB_header_filtered$Y.Coordinaat..m.+radius_m
xPlus=VegDB_header_filtered$X.Coordinaat..m.+radius_m
yMinus=VegDB_header_filtered$Y.Coordinaat..m.-radius_m
xMinus=VegDB_header_filtered$X.Coordinaat..m.-radius_m

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
proj4string=CRS(as.character("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")))

# Visualize polygon
plot(polys)

# Export
polys.df=SpatialPolygonsDataFrame(polys, data.frame(id=ID, row.names=ID))
writeOGR(polys.df, '.', 'DutchVegDB', 'ESRI Shapefile')

