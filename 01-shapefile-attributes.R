## ----load-libraries-data-------------------------------------------------

library(rgdal)
#in case the libraries and data are not still loaded

#Import a polygon shapefile 
aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

#Import a line shapefile
lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roadStream")

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
#color lines by TYPE attribute
type <- slot(object = lines, name = "data")$TYPE
#you can also write
type <- lines@data$TYPE

col <- rep(x= "black", length = length(type))
col[type == "footpath"] <- "red"

plot(x=lines, col=col,add=T)


## ------------------------------------------------------------------------


