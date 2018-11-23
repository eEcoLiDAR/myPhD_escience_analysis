:: @author: Zsofia Koma, UvA
:: Aim: Extract raster layers

:: Set global variables
set workingdirectory=D:\Koma\Paper1_ReedStructure\1_ProcessingLiDAR\02gz2

:: Conversion
Rscript.exe ply_tostackedraster.R %workingdirectory%\tiled tile_0_0.las_ground
::for %%i in (%workingdirectory%\tiled\*.las_ground.las) do Rscript.exe ply_toraster.R %workingdirectory%\tiled %%~ni