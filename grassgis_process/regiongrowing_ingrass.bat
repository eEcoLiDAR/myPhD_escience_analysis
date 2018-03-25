r.in.xyz -s -g separator="," in=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1.txt skip=1
g.region n=598499.94 s=598000 e=207999.98 w=207649.25
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1.txt output=tile_207500_598000_1_1_echo separator=, skip=1 value_column=6
r.out.gdal --overwrite input=tile_207500_598000_1_1_echo output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1_echo.tif

i.group group=group1 input=tile_207500_598000_1_1_echo
i.segment --overwrite group=group1 output=group1_region_growsegm threshold=0.4
r.out.gdal --overwrite input=group1_region_growsegm output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1_group1_region_growsegm.tif

r.to.vect --overwrite -s input=group1_region_growsegm output=group1_region_growsegm_poly type=area
v.out.ogr --overwrite input=group1_region_growsegm_poly type=area output=C:\zsofia\Amsterdam\Geobia\Features\group1_region_growsegm_poly.shp