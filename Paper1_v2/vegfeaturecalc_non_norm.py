"""
@author: Zsofia Koma, UvA
Aim: calculate vegetation related features using laserchicken within a cell

"""

import argparse
import os
import sys
import time

import laspy
from laspy.file import File

import numpy as np

#sys.path.insert(0, "D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/")
sys.path.insert(0, "D:/Koma/GitHub/eEcoLiDAR/")

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.volume_specification import Cell,InfiniteCylinder
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.feature_extractor import compute_features
from laserchicken.write_ply import write

# global variables

parser = argparse.ArgumentParser()
parser.add_argument('input', help='absolute path of input point cloud (las file)')
args = parser.parse_args()

filename=args.input
resolution=2.5

# Calculate features

start1 = time.time()
print("------ Import is started ------")

pc = read_las.read(filename+".las")
target = read_las.read(filename+"_target.las")
radius=resolution

print(("Number of points: %s ") % (pc[point]['x']['data'].shape[0]))
print(("Number of points in target: %s ") % (target[point]['x']['data'].shape[0]))

print("------ Computing neighborhood is started ------")

#compute_neighborhoods is now a generator. To get the result of a generator the user
#needs to call next(compute_neighborhoods). The following shows how to get the results.
#
#indices_cyl=compute_neighborhoods(pc, target, Cell(np.float(args.radius)))
#
neighbors=compute_neighborhoods(pc, target, Cell(np.float(radius)))
iteration=0
target_idx_base=0
for x in neighbors:
    print("Computed neighborhoods list length at iteration %d is: %d" % (iteration,len(x)))

    print("------ Feature calculation is started ------")
    compute_features(pc, x, target_idx_base, target, ['min_z','max_z','mean_z','median_z','perc_10','perc_30','perc_50','perc_70','perc_90','point_density','eigenv_1','eigenv_2','eigenv_3','z_entropy','std_z','var_z','skew_z','kurto_z','pulse_penetration_ratio','density_absolute_mean'], Cell(np.float(radius)))
    target_idx_base+=len(x)

    iteration+=1


write(target,filename+str(resolution)+"m_cell.ply")

end1 = time.time()
difftime1=end1 - start1
print(("feature calc: %f sec") % (difftime1))