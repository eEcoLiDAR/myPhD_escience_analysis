# convert ply files into cleaned text file and merge it together

work_folder="D:/Geobia_2018/Results_12ofApril/"

for f in $work_folder*.ply;do python ply_tograss.py ${f%.ply};done