from laserchicken import read_las
from laserchicken import write_ply
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.volume_specification import Sphere, InfiniteCylinder
from laserchicken.feature_extractor import compute_features

import numpy as np
import pandas as pd
import time

# Import
pc = read_las.read("D:/NAEM/Data/ALS_AHN2/SelStudyArea2_v2.las")
pc_sub = points_in_polygon_wkt(pc, "POLYGON((196550 446510,196550 446540,196580 446540,196580 446510,196550 446510))")

# Neighborhood calculation

start = time.time()
indices_cyl=compute_neighborhoods(pc_sub, pc_sub, InfiniteCylinder(5))
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))

start1 = time.time()

compute_features(pc_sub, indices_cyl, pc_sub, ['max_z','min_z','mean_z','median_z','std_z','var_z','range','coeff_var_z','skew_z','kurto_z',
                                               'eigenv_1','eigenv_2','eigenv_3','z_entropy','sigma_z','perc_20','perc_40','perc_60','perc_80'], InfiniteCylinder(5))

feadataframe=pd.DataFrame({'max_z':pc_sub[point]['max_z']['data'],'min_z':pc_sub[point]['min_z']['data'], 'mean_z':pc_sub[point]['mean_z']['data'],
                           'median_z':pc_sub[point]['median_z']['data'],'std_z':pc_sub[point]['std_z']['data'], 'var_z':pc_sub[point]['var_z']['data'],
                           'range':pc_sub[point]['range']['data'],'coeff_var_z':pc_sub[point]['coeff_var_z']['data'], 'skew_z':pc_sub[point]['skew_z']['data'],'kurto_z':pc_sub[point]['kurto_z']['data'],
                           'eigenv_1':pc_sub[point]['eigenv_1']['data'],'eigenv_2':pc_sub[point]['eigenv_2']['data'], 'eigenv_3':pc_sub[point]['eigenv_3']['data'],
                           'z_entropy':pc_sub[point]['z_entropy']['data'],'sigma_z':pc_sub[point]['sigma_z']['data'], 'perc_20':pc_sub[point]['perc_20']['data'],
                           'perc_40':pc_sub[point]['perc_40']['data'],'perc_60':pc_sub[point]['perc_60']['data'], 'perc_80':pc_sub[point]['perc_80']['data'],
                           'z':pc_sub[point]['z']['data'],'y':pc_sub[point]['y']['data'],'x':pc_sub[point]['x']['data']})

feadataframe.to_csv('D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/SelStudyArea2_withfea2.csv',sep=";",index=False)

#'eigenv_1':pc_sub[point]['eigenv_1']['data'],'eigenv_2':pc_sub[point]['eigenv_2']['data'], 'eigenv_3':pc_sub[point]['eigenv_3']['data'],

end1 = time.time()
difftime1=end1 - start1
print(("feature calc: %f sec") % (difftime1))

