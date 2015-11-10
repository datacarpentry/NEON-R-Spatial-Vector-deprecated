## ----load-libraries------------------------------------------------------

#load required libraries
library(rgdal)
library(raster)


## ----Import-Shapefile----------------------------------------------------
#set working directory to where the data files were saved.  
setwd("~/Documents/data/Spatio_TemporalWorkshop/1_WorkshopData")

#Import a polygon shapefile 
aoiBoundary <- readOGR("boundaryFiles/HARV", "HarClip_UTMZ18")



## ----Shapefile-attributes------------------------------------------------
#view attributes of the layer
aoiBoundary

## ----Shapefile-attributes-2----------------------------------------------
#just view the attributes of the data
(aoiBoundary@data)

## ----Plot-shapefile------------------------------------------------------
#create a quick plot of the shapefile
#note: lwd sets the line width!
plot(aoiBoundary,col="cyan1", border="black", lwd=3)


## ----view-crs-extent-----------------------------------------------------
#view just the crs for the shapefile
crs(aoiBoundary)

#view just the extent for the shapefile
extent(aoiBoundary)


## ----import-point-line, echo=FALSE, results="hide"-----------------------

#Import a line shapefile
lines <- readOGR("boundaryFiles/HARV",layer = "HARV_roads")
#import a point shapefile
point <- readOGR("boundaryFiles/HARV", layer="HARVtower_UTM18N")
  

#view attributes
lines
point


## ----View-Attribute-Summary----------------------------------------------
#View all attributes 
aoiBoundary
lines
point

#view a summary of each attribute associated with the spatial object
summary(aoiBoundary)


## ----view-crs-extent2----------------------------------------------------
#view just the crs for the shapefile
crs(aoiBoundary)

#view just the extent for the shapefile
extent(aoiBoundary)

#view just the class for the shapefile
class(aoiBoundary)


## ----plot-multiple-shapefiles--------------------------------------------
#Plot multiple shapefiles

plot(aoiBoundary, col = "purple", main="Harvard Forest\nStudy Area")
plot(lines, add = TRUE)

#use the pch element to adjust the symbology of the points
plot(point, add  = TRUE, pch = 19, col = "red")

