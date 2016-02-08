## ----load-packages-data--------------------------------------------------
#load packages
#rgdal: for vector work; sp package should always load with rgdal. 
library(rgdal)  
#raster: for metadata/attributes- vectors or rasters
library (raster)   

#set working directory to data folder
#setwd("pathToDirHere")

#Import a polygon shapefile 
aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                            "HarClip_UTMZ18")

#Import a line shapefile
lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/", "HARV_roads")

#Import a point shapefile 
point_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                      "HARVtower_UTM18N")


## ----view-shapefile-metadata---------------------------------------------
#view class
class(x = point_HARV)

# x= isn't actually needed; it just specifies which object
#view features count
length(point_HARV)

#view crs - note - this only works with the raster package loaded
crs(point_HARV)

#view extent- note - this only works with the raster package loaded
extent(point_HARV)

#view metadata summary
point_HARV

## ----shapefile-attributes------------------------------------------------
#just view the attributes & first 6 attribute values of the data
head(lines_HARV@data)

#how many attributes are in our vector data object?
length(lines_HARV@data)


## ----view-shapefile-attributes-------------------------------------------
#view just the attribute names for the lines_HARV spatial object
names(lines_HARV@data)


## ----challenge-code-attributes-classes, results="hide", echo=FALSE-------
#1
length(names(point_HARV@data))  #14 attributes
names(aoiBoundary_HARV@data)  #1 attribute

#2
head(point_HARV@data)  #Harvard University, LTER

#3
point_HARV@data  # C Country

## ----explore-attribute-values--------------------------------------------
#view all attributes in the lines shapefile within the TYPE field
lines_HARV$TYPE


## ----Subsetting-shapefiles-----------------------------------------------
# select features that are of TYPE "footpath"
# could put this code into other function to only have that function work on
# "footpath" lines
lines_HARV[lines_HARV$TYPE == "footpath",]

#save an object with only footpath lines
footpath_HARV<-lines_HARV[lines_HARV$TYPE == "footpath",]
footpath_HARV
#how many features in our new object
length(footpath_HARV)

## ----plot-subset-shapefile-----------------------------------------------
#plot just footpaths
plot(footpath_HARV,
     col=lines_HARV$OBJECTID, #color set by "OBJECTID" attribute
     lwd=6,
     main="Footpaths at NEON Harvard Forest Field Site")


## ----convert-to-factor---------------------------------------------------
#view the original class of the TYPE column
class(lines_HARV$TYPE)

#view levels or categories - note that there are no categories yet in our data!
#the attributes are just read as a list of character elements.
levels(lines_HARV$TYPE)

#Convert the TYPE attribute into a factor
#Only do this IF the data do not import as a factor!
#lines_HARV$TYPE <- as.factor(lines_HARV$TYPE)
#class(lines_HARV$TYPE)
#levels(lines_HARV$TYPE)

#how many features are in each category or level?
summary(lines_HARV$TYPE)

## ----palette-and-plot----------------------------------------------------
#check current palette
palette()

#use the default palette()
palette ("default")

#what is the default palette?
palette()

#plot the lines data, apply a diff color to each category
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     lwd=3,
     main="Roads at the NEON Harvard Forest Field Site")

## ----adjust-line-width---------------------------------------------------
#make all lines thicker
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n All Lines Thickness=6",
     lwd=6)

levels(lines_HARV$TYPE)
#adjust line width by level
#in this case, boardwalk (the first level) is the widest.
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Line width varies by Type Attribute Value",
     lwd=lines_HARV$TYPE)


## ----plot-width-by-attribute---------------------------------------------
#view the factor levels
levels(lines_HARV$TYPE)
#create vector of line width values
lineWidth <- c(6,4,1,2)[lines_HARV$TYPE]
#view vector
lineWidth
#adjust width of each level
#in this case, boardwalk (the first level) is the widest.
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Boardwalks & Footpath Lines Are Thick",
     lwd=lineWidth)


## ----add-legend-to-plot--------------------------------------------------
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site\n Default Legend")

#add a legend to our map
legend("bottomright",   #location of legend
      legend=levels(lines_HARV$TYPE), #categories or elements to render in the legend
      fill=palette()) #color palette to use to fill objects in legend.


## ----modify-legend-plot--------------------------------------------------
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Modified Legend")
#add a legend to our map
legend("bottomright", 
       legend=levels(lines_HARV$TYPE), 
       fill=palette(), 
       bty="n", #turn off the legend border
       cex=.8) #decrease the font / legend size


## ----adjust-palette-colors-----------------------------------------------

#manually set the colors for the plot!
palette(c("springgreen", "blue", "magenta", "orange") )
palette()

#plot using new colors
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Pretty Colors")
#add a legend to our map
legend("bottomright", 
       levels(lines_HARV$TYPE), 
       fill=palette(), 
       bty="n", cex=.8)


## ----bicycle-map, include=TRUE, results="hide", echo=FALSE---------------
#view levels 
levels(lines_HARV$BicyclesHo)

#convert to factor if necessary
lines_HARV$BicyclesHo <- as.factor(lines_HARV$BicyclesHo)
levels(lines_HARV$BicyclesHo)

#remove NA values
lines_removeNA <- lines_HARV[na.omit(lines_HARV$BicyclesHo),]

#set colors so only the allowed roads are magenta
palette(c("magenta","grey","grey"))
palette()
#plot using new colors
plot(lines_HARV, 
     col=lines_HARV$BicyclesHo,
     lwd=4,
     main="Roads Where Bikes and Horses Are Allowed \n NEON Harvard Forest Field Site")
#add a legend to our map
legend("bottomright", 
       levels(lines_HARV$BicyclesHo), 
       fill=palette(), 
       bty="n", #turn off border
       cex=.8) #adjust font size


## ----challenge-answer, echo=FALSE, results="hide"------------------------
# reset palette
palette ("default")
#view palette colors
palette()

#Plot multiple shapefiles
plot(aoiBoundary_HARV, 
     col = "grey93", 
     border="grey",
     main="NEON Harvard Forest\nField Site")

plot(lines_HARV, 
     col=lines_HARV$TYPE,
     add = TRUE)

plot(point_HARV, 
     add  = TRUE, 
     pch = 19, 
     col = "purple")

#assign plot to an object for easy modification!
plot_HARV<- recordPlot()


## ----customize-legend----------------------------------------------------

#create a list of all labels
labels <- c("Tower", "AOI", levels(lines_HARV$TYPE))
labels

#create a list of colors to use 
plotColors <- c("purple", "grey", fill=palette())
plotColors

#create a list of pch values
#these are the symbols that will be used for each legend value
# ?pch will provide more information on values
plotSym <- c(16,15,15,15,15,15)
plotSym

#Plot multiple shapefiles
plot_HARV

#to create a custom legend, we need to fake it
legend("bottomright", 
       legend=labels,
       pch=plotSym, 
       bty="n", 
       col=plotColors,
       cex=.8)


## ----refine-legend-------------------------------------------------------
#Create line object
lineLegend = c(NA,NA,1,1,1,1)
lineLegend
plotSym <- c(16,15,NA,NA,NA,NA)
plotSym

#Plot multiple shapefiles
plot_HARV

#Build a custom legend
legend("bottomright", 
       legend=labels, 
       lty = lineLegend,
       pch=plotSym, 
       bty="n", 
       col=plotColors,
       cex=.8)


## ----challenge-code-plot-color, results="hide", warning= FALSE, echo=FALSE----
##1
#Read the .csv file
State.Boundary.US <- readOGR("NEON-DS-Site-Layout-Files/US-Boundary-Layers",
          "US-State-Boundaries-Census-2014")

palette(terrain.colors((50)))
palette()

plot(State.Boundary.US,
     col=State.Boundary.US$NAME,
     main="Contiguous U.S. State Boundaries \n 50 Colors")

##2
#open plot locations
plotLocations <- readOGR("NEON-DS-Site-Layout-Files/HARV",
          "PlotLocations_HARV")

#how many unique soils?  Two
unique(plotLocations$soilTypeOr)

#create new color palette -- topo.colors palette
palette(topo.colors((2)))
palette()

#plot the locations 
plot(plotLocations,
     col=plotLocations$soilTypeOr, pch=18,
     main="NEON Field Sites by Soil Type")

#create legend 
legend("bottomright", 
       legend=c("Intceptisols","Histosols"),
       pch=18, 
       col=palette(),
       bty="n", 
       cex=1)

############ Challenge Part 3 ############
#create vector of plot symbols
plSymbols <- c(15,17)[plotLocations$soilTypeOr]
plSymbols

#plot the locations 
plot(plotLocations,
     col=plotLocations$soilTypeOr, 
     pch=plSymbols,
     main="NEON Field Sites by Soil Type")

#create legend 
legend("bottomright", 
       legend=c("Intceptisols","Histosols"),
       pch=plSymbols, 
       col=palette(),
       bty="n", 
       cex=1)

