"""
@author: Zsofia Koma, UvA
Aim: reorganized manually classified dataset into an input for Random Forest classification

Input: 
Output: 

Example usage (from command line): 

ToDo: 
1.
"""

import sys
import argparse

########################################################################################################

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('segments', help='polygon shape file with features and classes')
args = parser.parse_args()

# Import and define feature and label

print("------ Import data and re-organize------ ")


