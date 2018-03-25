"""
@author: Zsofia Koma, UvA
Aim: 

Input: laserchicken ply file with the calculated features (currently I am only using z) 
Output: vertical profile for the defined id

Example usage (from command line): python verticalprofile_forsegments.py C:/zsofia/Amsterdam/Geobia/Features/ group1_region_growsegm_poly_exp2.shp tile_
207500_598000_1_1.las.ply

ToDo: 
1. shp from grass directly not readable with geopandas just after a qgis transformation
2. total amateur vertical profile estimation (write out read back because of the tuple format, only one in one time)
"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

from shapely.geometry import Point
from geopandas.tools import sjoin

import matplotlib.pyplot as plt
import seaborn as sns

def nofp_per_perc(z,step):
    nof_perc_to_total=""

    for i in range(0,np.int(max(z)),step):
        nof_perc_to_total_calc=(z[(np.where((z>i)&(z<i+step)))].shape[0]/z.shape[0])*100
        nof_perc_to_total += "%s,%s \n" % (nof_perc_to_total_calc,i+step/2)

    return nof_perc_to_total

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('segments', help='polygon shape file with class')
parser.add_argument('features', help='point cloud with features')
parser.add_argument('segmentid', help='id of the segment')
args = parser.parse_args()

crs = {'init': 'epsg:28992'}

segments = gpd.GeoDataFrame.from_file(args.path+args.segments,crs=crs)

pc_wfea = pd.read_csv(args.path+args.features,sep=' ',names=['X','Y','Z','coeff_var_z','density_absolute_mean','echo_ratio','eigenv_1','eigenv_2','eigenv_3','gps_time','intensity','kurto_z','max_z','mean_z',
'median_z','min_z','normal_vector_1','normal_vector_2','normal_vector_3','pulse_penetration_ratio','range','raw_classification','sigma_z','skew_z','slope','std_z','var_z'],skiprows=39)
pc_wfea['geometry'] = pc_wfea.apply(lambda z: Point(z.X, z.Y), axis=1)
pc_wfea = gpd.GeoDataFrame(pc_wfea,crs=crs)

pointInPolys = sjoin(pc_wfea , segments, how='left',op='within')

segment_id=np.float(args.segmentid)

pointInPolys_sel=pointInPolys[(pointInPolys["fid"]==segment_id)]

#plt.scatter(pointInPolys_sel['X'].values,pointInPolys_sel['Y'].values)
#plt.show()

z=pointInPolys_sel['Z'].values
step=1

nof_perc_to_total=nofp_per_perc(z,step)
fileout = open(args.path+str(segment_id)+'nof_perc_to_total.txt', "w")
fileout.write(nof_perc_to_total)
fileout.close()

pc_profile = pd.read_csv(args.path+str(segment_id)+'nof_perc_to_total.txt',sep=',',names=['frequency','height'])
#print(pc_profile.head())

plt.plot(pc_profile['frequency'].values,pc_profile['height'].values)
plt.show()

