"
@author: Zsofia Koma, UvA
Aim: This script download the required AHN3 data from the pdok website
"

# Set working directory
workingdirectory="D:/Koma/Paper3/" ## set this directory where you would like to put your las files
setwd(workingdirectory)

# Import filenames file
ahn3file="listahn3.csv"
ahn3list=read.csv(file=ahn3file,header=TRUE,sep=",")

ahn3list$list=paste("https://geodata.nationaalgeoregister.nl/ahn3/extract/ahn3_laz/C_",ahn3list$bladnr_up,".LAZ",sep="")

write.table(ahn3list$list, file = "ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

#while read p; do curl -o ${p:62:73} "${p%?}";done < ahn3list.txt



