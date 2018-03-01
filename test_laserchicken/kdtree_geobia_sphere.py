import argparse
import time
import pickle
import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument('path_of_laserchicken', help='The path of laserchicken')
parser.add_argument('input', help='absolute path of input point cloud')
parser.add_argument('output', help='absolute path of output point cloud')
parser.add_argument('radius', help='radius of the volume')
args = parser.parse_args()

import sys
sys.path.insert(0, args.path_of_laserchicken)

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.volume_specification import Sphere
from laserchicken.compute_neighbors import compute_neighborhoods

print("------ Building kd-tree is started ------")

# Import
pc = read_las.read(args.input)

print(("Number of points: %s ") % (pc[point]['x']['data'].shape[0]))

# Neighborhood calculation

start = time.time()
indices_cyl=compute_neighborhoods(pc, pc, Sphere(np.float(args.radius)))
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))

output = open(args.output, 'wb')
pickle.dump(indices_cyl, output)
output.close()