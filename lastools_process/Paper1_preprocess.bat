: Preprocessing of ahn2 point clouds; create DTM, DSM, and normalized point cloud
: the dataset was tiled with lidR beforehand and the ground points are indicated with classification 2

::C:\LAStools\bin\lasheight -i *.laz -olaz -replace_z
C:\LAStools\bin\blast2dem -i *_1.laz -o *_shd.tif -step 1 -hillshade
