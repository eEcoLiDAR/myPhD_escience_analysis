"""
@author: Zsofia Koma, UvA
Aim: 

Input: laserchicken ply file with the calculated features (currently I am only using z) 
Output: aggregated features per segments --> shp

Example usage (from command line): python calc_segmentfea.py C:/zsofia/Amsterdam/Geobia/Workflow_30ofMarch/Features/ tile_208000_598000_1_1_region_grows
egmRGB_poly tile_208000_598000_1_1.las tile_208000_598000_1_1_region_growsegmRGB_pointwlabeledsegment

ToDo: 

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
parser.add_argument('classes', help='point cloud with features (as point shp)')
args = parser.parse_args()

crs = {'init': 'epsg:28992'}

# Import
segments = gpd.GeoDataFrame.from_file(args.path+args.segments+'.shp',crs=crs)

"""
pc_wfea = pd.read_csv(args.path+args.features+'.ply',sep=' ',names=['X','Y','Z','coeff_var_z','density_absolute_mean','echo_ratio','eigenv_1','eigenv_2','eigenv_3','gps_time','intensity','kurto_z','max_z','mean_z',
'median_z','min_z','normal_vector_1','normal_vector_2','normal_vector_3','pulse_penetration_ratio','range','raw_classification','sigma_z','skew_z','slope','std_z','var_z'],skiprows=39)
"""
pc_wfea =pd.read_csv(args.path+args.features,sep=',')
pc_wfea['geometry'] = pc_wfea.apply(lambda z: Point(z.X, z.Y), axis=1)
pc_wfea = gpd.GeoDataFrame(pc_wfea,crs=crs)

segments_wlabel = gpd.GeoDataFrame.from_file(args.path+args.classes+'.shp',crs=crs)
segments_wlabel['Prob'] = segments_wlabel['Highestfre']/ segments_wlabel['Sumfreq']
segments_wlabel.drop_duplicates('value')

# Assign classes to segment polygon
labeled_segments = segments.merge(segments_wlabel[['value','Open water','Struweel','Bos','Grasland','Landriet,','Landriet_1','Waterriet','Highestfre','Sumfreq','Highestid','Prob']], on='value')
print(labeled_segments.dtypes)

labeled_segments.drop_duplicates('value').to_file(args.path+args.segments+"wlabel.shp", driver='ESRI Shapefile')

# Assign aggregated features to polygon

pointInPolys = sjoin(pc_wfea , segments, how='left',op='within')

# Calculate aggreagted statistical features
fea_insegments_mean=pointInPolys.groupby('value')['echo_ratio','Planarity','Sphericity','Curviture','kurto_z','max_z','mean_z','median_z','pulse_penetration_ratio','range','sigma_z','skew_z','std_z','var_z'].mean().add_prefix('mean_').reset_index()
fea_insegments_std=pointInPolys.groupby('value')['echo_ratio','Planarity','Sphericity','Curviture','kurto_z','max_z','mean_z','median_z','pulse_penetration_ratio','range','sigma_z','skew_z','std_z','var_z'].std(ddof=0).add_prefix('std_').reset_index()
fea_insegments_median=pointInPolys.groupby('value')['echo_ratio','Planarity','Sphericity','Curviture','kurto_z','max_z','mean_z','median_z','pulse_penetration_ratio','range','sigma_z','skew_z','std_z','var_z'].median().add_prefix('median_').reset_index()

fea_insegments1 = fea_insegments_mean.merge(fea_insegments_std, on='value')
fea_insegments = fea_insegments1.merge(fea_insegments_median, on='value')
fea_insegments = fea_insegments.drop_duplicates('value')

# Calculate shape geometry features
labeled_segments['poly_area']=labeled_segments['geometry'].area

feawith_segments = labeled_segments.merge(fea_insegments, on='value')
feawith_segments.drop_duplicates('value').to_file(args.path+args.features+"wfea_wlabel.shp", driver='ESRI Shapefile')
