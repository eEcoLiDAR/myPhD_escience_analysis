:: @author: Zsofia Koma, UvA
:: Aim: Preprocessing LiDAR data

:: Set global variables
set workingdirectory=D:\Koma\Paper1_ReedStructure\1_ProcessingLiDAR\02gz2

:: Tiling
::mkdir %workingdirectory%\tiled
::pdal tile %workingdirectory%\*.laz %workingdirectory%\tiled\tile_#.las 2000

::Create boundary
::pdal tindex %workingdirectory%\tiled\boundary.shp %workingdirectory%\tiled\*.las

:: Extract ground points (using simple morphological filter (SMRF))
::for %%i in (%workingdirectory%\tiled\*.las) do pdal translate %%i %%~nfi_ground.las --json smrf.json 

:: Normalization (standard PDAL)
::for %%i in (%workingdirectory%\tiled\*_ground.las) do pdal translate %%i %%~nfi_ground_norm.las hag ferry --filters.ferry.dimensions="HeightAboveGround=Z"

:: Create DTM
::pdal pipeline createDTM.json
::pdal pipeline createDTM_v2.json --readers.las.filename=%workingdirectory%\tiled\tile_1_-3.las_ground.las --writers.gdal.filename=%workingdirectory%\tiled\tile_1_-3.las_ground_dtm.tif
::gdaldem hillshade D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/tile_1_0.las_ground.tif D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/tile_1_0.las_ground_shd.tif -z 1.0 -s 1.0 -az 315.0 -alt 45.0 -of GTiff

::for %%i in (%workingdirectory%\tiled\*_ground.las) do pdal pipeline createDTM_v2.json --readers.las.filename=%%i --writers.gdal.filename=%%~nfi_ground_dtm.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do gdaldem hillshade %%i %%~nfi_ground_dtm_shd.tif -z 1.0 -s 1.0 -az 315.0 -alt 45.0 -of GTiff

:: Compute terrain proporties
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do gdaldem slope %%i %%~nfi_ground_dtm_slope.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do gdaldem aspect %%i %%~nfi_ground_dtm_aspect.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do gdaldem TRI %%i %%~nfi_ground_dtm_tri.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do gdaldem TPI %%i %%~nfi_ground_dtm_tpi.tif
::for %%i in (%workingdirectory%\tiled\*_ground_dtm.tif) do gdaldem roughness %%i %%~nfi_ground_dtm_roughness.tif