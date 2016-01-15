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
#just view the attributes & first 6attribute values of the data
head(lines_HARV@data)

#how many attributes are in our data?
length(lines_HARV@data)


## ----view-shapefile-attributes-------------------------------------------
#view just the attribute names for the lines spatial object
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
#view all attributes in the TYPE column
lines_HARV$TYPE

# select features that are of TYPE "footpath"
# could put this code into other function to only have that function work on
# "footpath" lines
lines_HARV[lines_HARV$TYPE == "footpath",]

#save an object with only footpath lines
footpath_HARV<-lines_HARV[lines_HARV$TYPE == "footpath",]
footpath_HARV
#how many features in our new object
length(footpath_HARV)

#plot just footpaths
plot(footpath_HARV,
     lwd=6,
     main="Footpaths at NEON Harvard Forest Field Site")

## ----convert-to-factor---------------------------------------------------
#view the original class of the TYPE column
class(lines_HARV$TYPE)
#view levels or categories - not that there are no categories yet in our data!
#the attributes are just read as a list of character elements.
levels(lines_HARV$TYPE)

#Convert the TYPE attribute into a factor
lines_HARV$TYPE <- as.factor(lines_HARV$TYPE)
#the class is now a factor
class(lines_HARV$TYPE)
#view the levels or categories associated with TYPE (4 total)
levels(lines_HARV$TYPE)

#how many features are in each category or level?
summary(lines_HARV$TYPE)

#plot the lines data, apply a diff color to each category
plot(lines_HARV, col=lines_HARV$TYPE,
     lwd=3,
     main="Roads at the NEON Harvard Forest Field Site")

## ----adjust-line-width---------------------------------------------------
#make all lines thicker
plot(lines_HARV, col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site",
     lwd=6)

levels(lines_HARV$TYPE)
#adjust width of each level
#in this case, boardwalk (the first level) is the widest.
plot(lines_HARV, col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Boardwalk Line Width Wider",
     lwd=c(10,2,3,4))


## ----add-legend-to-plot--------------------------------------------------
plot(lines_HARV, col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site\n Default Legend")
#add a legend to our map
legend("bottomright", NULL, levels(lines_HARV$TYPE), fill=palette())


## ----modify-legend-plot--------------------------------------------------
plot(lines_HARV, col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Modified Legend")
#add a legend to our map
legend("bottomright", levels(lines_HARV$TYPE), fill=palette(), bty="n", cex=.8)


## ----adjust-palette-colors-----------------------------------------------
#view default colors
palette()

#manually set the colors for the plot!
palette(c("springgreen", "blue", "magenta", "red") )
palette()

#plot using new colors
plot(lines_HARV, col=lines_HARV$TYPE,
     main="Roads at the NEON Harvard Forest Field Site \n Pretty Colors")
#add a legend to our map
legend("bottomright", levels(lines_HARV$TYPE), fill=palette(), bty="n", cex=.8)


## ----bicycle-map, echo=FALSE---------------------------------------------
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
plot(lines_HARV, col=lines_HARV$BicyclesHo,
     lwd=4,
     main="Roads Where Bikes and Horses Are allowed  \n NEON Harvard Forest Field Site")
#add a legend to our map
legend("bottomright", 
       levels(lines_HARV$BicyclesHo), 
       fill=palette(), 
       bty="n", cex=.8)


## ----challenge-answer, echo=FALSE----------------------------------------

#Plot multiple shapefiles
plot(aoiBoundary_HARV, col = "grey93", border="grey",
     main="NEON Harvard Forest\nField Site")
plot(lines_HARV, 
     col=lines_HARV$TYPE,
     add = TRUE)
plot(point_HARV, add  = TRUE, pch = 19, col = "purple")

#assign plot to an object for easy modification!
plot_HARV<- recordPlot()

## ----customize-legend----------------------------------------------------

#create a list of all labels
labels <- c("Tower", "AOI", levels(lines_HARV$TYPE))
labels

#create a list of colors to use 
plotColors <- c("purple", "grey",fill=palette())
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

#to create a custom legend, we need to fake it
legend("bottomright", 
       legend=labels, 
       lty = lineLegend,
       pch=plotSym, 
       bty="n", 
       col=plotColors,
       cex=.9)


## ----challenge-code-plot-other, results="hide", echo=FALSE---------------

#Read the .csv file
State.Boundary.US <- readOGR("NEON-DS-Site-Layout-Files/US-Boundary-Layers",
          "US-State-Boundaries-Census-2014")

palette(terrain.colors((50)))
palette()

plot(State.Boundary.US,
     col=State.Boundary.US$NAME,
     main="Roads at the NEON Harvard Forest Field Site \n 50 Colors")

### part 2
#open plot locations

plotLocations <- readOGR("NEON-DS-Site-Layout-Files/HARV",
          "PlotLocations_HARV")

#how many unique soils?
unique(plotLocations$soilTypeOr)

#create new color palette
palette(topo.colors((2)))
palette()


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


