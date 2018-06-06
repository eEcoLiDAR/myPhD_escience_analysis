:: Aim: derive example features within GRASS GIS environment --> preprocessing step for pixel-based classification

:: set global variables
set filepath=D:\GitHub\eEcoLiDAR\myPhD_escience_analysis\test_data\
set filename=testdata

set n=600000
set s=597000
set e=220000
set w=206000

:: set region
g.region n=%n% s=%s% e=%e% w=%w%

:: calculate possible features within r.in.lidar fuction
r.in.lidar --overwrite input=%filepath%%filename%.las method=max resolution=1 output=%filename%_max.tif
r.out.gdal --overwrite input=%filename%_max.tif output=%filepath%%filename%_max.tif

r.in.lidar --overwrite input=%filepath%%filename%.las method=mean resolution=1 output=%filename%_mean.tif
r.out.gdal --overwrite input=%filename%_mean.tif output=%filepath%%filename%_mean.tif

r.in.lidar --overwrite input=%filepath%%filename%.las method=stddev resolution=1 output=%filename%_stddev.tif
r.out.gdal --overwrite input=%filename%_stddev.tif output=%filepath%%filename%_stddev.tif

r.in.lidar --overwrite input=%filepath%%filename%.las method=skewness resolution=1 output=%filename%_skewness.tif
r.out.gdal --overwrite input=%filename%_skewness.tif output=%filepath%%filename%_skewness.tif