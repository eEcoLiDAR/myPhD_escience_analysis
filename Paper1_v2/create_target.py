"""
@author: Zsofia Koma, UvA
Aim: create target point cloud for determining the cells
"""

import argparse
import os
import sys
import time

import laspy
from laspy.file import File
import numpy as np

# global variables

parser = argparse.ArgumentParser()
parser.add_argument('input', help='absolute path of input point cloud (las file)')
args = parser.parse_args()

filename=args.input
resolution=2.5
shift=1.25

# Create target point cloud

start1 = time.time()
# read las file

in_pc = File(filename+".las", mode='r')
in_pc_nparray = np.vstack([in_pc.x, in_pc.y, in_pc.z]).transpose()

print(("Number of points are: %s") % (in_pc_nparray.shape[0]))

# generate grid in 2D z==0 (for 2.5D analysis within cylinder)

min_x=np.min(in_pc_nparray[:,0])+shift
max_x=np.max(in_pc_nparray[:,0])+shift
step_x=resolution

min_y=np.min(in_pc_nparray[:,1])+shift
max_y=np.max(in_pc_nparray[:,1])+shift
step_y=resolution

bound_x = np.arange(min_x, max_x, step_x)
bound_y = np.arange(min_y, max_y, step_y)

target_x, target_y = np.meshgrid(bound_x, bound_y, indexing='ij')

# export as XYZ pcloud

x=np.ravel(target_x)
y=np.ravel(target_y)
z=np.ones(len(x))

false_intensity=np.zeros(len(x))

out_LAS = File(filename+"_target.las", mode = "w", header = in_pc.header)
out_LAS.x = x
out_LAS.y = y
out_LAS.z = z
out_LAS.intensity = false_intensity
out_LAS.close()

end1 = time.time()
difftime1=end1 - start1
print(("create target point: %f sec") % (difftime1))