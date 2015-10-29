## ----load-libraries------------------------------------------------------

#load required libraries
library(rgdal)
library(raster)


## ----Import-Shapefile----------------------------------------------------

#Import a polygon shapefile 
aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

#view attributes of the layer
aoiBoundary

#you can also use the attributes command to just view the attributes of the data
(aoiBoundary@data)

#create a quick plot of the shapefile
plot(aoiBoundary)


## ----view-crs-extent-----------------------------------------------------
#view just the crs for the shapefile
crs(aoiBoundary)

#view just the extent for the shapefile
extent(aoiBoundary)


## ----import-point-line, echo=FALSE---------------------------------------

#Import a line shapefile
lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roadStream")

#Import a point shapefile 
point <- readOGR("boundaryFiles/HARV/", "HARVtower_UTM18N")
  

## ----View-Attribute-Summary----------------------------------------------
#View attributes
aoiBoundary

#view a summary of each attribute associated with the spatial object
summary(aoiBoundary)

#explore the lines and point objects
lines
point


## ----plot-multiple-shapefiles--------------------------------------------
#Plot multiple shapefiles

plot(x = aoiBoundary, col = "purple", main="Harvard Forest\nStudy Area")
plot(x = lines, add = TRUE)

#use the pch element to adjust the symbology of the points
plot(x = point, add  = TRUE, pch = 19, col = "red")

