---
layout: post
title: "Lesson 00: Vector Data in R - Open and plot shapefiles"
date:   2015-10-26
authors: "Joseph Stachelek, Leah Wasser"
dateCreated:  2015-10-23
lastModified: 2015-10-26
tags: [module-1]
description: "This post explains the how to open and plot point, line, and polygon shapefiles in R."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/open-shapefiles-in-R/
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
In this lesson, we will work with vector data in R. We will open and plot point, 
line, and polygon data, stored in `shapefile` format, in R.

###Goals / Objectives
After completing this activity, you will:

 * Know the difference between point, line, and polygon vector elements.
 * Understand the differences between opening point, line and polygon shapefiles in R.
 * Understand the components of a _spatial object_ (in R)
 
###Tools To Install

To work with vector data in R, we can use the `rgdal` library. We will load the `raster`
library to work with rasters. The `raster` library also allows us to explore metadata
using similar commands with both rasters and vectors.


    #load required libraries
    library(rgdal)
    library(raster)

###Recommended Pre-Lesson Reading

#About Vector Data
Vector data are composed of discrete geometric locations (x,y values) that make 
up objects. The organization of the geometric locations, determines the type of 
vector that we are working with (point, line or polygon) as follows: 

* **Points:** in a point vector dataset, each point is represented by an x,y coordinate location. 
There can be many points in a vector point file. Examples of points include plot locations, or the
locations of individual trees.
* **Lines:** Lines are composed of many points that are connected. For instance, a road, 
or a stream is a line, each bend in the road or stream represents a vertex that 
has an x,y location associated with it. A line consists of ATLEAST 2 vertices 
that are connnected. Examples: Roads, Streams.
* **Polygons:** a polygon consists of 3 or more vertices that are both connected and
most often closed. Thus the outline of a plot boundary, a lake, ocean, state or 
country would all most often be stored in a polygon format. 

NOTE: a line can represent a boundary as well - however a line will not create a 
closed object.

**INSERT GRAPHIC HERE**

##Shapefiles: Points, Lines, and Polygons
Geospatial data in vector format, is often stored in a `shapefile` format. Because the 
structure of a point, line and polygon object is different, each shapefile
can only contain one vector type (all points, all polygons or all lines). You will 
not find a mixture of point, line and polygon objects in one shapefile!

Each vector in the shapefile often has a set os associated `attributes` that describe the data.
For example, a line shapefile that contains the locations of streams, might contain stream
names for each line.

More about shapefiles can found on [Wikipedia](https://en.wikipedia.org/wiki/Shapefile) 
(add link to Metadata lesson?).

##Importing shapefiles

We are going to use the `R` function `readOGR()` to import shapefiles. These 
shapefiles include 

* a polygon shapefile representing our study area boundary, 
* a line shapefile representing roads and streams, and 
* a point shapefile representing the location of a [flux tower](http://www.neoninc.org/science-design/collection-methods/flux-tower-measurements) located at the NEON 
Harvard Forest field site.

The first shapefile we will open, contains the boundary of our study area. 
It is a polygon layer.


    #Import a polygon shapefile 
    aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    #view attributes of the layer
    aoiBoundary

    ## Error in eval(expr, envir, enclos): object 'aoiBoundary' not found

    #you can also use the attributes command to just view the attributes of the data
    (aoiBoundary@data)

    ## Error in eval(expr, envir, enclos): object 'aoiBoundary' not found

    #create a quick plot of the shapefile
    plot(aoiBoundary)

    ## Error in plot(aoiBoundary): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'aoiBoundary' not found

#View Shapefile Metadata

When we import the `HarClip_UTMZ18` layer into R, some key metadata are stored
with the spatial R object:

1. ** object type: **  in this case our area of interest (AOI) is a polygon boundary
R knows to bring it in as a `SpatialPolygonsDataFrame`
2. **CRS** - The shapefile also contains projection information `coord ref.` in the output 
above.
3. **extent** - we can see the spatial extent of the shapefile. Note that the spatial
extent for a shapefile represents the extent for ALL polygons (or spatial objects)
in the shapefile!

We can view the CRS, Extent and other metadata for the shapefile using the following
commands:


    #view just the crs for the shapefile
    crs(aoiBoundary)

    ## Error in crs(aoiBoundary): error in evaluating the argument 'x' in selecting a method for function 'crs': Error: object 'aoiBoundary' not found

    #view just the extent for the shapefile
    extent(aoiBoundary)

    ## Error in extent(aoiBoundary): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'aoiBoundary' not found

#Import a line and point shapefile

>#ON YOUR OWN ACTIVITY
>
>Using the steps above, import the HARV_roadStream and HARVtower_UTM18N layers into R.
>Answer the following questions:

>1. What type of R spatial object is created when you import each layer?
>2. What is the extent and CRS for each object?
>3. Do the files contain, points, lines or polygons?
>4. How many spatial objects are in each file?
>
>Discuss the data with your neighbor as you work through this challenge!



    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

#Shapefile Attributes
Each spatial object in a shapefile can have the same set of attributes. These attributes
can be any sort of attribute that you might store in a spreadsheet about your data. 

We can view a metadata/attribute summary of each shapefile by entering 
the name of the `R` object in the console. Note that the metadata output includes 
the _class_, the number of _features_, the _extent_, and the `coordinate reference 
system` (crs) of the `R` object. The last two lines of summary show a preview of 
the `R` object _attributes_.


    #View attributes
    squarePlot

    ## Error in eval(expr, envir, enclos): object 'squarePlot' not found

    #view a summary of each attribute associated with the spatial object
    summary(squarePlot)

    ## Error in summary(squarePlot): error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'squarePlot' not found

    #explore the lines and point objects
    lines

    ## standardGeneric for "lines" defined from package "graphics"
    ## 
    ## function (x, ...) 
    ## standardGeneric("lines")
    ## <environment: 0x11307e640>
    ## Methods may be defined for arguments: x
    ## Use  showMethods("lines")  for currently available ones.

    point

    ## Error in eval(expr, envir, enclos): object 'point' not found

#Plot Multiple Shapefiles

The `plot()` function can be used for basic plotting of these spatial objects. 
We use the `add = TRUE` argument to overlay shapefiles on top of each other. As we 
would when creating a map in a typical GIS application like QGIS.

We can use the `main=""` to give our plot a title. If you want the title to 
span 2 lines, use `\n` where you'd like the line break.


    #Plot multiple shapefiles
    
    plot(x = aoiBoundary, col = "purple", main="Harvard Forest\nStudy Area")

    ## Error in plot(x = aoiBoundary, col = "purple", main = "Harvard Forest\nStudy Area"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'aoiBoundary' not found

    plot(x = lines, add = TRUE)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    #use the pch element to adjust the symbology of the points
    plot(x = point, add  = TRUE, pch = 19, col = "red")

    ## Error in plot(x = point, add = TRUE, pch = 19, col = "red"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'point' not found


