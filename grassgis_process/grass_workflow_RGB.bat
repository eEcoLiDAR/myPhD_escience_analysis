::r.in.xyz -s -g separator="," in=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1.las_pulse_penetration_ratio_Curviture_sigma_z.csv skip=1
::g.region n=598499.94 s=598000 e=208499.98 w=208000

r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1.las_pulse_penetration_ratio_Curviture_sigma_z.csv output=tile_208000_598000_1_1_pulse separator=, skip=1 value_column=4
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1.las_pulse_penetration_ratio_Curviture_sigma_z.csv output=tile_208000_598000_1_1_curv separator=, skip=1 value_column=5
r.in.xyz --overwrite input=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1.las_pulse_penetration_ratio_Curviture_sigma_z.csv output=tile_208000_598000_1_1_sigma separator=, skip=1 value_column=6

r.composite red=tile_208000_598000_1_1_pulse green=tile_208000_598000_1_1_curv blue=tile_208000_598000_1_1_sigma output=tile_208000_598000_1_1_RGB
r.out.gdal --overwrite input=tile_208000_598000_1_1_RGB output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_RGB.tif

r.out.gdal --overwrite input=tile_208000_598000_1_1_pulse output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_pulse.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_curv output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_curv.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_sigma output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_sigma.tif

i.group group=tile_208000_598000_1_1_groupRGB input=tile_208000_598000_1_1_pulse,tile_208000_598000_1_1_curv,tile_208000_598000_1_1_sigma

i.segment --overwrite group=tile_208000_598000_1_1_groupRGB output=tile_208000_598000_1_1_groupRGB_region_grow02 threshold=0.2 goodness=tile_208000_598000_1_1_groupRGB_region_grow02_goodness
i.segment --overwrite group=tile_208000_598000_1_1_groupRGB output=tile_208000_598000_1_1_groupRGB_region_grow04 threshold=0.4 goodness=tile_208000_598000_1_1_groupRGB_region_grow04_goodness
i.segment --overwrite group=tile_208000_598000_1_1_groupRGB output=tile_208000_598000_1_1_groupRGB_region_grow06 threshold=0.6 goodness=tile_208000_598000_1_1_groupRGB_region_grow06_goodness

r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow02 output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB02.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow04 output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB04.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow06 output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB06.tif

r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow02_goodness output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB02_goodness.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow04_goodness output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB04_goodness.tif
r.out.gdal --overwrite input=tile_208000_598000_1_1_groupRGB_region_grow06_goodness output=C:\zsofia\Amsterdam\Geobia\Workflow_30ofMarch\Features\tile_208000_598000_1_1_growsegmRGB06_goodness.tif

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


