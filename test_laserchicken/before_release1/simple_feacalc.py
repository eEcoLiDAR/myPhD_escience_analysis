"""
Example usage: python simple_feacalc.py D:/Results/Geobia/ 06en2_merged_kiv3._ground_height_kiv_kiv
"""
import argparse

import pandas as pd
import numpy as np

from laspy.file import File
from scipy.spatial import cKDTree

import matplotlib.pyplot as plt
import matplotlib.cm as cm
from mpl_toolkits.mplot3d import Axes3D

parser = argparse.ArgumentParser()
parser.add_argument('path', help='The path of files')
parser.add_argument('input', help='absolute path of input point cloud')
args = parser.parse_args()

inFile = File(args.path+args.input+'.las', mode='r')

points = np.vstack([inFile.x, inFile.y, inFile.z]).transpose()

print(np.min(inFile.x),np.max(inFile.x))
print(np.min(inFile.z),np.max(inFile.z))

# Cylinder

radius = 0.5
kdtree = cKDTree(points[:,0:2])
point_neighbours_rad = kdtree.query_ball_point(points[:,0:2], radius)

print(points[:,0:2].shape)

n_points=len(points)
print(n_points)

max_z=np.zeros(n_points)


for i in range(n_points):
	local_points = points[point_neighbours_rad[i]]
	
	max_z[i]=np.max(local_points[:,2])
	
print(len(max_z))

pcloud_wfea={}
pcloud_wfea["x"]=inFile.X
pcloud_wfea["y"]=inFile.Y
pcloud_wfea["z"]=inFile.Z
pcloud_wfea["max_z"]=max_z

pcloud_wfea=pd.DataFrame(pcloud_wfea)
pcloud_wfea=pcloud_wfea[["x","y","z","max_z"]]

#print(pcloud_wfea)

pcloud_wfea.to_csv(args.path+args.input+'_withfea.csv',sep=";",index=False)