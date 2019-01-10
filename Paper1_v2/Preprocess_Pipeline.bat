:: @author: Zsofia Koma, UvA
:: Aim: Preprocessing LiDAR data

:: Set global variables
set workingdirectory=D:\Koma\Paper1\ALS\01_test
::set workingdirectory=D:\Koma\Paper1\ALS\02gz2
::set workingdirectory=D:\Koma\Paper1\ALS\06en2
::set workingdirectory=D:\Koma\Paper1\ALS\06fn1
::set workingdirectory=D:\Koma\Paper1\ALS\02hz1

:: Tiling
::mkdir %workingdirectory%\tiled
::C:\OSGeo4W64\bin\pdal tile %workingdirectory%\*.laz %workingdirectory%\tiled\tile_#.las 2000

::Create boundary
::C:\OSGeo4W64\bin\pdal tindex %workingdirectory%\tiled\boundary.shp %workingdirectory%\tiled\*.las

:: Extract ground points (using simple morphological filter (SMRF))
::for %%i in (%workingdirectory%\tiled\*.las) do C:\OSGeo4W64\bin\pdal translate %%i %%~nfi_ground.las --json smrf.json 

:: Create DTM
for %%i in (%workingdirectory%\tiled\*_ground.las) do C:\OSGeo4W64\bin\pdal pipeline createDTM_v2.json --readers.las.filename=%%i --writers.gdal.filename=%%~nfi_ground_dtm.tif
for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem hillshade %%i %%~nfi_ground_dtm_shd.tif -z 1.0 -s 1.0 -az 315.0 -alt 45.0 -of GTiff