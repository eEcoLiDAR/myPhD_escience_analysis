:: Aim: execute segmentation using GRASS GIS
:: Previously necessary to set up the mapset with XY Descartes not specified coordinate system (the last parameter during the execution is the place where the PERMANENT directory is located)
:: Usage example:  C:/OSGeo4W64/bin/grass74.bat --exec D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1/featureextraction/grass_rasterize.bat D:/Geobia_2018/Results_12ofApril/GrassGIS/LauMeer D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testmetrics/ tile_00003_norm2_ascii
:: C:/OSGeo4W64/bin/grass74.bat --exec D:/Koma/GitHub/myPhD_escience_analysis/Paper1/featureextraction/grass_rasterize.bat D:/Koma/GRASS_GIS/Lauwersmeer/Lauwersmeer2 D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/test/ tile_00001_norm_ascii
:: for f in *.csv; do C:/OSGeo4W64/bin/grass74.bat --exec D:/Koma/GitHub/myPhD_escience_analysis/Paper1/featureextraction/grass_rasterize.bat D:/Koma/GRASS_GIS/Lauwersmeer/Lauwersmeer2 D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/tiled/ ${f%.*};done
:: C:/OSGeo4W64/bin/grass74.bat --exec D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1/featureextraction/grass_rasterize.bat D:/Koma/GRASS_GIS/Lauwersmeer/Lauwersmeer2 D:/Koma/Paper1_ReedStructure/Data/TestFeatureResults/ tile_00001_land_ascii
:: for f in *.csv; do C:/OSGeo4W64/bin/grass74.bat --exec D:/Koma/GitHub/myPhD_escience_analysis/Paper1/featureextraction/grass_rasterize.bat D:/Koma/GRASS_GIS/Lauwersmeer/Lauwersmeer2 D:/Koma/Paper1_ReedStructure/Data/ALS/WholeLau/tiled/ ${f%.*} ${f:0:15};done

set filepath=%2
set filename=%3
set lasfile=%4

:: read a raster to set the region
v.in.lidar -otb input=%lasfile%.las output=%lasfile% --overwrite

:: set region
::g.region n=%n% s=%s% e=%e% w=%w%
g.region vector=%lasfile%
g.region -p

:: import data
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_lin separator=, skip=1 value_column=7
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_plan separator=, skip=1 value_column=8
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_sph separator=, skip=1 value_column=9
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_omn separator=, skip=1 value_column=10
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_ani separator=, skip=1 value_column=11
r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv separator=, skip=1 value_column=13

:: export rasters
r.out.gdal --overwrite input=%filename%_lin output=%filepath%%filename%_linearity.tif
r.out.gdal --overwrite input=%filename%_plan output=%filepath%%filename%_planarity.tif
r.out.gdal --overwrite input=%filename%_sph output=%filepath%%filename%_sphericity.tif
r.out.gdal --overwrite input=%filename%_omn output=%filepath%%filename%_omnivariance.tif
r.out.gdal --overwrite input=%filename%_ani output=%filepath%%filename%_anisotropy.tif
r.out.gdal --overwrite input=%filename%_curv output=%filepath%%filename%_curvature.tif

:: import height layers
::r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv_0_1 separator=, skip=1 value_column=19 zrange=0,1
::r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv_1_25 separator=, skip=1 value_column=19 zrange=1,2.5
::r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv_25_5 separator=, skip=1 value_column=19 zrange=2.5,5
::r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv_5_75 separator=, skip=1 value_column=19 zrange=5,7.5
::r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv_75_10 separator=, skip=1 value_column=19 zrange=7.5,10
::r.in.xyz --overwrite input=%filepath%%filename%.csv output=%filename%_curv_a10 separator=, skip=1 value_column=19 zrange=10,50

:: export height layer rasters
::r.out.gdal --overwrite input=%filename%_curv_0_1 output=%filepath%%filename%_curv_0_1.tif
::r.out.gdal --overwrite input=%filename%_curv_1_25 output=%filepath%%filename%_curv_1_25.tif
::r.out.gdal --overwrite input=%filename%_curv_25_5 output=%filepath%%filename%_curv_25_5.tif
::r.out.gdal --overwrite input=%filename%_curv_5_75 output=%filepath%%filename%_curv_5_75.tif
::r.out.gdal --overwrite input=%filename%_curv_75_10 output=%filepath%%filename%_curv_75_10.tif
::r.out.gdal --overwrite input=%filename%_curv_a10 output=%filepath%%filename%_curv_a10.tif


