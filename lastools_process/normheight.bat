set filename=D:\Koma\Data\06en2_merged_v1

::C:\LAStools\bin\lasclip -i %filename%.las -poly D:\Koma\Data\studyarea.shp -v
::C:\LAStools\bin\lastile -i %filename%.las -o D:\Koma\Data\tile.las -tile_size 500

::C:\LAStools\bin\lasground_new -i D:\Koma\Data\tiles\*.las -step 1 -olas -cores 16
C:\LAStools\bin\lasheight -i D:\Koma\Data\tiles\*_1.las -olas -replace_z