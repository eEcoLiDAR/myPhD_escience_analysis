:: @author: Zsofia Koma, UvA
:: Aim: Preprocessing LiDAR data

:: Set global variables
set workingdirectory=D:\Koma\Paper1_ReedStructure\1_ProcessingLiDAR\02gz2

:: Tiling
::mkdir %workingdirectory%\tiled
::C:\OSGeo4W64\bin\pdal tile %workingdirectory%\*.laz %workingdirectory%\tiled\tile_#.las 2000

::Create boundary
::C:\OSGeo4W64\bin\pdal tindex %workingdirectory%\tiled\boundary.shp %workingdirectory%\tiled\*.las

:: Extract ground points (using simple morphological filter (SMRF))
::for %%i in (%workingdirectory%\tiled\*.las) do C:\OSGeo4W64\bin\pdal translate %%i %%~nfi_ground.las --json smrf.json 

:: Normalization (standard PDAL)
::for %%i in (%workingdirectory%\tiled\*_ground.las) do C:\OSGeo4W64\bin\pdal translate %%i %%~nfi_ground_norm.las hag ferry --filters.ferry.dimensions="HeightAboveGround=Z"

:: Create DTM
::C:\OSGeo4W64\bin\pdal pipeline createDTM.json
::C:\OSGeo4W64\bin\pdal pipeline createDTM_v2.json --readers.las.filename=%workingdirectory%\tiled\tile_1_-3.las_ground.las --writers.gdal.filename=%workingdirectory%\tiled\tile_1_-3.las_ground_dtm.tif
::C:\OSGeo4W64\bin\gdaldem hillshade D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/tile_1_0.las_ground.tif D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/tile_1_0.las_ground_shd.tif -z 1.0 -s 1.0 -az 315.0 -alt 45.0 -of GTiff

::for %%i in (%workingdirectory%\tiled\*_ground.las) do C:\OSGeo4W64\bin\pdal pipeline createDTM_v2.json --readers.las.filename=%%i --writers.gdal.filename=%%~nfi_ground_dtm.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem hillshade %%i %%~nfi_ground_dtm_shd.tif -z 1.0 -s 1.0 -az 315.0 -alt 45.0 -of GTiff

:: Compute terrain proporties
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem slope %%i %%~nfi_ground_dtm_slope.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem aspect %%i %%~nfi_ground_dtm_aspect.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem TRI %%i %%~nfi_ground_dtm_tri.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem TPI %%i %%~nfi_ground_dtm_tpi.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do C:\OSGeo4W64\bin\gdaldem roughness %%i %%~nfi_ground_dtm_roughness.tif

:: Extract features
::for %%i in (%workingdirectory%\tiled\*.las_ground.las) do python vegfeaturecalc_non_norm.py %workingdirectory%\tiled\%%~ni

:: Conversion
::Rscript.exe ply_tostackedraster.R %workingdirectory%\tiled tile_0_0.las_ground
::for %%i in (%workingdirectory%\tiled\*.las_ground.las) do Rscript.exe ply_tostackedraster.R %workingdirectory%\tiled %%~ni

:: Mosaicing
C:\OSGeo4W64\bin\gdalbuildvrt %workingdirectory%\tiled\mosaic.vrt %workingdirectory%\tiled\tile*allfea.tif
C:\OSGeo4W64\bin\gdal_translate -of GTiff %workingdirectory%\tiled\mosaic.vrt %workingdirectory%\tiled\allfea.tif

