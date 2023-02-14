setwd("D:\\00.项目制项目\\吴增源老师项目\\GEA")

##########
library(rgdal)
library(raster)
library(sp)
#library("plyr")
library("xlsx")

###########

# 自增函数
inc <- function(x){
  eval.parent(substitute(x <- x + 1))
}

###########

groupfile <- read.table("group.tsv", header = F, col.names = c("IndID", "FamID"))

#################

position <- read.xlsx(file = "苎麻GPS.xlsx",sheetName="Sheet2", as.data.frame = TRUE ,header = TRUE)
position <- na.omit(position)
position <- position[position$Sample.ID %in% groupfile$IndID, ]

filter <- read.xlsx(file = "苎麻GPS(2).xlsx",sheetName="Sheet3", as.data.frame = TRUE ,header = F)

samples <- position$Sample.ID

climate_data <- c()
i=0

for (s in samples) {
  
  inc(i)
  long = position[position$Sample.ID == s,]$long
  lat = position[position$Sample.ID == s,]$lat
  
  # downloading the bioclimatic variables from worldclim at a resolution of 30 seconds (.5 minutes)
  r <- getData("worldclim", var="bio", res=0.5, lon=long, lat=lat )
  # lets also get the elevational data associated with the climate data
  alt <- getData("worldclim", var="alt", res=.5, lon=long, lat=lat )
  
  coords <- position[position$Sample.ID == s,][c("long", "lat")]
  
  # the steps to extract values for the variables you want from the coordinates:
  points <- SpatialPoints(coords, proj4string = r@crs)
  # getting temp and precip for the points
  clim <- extract(r, points)
  # getting the 30s altitude for the points
  altS <- extract(alt, points)
  # bind it all into one dataframe
  climate <- cbind.data.frame(coords, altS, clim)
  # add sample ID
  climate$SampleID <- s
  climate$group <- groupfile[groupfile$IndID == s,]$FamID
  
  if( i == 1){
    climate_data <- climate
  }else{
    climate_data <- rbind(climate_data, setNames(climate, names(climate_data) ))
  }
}

outname = paste0("GEA.txt")
write.table(x = climate_data, outname, quote = F, sep = "\t", col.names = T, row.names = F)


#########




