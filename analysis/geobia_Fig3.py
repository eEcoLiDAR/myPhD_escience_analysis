import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

font = {'family': 'normal',
        'weight': 'bold',
        'size': 14}

plt.rc('font', **font)

workdir='C:/zsofia/Amsterdam/Geobia/Work_16ofApril/'
filename='merged_all_tiles_clean'

segm_optimal=pd.read_csv(workdir+filename+'.csv',sep=',')
#print(segm_optimal.dtypes)

segm_optimal=segm_optimal[segm_optimal['Minimum size']!=50]

segm_optimal=segm_optimal.sort_values(by=['Threshold'])

"""
fig, ax = plt.subplots(figsize=(8,6))
segm_optimal.groupby('Minimum size').plot(x='threshold',y='optimization_criteria',ax=ax,marker='o')
plt.show()
"""

sns.pointplot(x='Threshold',y='Optimization criteria',hue='Minimum size',data=segm_optimal,linestyle="-")
plt.show()