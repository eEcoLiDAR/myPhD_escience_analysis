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
gdaldem hillshade D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/tile_1_0.las_ground.tif D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/tile_1_0.las_ground_shd.tif -z 1.0 -s 1.0 -az 315.0 -alt 45.0 -of GTiff
