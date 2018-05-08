"""
@author: Zsofia Koma, UvA
Aim: generate artificial target points 

Input: las file (environmental point cloud)
Output: artificial target point cloud 

Example usage: python generate_targets.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/Results/Geobia/ 06en2_merged_kiv3._ground_height_kiv_kiv.las 06en2_merged_kiv3._ground_height_kiv_kiv_targ
et.txt
then txt->las txt2las -i D:\Results\Geobia\06en2_merged_kiv3._ground_height_kiv_kiv_target.txt -o D:\Results\Geobia\06en2_merged_kiv3._ground_height_kiv_kiv_target.las -parse xyzitc

ToDo: 
"""

import sys
import argparse

import laspy
from laspy.file import File

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

parser = argparse.ArgumentParser()
parser.add_argument('input', help='absolute path of input point cloud')
parser.add_argument('output', help='absolute path of output point cloud')
args = parser.parse_args()

# read las file

in_pc = File(args.input, mode='r')
in_pc_nparray = np.vstack([in_pc.x, in_pc.y, in_pc.z]).transpose()

print(("Number of points are: %s") % (in_pc_nparray.shape[0]))

# generate grid in 2D z==0 (for 2.5D analysis within cylinder)

min_x=np.min(in_pc_nparray[:,0])
max_x=np.max(in_pc_nparray[:,0])
step_x=1

min_y=np.min(in_pc_nparray[:,1])
max_y=np.max(in_pc_nparray[:,1])
step_y=1

bound_x = np.arange(min_x, max_x, step_x)
bound_y = np.arange(min_y, max_y, step_y)

target_x, target_y = np.meshgrid(bound_x, bound_y, indexing='ij')

#plt.scatter(target_x, target_y)
#plt.show()

# export as XYZ pcloud

x=np.ravel(target_x)
y=np.ravel(target_y)
z=np.ones(len(x))

false_intensity=np.zeros(len(x))

#plt.scatter(x,y)
#plt.show()

out_LAS = File(args.output, mode = "w", header = in_pc.header)
out_LAS.x = x
out_LAS.y = y
out_LAS.z = z
out_LAS.intensity = false_intensity
out_LAS.close()