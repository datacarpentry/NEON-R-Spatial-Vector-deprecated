---
layout: post
title: "Lesson 01: Work With Shapefile Attributes in R"
date:   2015-10-25
authors: [Joseph Stachelek, Leah Wasser]
contributors: [Megan Jones]
dateCreated:  2015-10-23
lastModified: 2015-10-26
tags: [module-1]
description: "This post explains the nature of shapefile attributes. Participants will be able to locate and query shapefile attributes as well as subset shapefiles by specific attribute values."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/shapefile-attributes-in-R/
comments: false
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
This lesson explains what attributes in shapefiles are. It also covers how to work 
with shapefile attributes in `R`. It covers how to identify and query shapefile 
attributes as well as subset shapefiles by specific attribute values. Finally,
we will review how to plot a shapefile according to a set of attribute values.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will:

 * Be able to query shapefile attributes
 * Be able to subset shapefiles based on specific attributes
 
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

NOTE: The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").
{: .notice}
 
##Notes about R Libraries

To work with vector data in R, we can use the `rgdal` library. We will load the `raster`
library to work with rasters. The `raster` library also allows us to explore metadata
using similar commands with both rasters and vectors.
 
##Querying shapefile attributes


    library(rgdal)
    #in case the libraries and data are not still loaded
    
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

Recall from the previous lesson that shapefile metadata can include a _class_, 
a _features_ count, an _extent_, and a _coordinate reference system_ (crs). 
Shapefile _attributes_ include measurements that correspond to the geometry of 
the shapefile features.

Metadata can be extracted individually using the `class()`, `length()`, `extent()`, 
`crs()`, `R` commands. Attributes can be extracted using the `slot()` command. 


    #view class
    class(x = aoiBoundary)

    ## [1] "SpatialPolygonsDataFrame"
    ## attr(,"package")
    ## [1] "sp"

    class(x = lines)

    ## [1] "SpatialLinesDataFrame"
    ## attr(,"package")
    ## [1] "sp"

    class(x = point)

    ## [1] "SpatialPointsDataFrame"
    ## attr(,"package")
    ## [1] "sp"

    #view features count
    length(x = aoiBoundary)

    ## [1] 1

    length(x = lines)

    ## [1] 13

    length(x = point)

    ## [1] 1

    #view crs - note - this only works with the raster package loaded
    crs(x = aoiBoundary)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    crs(x = lines)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    crs(x = point)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #view extent
    extent(x = squarePlot)

    ## Error in extent(x = squarePlot): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'squarePlot' not found

    extent(x = lines)

    ## class       : Extent 
    ## xmin        : 730741.2 
    ## xmax        : 733295.5 
    ## ymin        : 4711942 
    ## ymax        : 4714260

    extent(x = point)

    ## class       : Extent 
    ## xmin        : 732183.2 
    ## xmax        : 732183.2 
    ## ymin        : 4713265 
    ## ymax        : 4713265

#Shapefile Attributes

Shapefiles often contain an associated database or spreadsheet of values called
`attributes` that describe the vector features in the shapefile. You can think
of this like a spreadsheet with rows and columns. Each column in the spreadsheet
is an individual `Attribute` that describes an object.

For example, the `roads_stream` shapefile contains an attribute called `TYPE`. Each
line in the shapefile has an associated type which describes the type of road, or 
element in the file. 


You can quickly view all attributes of a spatial object in r using the `@data`. 
Let's give it a try.


    #view just the attribute names for the lines spatial object
    names(lines@data)

    ##  [1] "OBJECTID_1" "OBJECTID"   "TYPE"       "NOTES"      "MISCNOTES" 
    ##  [6] "RULEID"     "MAPLABEL"   "SHAPE_LENG" "LABEL"      "BIKEHORSE" 
    ## [11] "RESVEHICLE" "RECMAP"     "Shape_Le_1" "ResVehic_1" "BicyclesHo"

    #view all attribute data for the lines spatial object
    lines@data 

    ##    OBJECTID_1 OBJECTID       TYPE             NOTES MISCNOTES RULEID
    ## 0          14       48 woods road Locust Opening Rd      <NA>      5
    ## 1          40       91   footpath              <NA>      <NA>      6
    ## 2          41      106   footpath              <NA>      <NA>      6
    ## 3         211      279 stone wall              <NA>      <NA>      1
    ## 4         212      280 stone wall              <NA>      <NA>      1
    ## 5         213      281 stone wall              <NA>      <NA>      1
    ## 6         214      282 stone wall              <NA>      <NA>      1
    ## 7         215      283 stone wall              <NA>      <NA>      1
    ## 8         216      284 stone wall              <NA>      <NA>      1
    ## 9         553      674  boardwalk              <NA>      <NA>      2
    ## 10        752       71 woods road    Pierce Farm Rd      <NA>      5
    ## 11        753       71 woods road    Pierce Farm Rd      <NA>      5
    ## 12        754       71 woods road    Pierce Farm Rd      <NA>      5
    ##             MAPLABEL SHAPE_LENG             LABEL BIKEHORSE RESVEHICLE
    ## 0  Locust Opening Rd 1297.35706 Locust Opening Rd         Y         R1
    ## 1               <NA>  146.29984              <NA>         Y         R1
    ## 2               <NA>  676.71804              <NA>         Y         R2
    ## 3               <NA>  231.78957              <NA>      <NA>       <NA>
    ## 4               <NA>   45.50864              <NA>      <NA>       <NA>
    ## 5               <NA>  198.39043              <NA>      <NA>       <NA>
    ## 6               <NA>  143.19240              <NA>      <NA>       <NA>
    ## 7               <NA>   90.33118              <NA>      <NA>       <NA>
    ## 8               <NA>   35.88146              <NA>      <NA>       <NA>
    ## 9               <NA>   67.43464              <NA>         N         R3
    ## 10    Pierce Farm Rd 3808.43252    Pierce Farm Rd         Y         R2
    ## 11    Pierce Farm Rd 3808.43252    Pierce Farm Rd         N         R3
    ## 12    Pierce Farm Rd 3808.43252    Pierce Farm Rd         Y         R2
    ##    RECMAP Shape_Le_1                            ResVehic_1
    ## 0       Y 1297.10617    R1 - All Research Vehicles Allowed
    ## 1       Y  146.29983    R1 - All Research Vehicles Allowed
    ## 2       Y  676.71807 R2 - 4WD/High Clearance Vehicles Only
    ## 3    <NA>  231.78962                                  <NA>
    ## 4    <NA>   45.50859                                  <NA>
    ## 5    <NA>  198.39041                                  <NA>
    ## 6    <NA>  143.19241                                  <NA>
    ## 7    <NA>   90.33114                                  <NA>
    ## 8    <NA>   35.88152                                  <NA>
    ## 9       N   67.43466              R3 - No Vehicles Allowed
    ## 10      Y 1771.63108 R2 - 4WD/High Clearance Vehicles Only
    ## 11      Y  144.56559              R3 - No Vehicles Allowed
    ## 12      Y 1885.82912 R2 - 4WD/High Clearance Vehicles Only
    ##                         BicyclesHo
    ## 0      Bicycles and Horses Allowed
    ## 1      Bicycles and Horses Allowed
    ## 2      Bicycles and Horses Allowed
    ## 3                             <NA>
    ## 4                             <NA>
    ## 5                             <NA>
    ## 6                             <NA>
    ## 7                             <NA>
    ## 8                             <NA>
    ## 9           DO NOT SHOW ON REC MAP
    ## 10     Bicycles and Horses Allowed
    ## 11 Bicycles and Horses NOT ALLOWED
    ## 12     Bicycles and Horses Allowed

    #view just the tope 5 attributes for the lines spatial object
    head(lines@data)

    ##   OBJECTID_1 OBJECTID       TYPE             NOTES MISCNOTES RULEID
    ## 0         14       48 woods road Locust Opening Rd      <NA>      5
    ## 1         40       91   footpath              <NA>      <NA>      6
    ## 2         41      106   footpath              <NA>      <NA>      6
    ## 3        211      279 stone wall              <NA>      <NA>      1
    ## 4        212      280 stone wall              <NA>      <NA>      1
    ## 5        213      281 stone wall              <NA>      <NA>      1
    ##            MAPLABEL SHAPE_LENG             LABEL BIKEHORSE RESVEHICLE
    ## 0 Locust Opening Rd 1297.35706 Locust Opening Rd         Y         R1
    ## 1              <NA>  146.29984              <NA>         Y         R1
    ## 2              <NA>  676.71804              <NA>         Y         R2
    ## 3              <NA>  231.78957              <NA>      <NA>       <NA>
    ## 4              <NA>   45.50864              <NA>      <NA>       <NA>
    ## 5              <NA>  198.39043              <NA>      <NA>       <NA>
    ##   RECMAP Shape_Le_1                            ResVehic_1
    ## 0      Y 1297.10617    R1 - All Research Vehicles Allowed
    ## 1      Y  146.29983    R1 - All Research Vehicles Allowed
    ## 2      Y  676.71807 R2 - 4WD/High Clearance Vehicles Only
    ## 3   <NA>  231.78962                                  <NA>
    ## 4   <NA>   45.50859                                  <NA>
    ## 5   <NA>  198.39041                                  <NA>
    ##                    BicyclesHo
    ## 0 Bicycles and Horses Allowed
    ## 1 Bicycles and Horses Allowed
    ## 2 Bicycles and Horses Allowed
    ## 3                        <NA>
    ## 4                        <NA>
    ## 5                        <NA>

    #view attributes for the other spatial objects
    aoiBoundary@data

    ##   id
    ## 0  1

    point@data

    ##   Un_ID Domain DomainName       SiteName Type       Sub_Type     Lat
    ## 1     A      1  Northeast Harvard Forest Core Advanced Tower 42.5369
    ##        Long Zone  Easting Northing                Ownership    County
    ## 1 -72.17266   18 732183.2  4713265 Harvard University, LTER Worcester
    ##   annotation
    ## 1         C1

#CHALLENGE
Explore the attributes associated with the `point` and `aoiBoundary` spatial objects. 

1. How many attributes do each have?
2. Another question??

#Exploring values in One Attribute
We can also explore individual values stored within a particulat attribute. Again,
comparing attributes to a spreadsheet or a `data.frame`, this is similar to 
exploring values in a column. We can do this using the `$`.


    #view all attributes in the lines shapefile within the TYPE field
    lines$TYPE

    ##  [1] woods road footpath   footpath   stone wall stone wall stone wall
    ##  [7] stone wall stone wall stone wall boardwalk  woods road woods road
    ## [13] woods road
    ## Levels: boardwalk footpath stone wall woods road

    #view unique attributes in the lines shapefiles within the Type field
    levels(lines$TYPE)

    ## [1] "boardwalk"  "footpath"   "stone wall" "woods road"

#How do you access the LEVELS when working with categorical variables in a shapefile?

##Subsetting shapefiles

Using the `$` symbol, we were able to access the values associated with a 
particular `Attribute` in a shapefile. Next, we will use this syntax to select 
a subset of features from a spatial object in `R`. 

Note how our subsetting operation reduces the _features_ count from 13 to 2. 


    #view all attributes in the TYPE column
    lines$TYPE

    ##  [1] woods road footpath   footpath   stone wall stone wall stone wall
    ##  [7] stone wall stone wall stone wall boardwalk  woods road woods road
    ## [13] woods road
    ## Levels: boardwalk footpath stone wall woods road

    #select features that are of TYPE "footpath"
    lines[lines$TYPE == "footpath",]

    ## class       : SpatialLinesDataFrame 
    ## features    : 2 
    ## extent      : 731954.5, 732232.3, 4713131, 4713726  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 15
    ## names       : OBJECTID_1, OBJECTID,     TYPE, NOTES, MISCNOTES, RULEID, MAPLABEL, SHAPE_LENG, LABEL, BIKEHORSE, RESVEHICLE, RECMAP, Shape_Le_1,                            ResVehic_1,                  BicyclesHo 
    ## min values  :         40,       91, footpath,    NA,        NA,      6,       NA,   146.2998,    NA,         Y,         R1,      Y,   146.2998,    R1 - All Research Vehicles Allowed, Bicycles and Horses Allowed 
    ## max values  :         41,      106, footpath,    NA,        NA,      6,       NA,   676.7180,    NA,         Y,         R2,      Y,   676.7181, R2 - 4WD/High Clearance Vehicles Only, Bicycles and Horses Allowed


#I think we should plot by attribute HERE - given we are introducing attributes here
#we should also have some sort of application - maybe we want to find out in a point data set 
#how many points are of type "X"
#can we run summary stats on the different categories?

#Plotting Spatial Data in R

We can use the `col` argument to the `plot()` function to specify 
the color of spatial objects. If type is an attribute of our data, 
we can use the syntax `$TYPE` to tell `R` to plot the spatial
objects according to their unique TYPE values. 

The following code chunk extracts a vector of this attribute, creates 
a character color vector of the same length, and changes the positions 
of this color vector that correspond to _footpath_.

#NOTE -- It's worth visiting this to determine the BEST and most efficient
way to plot by attribute. The TYPE is a factor in R world -
#it's a categorical attribute. We should teach best practices but I am not sure
#what that is in R.

we should plot:
* then add a legend
* color by road type and add that to the legend.
* this would be a typical workflow.



    #color lines by TYPE attribute
    type <- slot(object = lines, name = "data")$TYPE
    #you can also write
    type <- lines@data$TYPE
    
    col <- rep(x= "black", length = length(type))
    col[type == "footpath"] <- "red"
    
    plot(x=lines, col=col,add=T)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

#some other challenge?
#maybe plotting should be it's own lesson in this set??


