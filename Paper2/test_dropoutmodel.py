import laspy
import numpy as np

import matplotlib.pyplot as plt

inFile = laspy.file.File("C:/Koma/Paper2/Test/tile_2_hole.las", mode = "r")

inFile_df=coords = np.vstack((inFile.x, inFile.y, inFile.z,inFile.pt_src_id,inFile.gps_time,inFile.raw_classification)).transpose()

inFile_df_oneline=inFile_df[inFile_df[:,3]==inFile_df[1,3]]

#plt.scatter(inFile_df_oneline[0:1000,0],inFile_df_oneline[0:1000,1],c=inFile_df_oneline[0:1000,5])
#plt.show()

print(inFile_df_oneline[1,4])

print(len(inFile_df_oneline[:,4]))

for i in range(0,len(inFile_df_oneline[:,4]),1):
	print(inFile_df_oneline[i+1,4]-inFile_df_oneline[i,4])

