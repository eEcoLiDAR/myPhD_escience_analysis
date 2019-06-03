import laspy
import numpy as np

import matplotlib.pyplot as plt

inFile = laspy.file.File("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/Transect_1495.las", mode = "r")

inFile_df=np.vstack((inFile.x, inFile.y, inFile.z,inFile.pt_src_id,inFile.gps_time,inFile.raw_classification)).transpose()

inFile_df_oneline=inFile_df[inFile_df[:,3]==inFile_df[1,3]]

#plt.scatter(inFile_df_oneline[0:1000,0],inFile_df_oneline[0:1000,1],c=inFile_df_oneline[0:1000,5])
#plt.show()

#print(inFile_df_oneline[1:10,4])
inFile_df_oneline_2=inFile_df_oneline[inFile_df_oneline[:,4].argsort()]
#print(inFile_df_oneline_2[1:10,4])

gpsdiff=np.zeros((len(inFile_df_oneline[:,4]), 1))
#print(gpsdiff.shape)

for i in range(0,len(inFile_df_oneline[:,4])-1,1):
	gpsdiff[i,0]=np.abs(inFile_df_oneline[i,4]-inFile_df_oneline[i+1,4])
	
print(np.median(gpsdiff))

print(gpsdiff[np.where(gpsdiff > np.mean(gpsdiff))])

reqfilling_id=np.array(np.where(gpsdiff > np.mean(gpsdiff)))
gpstime=gpsdiff[np.where(gpsdiff > np.mean(gpsdiff))]
reqnofp=gpstime/np.median(gpsdiff)

print(reqfilling_id.shape)
print(gpstime.shape)
print(reqnofp.shape)

print(reqnofp)

inFile_df_oneline_biggpsdiff=inFile_df_oneline_2[np.where(gpsdiff > np.mean(gpsdiff)),]
print(inFile_df_oneline_biggpsdiff.shape)

output=np.vstack((inFile_df_oneline_biggpsdiff[1,:,0], inFile_df_oneline_biggpsdiff[1,:,1], inFile_df_oneline_biggpsdiff[1,:,2],inFile_df_oneline_biggpsdiff[1,:,3],inFile_df_oneline_biggpsdiff[1,:,4],inFile_df_oneline_biggpsdiff[1,:,5])).transpose()
print(output.shape)

np.savetxt('D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/test.txt', output, delimiter=',',fmt='%1.9f')

plt.scatter(output[0:1000,0],output[0:1000,1],c=output[0:1000,5])
plt.show()
