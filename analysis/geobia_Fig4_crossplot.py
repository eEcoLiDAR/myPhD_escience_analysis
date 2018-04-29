import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

workdir='C:/zsofia/Amsterdam/Geobia/29April/crosssection/'
filename='trycross_1.txt'

crosscloud=pd.read_csv(workdir+filename,sep=',')

font = {'family': 'normal',
        'weight': 'bold',
        'size': 14}

plt.rc('font', **font)
 
plt.figure(figsize=(18,5))
plt.title("Crossplot A")
plt.scatter(crosscloud['X'].values-np.min(crosscloud['X'].values),crosscloud['Z'].values,c=crosscloud['Classification'].values,cmap='BrBG_r')
plt.xlabel('Length of the cross section [m]')
plt.ylabel('Normalized height [m]')
plt.tight_layout()
plt.show()