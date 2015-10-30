---
layout: post
title: "Lesson 00: Vector Data in R - Open and plot shapefiles"
date:   2015-10-26
authors: [Joseph Stachelek, Leah Wasser]
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

<div id="objectives">
<h3>What you'll need</h3>

You will need the most current version of R or R studio loaded on your computer 
to complete this lesson.

<h3>R Libraries to Install:</h3>
<ul>
<li><strong>raster:</strong> <code> install.packages("raster")</code></li>
<li><strong>sp:</strong> <code> install.packages("sp")</code></li>
<li><strong>rgdal:</strong> <code> install.packages("rgdal")</code></li>
<li><strong>ggplot2:</strong> <code> install.packages("ggplot2")</code></li>
</ul>

<a href="{{ site.baseurl }}/R/Packages-In-R/" target="_blank"> 
More on Packages in R - Adapted from Software Carpentry.</a>

<h2>Data to Download</h2>

Download the raster and <i>insitu</i> collected vegetation structure data:

<a href="http://files.figshare.com/2387960/boundaryFiles.zip" class="btn btn-success"> 
DOWNLOAD Harvard Forest Shapefiles</a>

<h3>Recommended Reading</h3>
This lesson is a part of a series on vector and raster data in R.

<ol>
<li> <a href="{{ site.baseurl }}/R/open-shapefiles-in-R/">
Intro to shapefiles in R</a></li>
<li><a href="{{ site.baseurl }}/R/shapefile-attributes-in-R/">
Working With Shapefile Attributes in R </a></li>
<li><a href="{{ site.baseurl }}/R/csv-to-shapefile-R/">
CSV to Shapefile in R</a></li>
<li><a href="{{ site.baseurl }}/R/crop-extract-raster-data-R/">
Crop and extract raster values in R</a></li>
</ol>
</div>

NOTE: The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").
{: .notice}
 
###Notes about R Libraries

To work with vector data in R, we can use the `rgdal` library. We will load the `raster`
library to work with rasters. The `raster` library also allows us to explore metadata
using similar commands with both rasters and vectors.


    #load required libraries
    library(rgdal)
    library(raster)


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

The first shapefile that we will open, contains the boundary of our study area. 
It is a polygon layer. We can tell it is a polygon by viewing it's `class` in the 
attributes of the object which is `SpatialPolygonsDataFrame`.


    #Import a polygon shapefile 
    aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "boundaryFiles/HARV/", layer: "HarClip_UTMZ18"
    ## with 1 features
    ## It has 1 fields

    #view attributes of the layer
    aoiBoundary

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 1 
    ## extent      : 732128, 732251.1, 4713209, 4713359  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 1
    ## names       : id 
    ## min values  :  1 
    ## max values  :  1

    #you can also use the attributes command to just view the attributes of the data
    (aoiBoundary@data)

    ##   id
    ## 0  1

    #create a quick plot of the shapefile
    #note: lwd sets the line width!
    #for a list of r color options 
    #https://codeyarns.files.wordpress.com/2011/07/20110729-vim-named-colors.png?w=700
    plot(aoiBoundary,col="cyan1", border="black", lwd=3)

![ ]({{ site.baseurl }}/images/rfigs/00-open-a-shapefile/Import-Shapefile-1.png) 

#View Shapefile Metadata

When we import the `HarClip_UTMZ18` layer into R, some key metadata are stored
with the spatial R object:

1. **Object Type: **  in this case our area of interest (AOI) is a polygon boundary
R knows to bring it in as a `SpatialPolygonsDataFrame`
2. **CRS** - The shapefile also contains projection information `coord ref.` in the output 
above.
3. **Extent** - we can see the spatial extent of the shapefile. Note that the spatial
extent for a shapefile represents the extent for ALL polygons (or spatial objects)
in the shapefile!

We can view the CRS, Extent and other metadata for the shapefile using the following
commands:


    #view just the crs for the shapefile
    crs(aoiBoundary)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #view just the extent for the shapefile
    extent(aoiBoundary)

    ## class       : Extent 
    ## xmin        : 732128 
    ## xmax        : 732251.1 
    ## ymin        : 4713209 
    ## ymax        : 4713359

#Import a line and point shapefile

>#ON YOUR OWN ACTIVITY
>
>Using the steps above, import the HARV_roadStream and HARVtower_UTM18N layers into R.
>Call the Harv_roadStream object `lines` and the HARVtower_UTM18N `point`
>Answer the following questions:

>1. What type of R spatial object is created when you import each layer?
>2. What is the extent and CRS for each object?
>3. Do the files contain, points, lines or polygons?
>4. How many spatial objects are in each file?
>
>Discuss the data with your neighbor as you work through this challenge!



    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open layer

#Shapefile Attributes
Each spatial object in a shapefile can have the same set of attributes. These attributes
can be any sort of attribute that you might store in a spreadsheet about your data. 

We can view a metadata/attribute summary of each shapefile by entering 
the name of the `R` object in the console. Note that the metadata output includes 
the _class_, the number of _features_, the _extent_, and the `coordinate reference 
system` (crs) of the `R` object. The last two lines of summary show a preview of 
the `R` object _attributes_.


    #View attributes
    aoiBoundary

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 1 
    ## extent      : 732128, 732251.1, 4713209, 4713359  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 1
    ## names       : id 
    ## min values  :  1 
    ## max values  :  1

    #view a summary of each attribute associated with the spatial object
    summary(aoiBoundary)

    ## Object of class SpatialPolygonsDataFrame
    ## Coordinates:
    ##       min       max
    ## x  732128  732251.1
    ## y 4713209 4713359.2
    ## Is projected: TRUE 
    ## proj4string :
    ## [+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0]
    ## Data attributes:
    ##        id   
    ##  Min.   :1  
    ##  1st Qu.:1  
    ##  Median :1  
    ##  Mean   :1  
    ##  3rd Qu.:1  
    ##  Max.   :1

    #explore the lines and point objects
    lines

    ## class       : SpatialLinesDataFrame 
    ## features    : 13 
    ## extent      : 730741.2, 733295.5, 4711942, 4714260  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 15
    ## names       : OBJECTID_1, OBJECTID,       TYPE,             NOTES, MISCNOTES, RULEID,          MAPLABEL, SHAPE_LENG,             LABEL, BIKEHORSE, RESVEHICLE, RECMAP, Shape_Le_1,                         ResVehic_1,                  BicyclesHo 
    ## min values  :         14,       48,  boardwalk, Locust Opening Rd,        NA,      1, Locust Opening Rd,   35.88146, Locust Opening Rd,         N,         R1,      N,   35.88152, R1 - All Research Vehicles Allowed, Bicycles and Horses Allowed 
    ## max values  :        754,      674, woods road,    Pierce Farm Rd,        NA,      6,    Pierce Farm Rd, 3808.43252,    Pierce Farm Rd,         Y,         R3,      Y, 1885.82912,           R3 - No Vehicles Allowed,      DO NOT SHOW ON REC MAP

    point

    ## class       : SpatialPointsDataFrame 
    ## features    : 1 
    ## extent      : 732183.2, 732183.2, 4713265, 4713265  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 14
    ## names       : Un_ID, Domain, DomainName,       SiteName, Type,       Sub_Type,     Lat,      Long, Zone,  Easting, Northing,                Ownership,    County, annotation 
    ## min values  :     A,      1,  Northeast, Harvard Forest, Core, Advanced Tower, 42.5369, -72.17266,   18, 732183.2,  4713265, Harvard University, LTER, Worcester,         C1 
    ## max values  :     A,      1,  Northeast, Harvard Forest, Core, Advanced Tower, 42.5369, -72.17266,   18, 732183.2,  4713265, Harvard University, LTER, Worcester,         C1

#Plot Multiple Shapefiles

The `plot()` function can be used for basic plotting of these spatial objects. 
We use the `add = TRUE` argument to overlay shapefiles on top of each other. As we 
would when creating a map in a typical GIS application like QGIS.

We can use the `main=""` to give our plot a title. If you want the title to 
span 2 lines, use `\n` where you'd like the line break.


    #Plot multiple shapefiles
    
    plot(x = aoiBoundary, col = "purple", main="Harvard Forest\nStudy Area")
    plot(x = lines, add = TRUE)
    
    #use the pch element to adjust the symbology of the points
    plot(x = point, add  = TRUE, pch = 19, col = "red")

![ ]({{ site.baseurl }}/images/rfigs/00-open-a-shapefile/plot-multiple-shapefiles-1.png) 

#Another On Your Own Activity

>More here on what this is
>Ideas?
>
