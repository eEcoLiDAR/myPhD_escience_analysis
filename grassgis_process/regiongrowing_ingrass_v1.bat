: absolutely not working (path problems...)
: Segmentation using simple layer
: ToDo: 1. set extent automatically

:: before run the script make sure the following steps:
:: 1. set mapset into descartes coordinate system without projection definition
::start up osgeo command line type in grass74 -gtext
:: 2. g.region should be defined with the following lines:
::r.in.xyz -s -g separator="," in=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1.txt skip=1
::g.region n=598499.94 s=598000 e=207999.98 w=207649.25

set path=%1
set filename=%2
set feature=%3
set threshold=%4

r.in.xyz --overwrite input=%path%%filename%.txt output=%filename%_%feature% separator=, skip=1 value_column=%feature%
r.out.gdal --overwrite input=%filename%_%feature% output=%path%%filename%_%feature%.tif

i.group group=group_%feature% input=%filename%_%feature%
i.segment --overwrite group=group_%feature% output=%filename%_%feature%_growsegm_%threshold% threshold=%threshold%
r.out.gdal --overwrite input=%filename%_%feature%_growsegm_%threshold% output=%path%%filename%_%feature%_growsegm_%threshold%.tif

r.to.vect --overwrite -s input=%filename%_%feature%_growsegm_%threshold% output=%filename%_%feature%_growsegm_%threshold%_poly type=area
v.out.ogr --overwrite input=%filename%_%feature%_growsegm_%threshold%_poly type=area output=%path%%filename%_%feature%_growsegm_%threshold%_poly.shp