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

print("------ Import is started ------")

pc = read_las.read(args.input)
target = read_las.read(args.target)

print(("Number of points: %s ") % (pc[point]['x']['data'].shape[0]))
print(("Number of points in target: %s ") % (target[point]['x']['data'].shape[0]))

print("------ Computing neighborhood is started ------")

start = time.time()
num_iterations=0

#compute_neighboorhoods is now a generator. To get the result of a generator the user
#needs to call next(compute_neighboorhoods). The following shows how to get the results.
#
#indices_cyl=compute_neighborhoods(pc, target, InfiniteCylinder(np.float(args.radius)))
#
compute_neighborhoods=compute_neighborhoods(pc, target, InfiniteCylinder(np.float(args.radius)))
indices_cyl=[]
for x in compute_neighborhoods:
  print ("Iteration %d" % num_iterations)
  indices_cyl += x
  num_iterations+=1
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))
print("Computed neighborhoods list length is: %d" % len(indices_cyl))

print("------ Feature calculation is started ------")

start1 = time.time()

compute_features(pc, indices_cyl, target, ['max_z','echo_ratio','eigenv_1', 'eigenv_2', 'eigenv_3',
'normal_vector_1','normal_vector_2','normal_vector_3','slope','pulse_penetration_ratio','sigma_z'], InfiniteCylinder(np.float(args.radius)))

end1 = time.time()
difftime1=end1 - start1
print(("feature calc: %f sec") % (difftime1))

write(target,args.output)
