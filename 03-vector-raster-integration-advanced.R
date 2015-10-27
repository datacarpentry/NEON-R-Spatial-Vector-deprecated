## ----load-libraries-data-------------------------------------------------

library(raster)
library(rgdal)

#if the data aren't already loaded
#Import a polygon shapefile 
aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

#Import a line shapefile
lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roadStream")

#Import a point shapefile 
point <- readOGR("boundaryFiles/HARV/", "HARVtower_UTM18N")

#import raster chm
chm <- raster("NEON_RemoteSensing/HARV/CHM/HARV_chmCrop.tif")


## ----Crop by vector extent-----------------------------------------------

#crop the chm
chm.cropped <- crop(x = chm, y = aoiBoundary)

#view the data in a plot
plot(aoiBoundary, main = "Cropped raster")
plot(r_cropped, add = TRUE)

#lets look at the extent of all of our objects
extent(chm)
extent(chm.cropped)
extent(aoiBoundary)


## ----crop-raster-points--------------------------------------------------

plotLocations <- readOGR(".", "newFile")

#crop the chm 
chm.cropped <- crop(x = chm, y = plotLocations)


## ----Create-custom-extent-object-----------------------------------------
extent <- raster::drawExtent()


## ----Hidden-extent-chunk, echo=FALSE-------------------------------------
#this is throwing an error
new.extent <- extent(xmin = 732161.2, xmax = 732238.7, ymin = 4713249, ymax = 4713333)


## ----Crop by drawn extent------------------------------------------------
r_cropped_man <- crop(x = r, y = new.extent)

plot(aoiBoundary, main = "Manually cropped raster")
plot(extent, add = TRUE)
plot(r_cropped_man, add = TRUE)

## ----Extract from raster-------------------------------------------------

#extract tree height for AOI
#set df=TRUE to return a data.frame rather than a list of values
tree_height <- extract(x = chm, y = aoiBoundary, df=TRUE)

#view the object
head(tree_height)

#view histogram of tree heights in study area
hist(tree_height$HARV_chmCrop, main="Tree Height (m) \nHarvard Forest AOI")

#view summary of values
summary(tree_height$HARV_chmCrop)


## ----summarize-extract---------------------------------------------------

#extract the average tree height (calculated using the raster pixels)
#located within the AOI polygon
av_tree_height_AOI <- extract(x = chm, y = aoiBoundary, fun=mean, df=TRUE)

#view output
av_tree_height_AOI


## ----extract-point-to-buffer---------------------------------------------

#extract the average tree height (calculated using the raster pixels)
#located within the AOI polygon
av_tree_height_tower <- extract(x = chm, 
                               y = point, 
                               buffer=20,
                               fun=mean, 
                               df=TRUE)

#view data
av_tree_height_tower


## ----extract-plot-tree-height, ECHO=FALSE--------------------------------

############ CODE FOR ON YOUR OWN ACTIVITY #####################
#Import a polygon shapefile 
plotLocations <- readOGR(".", "newFile")

#extract data at each plot location
av_tree_height_plots <- extract(x = chm, 
                               y = plotLocations, 
                               buffer=20,
                               fun=mean, 
                               df=TRUE)

#view data
av_tree_height_plots



