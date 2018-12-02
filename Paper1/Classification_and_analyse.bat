:: @author: Zsofia Koma, UvA
:: Aim: Preprocessing LiDAR data

:: Set global variables

set workingdirectory=D:\Koma\Paper1\ALS\forClassification

:: Merge rasters from different tiles
C:\OSGeo4W64\bin\gdalbuildvrt %workingdirectory%\mosaic.vrt %workingdirectory%\*_allfea_2o5m.tif
C:\OSGeo4W64\bin\gdal_translate -of GTiff %workingdirectory%\mosaic.vrt %workingdirectory%\alltiles_fea.tif