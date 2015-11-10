---
layout: post
title: "Lesson 03: Crop Rasters and Extract values in R"
date:   2015-10-23
authors: [Joseph Stachelek, Leah Wasser]
dateCreated:  2015-10-23
lastModified: 2015-11-10
tags: [module-1]
description: "This lesson explains how to modify (crop) a raster extent based on the extent of a vector shapefile. Particpants will also be able to extract values from a raster that correspond to the geometry of a vector overlay."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/crop-extract-raster-data-R/
comments: false
---

{% include _toc.html %}


##About

This lesson explains how to crop a raster using the extent of a 
vector shapefile. We will also cover how to extract values from a raster 
that occur within a set of polygons, or in a buffer (surrounding) region around 
a set of points.

<div id="objectives" markdown="1">

**R Skill Level:** Beginner / Intermediate

###Goals / Objectives
After completing this activity, you will:

 * Be able to crop a raster to the extent of a vector layer
 * Be able to extract values from raster that correspond to a vector file overlay
 
###What you'll need

You will need the most current version of R or R studio loaded on your computer 
to complete this lesson.

###R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **ggplot2:** `install.packages("ggplot2")`

<a href="{{ site.baseurl }}/R/Packages-In-R/" target="_blank"> 
More on Packages in R - Adapted from Software Carpentry.</a>

##Data to Download

Download the shapefiles neede to complete this lesson:

<a href="http://files.figshare.com/2387960/boundaryFiles.zip" class="btn btn-success"> 
DOWNLOAD Harvard Forest Shapefiles</a>

###Recommended Reading
This lesson is a part of a series on vector and raster data in R.

1. <a href="{{ site.baseurl }}/R/open-shapefiles-in-R/">
Intro to shapefiles in R</a>
2. <a href="{{ site.baseurl }}/R/shapefile-attributes-in-R/">
Working With Shapefile Attributes in R </a>
3. <a href="{{ site.baseurl }}/R/csv-to-shapefile-R/">
CSV to Shapefile in R</a>
4. <a href="{{ site.baseurl }}/R/crop-extract-raster-data-R/">
Crop and extract raster values in R</a>

</div> 
 
##Crop a raster to vector layer extent

The following code chunk crops our previously loaded raster by the extent of our 
polygon shapefile.


    library(raster)
    library(rgdal)
    
    #if the data aren't already loaded
    #Import a polygon shapefile 
    aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "boundaryFiles/HARV/", layer: "HarClip_UTMZ18"
    ## with 1 features
    ## It has 1 fields

    #Import a line shapefile
    lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roads")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "boundaryFiles/HARV/", layer: "HARV_roads"
    ## with 13 features
    ## It has 15 fields

    #Import a point shapefile 
    point <- readOGR("boundaryFiles/HARV/", "HARVtower_UTM18N")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "boundaryFiles/HARV/", layer: "HARVtower_UTM18N"
    ## with 1 features
    ## It has 14 fields

    #import raster chm
    chm <- raster("NEON_RemoteSensing/HARV/CHM/HARV_chmCrop.tif")

#Crop a Raster using the EXTENT of a vector layer

We can use the `crop` function to crop a raster to the extent of another spatial 
object.


    #crop the chm
    chm.cropped <- crop(x = chm, y = aoiBoundary)
    
    #view the data in a plot
    plot(aoiBoundary, main = "Cropped raster")
    plot(chm.cropped, add = TRUE)

![ ]({{ site.baseurl }}/images/rfigs/03-vector-raster-integration-advanced/Crop-by-vector-extent-1.png) 

    #lets look at the extent of all of our objects
    extent(chm)

    ## class       : Extent 
    ## xmin        : 731453 
    ## xmax        : 733150 
    ## ymin        : 4712471 
    ## ymax        : 4713838

    extent(chm.cropped)

    ## class       : Extent 
    ## xmin        : 732128 
    ## xmax        : 732251 
    ## ymin        : 4713209 
    ## ymax        : 4713359

    extent(aoiBoundary)

    ## class       : Extent 
    ## xmin        : 732128 
    ## xmax        : 732251.1 
    ## ymin        : 4713209 
    ## ymax        : 4713359

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


#I AM NOT SURE IF WE WANT TO DRAW ONE OR NOT. 
# you can also grab en extent from another object and use that.

We can also use an `extent` object as input to the `y` argument to `crop()`. 
The `drawExtent()` function is an easy (but imprecise) way to construct an `extent` 
object. See the documentation for the `extent()` function for more ways to create 
an `extent` object (`help.search("extent", package = "raster")). 
(More on the extent class in R)[http://www.inside-r.org/packages/cran/raster/docs/extent]


    new.extent  <- raster::drawExtent()

    ## Error in graphics::locator(n = 1, type = "p", pch = "+", col = col): plot.new has not been called yet


#CHECK THE CODE BELOW - THROWING AN ERROR BUT NOT SURE WHY?

  
Once we have defined the extent that we wish to crop our raster to, we can then
use the `crop` function to crop our `chm`. 


    #crop raster
    r_cropped_man <- crop(x = chm, y = new.extent)
    
    #plot extent boundary and newly cropped raster
    plot(aoiBoundary, main = "Manually cropped raster")
    plot(new.extent, col="cyan1", add = TRUE)
    plot(r_cropped_man, add = TRUE)

![ ]({{ site.baseurl }}/images/rfigs/03-vector-raster-integration-advanced/crop-using-drawn-extent-1.png) 

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
    
    #view the object
    head(tree_height)

    ##   ID HARV_chmCrop
    ## 1  1        21.20
    ## 2  1        23.85
    ## 3  1        23.83
    ## 4  1        22.36
    ## 5  1        23.95
    ## 6  1        23.89

    #view histogram of tree heights in study area
    hist(tree_height$HARV_chmCrop, main="Tree Height (m) \nHarvard Forest AOI")

![ ]({{ site.baseurl }}/images/rfigs/03-vector-raster-integration-advanced/Extract-from-raster-1.png) 

    #view summary of values
    summary(tree_height$HARV_chmCrop)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.03   21.36   22.81   22.43   23.97   38.17

#Summarizing Extracted Values 

Note that the extract function returns a `LIST` of values if you do not summarize
the data in some way or tell R to return a data.frame (`df=TRUE`). You can also
tell R to summarize and RETURN the extracted values


    #extract the average tree height (calculated using the raster pixels)
    #located within the AOI polygon
    av_tree_height_AOI <- extract(x = chm, y = aoiBoundary, fun=mean, df=TRUE)
    
    #view output
    av_tree_height_AOI

    ##   ID HARV_chmCrop
    ## 1  1     22.43018

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
    
    #view data
    av_tree_height_tower

    ##   ID HARV_chmCrop
    ## 1  1     22.38812

>#CHALLENGE - On Your Own
>
>Use the plot location shapefile that you created in lesson 02 to extract an average
>tree height value for each plot location in the study area.


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
    
    #view data
    av_tree_height_plots

    ##    ID HARV_chmCrop
    ## 1   1           NA
    ## 2   2     23.96708
    ## 3   3     22.35182
    ## 4   4     16.49719
    ## 5   5     21.55459
    ## 6   6     19.16891
    ## 7   7     20.61542
    ## 8   8     21.61490
    ## 9   9     12.23897
    ## 10 10     19.13231
    ## 11 11     21.36908
    ## 12 12     19.31904
    ## 13 13     17.25802
    ## 14 14     20.47314
    ## 15 15     12.68322
    ## 16 16     15.51574
    ## 17 17     18.90796
    ## 18 18     18.19454
    ## 19 19     19.67558
    ## 20 20     20.23258
    ## 21 21     20.44836

