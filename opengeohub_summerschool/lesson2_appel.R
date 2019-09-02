install.packages(c("gdalcubes", "magrittr", "raster", "stars", "mapview", "viridis"))

library(gdalcubes)
gdalcubes_options(threads=2)

L8.files = list.files("D:/Koma/L8_Amazon_mini/", pattern = ".tif", recursive = TRUE, full.names = TRUE) 
head(L8.files, 15)
sum(file.size(L8.files)) / 1000^3
L8.col = create_image_collection(L8.files, format = "L8_SR", out_file = "L8.db")
extent(L8.col, srs="EPSG:4326")

v.overview.500m = cube_view(srs="EPSG:3857", extent=L8.col, dx=500, dy=500, dt = "P1Y", resampling="average", aggregation="median")
v.overview.500m

v.subarea.60m = cube_view(extent=list(left=-6180000, right=-6080000, bottom=-550000, top=-450000, 
                                      t0="2014-01-01", t1="2018-12-31"), dt="P1Y", dx=60, dy=60, srs="EPSG:3857", 
                          aggregation = "median", resampling = "average")
v.subarea.60m

v.subarea.60m.daily =  cube_view(view = v.subarea.60m, dt="P1D") 
v.subarea.60m.daily

L8.cube.overview = raster_cube(L8.col, v.overview.500m)
L8.cube.overview

L8.cube.overview.rgb = select_bands(L8.cube.overview, c("B02", "B03", "B04"))
L8.cube.overview.rgb

plot(L8.cube.overview.rgb, rgb=3:1, zlim=c(0,1500))

gdalcubes_options(ncdf_compression_level = 1)
write_ncdf(L8.cube.overview.rgb, file.path("~/Desktop", basename(tempfile(fileext = ".nc"))))
gdalcubes_options(ncdf_compression_level = 0)

# Ex1
L8.files = list.files("D:/Koma/L8_Amazon_mini/", pattern = ".tif", recursive = TRUE, full.names = TRUE) 
head(L8.files, 15)
sum(file.size(L8.files)) / 1000^3
L8.col = create_image_collection(L8.files, format = "L8_SR", out_file = "L8.db")
extent(L8.col, srs="EPSG:4326")

v.overview.1km = cube_view(srs="EPSG:5641", extent=L8.col, dx=1000, dy=1000, dt = "P1Y", resampling="average", aggregation="median")
v.overview.1km

L8.cube.overview = raster_cube(L8.col, v.overview.1km)
L8.cube.overview

L8.cube.overview.b5 = select_bands(L8.cube.overview, c("B05"))
L8.cube.overview.b5
plot(L8.cube.overview)

plot(select_bands(L8.cube.overview, c("B04", "B07", "B02")), rgb=3:1, zlim=c(0,1500))

v.overview.1km2017 = cube_view(srs="EPSG:5641", extent=list(left=-54.15506, right=-52.10338, bottom=-5.392073, top=-3.289862,t0="2017",t1="2017"), dx=1000, dy=1000, dt = "P1Y",resampling="average", aggregation="median")
L8.cube.overview = raster_cube(L8.col, v.overview.1km2017)
plot(select_bands(L8.cube.overview, c("B04", "B07", "B02")), rgb=3:1, zlim=c(0,1500))
