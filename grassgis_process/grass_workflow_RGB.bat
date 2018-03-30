::r.in.xyz -s -g separator="," in=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1echo_ratioeigenv_1sigma_z.csv skip=1
::g.region n=598499.94 s=598000 e=208499.98 w=208000

r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1echo_ratioeigenv_1sigma_z.csv output=tile_208000_598000_1_1_echo separator=, skip=1 value_column=4
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1echo_ratioeigenv_1sigma_z.csv output=tile_208000_598000_1_1_eig separator=, skip=1 value_column=5
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1echo_ratioeigenv_1sigma_z.csv output=tile_208000_598000_1_1_sigma separator=, skip=1 value_column=6

r.composite red=tile_208000_598000_1_1_echo green=tile_208000_598000_1_1_eig blue=tile_208000_598000_1_1_sigma output=tile_208000_598000_1_1_RGB
r.out.gdal --overwrite input=tile_208000_598000_1_1_RGB output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_RGB.tif

r.out.gdal --overwrite input=tile_208000_598000_1_1_echo output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_echo.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_eig output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_eig.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_sigma output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_sigma.tif

i.group group=tile_208000_598000_1_1_groupRGB input=tile_208000_598000_1_1_echo,tile_208000_598000_1_1_eig,tile_208000_598000_1_1_sigma

i.segment --overwrite group=tile_208000_598000_1_1_groupRGB output=tile_208000_598000_1_1_groupRGB_region_grow02 threshold=0.2 goodness=tile_208000_598000_1_1_groupRGB_region_grow02_goodness
i.segment --overwrite group=tile_208000_598000_1_1_groupRGB output=tile_208000_598000_1_1_groupRGB_region_grow04 threshold=0.4 goodness=tile_208000_598000_1_1_groupRGB_region_grow04_goodness
i.segment --overwrite group=tile_208000_598000_1_1_groupRGB output=tile_208000_598000_1_1_groupRGB_region_grow06 threshold=0.6 goodness=tile_208000_598000_1_1_groupRGB_region_grow06_goodness

r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow02 output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB02.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow04 output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB04.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow06 output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB06.tif

r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow02_goodness output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB02_goodness.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow04_goodness output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB04_goodness.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow06_goodness output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB06_goodness.tif

i.segment.stats map=tile_208000_598000_1_1_groupRGB_region_grow02 csvfile=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB02_stat.csv area_measures=area, perimeter, compact_circle, compact_square
i.segment.stats map=tile_208000_598000_1_1_groupRGB_region_grow04 csvfile=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB04_stat.csv area_measures=area, perimeter, compact_circle, compact_square
i.segment.stats map=tile_208000_598000_1_1_groupRGB_region_grow06 csvfile=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB06_stat.csv area_measures=area, perimeter, compact_circle, compact_square

r.to.vect --overwrite -s input=tile_208000_598000_1_1_groupRGB_region_grow02 output=tile_207500_598500_region_growsegmRGB02_poly type=area
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB02_poly type=area output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_region_growsegmRGB02_poly.shp format=ESRI_Shapefile
r.to.vect --overwrite -s input=tile_208000_598000_1_1_groupRGB_region_grow02 output=tile_207500_598500_region_growsegmRGB02_point type=point
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB02_point type=point output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_region_growsegmRGB02_point.shp format=ESRI_Shapefile

r.to.vect --overwrite -s input=tile_208000_598000_1_1_groupRGB_region_grow04 output=tile_207500_598500_region_growsegmRGB04_poly type=area
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB04_poly type=area output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_region_growsegmRGB04_poly.shp format=ESRI_Shapefile
r.to.vect --overwrite -s input=tile_208000_598000_1_1_groupRGB_region_grow04 output=tile_207500_598500_region_growsegmRGB04_point type=point
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB04_point type=point output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_region_growsegmRGB04_point.shp format=ESRI_Shapefile

r.to.vect --overwrite -s input=tile_208000_598000_1_1_groupRGB_region_grow06 output=tile_207500_598500_region_growsegmRGB06_poly type=area
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB06_poly type=area output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_region_growsegmRGB06_poly.shp format=ESRI_Shapefile
r.to.vect --overwrite -s input=tile_208000_598000_1_1_groupRGB_region_grow06 output=tile_207500_598500_region_growsegmRGB06_point type=point
v.out.ogr --overwrite input=tile_207500_598500_region_growsegmRGB06_point type=point output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_region_growsegmRGB06_point.shp format=ESRI_Shapefile


