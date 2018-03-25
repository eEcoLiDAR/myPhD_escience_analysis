r.in.xyz -s -g separator="," in=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1echo_ratioeigenv_1kurto_z.csv skip=1
g.region n=598999.94 s=598500 e=207999.98 w=207622.66

r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1echo_ratioeigenv_1kurto_z.csv output=tile_207500_598500_1_1_echo separator=, skip=1 value_column=4
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1echo_ratioeigenv_1kurto_z.csv output=tile_207500_598500_1_1_eig separator=, skip=1 value_column=5
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1echo_ratioeigenv_1kurto_z.csv output=tile_207500_598500_1_1_pulse_pen separator=, skip=1 value_column=6

r.out.gdal --overwrite input=tile_207500_598500_1_1_echo output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1_echo.tif
r.out.gdal --overwrite input=tile_207500_598500_1_1_eig output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1_eig.tif
r.out.gdal --overwrite input=tile_207500_598500_1_1_kurto_z output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1_kurto_z.tif

i.group group=tile_207500_598500_groupRGB input=tile_207500_598500_1_1_echo,tile_207500_598500_1_1_eig,tile_207500_598500_1_1_kurto_z
i.segment --overwrite group=tile_207500_598500_groupRGB output=tile_207500_598500_region_growsegmRGB threshold=0.4
r.out.gdal --overwrite input=tile_207500_598500_region_growsegmRGB output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_1_1_group_region_growsegmRGB3.tif

r.to.vect --overwrite -s input=tile_207500_598500_region_growsegmRGB output=tile_207500_598500_region_growsegmRGB_poly type=area
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB_poly type=area output=C:\zsofia\Amsterdam\Geobia\Features\tile_207500_598500_region_growsegmRGB_poly3.shp