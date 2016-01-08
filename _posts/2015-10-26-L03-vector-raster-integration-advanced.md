---
layout: post
title: "Lesson 03: Raster-Vector Integration: Crop Rasters and Extract Values in
R"
date:   2015-10-23
authors: [Joseph Stachelek, Leah Wasser, Megan A. Jones]
contributors: [Sarah Newman]
dateCreated:  2015-10-23
lastModified: 2016-01-07
packagesLibraries: [rgdal, raster, ggplot2]
category: 
mainTag: vector-data-workshop
tags: [vector-data, vector-data-workshop]
description: "This lesson explains how to modify (crop) a raster extent based on
the extent of a vector shapefile. The skills to be able to extract values from a
raster that correspond to the geometry of a vector overlay are also taught."
code1: 03-vector-raster-integration-advanced.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/crop-extract-raster-data-R/
comments: false
---

{% include _toc.html %}

##About
This lesson explains how to crop a raster using the extent of a vector
shapefile. We will also cover how to extract values from a raster that occur
within a set of polygons, or in a buffer (surrounding) region around a set of
points.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">
#Goals / Objectives
After completing this activity, you will:

 * Be able to crop a raster to the extent of a vector layer.
 * Be able to extract values from raster that correspond to a vector file
 overlay.
 
##Things You’ll Need To Complete This Lesson
To complete this lesson: you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

###Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`
* **ggplot2:** `install.packages("ggplot2")`

* [More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)


###Download Data
{% include/dataSubsets/_data_Site-Layout-Files.html %}
{% include/dataSubsets/_data_Airborne-Remote-Sensing.html %}

****

{% include/_greyBox-wd-rscript.html %}

**Vector Lesson Series:** This lesson is part of a lesson series on 
[vector data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-vector-series). It is also
part of a larger 
[spatio-temporal Data Carpentry Workshop ]({{ site.baseurl }}self-paced-tutorials/spatio-temporal-workshop)
that includes working with
[raster data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-raster-series) 
and  
[tabular time series in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series).
</div> 
 
##Crop a Raster to Vector Extent
The spatial layers that we have to work with on a project may not all have the 
same extent and create a pretty map.  For example look at this map, based on
four vector shapefiles with data on (field site boundary,
roads/trails, tower location, and study plot locations) and one raster GeoTIFF
file, a Canopy Height Model (CHM) for the Harvard Forest, Massachusettes.  

The plot locations (black & blue crosses) extend off the CHM raster.  The field
site boundary (green square) is so small we can't tell the precise location of 
the tower (black triangle).  


    ## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)

    ## Error in plot(chm_HARV, main = "Map of Study Plots\n w/ Canopy Height Model\nNEON Harvard Forest"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'chm_HARV' not found

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    ## Error in polypath(x = mcrds[, 1], y = mcrds[, 2], border = border, col = col, : plot.new has not been called yet

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

If we wanted a map of just the field site (green square), it would be nice for
visual appeal and file size to get rid of all the data outside the extent of 
the boundary of the green square.  We can do just this using the `crop` function
and the `extent` metadata in our shapefiles.  

Further more, it would be helpful to summarize the mean canopy height within the 
field site boundary or at each of the plot locatations.  This can be done with 
the `extract` function.  This lesson explains how to do all of these.  

#Import Data
We will use four vector shapefiles with data on (field site boundary,
roads/trails, tower location, and study plot locations) and one raster GeoTIFF
file, a Canopy Height Model for the Harvard Forest, Massachusettes. 

If you completed
[Vector Data in R: Open & Plot Shapefiles]({{site.baseurl}}/R/open-shapefile-in-R/)
and [.csv to Shapefile in R]({{site.baseurl}}/R/csv-to-shapefile-in-R/)
you may already have these `R` spatial objects. 


    #load packages
    library(rgdal)  #for vector work; sp package should always load with rgdal. 
    library (raster)   #for metadata/attributes- vectors or rasters
    
    #set working directory to data folder
    #setwd("pathToDirHere")
    
    #Imported in L00: Vector Data in R - Open & Plot Data
    # shapefile 
    aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                                "HarClip_UTMZ18")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV/", layer: "HarClip_UTMZ18"
    ## with 1 features
    ## It has 1 fields

    #Import a line shapefile
    lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/",
                           "HARV_roads")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV/", layer: "HARV_roads"
    ## with 13 features
    ## It has 15 fields

    #Import a point shapefile 
    point_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                          "HARVtower_UTM18N")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV/", layer: "HARVtower_UTM18N"
    ## with 1 features
    ## It has 14 fields

    #Imported in L02: .csv to Shapefile in R
    #import raster Canopy Height Model (CHM)
    chm_HARV <- 
      raster("NEON-DS-Airborne-RemoteSensing/HARV/CHM/HARV_chmCrop.tif")

    ## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)

#Crop a Raster Using Vector Extent
We can use the `crop` function to crop a raster to the extent of another spatial 
object.


    #crop the chm
    chm_HARV_BoundCrop <- crop(x = chm_HARV, y = aoiBoundary_HARV)

    ## Error in crop(x = chm_HARV, y = aoiBoundary_HARV): error in evaluating the argument 'x' in selecting a method for function 'crop': Error: object 'chm_HARV' not found

    #view the data in a plot
    plot(aoiBoundary_HARV, main = "Cropped CHM Raster")

![ ]({{ site.baseurl }}/images/rfigs/03-vector-raster-integration-advanced/Crop-by-vector-extent-1.png) 

    plot(chm_HARV_BoundCrop, add = TRUE)

    ## Error in plot(chm_HARV_BoundCrop, add = TRUE): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'chm_HARV_BoundCrop' not found

    #lets look at the extent of all of our objects
    extent(chm_HARV)

    ## Error in extent(chm_HARV): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'chm_HARV' not found

    extent(chm_HARV_BoundCrop)

    ## Error in extent(chm_HARV_BoundCrop): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'chm_HARV_BoundCrop' not found

    extent(aoiBoundary_HARV)

    ## class       : Extent 
    ## xmin        : 732128 
    ## xmax        : 732251.1 
    ## ymin        : 4713209 
    ## ymax        : 4713359

<div id="challenge" markdown="1">
##Challenge: Crop to Vector Points Extent
Crop the Canopy Height Model to the extent of the study plot locations. Then
plot both layers together. 

If you completed
[.csv to Shapefile in R]({{site.baseurl}}/R/csv-to-shapefile-in-R/)
you have these locations as a the spatial `R` Spatial object
`plot.locationsSp_HARV`.  Otherwise, import the locations from the
`PlotLocations_HARV` shapefile in the downloaded data. 

These are discrete points not a large boundary like with `aoiBoundary_HARV` how
is the extent for the cropping of the raster determined?  
</div>

    ## Error in crop(x = chm_HARV, y = plot.locationsSp_HARV): error in evaluating the argument 'x' in selecting a method for function 'crop': Error: object 'chm_HARV' not found

    ## Error in plot(CHM_plots_HARVcrop, main = "Study Plot Locations\n NEON Harvard Forest"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'CHM_plots_HARVcrop' not found

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet


#Draw an Extent
We can also use an `extent` object as input to the `y` argument to `crop()`. 
The `drawExtent()` function is an easy (but imprecise) way to construct an
`extent`object. 


    new.extent.draw  <- raster::drawExtent()

    ## Error in graphics::locator(n = 1, type = "p", pch = "+", col = col): plot.new has not been called yet

Or we can set an `extent` manually if we know exactly where we want the extent
to occur. 


    #extent format (xmin,xmax,ymin,ymax)
    new.extent <- extent(732161.2, 732238.7, 4713249, 4713333)

Once we have defined the extent that we wish to crop our raster to, we can then
use the `crop` function to crop our `chm`. 


    #crop raster
    CHM_HARV_manualCrop <- crop(x = chm_HARV, y = new.extent)

    ## Error in crop(x = chm_HARV, y = new.extent): error in evaluating the argument 'x' in selecting a method for function 'crop': Error: object 'chm_HARV' not found

    #plot extent boundary and newly cropped raster
    plot(aoiBoundary_HARV, main = "Manually Cropped Raster\n Harvard Forest")
    plot(new.extent, col="darkblue", add = TRUE)

![ ]({{ site.baseurl }}/images/rfigs/03-vector-raster-integration-advanced/crop-using-drawn-extent-1.png) 

    plot(CHM_HARV_manualCrop, add = TRUE)

    ## Error in plot(CHM_HARV_manualCrop, add = TRUE): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'CHM_HARV_manualCrop' not found

We can see that our manual `new.extent` is smaller than the `aoiBoundary_HARV` 
and that the raster correctly cropped to the manually set extent.  
 
See the documentation for the `extent()` function for more ways
to create an `extent` object. 
* `help.search("extent", package = "raster"))
* More on the 
<a href="http://www.inside-r.org/packages/cran/raster/docs/extent" target="_blank">
extent class in `R`</a>.

##Extract Raster Value Based on Vector Layer
Often we want to extract values from a raster layer for particular locations - 
for example, plot locations that we are sampling on the ground. 

To do this, we can use the `extract()` function. We will begin by extracting all
canopy height pixel values located within our `aoiBoundary` polygon which
surrounds the tower located at the NEON Harvard Forest field site.

<figure>
    <a href="http://neondataskills.org/images/spatialData/BufferSquare.png">
    <img src="http://neondataskills.org/images/spatialData/BufferSquare.png"></a>
    <figcaption> Extract raster information using a polygon boundary. 
    Source: National Ecological Observatory Network (NEON).  
    </figcaption>
</figure>


    #extract tree height for AOI
    #set df=TRUE to return a data.frame rather than a list of values
    tree_height <- extract(x = chm_HARV, y = aoiBoundary_HARV, df=TRUE)

    ## Error in extract(x = chm_HARV, y = aoiBoundary_HARV, df = TRUE): error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm_HARV' not found

    #view the object
    head(tree_height)

    ## Error in head(tree_height): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'tree_height' not found

We can use this to view a histogram of tree heights in the study area.


    #view histogram of tree heights in study area
    hist(tree_height$HARV_chmCrop, main="Tree Height (m) \nHarvard Forest")

    ## Error in hist(tree_height$HARV_chmCrop, main = "Tree Height (m) \nHarvard Forest"): error in evaluating the argument 'x' in selecting a method for function 'hist': Error: object 'tree_height' not found

    #view summary of values
    summary(tree_height$HARV_chmCrop)

    ## Error in summary(tree_height$HARV_chmCrop): error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'tree_height' not found

* Check out the documentation for the `extract()` function for more details 
(`help.search("extract", package = "raster")`).

#Summarize Extracted Raster Values 
The `extract` function returns a `LIST` of values as default. You can tell `R` 
to summarize the data in some way or to return a `data.frame` (`df=TRUE`). 

You can also tell `R` to summarize and return the extracted values. 


    #extract the average tree height (calculated using the raster pixels)
    #located within the AOI polygon
    av_tree_height_AOI <- extract(x = chm_HARV, y = aoiBoundary_HARV,
                                  fun=mean, df=TRUE)

    ## Error in extract(x = chm_HARV, y = aoiBoundary_HARV, fun = mean, df = TRUE): error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm_HARV' not found

    #view output
    av_tree_height_AOI

    ## Error in eval(expr, envir, enclos): object 'av_tree_height_AOI' not found

#Extract Data using x,y Locations
We can also extract data from a raster using point locations. We can specify the
buffer region (or area around the point) that we wish to extract pixels from.
Below is code that demonstrates how to do this, using a single point - the
Harvard Forest tower location.

<figure>
    <a href="http://neondataskills.org/images/spatialData/BufferCircular.png">
    <img src="http://neondataskills.org/images/spatialData/BufferCircular.png"></a>
    <figcaption> Extract raster information using a buffer region. 
    Source: National Ecological Observatory Network (NEON).  
    </figcaption>
</figure>


    #extract the average tree height (calculated using the raster pixels)
    #located within the AOI polygon
    #use a buffer of 20 meters and mean function (fun) 
    av_tree_height_tower <- extract(x = chm_HARV, 
                                   y = point_HARV, 
                                   buffer=20,
                                   fun=mean, 
                                   df=TRUE)

    ## Error in extract(x = chm_HARV, y = point_HARV, buffer = 20, fun = mean, : error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm_HARV' not found

    #view data
    av_tree_height_tower

    ## Error in eval(expr, envir, enclos): object 'av_tree_height_tower' not found

<div id="challenge" markdown="1">
#Challenge: Extract & Summarize Raster Data in a Vector Extent
Use the plot location shapefile `plot.locations_HARV` to extract an average
tree height value for each plot location in the study area.
</div>

    ## Error in extract(x = chm_HARV, y = plot.locations_HARV, buffer = 20, fun = mean, : error in evaluating the argument 'x' in selecting a method for function 'extract': Error: object 'chm_HARV' not found

    ## Error in eval(expr, envir, enclos): object 'meanTreeHt_plots_HARV' not found
