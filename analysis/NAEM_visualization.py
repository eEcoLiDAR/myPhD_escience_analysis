import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

workdir='D:/NAEM/Data/ALS_AHN2/'
filename='nof_perc_to_total.txt'
filename1='nof_perc_to_total_sub1.txt'
filename2='nof_perc_to_total_sub2.txt'
filename3='nof_perc_to_total_sub3.txt'

stat_filename='SelStudyArea2_statcyl.txt'
stat_filename1='SelStudyArea2_statcyl_sub1.txt'
stat_filename2='SelStudyArea2_statcyl_sub2.txt'
stat_filename3='SelStudyArea2_statcyl_sub3.txt'

#Multilayer analysis
multilayer=pd.read_csv(workdir+filename,sep=',',names=['Pulse penetration ratio [%]','Height [m]'])
multilayer1=pd.read_csv(workdir+filename1,sep=',',names=['Pulse penetration ratio [%]','Height [m]'])
multilayer2=pd.read_csv(workdir+filename2,sep=',',names=['Pulse penetration ratio [%]','Height [m]'])
multilayer3=pd.read_csv(workdir+filename3,sep=',',names=['Pulse penetration ratio [%]','Height [m]'])
#print(multilayer)

font = {'family': 'normal',
        'weight': 'bold',
        'size': 22}

plt.rc('font', **font)

ax=multilayer.plot(x='Pulse penetration ratio [%]',y='Height [m]',lw=5)
multilayer1.plot(x='Pulse penetration ratio [%]',y='Height [m]',lw=5,ax=ax)
multilayer2.plot(x='Pulse penetration ratio [%]',y='Height [m]',lw=5,ax=ax)
multilayer3.plot(x='Pulse penetration ratio [%]',y='Height [m]',lw=5,ax=ax)

ax.legend(["20 pt/m2", "7 pt/m2", "4 pt/m2","2 pt/m2"])
plt.show()

#Single layer analysis
singlelayer=pd.read_csv(workdir+stat_filename,sep=',',names=['X','Y','Z','max_z','min_z','mean_z','median_z','std_z','var_z','range_z','coeff_var_z','skew_z','kurto_z'])
singlelayer1=pd.read_csv(workdir+stat_filename1,sep=',',names=['X','Y','Z','max_z','min_z','mean_z','median_z','std_z','var_z','range_z','coeff_var_z','skew_z', 'kurto_z'])
singlelayer2=pd.read_csv(workdir+stat_filename2,sep=',',names=['X','Y','Z','max_z', 'min_z', 'mean_z', 'median_z', 'std_z', 'var_z', 'range_z', 'coeff_var_z', 'skew_z', 'kurto_z'])
singlelayer3=pd.read_csv(workdir+stat_filename3,sep=',',names=['X','Y','Z','max_z', 'min_z', 'mean_z', 'median_z', 'std_z', 'var_z', 'range_z', 'coeff_var_z', 'skew_z', 'kurto_z'])

plt.subplot(2, 1, 1)
bp=plt.boxplot([singlelayer.max_z.values,singlelayer1.max_z.values,singlelayer2.max_z.values,singlelayer3.max_z.values],patch_artist=True)
plt.xticks([1, 2, 3,4], ["20 pt/m2", "7 pt/m2", "4 pt/m2","2 pt/m2"])
plt.title('Canopy height', fontsize=16)

plt.subplot(2, 1, 2)
bp2=plt.boxplot([singlelayer.std_z.values,singlelayer1.std_z.values,singlelayer2.std_z.values,singlelayer3.std_z.values],patch_artist=True)
plt.xticks([1, 2, 3,4], ["20 pt/m2", "7 pt/m2", "4 pt/m2","2 pt/m2"])
plt.title('Variation of height', fontsize=16)

for box in bp['boxes']:
    # change outline color
    box.set( color='#7570b3', linewidth=2)
    # change fill color
    box.set( facecolor = '#1b9e77' )

for whisker in bp['whiskers']:
    whisker.set(color='#7570b3', linewidth=5)

for cap in bp['caps']:
    cap.set(color='#7570b3', linewidth=5)

for median in bp['medians']:
    median.set(color='#b2df8a', linewidth=2)

for flier in bp['fliers']:
    flier.set(marker='o', color='#e7298a', alpha=0.5)

for whisker in bp2['whiskers']:
        whisker.set(color='#7570b3', linewidth=5)

for cap in bp2['caps']:
        cap.set(color='#7570b3', linewidth=5)


plt.subplots_adjust(hspace=0.5)

plt.show()
