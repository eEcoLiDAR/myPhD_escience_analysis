"""
Aim: 
1. Read shapefile (training)
2. Extract point cloud related to the polygons
3. Add class label to the extracted point cloud
4. Save as a pandas dataframe
5. Boxplot, scatterplot, histogram
"""
import sys
sys.path.insert(0, 'C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/eEcoLiDAR/')
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

from shapely.geometry import Point
from geopandas.tools import sjoin

#from laserchicken import read_ply
#from laserchicken.spatial_selections import points_in_polygon_wkt

import matplotlib.pyplot as plt
import seaborn as sns

crs = {'init': 'epsg:28992'}

training = gpd.GeoDataFrame.from_file('C:/zsofia/Amsterdam/Geobia/Result/training1.shp',crs=crs)
#pc_wfea = read_ply.read('C:/zsofia/Amsterdam/Geobia/Result/06en2_merged_kiv3._ground_height_kiv_kiv._cylinder2.5.ply')
#pc_sub = points_in_polygon_wkt(pc, "POLYGON((196550 446510,196550 446540,196580 446540,196580 446510,196550 446510))")

pc_wfea = pd.read_csv('C:/zsofia/Amsterdam/Geobia/Result/06en2_merged_kiv3.csv',sep=',')
pc_wfea['geometry'] = pc_wfea.apply(lambda z: Point(z.X, z.Y), axis=1)
pc_wfea = gpd.GeoDataFrame(pc_wfea,crs=crs)

pointInPolys = sjoin(pc_wfea , training, how='left',op='within')

pointInPolys.boxplot(column='echo_ratio',by='class')
plt.show()
pointInPolys.boxplot(column='sigma_z',by='class')
plt.show()
pointInPolys.boxplot(column='pulse_penetration_ratio',by='class')
plt.show()
pointInPolys.boxplot(column='std_z',by='class')
plt.show()
pointInPolys.boxplot(column='kurto_z',by='class')
plt.show()

#pointInPolys.to_csv('C:/zsofia/Amsterdam/Geobia/Result/output.csv')




