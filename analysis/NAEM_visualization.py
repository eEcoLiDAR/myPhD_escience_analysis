import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

workdir='D:/NAEM/Data/ALS_AHN2/'
filename='nof_perc_to_total.txt'

multilayer=pd.read_csv(workdir+filename,sep=',',names=['Pulse penetration ratio [%]','Height [m]'])
print(multilayer)

font = {'family': 'normal',
        'weight': 'bold',
        'size': 22}

plt.rc('font', **font)

multilayer.plot(x='Pulse penetration ratio [%]',y='Height [m]',lw=5)
plt.show()