:: Using PDAL for transfer laz->las and normalize the point cloud

::pdal translate D:\Koma\lidar_bird_dsm_workflow\escience_test\tile0_1.laz D:\Koma\lidar_bird_dsm_workflow\escience_test\tile0_1.las
pdal translate D:\Koma\lidar_bird_dsm_workflow\escience_test\tile0_1.las D:\Koma\lidar_bird_dsm_workflow\escience_test\tile0_1_norm.las hag ferry --filters.ferry.dimensions="HeightAboveGround=Z"