import argparse
import time
import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument('path_of_laserchicken', help='The path of laserchicken')
parser.add_argument('input', help='absolute path of input point cloud')
parser.add_argument('target', help='target points as las file')
parser.add_argument('radius', help='radius of the volume')
parser.add_argument('output', help='absolute path of output point cloud')
args = parser.parse_args()

import sys
sys.path.insert(0, args.path_of_laserchicken)

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.volume_specification import InfiniteCylinder
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.feature_extractor import compute_features
from laserchicken.write_ply import write

print("------ Building kd-tree is started ------")

# Import
pc = read_las.read(args.input)
target = read_las.read(args.target)

print(("Number of points: %s ") % (pc[point]['x']['data'].shape[0]))
print(("Number of points in target: %s ") % (target[point]['x']['data'].shape[0]))

# Neighborhood calculation

start = time.time()
#compute_neighborhoods is now a generator. To get the result of a generator the user
#needs to call next(compute_neighborhoods). The following shows how to get the results.
#
#indices_cyl=compute_neighborhoods(pc, target, InfiniteCylinder(np.float(args.radius)))
#
neighbors=compute_neighborhoods(pc, target, InfiniteCylinder(np.float(args.radius)))
iteration=0
target_idx_base
for x in neighbors:
  end = time.time()
  difftime=end - start
  print(("build kd-tree: %f sec") % (difftime))
  print("Computed neighborhoods list length at iteration %d is: %d" % (iteration, len(indices_cyl)))

  # Calculate features
  start1 = time.time()
  compute_features(pc, indices_cyl, target_idx_base, target, ['max_z','min_z','mean_z','median_z','std_z','var_z','range','coeff_var_z','skew_z','kurto_z',
'sigma_z','perc_20','perc_40','perc_60','perc_80','echo_ratio','pulse_penetration_ratio','density_absolute_mean'], InfiniteCylinder(np.float(args.radius)))
  end1 = time.time()
  difftime1=end1 - start1
  print(("feature calc: %f sec") % (difftime1))
  target_idx_base+=len(x)
  iteration+=1

write(target,args.output)
