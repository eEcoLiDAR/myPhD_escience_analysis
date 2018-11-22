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
::pdal translate %workingdirectory%\tiled\tile_0_0.las %workingdirectory%\tiled\tile_0_0_ground.las --json smrf.json

:: Normalization
::pdal translate %workingdirectory%\tiled\tile_0_0_ground.las %workingdirectory%\tiled\tile_0_0_ground_norm.las hag ferry --filters.ferry.dimensions="HeightAboveGround=Z"
