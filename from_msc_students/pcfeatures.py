#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 19 14:52:10 2018

@author: berend-christiaan

Functions for calculating point cloud features

"""

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

import sys

import gc

import queue

import laspy

from laspy.file import File

import os

import tqdm

from tqdm import tqdm


def par_calc(start,stop,points,tree,chunk,k,clf):
   
    #%% Setting up constants and output file
    a = (4/3)*math.pi
    
    output = pd.DataFrame(np.array(np.zeros([stop-start,14])),index = range(start,stop), columns=['delta_z', 'std_z', 'radius', 'density', 'norm_z','linearity', 'planarity', 'sphericity', 'omnivariance','anisotropy', 'eigenentropy', 'sum_eigenvalues','curvature',"classification"])
    #output = pd.DataFrame([],index = range(start,stop), columns=['delta_z', 'std_z', 'radius', 'density', 'norm_z','linearity', 'planarity', 'sphericity', 'omnivariance','anisotropy', 'eigenentropy', 'sum_eigenvalues','curvature',"classification"])

    
    
    print(output.index)
    
    chunk_range = [x for x in range(0,chunk)]
    
    #%% Looping over the to-be-evaluated points in a semi-vectorized approach
    
    for x in range(start,stop,chunk):
        
        #Since there are more indexes entries than stop gives, chunk will surpass the stop mark (in 9/10 threads). 
        #Re-evaluation of chunksize.
        
        if x + chunk > stop:

            chunk = stop - x
            chunk_range = [x for x in range(0,chunk)]
         
            
        chunk_res = pd.DataFrame(np.array(np.zeros([chunk,2])),columns=['planarity', 'sphericity'])

        #Find nearest neighbours dinstance (dd) and index (ii)
        #print("KDtree Query")
        
        knndd,knnii = tree.query(points[x:x+chunk],k) # 
    
        neighbour_group_xyz = points[knnii.astype(np.int64)] # Extract the xyz information
     
        #%%
        #Determine which index entries of this chunk should be calculatated or dropped based upon filter planarity & sphericity
        #These filters can be set to whichever ofcourse depending on the intended use. Current filter is based on 
        #Lucas, C 2017 "Delineating linear vegetation elements in agricultural landscapes using LiDAR point clouds"
        #Incase a different combination of features is required to filter beforehand, please contact me at berend_wijers@msn.com
        #Before any of the structure tensors can be calculated, eigenvalues/vectors need to be derived from the group of points.
        
        #Covariance

        N = neighbour_group_xyz.shape[1] #1->2

        m1 = neighbour_group_xyz - neighbour_group_xyz.sum(1,keepdims=1)/N #1->2

        #Produce a 3d matrix with shape (chunk,2,2)
        
        neighbour_group_cov = np.einsum('ikj,ikl->ijl',m1,m1) /(N - 1) #ikj, ikl -> ijl ---> ijk, ilk, ijl
        
        #Retrieve the eigenvalues and vectors of each covariance matrix. Note, each covariance matrice corresponds to a
        #point to be evaluated accompaniying its K closest neighbours 
        
        knn_eigval, knn_eigvec = np.linalg.eig(neighbour_group_cov)
        
        #retrieve the IDX of the sorted eigenvalues

        idx = np.fliplr(np.array(knn_eigval).argsort())

        #Retrieve the sorted eigenvalues

        knn_eigval_sort = knn_eigval[np.arange(len(knn_eigval))[:,None], idx]
        
        #Sum of eigenvalues

        knn_eigval_sum = np.sum(knn_eigval_sort, axis=1)
        
        #Normalize the sorted eigenvalues
        
        knn_eigval_sort  = (knn_eigval_sort / np.tile(np.array([knn_eigval_sum]).transpose(), (1, 3)))
        
        #output.ix[x:x+chunk-1,11]
                        

        #Return the normal vectors

        knn_eigvec_norm_vec = knn_eigvec[:,:,2]
        
        #Calculate structure tensors based upon the sorted eigenvalues / vectors
        
        #Planarity
        chunk_res['planarity'] = (knn_eigval_sort[:,1]-knn_eigval_sort[:,2])/knn_eigval_sort[:,0]
        #output.ix[x:x+chunk-1,6] = (knn_eigval_sort[:,1]-knn_eigval_sort[:,2])/knn_eigval_sort[:,0]
                #Sphericity
        chunk_res['sphericity'] = knn_eigval_sort[:,2]/knn_eigval_sort[:,0]
        #output.ix[x:x+chunk-1,7] = knn_eigval_sort[:,2]/knn_eigval_sort[:,0]
        
        #Introduce a filter to filter out points which do not have a shape corresponding to "large" vegetation.
        #chunk_res.query('sphericity > 0.00 & planarity < 0.7', inplace=True)
        
        #ENABLE FOR IN SITU FILTERING
        idx_keep = np.where(np.logical_and(chunk_res["sphericity"]>0.05, chunk_res["planarity"]<0.7))
         
        #Store planarity and sphericty in output
        output.ix[x+idx_keep[0],7] = chunk_res.ix[idx_keep[0],'sphericity']
        
        output.ix[x+idx_keep[0],6] = chunk_res.ix[idx_keep[0],'planarity'] 
        
        
        
        #print(output)output.ix[x+idx_keep[0],6]
        #time.sleep(5)
        
        
        
        #chunk_range = [x for x in range(0,chunk)]
        
        idx_drop = np.where(np.isin(chunk_range,idx_keep[0],assume_unique=True,invert = True))
        
        idx_drop = idx_drop[0] + x
        
        
        #print("Dropped:",chunk-len(idx_keep[0]),"points thanks to the filter!",idx_drop[0])
        
    
        #print([start,stop,x,chunk,len(idx_keep[0])])
        
       
        #knndd
        #knnii
        #knn_eigval
        #knn_eigvec
        
        #ENABLE THESE FOR IN SITU FILTERING
        knn_eigval_sum = knn_eigval_sum[idx_keep]
        knn_eigval_sort = knn_eigval_sort[idx_keep]
        knn_eigvec_norm_vec = knn_eigvec_norm_vec[idx_keep]
        neighbour_group_xyz = neighbour_group_xyz[idx_keep]
        knndd = knndd[idx_keep]
        
        output.ix[x+idx_keep[0],11]=knn_eigval_sum
        
        output.drop(idx_drop,axis=0,inplace=True)
        
        #make it so thanything also get dropped.
        
        
        #output.query('sphericity > 0.05 & planarity < 0.7', inplace=True)
        #output.query(output.ix[x:x+chunk-1,'sphericity'] > 0.05 & output.ix[x:x+chunk-1,'planarity'] < 0.7, inplace=True)
        
        #drop_idx = np.argwhere(output["sphericity"] > 0.05 & output["planarity"] < 0.7)
        
        
        #Drop data OR synchronize the following variables: group_xyz, knndd, knnii, etc etc.
        #Keep index the same, reset index after all output files are returned and added.
        #Synchronize the knndd, knnii, group xyz, knn eigvec, eigval sort, eigval sum
        
        #%%
        #Calculate remaining features for all points which are expected to belong to vegetation.
        
        neighbour_group_z = neighbour_group_xyz[:,:,2] #Works in unix
        
        #Delta Z
        output.ix[x+idx_keep[0],0] = np.amax(neighbour_group_z,axis=1) - np.amin(neighbour_group_z,axis=1)
        #output.ix[x:x+chunk-1,0] = np.amax(neighbour_group_z,axis=1) - np.amin(neighbour_group_z,axis=1)
        
        #Height standard deviation
        output.ix[x+idx_keep[0],1] = np.std(neighbour_group_z,axis=1)  
        #output.ix[x:x+chunk-1,1] = np.std(neighbour_group_z,axis=1)  

        #Local Radius

        Rl = np.amax(knndd,axis=1)
        #output.ix[x:x+chunk-1,2] = Rl
        output.ix[x+idx_keep[0],2] = Rl

        #Local Point Density
        output.ix[x+idx_keep[0],3] = k / (a * (Rl**3))
        #output.ix[x:x+chunk-1,3] = k / (a * (Rl**3))
        
        #Vectorized calculations for eigenvalues etc. 
        
        #Normalized Z
        #output.ix[x:x+chunk-1,4] = (knn_eigval_sort / np.tile(np.array([knn_eigval_sum]).transpose(), (1, 3)))

    ##Structure tensors
        
            
    
    
    #Norm-Z

        #Nz = abs(knn_eigvec_norm_vec[:, 2])
        #output.ix[x:x+chunk-1,4] = abs(knn_eigvec_norm_vec[:, 2])
        output.ix[x+idx_keep[0],4] = abs(knn_eigvec_norm_vec[:, 2])
      
    #Linearity

        #L = (knn_eigval_sort[:,0]-knn_eigval_sort[:,1])/knn_eigval_sort[:,0]
        #output.ix[x:x+chunk-1,5] = (knn_eigval_sort[:,0]-knn_eigval_sort[:,1])/knn_eigval_sort[:,0]
        output.ix[x+idx_keep[0],5] = (knn_eigval_sort[:,0]-knn_eigval_sort[:,1])/knn_eigval_sort[:,0]
    #Planarity
        output.ix[x+idx_keep[0],6] = (knn_eigval_sort[:,1]-knn_eigval_sort[:,2])/knn_eigval_sort[:,0]
    #Sphericity  
        output.ix[x+idx_keep[0],7] = knn_eigval_sort[:,2]/knn_eigval_sort[:,0]
          
    #Omnivariance

        #O = scipy.cbrt(knn_eigval_sort[:,0]*knn_eigval_sort[:,1]*knn_eigval_sort[:,2])
        #output.ix[x:x+chunk-1,8] = scipy.cbrt(knn_eigval_sort[:,0]*knn_eigval_sort[:,1]*knn_eigval_sort[:,2])
        output.ix[x+idx_keep[0],8] = scipy.cbrt(knn_eigval_sort[:,0]*knn_eigval_sort[:,1]*knn_eigval_sort[:,2])
      
    #Anisotropy

        #A = (knn_eigval_sort[:,0] - knn_eigval_sort[:,2]) / knn_eigval_sort[:,0]
        #output.ix[x:x+chunk-1,9] = (knn_eigval_sort[:,0] - knn_eigval_sort[:,2]) / knn_eigval_sort[:,0]
        output.ix[x+idx_keep[0],9] = (knn_eigval_sort[:,0] - knn_eigval_sort[:,2]) / knn_eigval_sort[:,0]
      

    #Eigenentropy

        #output.ix[x:x+chunk-1,10] =  (-1 *((knn_eigval_sort[:,0] * np.log(knn_eigval_sort[:,0])) +

         #         (knn_eigval_sort[:,1] * np.log(knn_eigval_sort[:,1])) +

          #        (knn_eigval_sort[:,2] * np.log(knn_eigval_sort[:,2]))))     
        
        output.ix[x+idx_keep[0],10] =  (-1 *((knn_eigval_sort[:,0] * np.log(knn_eigval_sort[:,0])) +

                  (knn_eigval_sort[:,1] * np.log(knn_eigval_sort[:,1])) +

                  (knn_eigval_sort[:,2] * np.log(knn_eigval_sort[:,2]))))     

     

    #Local surface variation       
      
        #output.ix[x:x+chunk-1,12] = knn_eigval_sort[:,2] / knn_eigval_sum
        output.ix[x+idx_keep[0],12] = knn_eigval_sort[:,2] / knn_eigval_sum
        #idx = list(range(x,x+chunk))
        #output.ix[x:x+chunk-1,13] = int(range(x,x+chunk))
        
      
       #Classification
        #output.ix[x:x+chunk-1,13] = clf.predict(output.ix[x:x+chunk-1])
        if len(idx_keep[0]) >= 1:
            #print("Classifying!")
            #print(output.ix[x+idx_keep[0]])
            output.ix[x+idx_keep[0],13] = clf.predict(output.ix[x+idx_keep[0]])
        #ret.append((delta_z, std_z, Rl, density,Nz,L,P,Sp,O,A,E,knn_eigval_sum,C,idx))
        
            #print("Nothing to classify!")
        #Collect garbage incase anyone forgot to pick up their thrash.
        gc.collect()
        
        #progress
        #print((x/stop)*100, "%"  ,end="\r")
    
    #output.query('sphericity_50 > 0.05 & planarity_50 < 0.7', inplace=True)
    
    #output.loc[(output!=0).any(axis=1)]
    #print("Classified {} points as vegetation".format(np.sum(output['classification'])))
    #print(output)
    return output
