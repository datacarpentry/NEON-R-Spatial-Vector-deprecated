---
layout: post
title: "Lesson 03: Crop Rasters and Extract values in R"
date:   2015-10-23
authors: "Joseph Stachelek, Leah Wasser"
dateCreated:  2015-10-23
lastModified: 2015-10-26
tags: [module-1]
description: "This lesson explains how to modify (crop) a raster extent based on the extent of a vector shapefile. Particpants will also be able to extract values from a raster that correspond to the geometry of a vector overlay."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/crop-extract-raster-data-R/
---

<section id="table-of-contents" class="toc">
  <header>
    <h3>Contents</h3>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->



##About

This lesson explains how to modify (crop) a raster extent based on the extent of a 
vector shapefile. Particpants will also be able to extract values from a raster 
that occur within a set of polygons, or in a buffer (surrounding) region around 
a set of points.


###Goals / Objectives
After completing this activity, you will:

 * Be able to crop a raster to the extent of a vector layer
 * Be able to extract values from raster that correspond to a vector file overlay
 
##Crop a raster to vector layer extent

The following code chunk crops our previously loaded raster by the extent of our 
polygon shapefile.


    library(raster)
    library(rgdal)
    
    #if the data aren't already loaded
    #Import a polygon shapefile 
    aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    #Import a line shapefile
    lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roadStream")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    #Import a point shapefile 
    point <- readOGR("boundaryFiles/HARV/", "HARVtower_UTM18N")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    #import raster chm
    chm <- raster("NEON_RemoteSensing/HARV/CHM/HARV_chmCrop.tif")

    ## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)

#Crop a Raster using the EXTENT of a vector layer

We can use the `crop` function to crop a raster to the extent of another spatial 
object.


    #crop the chm
    chm.cropped <- crop(x = chm, y = aoiBoundary)

    ## Error in crop(x = chm, y = aoiBoundary): error in evaluating the argument 'x' in selecting a method for function 'crop': Error: object 'chm' not found

    #view the data in a plot
    plot(aoiBoundary, main = "Cropped raster")

    ## Error in plot(aoiBoundary, main = "Cropped raster"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'aoiBoundary' not found

    plot(r_cropped, add = TRUE)

    ## Error in plot(r_cropped, add = TRUE): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'r_cropped' not found

    #lets look at the extent of all of our objects
    extent(chm)

    ## Error in extent(chm): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'chm' not found

    extent(chm.cropped)

    ## Error in extent(chm.cropped): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'chm.cropped' not found

    extent(aoiBoundary)

    ## Error in extent(aoiBoundary): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'aoiBoundary' not found

#On Your Own -- still in progress

We should have them import the shapefile they mad in lesson 02 and crop to that
extent. Then ask - how does crop work because a point file isn't a boundary...
but it does have an extent...


    plotLocations <- readOGR(".", "newFile")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: ".", layer: "newFile"
    ## with 21 features
    ## It has 43 fields

    #crop the chm 
    chm.cropped <- crop(x = chm, y = plotLocations)

    ## Error in crop(x = chm, y = plotLocations): error in evaluating the argument 'x' in selecting a method for function 'crop': Error: object 'chm' not found


#I AM NOT SURE IF WE WANT TO DRAW ONE OR NOT. 
# you can also grab en extent from another object and use that.

We can also use an `extent` object as input to the `y` argument to `crop()`. 
The `drawExtent()` function is an easy (but imprecise) way to construct an `extent` 
object. See the documentation for the `extent()` function for more ways to create 
an `extent` object (`help.search("extent", package = "raster")). 


    extent <- raster::drawExtent()

    ## Error in graphics::locator(n = 1, type = "p", pch = "+", col = col): plot.new has not been called yet

#CHECK THE CODE BELOW - THROWING AN ERROR BUT NOT SURE WHY?

    ## Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'extent' for signature '"missing"'
  
#this section still doesn't work. (above error) 


    r_cropped_man <- crop(x = r, y = new.extent)

    ## Error in crop(x = r, y = new.extent): error in evaluating the argument 'x' in selecting a method for function 'crop': Error: object 'r' not found

    plot(aoiBoundary, main = "Manually cropped raster")

    ## Error in plot(aoiBoundary, main = "Manually cropped raster"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'aoiBoundary' not found

    plot(extent, add = TRUE)

    ## Warning in x(x): more elements than expected (should be 4)

    ## Error in curve(expr = x, from = from, to = to, xlim = xlim, ylab = ylab, : 'expr' did not evaluate to an object of length 'n'

    plot(r_cropped_man, add = TRUE)

    ## Error in plot(r_cropped_man, add = TRUE): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'r_cropped_man' not found

##Extract values from a raster using a vector overlay

Often we want to extract values from a raster layer for particular locations - 
for example plot locations that we are sampling on the ground. To do this, we can
use the `extract()` function. We will begin by extracting all canopy height pixel 
values located within our aoiBoundary polygon which surrounds the tower located at the NEON
field site, Harvard Forest. We can use this to view a histogram of tree heights
in our area of interest!

Check out the documentation for the `extract()` function for more details 
(`help.search("extract", package = "raster")`).


![Extract using polygon boundary](http://neondataskills.org/images/spatialData/BufferSquare.png "Extract using polygon boundary")


    #extract tree height for AOI
    #set df=TRUE to return a data.frame rather than a list of values
    tree_height <- extract(x = chm, y = aoiBoundary, df=TRUE)

    ## Error in extract(x = chm, y = aoiBoundary, df = TRUE): error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm' not found

    #view the object
    head(tree_height)

    ## Error in head(tree_height): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'tree_height' not found

    #view histogram of tree heights in study area
    hist(tree_height$HARV_chmCrop, main="Tree Height (m) \nHarvard Forest AOI")

    ## Error in hist(tree_height$HARV_chmCrop, main = "Tree Height (m) \nHarvard Forest AOI"): error in evaluating the argument 'x' in selecting a method for function 'hist': Error: object 'tree_height' not found

    #view summary of values
    summary(tree_height$HARV_chmCrop)

    ## Error in summary(tree_height$HARV_chmCrop): error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'tree_height' not found

#Summarizing Extracted Values 

Note that the extract function returns a `LIST` of values if you do not summarize
the data in some way or tell R to return a data.frame (`df=TRUE`). You can also
tell R to summarize and RETURN the extracted values


    #extract the average tree height (calculated using the raster pixels)
    #located within the AOI polygon
    av_tree_height_AOI <- extract(x = chm, y = aoiBoundary, fun=mean, df=TRUE)

    ## Error in extract(x = chm, y = aoiBoundary, fun = mean, df = TRUE): error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm' not found

    #view output
    av_tree_height_AOI

    ## Error in eval(expr, envir, enclos): object 'av_tree_height_AOI' not found

#Extracting Data Using X,Y Locations

We can also extract data from a raster using point locations. We can specify the
buffer region (or area around the point) that we wish to extract pixels from. Below
is code that demonstrates how to do this, using a single point - the Harvard Forest
tower location.

![Extract using buffer region](http://neondataskills.org/images/spatialData/BufferCircular.png "Extract using buffer region")



    #extract the average tree height (calculated using the raster pixels)
    #located within the AOI polygon
    av_tree_height_tower <- extract(x = chm, 
                                   y = point, 
                                   buffer=20,
                                   fun=mean, 
                                   df=TRUE)

    ## Error in extract(x = chm, y = point, buffer = 20, fun = mean, df = TRUE): error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm' not found

    #view data
    av_tree_height_tower

    ## Error in eval(expr, envir, enclos): object 'av_tree_height_tower' not found

#CHALLENGE
Use the plot location shapefile that you created in lesson 02 to extract an average
tree height value for each plot location in the study area!


    ############ CODE FOR ON YOUR OWN ACTIVITY #####################
    #Import a polygon shapefile 
    plotLocations <- readOGR(".", "newFile")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: ".", layer: "newFile"
    ## with 21 features
    ## It has 43 fields

    #extract data at each plot location
    av_tree_height_plots <- extract(x = chm, 
                                   y = plotLocations, 
                                   buffer=20,
                                   fun=mean, 
                                   df=TRUE)

    ## Error in extract(x = chm, y = plotLocations, buffer = 20, fun = mean, : error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm' not found

    #view data
    av_tree_height_plots

    ## Error in eval(expr, envir, enclos): object 'av_tree_height_plots' not found

