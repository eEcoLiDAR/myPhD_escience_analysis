::C:/OSGeo4W64/bin/grass74.bat --exec D:/Koma/GitHub/myPhD_escience_analysis/Paper1/featureextraction/mosaic.bat

::gdaltindex an_index.shp *_heightq090.tif

::gdalbuildvrt mosaic.vrt *_heightq090.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_heightq090.tif

::gdalbuildvrt mosaic.vrt *_anisotropy.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_anisotropy.tif

::gdalbuildvrt mosaic.vrt *_curvature.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_curvature.tif

::gdalbuildvrt mosaic.vrt *_linearity.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_linearity.tif

::gdalbuildvrt mosaic.vrt *_omnivariance.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_omnivariance.tif

::gdalbuildvrt mosaic.vrt *_planarity.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_planarity.tif

::gdalbuildvrt mosaic.vrt *_sphericity.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_sphericity.tif

::gdalbuildvrt mosaic.vrt *_pulsepenrat.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_pulsepenrat.tif

::gdalbuildvrt mosaic.vrt *_heightmax.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_heightmax.tif

::gdalbuildvrt mosaic.vrt *_heightmean.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_heightmean.tif

::gdalbuildvrt mosaic.vrt *_heightmedian.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_heightmedian.tif

::gdalbuildvrt mosaic.vrt *_heightq025.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_heightq025.tif

::gdalbuildvrt mosaic.vrt *_heightq075.tif
::gdal_translate -of GTiff mosaic.vrt mosaic_heightq075.tif

gdalbuildvrt mosaic.vrt *_heightkurto.tif
gdal_translate -of GTiff mosaic.vrt mosaic_heightkurto.tif

gdalbuildvrt mosaic.vrt *_heightskew.tif
gdal_translate -of GTiff mosaic.vrt mosaic_heightskew.tif

gdalbuildvrt mosaic.vrt *_heightstd.tif
gdal_translate -of GTiff mosaic.vrt mosaic_heightstd.tif

gdalbuildvrt mosaic.vrt *_heightvar.tif
gdal_translate -of GTiff mosaic.vrt mosaic_heightvar.tif

gdalbuildvrt mosaic.vrt *_meandtm.tif
gdal_translate -of GTiff mosaic.vrt mosaic_meandtm.tif

