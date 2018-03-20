"""
Aim: Explore the labeled dataset with pandas
"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

import matplotlib.pyplot as plt
import seaborn as sns

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('labeledpcwfea', help='where the files are located')
args = parser.parse_args()

labeledpc_wfea = pd.read_csv(args.path+args.labeledpcwfea,sep=',')

get_coloumnnames=list(labeledpc_wfea)
#print(get_coloumnnames[4:-4])

# Boxplots

for i in get_coloumnnames[4:-4]:
	print(i)
	labeledpc_wfea.boxplot(column=str(i),by="class")
	plt.show()
	#sns.pairplot(data=labeledpc_wfea,vars=[str(i)], hue="class")
	#plt.show()
	
labeledpc_wfea_selcol = labeledpc_wfea.iloc[:,4:-4]

sns.heatmap(labeledpc_wfea_selcol.corr(), annot=True, fmt=".2f")
plt.show()
	
#sns.pairplot(data=labeledpc_wfea,vars=[str(get_coloumnnames[4]),str(get_coloumnnames[5]),str(get_coloumnnames[6]),str(get_coloumnnames[7])], hue="class")
#plt.show()