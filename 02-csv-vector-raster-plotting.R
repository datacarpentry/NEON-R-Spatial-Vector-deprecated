## ----load-libraries------------------------------------------------------

#first load libraries
library(rgdal)
library(raster)


## ----read-csv------------------------------------------------------------

#Leah's notes
setwd("~/Documents/data/1_DataPortal_Workshop/1_WorkshopData")

#Read the csv file
plot.location <- read.csv("boundaryFiles/HARV/HARV_PlotLocations.csv")

#look at the data structure
head(plot.location)


## ----read-shp------------------------------------------------------------
#note: read ogr is preferred as it maintains prj info
aoiBoundary <- readOGR("boundaryFiles/HARV/","HarClip_UTMZ18")

#check the CRS
crs(aoiBoundary)

#the x,y location values for the dataset are available in 
#the x and y columns. We can use that for our spatial data point object
#we know the csv file coordinates are in the same CRS as the other shapefiles.
#we can assign this to the SpatialPointsDataFrame when we import it.
plot.locationSp <- SpatialPointsDataFrame(plot.location[,1:2],
                                                plot.location,
                                                proj4string = crs(aoiBoundary))

#look at CRS
crs(plot.locationSp)


## ----plot-data-----------------------------------------------------------

#plot the points
#use main = to add a title to the map
plot(plot.locationSp, main="Map of Study Area")

#let's add the polygon layer to our plot
plot(aoiBoundary, add=TRUE)

#add roads to our plot
roads <- readOGR("boundaryFiles/HARV/","HARV_roadStream")
plot(roads, add=TRUE)


## ----write-shapefile-----------------------------------------------------
#write a shapefile
writeOGR(plot.locationSp, getwd(), "newFile", driver="ESRI Shapefile")


## ----project-vectors-----------------------------------------------------

#note: read ogr is preferred as it maintains prj info
newPlots <- readOGR("boundaryFiles/HARV/","newPlots_latLon")

#http://www.statmethods.net/advgraphs/parameters.html
#add these points to our plot
plot(newPlots, add=TRUE, col=115, pch=19)


## ----explore-spatial-data------------------------------------------------
#view coordinates
newPlots@coords

#it appears as if our coordinates are in lat / long
#let's check the CRS of our data to see what's going on
crs(newPlots)



## ----project-data--------------------------------------------------------

#let's double check the crs of our plots layer
crs(plot.locationSp)

#reproject our vector layer to the projection of our other plot data.
newPlots_UTMZ18N<- spTransform(newPlots,crs(plot.locationSp))
#try to plot the data
plot(newPlots_UTMZ18N, add=TRUE, col=116,pch=19)



## ----plot-data-2---------------------------------------------------------

#add roads to our plot
plot(roads, main="Study Area")
#plot the points
#use main = to add a title to the map
plot(newPlots_UTMZ18N,add=T, col=116,pch=19)

plot(plot.locationSp, add=T)

#let's add the polygon layer to our plot
plot(aoiBoundary, add=TRUE)


## ----Plot vector-raster overlay------------------------------------------

chm <- raster("NEON_RemoteSensing/HARV/CHM/HARV_chmCrop.tif")

#notice that the `\n` command allows you to split title lines into two.

plot(chm, main="Tree Height\nHarvard Forest")

plot(roads, add = TRUE)
plot(aoiBoundary, add = TRUE)
plot(plot.location_spatial, add = TRUE, pch=19)


