import laspy
import numpy as np
import pandas as pd

import matplotlib.pyplot as plt

inFile = laspy.file.File("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/Transect_1495.las", mode = "r")

inFile_df=np.vstack((inFile.x, inFile.y, inFile.z,inFile.pt_src_id,inFile.gps_time,inFile.raw_classification,inFile.edge_flight_line)).transpose()

# Get only one flight line

inFile_df_oneline=inFile_df[inFile_df[:,3]==inFile_df[1,3]]

plt.scatter(inFile_df_oneline[0:1000,0],inFile_df_oneline[0:1000,1],c=inFile_df_oneline[0:1000,5])
plt.show()

# Order by gpstime

inFile_df_oneline_ord=inFile_df_oneline[inFile_df_oneline[:,4].argsort()]

plt.scatter(inFile_df_oneline_ord[0:1000,0],inFile_df_oneline_ord[0:1000,1],c=inFile_df_oneline_ord[0:1000,4])
plt.show()

inFile_df_oneline_ord_df=pd.DataFrame(inFile_df_oneline_ord)

# Identify point with big gpstime difference

inFile_df_oneline_ord_df[7]=abs(inFile_df_oneline_ord_df[4].diff(periods=-1))

bigdiff=inFile_df_oneline_ord_df[inFile_df_oneline_ord_df[7] > np.mean(inFile_df_oneline_ord_df[7])]

bigdiff.plot.scatter(x=0,y=1,c=6)

bigdiff.to_csv("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/Transect_1495_drop.csv",index=False)
