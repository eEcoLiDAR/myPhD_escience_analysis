:: Aim: execute segmentation using GRASS GIS
:: Previously necessary to set up the mapset with XY Descartes not specified coordinate system (the last parameter during the execution is the place where the PERMANENT directory is located)
:: Usage example: C:/OSGeo4W64/bin/grass74.bat --exec D:/Geobia_2018/Results_6ofApril/grass_frombatchtest.bat D:/Geobia_2018/Results_12ofApril/GrassGIS/LauMeer

set filepath=D:\Geobia_2018\Results_12ofApril\
set filename=tile_207500_598000_1_1.las_clean.txt_PC1__PC2__PC3

set n=598499.94 
set s=598000 
set e=207999.98 
set w=207649.25

set thres=0.4
set minsize=5

:: set region
g.region n=%n% s=%s% e=%e% w=%w%

:: import data
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_PC1 separator=, skip=1 value_column=4
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_PC2 separator=, skip=1 value_column=5
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_PC3 separator=, skip=1 value_column=6

:: segmentation
i.group group=%filename%_groupPCs input=%filename%_PC1,%filename%_PC2,%filename%_PC3
i.segment --overwrite group=%filename%_groupPCs output=%filename%_groupPCs_%thres%_%minsize% threshold=%thres% minsize=%minsize% goodness=%filename%_groupPCs_%thres%_%minsize%_goodness

:: export rasters
r.out.gdal --overwrite input=%filename%_groupPCs_%thres%_%minsize% output=%filepath%%filename%_groupPCs_%thres%_%minsize%.tif
r.out.gdal --overwrite input=%filename%_groupPCs_%thres%_%minsize%_goodness output=%filepath%%filename%_groupPCs_%thres%_%minsize%_goodness.tif

:: export vectors
r.to.vect --overwrite -s input=%filename%_groupPCs_%thres%_%minsize% output=groupPCs_poly type=area
v.out.ogr --overwrite input=groupPCs_poly type=area output=%filepath%%filename%_groupPCs_%thres%_%minsize%_poly.shp format=ESRI_Shapefile
r.to.vect --overwrite -s input=%filename%_groupPCs_%thres%_%minsize% output=groupPCs_point type=point
v.out.ogr --overwrite input=groupPCs_point type=point output=%filepath%%filename%_groupPCs_%thres%_%minsize%_point.shp format=ESRI_Shapefile