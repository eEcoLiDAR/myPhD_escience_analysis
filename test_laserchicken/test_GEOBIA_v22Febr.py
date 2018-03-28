## Fix the path (temporary)
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('path_of_laserchicken', help='The path of laserchicken')
parser.add_argument('input', help='absolute path of input point cloud')
parser.add_argument('output', help='absolute path of output point cloud')
args = parser.parse_args()

import sys
sys.path.insert(0, args.path_of_laserchicken)

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.volume_specification import Sphere, InfiniteCylinder
from laserchicken.feature_extractor import compute_features

import numpy as np
import pandas as pd
import time

# Import
pc = read_las.read(args.input)

# Neighborhood calculation

start = time.time()
#compute_neighborhoods is now a generator. To get the result of a generator the user
#needs to call next(compute_neighborhoods). The following shows how to get the results.
#
#indices_cyl=compute_neighborhoods(pc, target, InfiniteCylinder(np.float(args.radius)))
#
compute_neighborhoods=compute_neighborhoods(pc, pc, Sphere(2.5))
indices_cyl=[]
for x in compute_neighborhoods:
  print ("Iteration %d" % num_iterations)
  indices_cyl += x
  num_iterations+=1
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))
print("Computed neighborhoods list length is: %d" % len(indices_cyl))

start1 = time.time()

compute_features(pc, indices_cyl, pc, ['max_z','min_z','mean_z','median_z','std_z','var_z','range','coeff_var_z','skew_z','kurto_z',
                                               'eigenv_1','eigenv_2','eigenv_3','z_entropy','sigma_z','perc_20','perc_40','perc_60','perc_80'], Sphere(2.5))

feadataframe=pd.DataFrame({'_x':pc[point]['x']['data'],'_y':pc[point]['y']['data'],'_z':pc[point]['z']['data'],
                           'max_z':pc[point]['max_z']['data'],'min_z':pc[point]['min_z']['data'], 'mean_z':pc[point]['mean_z']['data'],
                           'median_z':pc[point]['median_z']['data'],'std_z':pc[point]['std_z']['data'], 'var_z':pc[point]['var_z']['data'],
                           'range':pc[point]['range']['data'],'coeff_var_z':pc[point]['coeff_var_z']['data'], 'skew_z':pc[point]['skew_z']['data'],'kurto_z':pc[point]['kurto_z']['data'],
                           'eigenv_1':pc[point]['eigenv_1']['data'],'eigenv_2':pc[point]['eigenv_2']['data'], 'eigenv_3':pc[point]['eigenv_3']['data'],
                           'z_entropy':pc[point]['z_entropy']['data'],'sigma_z':pc[point]['sigma_z']['data'], 'perc_20':pc[point]['perc_20']['data'],
                           'perc_40':pc[point]['perc_40']['data'],'perc_60':pc[point]['perc_60']['data'], 'perc_80':pc[point]['perc_80']['data']})

feadataframe.to_csv(args.output,sep=";",index=False)

end1 = time.time()
difftime1=end1 - start1
print(("feature calc: %f sec") % (difftime1))

