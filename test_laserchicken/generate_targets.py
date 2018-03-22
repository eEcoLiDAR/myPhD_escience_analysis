import sys
import argparse

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

parser = argparse.ArgumentParser()
parser.add_argument('path_of_laserchicken', help='The path of laserchicken')
parser.add_argument('path', help='The path of files')
parser.add_argument('input', help='absolute path of input point cloud')
parser.add_argument('output', help='absolute path of output point cloud')
args = parser.parse_args()

sys.path.insert(0, args.path_of_laserchicken)

from laserchicken import read_las
from laserchicken.keys import point

pc = read_las.read(args.path+args.input)

print(("Number of points: %s ") % (pc[point]['x']['data'].shape[0]))

# generate grid in 2D z==0 (for 2.5D analysis within cylinder)

min_x=np.min(pc[point]['x']['data'])
max_x=np.max(pc[point]['x']['data'])
step_x=1

min_y=np.min(pc[point]['y']['data'])
max_y=np.max(pc[point]['y']['data'])
step_y=1

bound_x = np.arange(min_x, max_x, step_x)
bound_y = np.arange(min_y, max_y, step_y)

target_x, target_y = np.meshgrid(bound_x, bound_y, indexing='ij')

#plt.scatter(target_x, target_y)
#plt.show()

# export as XYZ pcloud

x=np.ravel(target_x)
y=np.ravel(target_y)
z=np.zeros(len(x))

false_intensity=np.zeros(len(x))
false_gpstime=np.zeros(len(x))
false_classification=np.zeros(len(x))

#plt.scatter(x,y)
#plt.show()

xyz=np.vstack((x,y,z,false_intensity,false_gpstime,false_classification)).T

np.savetxt(args.path+args.output, xyz, fmt='%1.5f %1.5f %1.5f %1.5f %1.5f %1.5f')

"""
Example usage: python generate_targets.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/Results/Geobia/ 06en2_merged_kiv3._ground_height_kiv_kiv.las 06en2_merged_kiv3._ground_height_kiv_kiv_targ
et.txt

then txt->las txt2las -i D:\Results\Geobia\06en2_merged_kiv3._ground_height_kiv_kiv_target.txt -o D:\Results\Geobia\06en2_merged_kiv3._ground_height_kiv_kiv_target.las -parse xyzitc
"""
