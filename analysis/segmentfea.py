"""
@author: Zsofia Koma, UvA
Aim: 

Input: laserchicken ply file with the calculated features (currently I am only using z) 
Output: aggregated features per segments --> shp

Example usage (from command line): python segmentfea.py C:/zsofia/Amsterdam/Geobia/Features/ group1_region_growsegm_poly_exp2.shp tile_207500_598000_1_1
.las.ply

ToDo: 
1. shp from grass directly not readable with geopandas just after a qgis transformation

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

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('segments', help='polygon shape file with class')
parser.add_argument('features', help='point cloud with features')
args = parser.parse_args()

crs = {'init': 'epsg:28992'}

segments = gpd.GeoDataFrame.from_file(args.path+args.segments,crs=crs)

pc_wfea = pd.read_csv(args.path+args.features,sep=' ',names=['X','Y','Z','coeff_var_z','density_absolute_mean','echo_ratio','eigenv_1','eigenv_2','eigenv_3','gps_time','intensity','kurto_z','max_z','mean_z',
'median_z','min_z','normal_vector_1','normal_vector_2','normal_vector_3','pulse_penetration_ratio','range','raw_classification','sigma_z','skew_z','slope','std_z','var_z'],skiprows=39)
pc_wfea['geometry'] = pc_wfea.apply(lambda z: Point(z.X, z.Y), axis=1)
pc_wfea = gpd.GeoDataFrame(pc_wfea,crs=crs)

pointInPolys = sjoin(pc_wfea , segments, how='left',op='within')
#print(pointInPolys.dtypes)

feamean_insegments=pointInPolys.groupby(['cat']).mean()
#print(feamean_insegments.dtypes)

feawith_segments = segments.merge(feamean_insegments, on='value')
#print(feawith_segments.head())
feawith_segments.to_file(args.path+args.features+"wfea.shp", driver='ESRI Shapefile')