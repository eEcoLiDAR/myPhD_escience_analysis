: Preprocessing of ahn2 point clouds 
: set the command line into the directory which contains the only-ground and object point cloud (laz files downloaded from ahn2 viewer)

::C:\LAStools\bin\las2las -i g02gz2.laz -set_classification 2 -olaz
::C:\LAStools\bin\lasmerge -i g02gz2_1.laz u02gz2.laz -o 02gz2.laz

::C:\LAStools\bin\lasheight -i *.las -olaz -replace_z

C:\LAStools\bin\las2dem -i *.laz -otif -keep_class 2 -step 2.5