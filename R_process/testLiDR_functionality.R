library("lidR")

las = readLAS("D:/Geobia_2018/Lau_tiles/Lauw_island_tiles/tile_208500_598500_1_1.las")

hmean = grid_metrics(las, mean(Z),res=1)
plot(hmean)

hmean_voxel=grid_metrics3d(las, mean(Z),res=1)
plot(hmean_voxel)
