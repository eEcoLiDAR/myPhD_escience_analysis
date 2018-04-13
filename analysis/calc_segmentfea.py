"""
@author: Zsofia Koma, UvA
Aim: calculate segment based-features

Input: polygon of the segmentation, point cloud based features (txt), point shape file with classes
Output: aggregated features per segments + label --> shp (polygon)

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

print("------ Import data------ ")

segments = gpd.GeoDataFrame.from_file(args.path+args.segments+'.shp',crs=crs)

pc_wfea =pd.read_csv(args.path+args.features,sep=',',names=['X','Y','Z','echo_ratio','Planarity','Sphericity','Curvature','kurto_z','max_z','mean_z','median_z','pulse_penetration_ratio','range','sigma_z','skew_z','std_z','var_z'])
pc_wfea['geometry'] = pc_wfea.apply(lambda z: Point(z.X, z.Y), axis=1)
pc_wfea = gpd.GeoDataFrame(pc_wfea,crs=crs)

segments_wlabel = gpd.GeoDataFrame.from_file(args.path+args.classes+'.shp',crs=crs)
segments_wlabel['Prob'] = segments_wlabel['Highestfre']/ segments_wlabel['Sumfreq']
segments_wlabel.drop_duplicates('value')

# Assign classes to segment polygon

print("------ Assign classes to segment polygon ------ ")

labeled_segments = segments.merge(segments_wlabel[['value','Open water','Struweel','Bos','Grasland','Landriet,','Landriet_1','Waterriet','Highestfre','Sumfreq','Highestid','Prob']], on='value')

labeled_segments.drop_duplicates('value').to_file(args.path+args.segments+"wlabel.shp", driver='ESRI Shapefile')

# Assign aggregated features to polygon

print("------ Calculate segment-based features (mean, std) ------ ")

pointInPolys = sjoin(pc_wfea , segments, how='left',op='within')

# Calculate aggreagted statistical features
fea_insegments_mean=pointInPolys.groupby('value')['echo_ratio','Planarity','Sphericity','Curvature','kurto_z','max_z','mean_z','median_z','pulse_penetration_ratio','range','sigma_z','skew_z','std_z','var_z'].mean().add_prefix('mean_').reset_index()
fea_insegments_std=pointInPolys.groupby('value')['echo_ratio','Planarity','Sphericity','Curvature','kurto_z','max_z','mean_z','median_z','pulse_penetration_ratio','range','sigma_z','skew_z','std_z','var_z'].std(ddof=0).add_prefix('std_').reset_index()

fea_insegments1 = fea_insegments_mean.merge(fea_insegments_std, on='value')
fea_insegments = fea_insegments1.drop_duplicates('value')

# Calculate shape geometry features
labeled_segments['poly_area']=labeled_segments['geometry'].area

# Export

print("------ Export ------ ")

feawith_segments = labeled_segments.merge(fea_insegments, on='value')
feawith_segments.drop_duplicates('value').to_file(args.path+args.segments+".wfea_wlabel.shp", driver='ESRI Shapefile')
