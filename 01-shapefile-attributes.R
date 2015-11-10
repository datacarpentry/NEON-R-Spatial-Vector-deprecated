## ----load-libraries-data-------------------------------------------------

library(rgdal)
library (raster)   #notice sp package should always load with raster. 
#in case the libraries and data are not still loaded

#Import a polygon shapefile 
aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

#Import a line shapefile
lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roads")

#Import a point shapefile 
point <- readOGR("boundaryFiles/HARV/", "HARVtower_UTM18N")


## ----view-shapefile-metadata---------------------------------------------

#view class
class(x = aoiBoundary)
class(x = lines)
class(x = point)

#view features count
length(x = aoiBoundary)
length(x = lines)
length(x = point)

#view crs - note - this only works with the raster package loaded
crs(x = aoiBoundary)
crs(x = lines)
crs(x = point)

#view extent
extent(x = squarePlot)
extent(x = lines)
extent(x = point)


## ----view-shapefile-attributes-------------------------------------------

#view just the attribute names for the lines spatial object
names(lines@data)

#view all attribute data for the lines spatial object
lines@data 

#view just the tope 5 attributes for the lines spatial object
head(lines@data)

#view attributes for the other spatial objects
aoiBoundary@data
point@data


## ----explore-attribute-values--------------------------------------------

#view all attributes in the lines shapefile within the TYPE field
lines$TYPE

#view unique attributes in the lines shapefiles within the Type field
levels(lines$TYPE)


## ----Subsetting shapefiles-----------------------------------------------

#view all attributes in the TYPE column
lines$TYPE

#select features that are of TYPE "footpath"
lines[lines$TYPE == "footpath",]


## ----Color lines by attribute--------------------------------------------
#add legend to previous plot


#color lines by TYPE attribute
#1st create object that is the TYPE attribute (you could just do this directly
#in the col {} below but this makes for cleaner code)
type <- lines@data$TYPE
#Bonus: if you prefer using slot(). 
type <- slot(object = lines, name = "data")$TYPE

#2nd set the color for all the lines 
col <- rep(x= "black", length = length(type))

#3rd specify the color you want for the TYPE level you want 
col[type == "footpath"] <- "red"

#4th plot. Add is still true because we want this to map onto the previous plot 
plot(x=lines, col=col,add=TRUE)


