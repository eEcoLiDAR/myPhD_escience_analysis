:: @author: Zsofia Koma, UvA
:: Aim: Preprocessing LiDAR data

:: Set global variables
set workingdirectory=D:\Koma\Paper1\ALS\01_test
::set workingdirectory=D:\Koma\Paper1\ALS\02gz2
::set workingdirectory=D:\Koma\Paper1\ALS\06en2
::set workingdirectory=D:\Koma\Paper1\ALS\06fn1
::set workingdirectory=D:\Koma\Paper1\ALS\02hz1

:: Create target points for feature extraction
::for %%i in (%workingdirectory%\tiled\*.las_ground.las) do python create_target.py %workingdirectory%\tiled\%%~ni
:: Extract features
::for %%i in (%workingdirectory%\tiled\*.las_ground.las) do python vegfeaturecalc_non_norm.py %workingdirectory%\tiled\%%~ni
:: Calculate surface roughness

:: Compute terrain properties
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem slope %%i %%~nfi_ground_dtm_slope.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem aspect %%i %%~nfi_ground_dtm_aspect.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem roughness %%i %%~nfi_ground_dtm_roughness.tif

:: Conversion + Normalization
::for %%i in (%workingdirectory%\tiled\*.las_ground.las) do Rscript.exe ply_tostackedraster.R %workingdirectory%\tiled %%~

:: Mosaicking
::C:\OSGeo4W64\bin\gdalbuildvrt %workingdirectory%\tiled\mosaic.vrt %workingdirectory%\tiled\tile*allfea.tif
::C:\OSGeo4W64\bin\gdal_translate -of GTiff %workingdirectory%\tiled\mosaic.vrt %workingdirectory%\tiled\allfea_1m.tif