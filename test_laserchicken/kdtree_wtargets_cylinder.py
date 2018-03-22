import argparse
import time
import pickle
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

print("------ Building kd-tree is started ------")

# Import
pc = read_las.read(args.input)
target = read_las.read(args.target)

print(("Number of points: %s ") % (pc[point]['x']['data'].shape[0]))
print(("Number of points in target: %s ") % (target[point]['x']['data'].shape[0]))

# Neighborhood calculation

start = time.time()
indices_cyl=compute_neighborhoods(pc, target, InfiniteCylinder(np.float(args.radius)))
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))

output = open(args.output, 'wb')
pickle.dump(indices_cyl, output)
output.close()
