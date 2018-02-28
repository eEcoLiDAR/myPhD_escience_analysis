import argparse
import time
import pickle

parser = argparse.ArgumentParser()
parser.add_argument('path_of_laserchicken', help='The path of laserchicken')
parser.add_argument('input', help='absolute path of input point cloud')
parser.add_argument('output', help='absolute path of output point cloud')
args = parser.parse_args()

import sys
sys.path.insert(0, args.path_of_laserchicken)

from laserchicken import read_las
from laserchicken.volume_specification import Sphere, InfiniteCylinder
from laserchicken.compute_neighbors import compute_neighborhoods

# Import
pc = read_las.read(args.input)

# Neighborhood calculation

start = time.time()
indices_cyl=compute_neighborhoods(pc, pc, Sphere(2.5))
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))

output = open(args.output, 'wb')
pickle.dump(indices_cyl, output)
output.close()