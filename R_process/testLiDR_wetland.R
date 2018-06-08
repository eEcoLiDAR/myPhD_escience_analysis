library(lidR)
library(rgdal)
library(sp)

las = readLAS("D:/Sync/_Amsterdam/xOther/lauwermeer_merged.las")
non_reed = rgdal::readOGR("D:/Paper1_ReedbedStructure/Results/GEE/drive-download-20180605T130407Z-001/Lauwersmeer_vector.shp")
non_reed_dcoord <- spTransform(non_reed, CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.417,50.3319,465.552,-0.398957,0.343988,-1.8774,4.0725 +units=m +no_defs"))

lasclassify(las, non_reed_dcoord, field="non_reed")

reed = lasfilter(las, non_reed == TRUE)
plot(reed)

hmean = grid_metrics(reed, mean(Z),res=1)
plot(hmean)