#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: Berend Wijers, UvA
some code cleaning was done by Zsofia Koma, UvA

Aim: Calculate 3D shape features related to eigenvalues (Weinmann et al., 2017) based on defined point cloud neighborhood

Input: las file
Output: las file with extra attributes

Example usage: python <path of the python file>/calc_start_v3.py tile_00003_norm2.las

for all files in the dir.: for f in *_land.las; do python D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/from_msc_students/calc_start_v3.py $f;done

"""
import sys
import os
import glob
import argparse

import gc
import queue

import glob
import psutil
from psutil import virtual_memory

import pandas as pd
import numpy as np
import scipy
from scipy import spatial

import math
from math import ceil

import time
import multiprocessing as mp
from concurrent.futures import ThreadPoolExecutor
import pickle

import laspy
from laspy.file import File

import pcfeatures_v3
from pcfeatures_v3 import par_calc

import lidar_funcs_v2
from lidar_funcs_v2 import hasNumbers

if __name__ == "__main__":

    ########### Define import las file ###########	
    parser = argparse.ArgumentParser()
    parser.add_argument('input', help='absolute path of input point cloud')
    args = parser.parse_args()
	
    print(args.input)

    input_file_path = args.input
        
    print("Memory mappping", os.path.basename(input_file_path), "...")
        
        #in_LAS = File(input_file_path[i], mode='r')
    in_LAS = File(input_file_path,mode='r')
        
        #Read out the size and therefore point density by len points divided by minx,y max xy distances.
    input_rows = 'max'

    if input_rows == "max" :
            #input_rows = None
        input_rows = int(len(in_LAS))
    else:
        input_rows = int(input_rows)


    ########### Explore LiDAR dataset ########### 
	
    print("Determining average point density of the input file")
        #Top left x coordinate
    left_x = np.min(in_LAS.x)
    top_y = np.min(in_LAS.y[np.where(in_LAS.x == left_x)])
        
    top_left_xy = np.array((left_x,top_y)) #used
    bot_left_xy = np.array((left_x,top_y+10))# used
    top_right_xy = np.array((left_x+10,top_y)) #used
    bot_right_xy = np.array((left_x+10,top_y+10)) #unused

    A = np.array((top_left_xy,bot_left_xy,top_left_xy,top_right_xy))
    B = np.array((top_right_xy,bot_right_xy,bot_left_xy,bot_right_xy))
        
    dd = np.sqrt(np.einsum('ij,ij->i',A-B,A-B))
        
    surf_area = dd[0] * dd[2]
        
    x_range = np.where(np.logical_and(in_LAS.x > top_left_xy[0], in_LAS.x < top_right_xy[0]))
        #y_range = np.where(np.logical_and(in_LAS.y > top_left_xy[1], in_LAS.y < bot_left_xy[1]))
        
    x_range_points = np.vstack(np.array([in_LAS.x[x_range],in_LAS.y[x_range]])).transpose()
        
        
    num_points = len(np.where(np.logical_and(x_range_points[:,1] > top_left_xy[1], x_range_points[:,1] < bot_left_xy[1]))[0])
        
        
    est_p_density = num_points/surf_area
        
    print("Estimated point density of this file is {} points/m2".format(est_p_density))
	
    fullstarttime = time.time()

	########### Define features ###########
    
    features = ['linearity', 'planarity', 'sphericity', 'omnivariance','anisotropy', 'eigenentropy','curvature']
    		
	########### Build up KDTree ###########
    
    print("Defining constants..")

    x = None
  
    #k = 5 0.5pt/m2
    #Callibration: K = 50 for 16 pt/m2
    #50 / 16 = 3.125 K's per point
        
    k = int(3.125 * est_p_density)
        
    #introduce a minimum K check (We need atleast 3 to do anything sensible!)
        
    if k < 3:
        k = 3
            
    print("Using K={}".format(k))
        
    print("Retrieving points to be processed from memory")
      
    points = np.vstack([in_LAS.x[0:input_rows],in_LAS.y[0:input_rows],in_LAS.z[0:input_rows]]).transpose()
    
        
    points_remain_prop = pd.DataFrame(np.vstack([in_LAS.intensity[0:input_rows],in_LAS.return_num[0:input_rows],in_LAS.num_returns[0:input_rows]]).transpose(),columns = ["intensity","return_number","number_of_returns"])
        #points_remain_prop = np.vstack([in_LAS.intensity[0:input_rows]]).transpose()
  
    print("Constructing KDTree")

    #evaluate options for quicker kdtree building
    tree=scipy.spatial.cKDTree(points,balanced_tree=0,compact_nodes=0)
    point_cloud_prop = pd.DataFrame([], columns=features)
	
	########### Set CPU usage ###########
	
    print("Multiprocessing")
 
    ##Dynamic chunk size based upon CPU/MEMORY ratio
    #500.000 seems to be good for 40 cores with 256 gb of ram.
    #256 GB / 40 = 6.4 GB/Core. 500.000 chunk size for K = 50 seems to be appropriate.
    #500.000 * 50 = 25.000.000 points per 6.4 GB/Core
    #25.000.000 / 6.4 = 3.906.205 points / GB/core
    #Values have been experimentally found.
	
    cpu_count = mp.cpu_count()
    mem=virtual_memory()
    print(mem)
    mem_tot = mem.free/1000000000
    print(mem_tot)
    cpu_mem_ratio = mem_tot/cpu_count
    print(cpu_mem_ratio)
    #K = 50
    #Apparently classifying points copy huge datasets to the memory (duplicates) as such a new variable H is introduced which is a integer between 0 - 1 to be able to scale.
	
    H = 0.5
    tot_points_cpu = (3906205*H) * cpu_mem_ratio
    print(tot_points_cpu)
    chunk = int(tot_points_cpu / k)
 
    print('Using chunk size:', chunk) 

    print("Total processors (hyper threading) available: ",mp.cpu_count(),". Using: ",cpu_count, "threads")
    
    #Maximum amount of points to go through
    
    num_points = len(points)

    #Number of points per CPU
    
    points_p_cpu = int(num_points/cpu_count)
    index_order = np.zeros((cpu_count,2),dtype=int)
    
    #Create an index work order per core
    
    print("Create start stop indexes for n_cpu_cores-1")
    
    for l in range(0,cpu_count):
    
        index_start = int(l * (points_p_cpu))
    
        index_order[l] = [int(index_start),int(index_start + (points_p_cpu))]
    
        if l == cpu_count-1:
    
            index_order[-1,1] = index_order[-1,1] + num_points%cpu_count              #Add remaining index to last cpu core

    print(index_order) 

    #Split the work in cpu_cores, let the function run with those parameters.
       
    print("Splitting work load across n_cpu-1")
    
    classification = False
    tensor_filter = False
    
    q = queue.Queue()
    
	########### Parallel computation ###########
	
    mod_start = time.time()
        
    with ThreadPoolExecutor(max_workers=cpu_count) as executor:
    
        futures = []
    
        for j in range(0,cpu_count):
    
            start = index_order[j,0]
    
            stop = index_order[j,1]

            print("Submitting thread", j)
            futures.append(executor.submit(par_calc, start, stop, points,points_remain_prop,tree,chunk,k,features,tensor_filter,classification))
    
           
    print(time.time()-mod_start)
        
    print("Done!")
       
    print("Retrieving results")
    mod_start = time.time()

    output = []
        
    for future in futures:
  
        output = future.result()
            #print(output)
        point_cloud_prop = pd.concat([point_cloud_prop,output],axis=0)
            #print(point_cloud_prop)
        
    print(time.time()-mod_start)
    print("Done!")
	
    fullendtime = time.time()
    fulldifftime=fullendtime - fullstarttime

    print(fulldifftime)
        
    del output
    
    print("Calculations are done, just finishing up here..")
    
    print("Keeping track of parameters used...")
    
        
 	########### Organizing the columns for output ###########
	
    print("Bundeling everything together..")
        
    points = pd.DataFrame(points,columns = ["x","y","z"])
    points_remain_prop = pd.DataFrame(points_remain_prop,columns = ["intensity","return_number","number_of_returns"])
        
    points = points.ix[point_cloud_prop.index]
    points_remain_prop = points_remain_prop.ix[point_cloud_prop.index]
    print(points_remain_prop.columns)
                
    point_cloud = points
    del points
    point_cloud = pd.concat([point_cloud,points_remain_prop],axis=1)
    del points_remain_prop
    point_cloud = pd.concat([point_cloud,point_cloud_prop],axis=1)
    del point_cloud_prop
        
    print(point_cloud.columns)
    print("removing duplicate columns")
    point_cloud = point_cloud.loc[:,~point_cloud.columns.duplicated()]
	
    point_cloud.to_csv(input_file_path[:-4]+'_ascii.csv',sep=',',index=False,header=True)

	########### Output ###########
	
    print("Outputting to las file")

    las_path_base = os.path.basename(input_file_path[:-4])
	
    out_filename = '%s_veg_classification_testparams.las' % (las_path_base)
    print(out_filename)
    out_LAS = File(out_filename, mode = "w", header = in_LAS.header)      
        
    #out_LAS.define_new_dimension(name="delta_z"+"_"+str(k), data_type=9, description= "Spatial feature")
    #out_LAS.define_new_dimension(name="std_z"+"_"+str(k), data_type=9, description= "Spatial feature")
    #out_LAS.define_new_dimension(name="radius"+"_"+str(k), data_type=9, description= "Spatial feature")
    #out_LAS.define_new_dimension(name="density"+"_"+str(k), data_type=9, description= "Spatial feature")
    #out_LAS.define_new_dimension(name="norm_z"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="linearity"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="planarity"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="sphericity"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="omnivariance"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="anisotropy"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="eigenentropy"+"_"+str(k), data_type=9, description= "Spatial feature")
    #out_LAS.define_new_dimension(name="sum_eigenvalues"+"_"+str(k), data_type=9, description= "Spatial feature")
    out_LAS.define_new_dimension(name="curvature"+"_"+str(k), data_type=9, description= "Spatial feature")
    #out_LAS.define_new_dimension(name="classification"+"_"+str(k),data_type=9, description="reference")
        
    print(point_cloud.columns)

    out_LAS.x = point_cloud['x']
        #point_cloud.drop('x')
        
    out_LAS.y = point_cloud['y']
    out_LAS.z = point_cloud['z']
    out_LAS.intensity = point_cloud['intensity'] 
    out_LAS.return_num = point_cloud['return_number']
        #print(point_cloud["number_of_returns"])
    point_cloud["number_of_returns"] = point_cloud["number_of_returns"]
        #print(point_cloud["number_of_returns"])
    out_LAS.num_returns = point_cloud['number_of_returns']
        
        #Setting attributes Maybe do this with "try" ?
    #setattr(out_LAS,'delta_z'+"_"+str(k),point_cloud['delta_z'])
        #point_cloud.drop('delta_z')
    #setattr(out_LAS,'std_z'+"_"+str(k),point_cloud['std_z'])
        #point_cloud.drop('std_z')
    #setattr(out_LAS,'radius'+"_"+str(k),point_cloud['radius'])
        #point_cloud.drop('radius')
    #setattr(out_LAS,'density'+"_"+str(k),point_cloud['density'])
        #point_cloud.drop('density')
    #setattr(out_LAS,'norm_z'+"_"+str(k),point_cloud['norm_z'])
        #point_cloud.drop('norm_z')
    setattr(out_LAS,'linearity'+"_"+str(k),point_cloud['linearity'])
        #point_cloud.drop('linearity')
    setattr(out_LAS,'planarity'+"_"+str(k),point_cloud['planarity'])
        #point_cloud.drop('planarity')
    setattr(out_LAS,'sphericity'+"_"+str(k),point_cloud['sphericity'])
        #point_cloud.drop('sphericity')
    setattr(out_LAS,'omnivariance'+"_"+str(k),point_cloud['omnivariance'])
        #point_cloud.drop('omnivariance')
    if "anisotropy" in features:
        setattr(out_LAS,'anisotropy'+"_"+str(k),point_cloud['anisotropy'])
        #point_cloud.drop('anisotropy')
    if "eigenentropy" in features:
        setattr(out_LAS,'eigenentropy'+"_"+str(k),point_cloud['eigenentropy'])
        #point_cloud.drop('eigenentropy')
    #if "curvature" in features:
        #setattr(out_LAS,'sum_eigenvalues'+"_"+str(k),point_cloud['sum_eigenvalues'])
        #point_cloud.drop('sum_eigenvalues')
    if "curvature" in features:
        setattr(out_LAS,'curvature'+"_"+str(k),point_cloud['curvature'])
        #point_cloud.drop('curvature')
    #if "classification" in features:
        #setattr(out_LAS,'classification'+"_"+str(k),point_cloud['classification'])
        #point_cloud.drop('classification')
        
    out_LAS.close()
	
    fullendtime_end = time.time()
    fulldifftime_end=fullendtime_end - fullstarttime
	
    print(fulldifftime_end)
       

        

 