# -*- coding: utf-8 -*-
"""
Created on Mon Jan 15 17:03:21 2018

@author: Berend-Christiaan
"""
#Classifier for unedited data, input Wijers
# -*- coding: utf-8 -*-
"""
@author: Chris Lucas
"""
#Wijers initialization
#Input: Params Beesd_Wijers, Params veg / non veg _ Wijers
import time
import os
#os.chdir("E:\MscThesis\Code")
os.chdir("/media/berend-christiaan/bwijers_college/MscThesis/Code/")
import pandas as pd
import pickle
from clf_preprocessing import merge_dataframes, correlated_features
from clf_classifiers import BalancedRandomForest, classify_vegetation
from clf_assessment import (grid_search, cross_validation,
                            mean_decrease_impurity)
start_time = time.time()
# %% Load ground truth data
start_time_mod = time.time()
print ("loading data..")
classes = ['veg', 'non_veg']
#veg_pc = pd.read_csv("E:/MscThesis/Code/Countries/TheNetherlands/BeesdGeldermalsen/Data/AHN3/Wijers/C_39CN1_params_veg.csv", delimiter=',', header=0)
#non_veg_pc = pd.read_csv("E:/MscThesis/Code/Countries/TheNetherlands/BeesdGeldermalsen/Data/AHN3/Wijers/C_39CN1_params_non_veg.csv", delimiter=',', header=0)
veg_pc = pd.read_csv("/media/berend-christiaan/bwijers_college/MscThesis/Code/Countries/TheNetherlands/BeesdGeldermalsen/Data/AHN3/Wijers/C_39CN1_params_veg.csv", delimiter=',', header=0)
non_veg_pc = pd.read_csv("/media/berend-christiaan/bwijers_college/MscThesis/Code/Countries/TheNetherlands/BeesdGeldermalsen/Data/AHN3/Wijers/C_39CN1_params_non_veg.csv", delimiter=',', header=0)

data = merge_dataframes({'veg': veg_pc, 'non_veg': non_veg_pc}, 'class')
data.rename(columns={'//X': 'X'}, inplace=True)
data.rename(columns=lambda x: x.replace(',', '_'), inplace=True)
del veg_pc, non_veg_pc
class_cat, class_indexer = pd.factorize(data['class'])
data['class_cat'] = class_cat
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 

# %% Define the feature space
start_time_mod = time.time()
print("Define the feature space")
features = data.columns.drop(['class', 'class_cat', 'X', 'Y', 'Z',
                              'norm_x_50', 'norm_y_50', 'return_number'],
                             'ignore')
#Simulate lack of data by removing features. Extra remove: norm_returns, number_of_returns, intensity
#features = data.columns.drop(['class', 'class_cat', 'X', 'Y', 'Z',
#                              'norm_x_50', 'norm_y_50', 'return_number','number_of_returns','norm_returns','intensity'],
#                             'ignore')

features = features.drop(correlated_features(data, features, corr_th=0.98))
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
# %% GridSearch (Cross Validated)
start_time_mod = time.time()
print("GridSearch (Cross Validated)")
#param_dict = {'min_samples_leaf': [5, 10],
#              'min_samples_split': [5, 10],
#              'ratio': [0.15, 0.1, 0.05]}

#gs_scores, param_grid = grid_search(data, features, 'class_cat', param_dict)
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
# %% Cross Validation
#start_time_mod = time.time()
print("Cross Validation")
#cv_scores, conf_matrices = cross_validation(data, features, 'class_cat')
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
# %% Load all data
start_time_mod = time.time()
print("Load all data")
point_cloud = pd.read_csv("E:/MscThesis/Code/Countries/TheNetherlands/BeesdGeldermalsen/Data/AHN3/Wijers/C_39CN1_params_wijers.csv", delimiter=',', header=0)
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
# %% Create final classifier
start_time_mod = time.time()
print("Create final classifier")
clf = BalancedRandomForest(n_estimators=1000, min_samples_leaf=5,
                           min_samples_split=5, ratio=0.2)
clf.fit(data[features], data['class_cat'])
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
#Save final classifier
# Dump the trained decision tree classifier with Pickle
with open("clf_beesd_geld_10_03_ahn3_no_edit.pkl","wb")as f:
        pickle.dump([clf,features],f)

#with open("features_beesd_geld_10_03_ahn3_no_edit.pkl","wb")as f:
#        pickle.dump(features,f)
# %% Assess feature importances
start_time_mod = time.time()
print("Assess feature importances")
fi_scores = mean_decrease_impurity(clf, features)
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 

# %% Classify vegetation / non-vegetation
start_time_mod = time.time()
print("Classify vegetation / non-vegetation")
classification = []
parts = 8
part = int(len(point_cloud)/parts)
for i in range(parts):
    if i == parts-1:
        temp_pc = point_cloud.loc[point_cloud.index[i*part:]]
    else:
        temp_pc = point_cloud.loc[point_cloud.index[i*part:(i+1)*part]]
    preds = clf.predict(temp_pc[features])
    classification.extend(list(preds))

point_cloud['class'] = classification
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
# %% Classify trees / low vegetation
start_time_mod = time.time()
print("Classify trees / low vegetation")
points = point_cloud.loc[point_cloud['class'] == 1].as_matrix(columns=['x', 'y', 'z'])
radius = 2.0
tree_th = 4.0
classification = classify_vegetation(points, radius, tree_th)
point_cloud['veg_class'] = 'non_veg'
point_cloud.loc[point_cloud['class'] == 1, 'veg_class'] = classification
point_cloud['class'], _ = pd.factorize(point_cloud['veg_class'])
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 
# %% Save results
start_time_mod = time.time()
print("Save results")
point_cloud.to_csv("E:/MscThesis/Code/Countries/TheNetherlands/BeesdGeldermalsen/Data/AHN3/params_wijers_unedit_train_wijers/veg_classification_data_wijers_unedited_train_wijers_test1.csv",
                   columns=['x', 'y', 'z', 'class'], index=False)
print("Done!")
print("Module time: ",(time.time() - start_time_mod)/60, "minutes.")
print("Total runtime:",(time.time() - start_time)/3600,'hours have passed.') 