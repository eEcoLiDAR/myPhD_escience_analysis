: Preprocessing of ahn2 point clouds; create DTM, DSM, and normalized point cloud
: the dataset was tiled with lidR beforehand and the ground points are indicated with classification 2

::C:\LAStools\bin\lastile -i *.laz -olaz -tile_size 1000
::C:\LAStools\bin\lasground_new -i *.laz -step 1 -olaz -cores 16
::C:\LAStools\bin\lasheight -i *_1.laz -olaz -replace_z

