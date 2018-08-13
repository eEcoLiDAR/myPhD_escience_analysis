::C:/OSGeo4W64/bin/grass74.bat --exec D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1/featureextraction/mosaic.bat

::gdaltindex an_index.shp *_heightq090.tif

gdalbuildvrt mosaic.vrt *_heightq090.tif
gdal_translate -of GTiff mosaic.vrt mosaic_heightq090.tif