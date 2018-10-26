"""
@author: Zsofia Koma, UvA
Aim: apply Random Forest for classifying point cloud

Input: 
Output: 

Example usage (from command line): 

ToDo: 
1.
"""

import sys
import argparse

from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score,precision_score,recall_score
from sklearn.metrics import classification_report

from collections import Counter
from imblearn.under_sampling import RandomUnderSampler

import matplotlib.pyplot as plt
import seaborn as sns

########################################################################################################

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('segments', help='polygon shape file with features and classes')
args = parser.parse_args()

# Import and define feature and label

print("------ Import data and re-organize------ ")
