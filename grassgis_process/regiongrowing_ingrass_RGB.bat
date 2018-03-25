::r.in.xyz -s -g separator="," in=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1.txt skip=1
::g.region n=598499.94 s=598000 e=207999.98 w=207649.25

::r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1echo_ratioeigenv_1skew_z.csv output=tile_207500_598000_1_1_echo separator=, skip=1 value_column=4
::r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1echo_ratioeigenv_1skew_z.csv output=tile_207500_598000_1_1_eig separator=, skip=1 value_column=5
::r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1echo_ratioeigenv_1skew_z.csv output=tile_207500_598000_1_1_skew separator=, skip=1 value_column=6

::r.out.gdal --overwrite input=tile_207500_598000_1_1_echo output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1_echo.tif
::r.out.gdal --overwrite input=tile_207500_598000_1_1_eig output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1_eig.tif
::r.out.gdal --overwrite input=tile_207500_598000_1_1_skew output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1_skew.tif

i.group group=groupRGB input=tile_207500_598000_1_1_echo,tile_207500_598000_1_1_eig,tile_207500_598000_1_1_skew
i.segment --overwrite group=groupRGB output=group_region_growsegmRGB threshold=0.4
r.out.gdal --overwrite input=group_region_growsegmRGB output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598000_1_1_group_region_growsegmRGB.tif

r.to.vect --overwrite -s input=group_region_growsegmRGB output=group_region_growsegmRGB_poly type=area
v.out.ogr --overwrite input=group_region_growsegmRGB_poly type=area output=C:\zsofia\Amsterdam\Geobia\Features\group_region_growsegmRGB_poly.shp