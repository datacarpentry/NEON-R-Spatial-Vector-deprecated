---
layout: post
title: "Lesson 01: Explore Shapefile Attributes & Plot Shapefile Objects by
Attribute Value in R"
date:   2015-10-26
authors: [Joseph Stachelek, Leah Wasser, Megan A. Jones]
contributors: [Sarah Newman]
dateCreated:  2015-10-23
lastModified: 2016-01-21
packagesLibraries: [rgdal, raster]
category: self-paced-tutorial
mainTag: vector-data-series
tags: [vector-data, R, spatial-data-gis]
workshopSeries: [vector-data-series]
description: "This lesson provides an overview of how to locate and query
shapefile attributes as well as subset shapefiles by specific attribute values
in R. It also covers plotting multiple shapefiles by attribute and building a 
custom plot legend. "
code1: 01-shapefile-attributes.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/shapefile-attributes-in-R/
comments: false
---

{% include _toc.html %}

##About
This lesson explains what shapefile attributes are and how to
work with shapefile attributes in `R`. It also covers how to identify and query 
shapefile attributes as well as subset shapefiles by specific attribute values. 
Finally, we will review how to plot a shapefile according to a set of attribute 
values.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

#Goals / Objectives
After completing this activity, you will:

 * Be able to query shapefile attributes.
 * Be able to subset shapefiles using specific attribute values.
 * Know how to plot a shapefile, colored by unique attribute values.
 
##Things You’ll Need To Complete This Lesson
To complete this lesson: you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

###Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

##Download Data
{% include/dataSubsets/_data_Site-Layout-Files.html %}

****

{% include/_greyBox-wd-rscript.html %}

**Vector Lesson Series:** This lesson is part of a lesson series on 
[vector data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-vector-series).
It is also part of a larger 
[spatio-temporal Data Carpentry Workshop ]({{ site.baseurl }}self-paced-tutorials/spatio-temporal-workshop)
that includes working with
[raster data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-raster-series) 
and [tabular time series in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series).

</div>

##Shapefile Metadata & Attributes
When we import a shapefile into `R`, the `readOGR()` function automatically
stores metadata and attributes associated with the file.

##Load the Data
To work with vector data in `R`, we can use the `rgdal` library. The `raster` 
package also allows us to explore metadata using similar commands for both
rasters and vectors. 

We will first, import three shapefiles. The first is our `AOI` or area of
interest boundary polygon that we worked with in 
[Lesson 00 - Vector Data in R - Open and Plot Shapefiles]({{site.baseurl}}R/open-shapefiles-in-R/). 
The second is a shapefile containing the location of roads within the field
site. Finally we will import a file containing the Fisher tower location.

If you completed the
[Vector Data in R - Open and Plot Shapefiles]({{site.baseurl}}R/open-shapefiles-in-R/ ) 
lesson, you can skip this code chunk.


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

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV/", layer: "HarClip_UTMZ18"
    ## with 1 features
    ## It has 1 fields

    #Import a line shapefile
    lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/", "HARV_roads")

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

##Query Shapefile Metadata 
Remember, as covered in Lesson 00, we can view metadata associated with 
an `R` using:

* `class()` - Determine the type of vector data stored in the object
* `length()` - How many features are in this spatial object?
* object `extent()` - the spatial extent (geographic area covered by) features 
in the object
* coordinate reference system (`CRS`) - The spatial projection that the data are
in. 

Let's explore the metadata for our `point_HARV` object. 


    #view class
    class(x = point_HARV)

    ## [1] "SpatialPointsDataFrame"
    ## attr(,"package")
    ## [1] "sp"

    # x= isn't actually needed; it just specifies which object
    #view features count
    length(point_HARV)

    ## [1] 1

    #view crs - note - this only works with the raster package loaded
    crs(point_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #view extent- note - this only works with the raster package loaded
    extent(point_HARV)

    ## class       : Extent 
    ## xmin        : 732183.2 
    ## xmax        : 732183.2 
    ## ymin        : 4713265 
    ## ymax        : 4713265

    #view metadata summary
    point_HARV

    ## class       : SpatialPointsDataFrame 
    ## features    : 1 
    ## extent      : 732183.2, 732183.2, 4713265, 4713265  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 14
    ## names       : Un_ID, Domain, DomainName,       SiteName, Type,       Sub_Type,     Lat,      Long, Zone,  Easting, Northing,                Ownership,    County, annotation 
    ## min values  :     A,      1,  Northeast, Harvard Forest, Core, Advanced Tower, 42.5369, -72.17266,   18, 732183.2,  4713265, Harvard University, LTER, Worcester,         C1 
    ## max values  :     A,      1,  Northeast, Harvard Forest, Core, Advanced Tower, 42.5369, -72.17266,   18, 732183.2,  4713265, Harvard University, LTER, Worcester,         C1


##About Shapefile Attributes
Shapefiles often contain an associated database or spreadsheet of values called
`attributes` that describe the vector features in the shapefile. You can think
of this like a spreadsheet with rows and columns. Each column in the spreadsheet
is an individual `attribute` that describes an object (sometimes called
variables). Shapefile `attributes` include measurements that correspond to the
geometry of the shapefile features.

For example, the Roads shapefile (`lines_HARV` object) contains an attribute
called `TYPE`. Each line in the shapefile has an associated `TYPE` which 
describes the type of road (road, footpath, boardwalk, etc). 

<figure>
    <a href="{{ site.baseurl }}/images/spatialVector/Attribute_Table.png">
    <img src="{{ site.baseurl }}/images/spatialVector/Attribute_Table.png"></a>
    <figcaption>The shapefile format allows us to store attributes for each feature
    (vector object) stored in the shapefile. The attribute table, is similar to 
    a spreadsheet. There is a row for each feature. The first column contains the 
    unique ID of the feature. We can add additional columns that describe the 
    feature. 
    Image Source: National Ecological Observatory Network (NEON) 
    </figcaption>
</figure>

We can look at all of the associated data attributes by printing the contents of
the `data` slot with `@data`. We can use the base `R` `length` function to count
the number of attributes associated with a spatial object too.


    #just view the attributes & first 6attribute values of the data
    head(lines_HARV@data)

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

    #how many attributes are in our data?
    length(lines_HARV@data)

    ## [1] 15


We can view the individual NAMES of each attribute using the
`names(lines_HARV@data)` method in `R`. We can also view just the first 6 rows
of attribute values using  `head(lines_HARV@data)`. 

Let's give it a try.


    #view just the attribute names for the lines spatial object
    names(lines_HARV@data)

    ##  [1] "OBJECTID_1" "OBJECTID"   "TYPE"       "NOTES"      "MISCNOTES" 
    ##  [6] "RULEID"     "MAPLABEL"   "SHAPE_LENG" "LABEL"      "BIKEHORSE" 
    ## [11] "RESVEHICLE" "RECMAP"     "Shape_Le_1" "ResVehic_1" "BicyclesHo"


<div id="challenge" markdown="1">
##Challenge: Attributes for Different Spatial Classes
Explore the attributes associated with the `point_HARV` and `aoiBoundary_HARV` 
spatial objects. 

1. How many attributes do each have?
2. Who owns the site in the `point_HARV` data object?
3. Which of the following are NOT attributes of the `point` data object?

    A) Latitude      B) County     C) Country
</div>



##Explore Values within One Attribute
We can explore individual values stored within a particular attribute.
Again, comparing attributes to a spreadsheet or a `data.frame`, this is similar
to exploring values in a column. We can do this using the `$` and the name of
the attribute. 


    #view all attributes in the lines shapefile within the TYPE field
    lines_HARV$TYPE

    ##  [1] woods road footpath   footpath   stone wall stone wall stone wall
    ##  [7] stone wall stone wall stone wall boardwalk  woods road woods road
    ## [13] woods road
    ## Levels: boardwalk footpath stone wall woods road

###Subset Shapefiles
Using the `$` symbol, we can access the values associated with a particular
`attribute` in a shapefile. We can use this syntax to select a subset of
features from a spatial object in `R`. 


    #view all attributes in the TYPE column
    lines_HARV$TYPE

    ##  [1] woods road footpath   footpath   stone wall stone wall stone wall
    ##  [7] stone wall stone wall stone wall boardwalk  woods road woods road
    ## [13] woods road
    ## Levels: boardwalk footpath stone wall woods road

    # select features that are of TYPE "footpath"
    # could put this code into other function to only have that function work on
    # "footpath" lines
    lines_HARV[lines_HARV$TYPE == "footpath",]

    ## class       : SpatialLinesDataFrame 
    ## features    : 2 
    ## extent      : 731954.5, 732232.3, 4713131, 4713726  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 15
    ## names       : OBJECTID_1, OBJECTID,     TYPE, NOTES, MISCNOTES, RULEID, MAPLABEL, SHAPE_LENG, LABEL, BIKEHORSE, RESVEHICLE, RECMAP, Shape_Le_1,                            ResVehic_1,                  BicyclesHo 
    ## min values  :         40,       91, footpath,    NA,        NA,      6,       NA,   146.2998,    NA,         Y,         R1,      Y,   146.2998,    R1 - All Research Vehicles Allowed, Bicycles and Horses Allowed 
    ## max values  :         41,      106, footpath,    NA,        NA,      6,       NA,   676.7180,    NA,         Y,         R2,      Y,   676.7181, R2 - 4WD/High Clearance Vehicles Only, Bicycles and Horses Allowed

    #save an object with only footpath lines
    footpath_HARV<-lines_HARV[lines_HARV$TYPE == "footpath",]
    footpath_HARV

    ## class       : SpatialLinesDataFrame 
    ## features    : 2 
    ## extent      : 731954.5, 732232.3, 4713131, 4713726  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 15
    ## names       : OBJECTID_1, OBJECTID,     TYPE, NOTES, MISCNOTES, RULEID, MAPLABEL, SHAPE_LENG, LABEL, BIKEHORSE, RESVEHICLE, RECMAP, Shape_Le_1,                            ResVehic_1,                  BicyclesHo 
    ## min values  :         40,       91, footpath,    NA,        NA,      6,       NA,   146.2998,    NA,         Y,         R1,      Y,   146.2998,    R1 - All Research Vehicles Allowed, Bicycles and Horses Allowed 
    ## max values  :         41,      106, footpath,    NA,        NA,      6,       NA,   676.7180,    NA,         Y,         R2,      Y,   676.7181, R2 - 4WD/High Clearance Vehicles Only, Bicycles and Horses Allowed

    #how many features in our new object
    length(footpath_HARV)

    ## [1] 2

    #plot just footpaths
    plot(footpath_HARV,
         lwd=6,
         main="Footpaths at NEON Harvard Forest Field Site")

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/Subsetting-shapefiles-1.png) 

Our subsetting operation reduces the `features` count from 13 to 2. This means
that only two lines have the attribute "TYPE=footpath".

##Plot Lines by Attribute Value

To plot vector data, colored by a set of attribute values, we can convert an
attribute that has categorical data to class= `factor`. A factor is similar to a
category - you can group vector objects by a particular category value - for
example you can group all lines of `TYPE=footpath`. However in `R`, a factor
can also have an *order*. 

If we convert the `lines_HARV$TYPE` column to a factor using `as.factor()`, then
it will be much easier to plot features by attribute value.



    #view the original class of the TYPE column
    class(lines_HARV$TYPE)

    ## [1] "factor"

    #view levels or categories - not that there are no categories yet in our data!
    #the attributes are just read as a list of character elements.
    levels(lines_HARV$TYPE)

    ## [1] "boardwalk"  "footpath"   "stone wall" "woods road"

    #Convert the TYPE attribute into a factor
    lines_HARV$TYPE <- as.factor(lines_HARV$TYPE)
    #the class is now a factor
    class(lines_HARV$TYPE)

    ## [1] "factor"

    #view the levels or categories associated with TYPE (4 total)
    levels(lines_HARV$TYPE)

    ## [1] "boardwalk"  "footpath"   "stone wall" "woods road"

    #how many features are in each category or level?
    summary(lines_HARV$TYPE)

    ##  boardwalk   footpath stone wall woods road 
    ##          1          2          6          4

    #plot the lines data, apply a diff color to each category
    plot(lines_HARV, col=lines_HARV$TYPE,
         lwd=3,
         main="Roads at the NEON Harvard Forest Field Site")

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/convert-to-factor-1.png) 


###Adjust Line Width
We can adjust the width of our plot lines too using `lwd`. We can set all lines
to be thicker or thinner using `lwd=`. Or given we have a factor with 4 levels, 
we can provide an vector of numbers, each of which represents the thickness of
one of our four levels or categories as follows:
     

    #make all lines thicker
    plot(lines_HARV, col=lines_HARV$TYPE,
         main="Roads at the NEON Harvard Forest Field Site",
         lwd=6)

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/adjust-line-width-1.png) 

    levels(lines_HARV$TYPE)

    ## [1] "boardwalk"  "footpath"   "stone wall" "woods road"

    #adjust width of each level
    #in this case, boardwalk (the first level) is the widest.
    plot(lines_HARV, col=lines_HARV$TYPE,
         main="Roads at the NEON Harvard Forest Field Site \n Boardwalk Line Width Wider",
         lwd=c(10,2,3,4))

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/adjust-line-width-2.png) 

##Add Plot Legend

We can add a legend to our plot too. When we add a legend, we can use
the following elements to specify labels and colors:

* `levels(lines_HARV$TYPE)` - Label the legend elements using the categories of 
`levels` in our `TYPE` attribute (boardwalk, footpath, etc).
* `fill=palette()` - apply unique colors to the boxes in our legend. 
`palette()` is the default set of colors that `R` applies to all plots. 
* We can specify the **location** of our legend too. Let's use `bottomright` for 
this plot. We could also use `top`, `topright`, etc.

Let's add a legend to our plot.


    plot(lines_HARV, col=lines_HARV$TYPE,
         main="Roads at the NEON Harvard Forest Field Site\n Default Legend")
    #add a legend to our map
    legend("bottomright", NULL, levels(lines_HARV$TYPE), fill=palette())

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/add-legend-to-plot-1.png) 

We can tweak the appearance of our legend too.

* `bty=n` - turn off the legend BORDER
* `cex` - make the font size smaller

Let's try it out.


    plot(lines_HARV, col=lines_HARV$TYPE,
         main="Roads at the NEON Harvard Forest Field Site \n Modified Legend")
    #add a legend to our map
    legend("bottomright", levels(lines_HARV$TYPE), fill=palette(), bty="n", cex=.8)

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/modify-legend-plot-1.png) 

The default color palette in R is accessed by the `palette()` command. We can 
modify this list of colors to create a prettier looking plot!


    #view default colors
    palette()

    ## [1] "#4C00FF" "#00E5FF"

    #manually set the colors for the plot!
    palette(c("springgreen", "blue", "magenta", "red") )
    palette()

    ## [1] "springgreen" "blue"        "magenta"     "red"

    #plot using new colors
    plot(lines_HARV, col=lines_HARV$TYPE,
         main="Roads at the NEON Harvard Forest Field Site \n Pretty Colors")
    #add a legend to our map
    legend("bottomright", levels(lines_HARV$TYPE), fill=palette(), bty="n", cex=.8)

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/adjust-palette-colors-1.png) 

<i class="fa fa-star"></i> **Data Tip:** You can apply built in colors ramps to 
your palette too. For example `palette(rainbow(6))` or
`palette(terrain.colors(6))`. 
You can reset the palette colors using `palette("default")` if need be!
{: .notice} 

<div id="challenge" markdown="1">
##Challenge: Plot Lines by Attribute
Create a plot that emphasizes only roads where bicycles and horses are allowed. 
NOTE: this attribute information is located in the `lines_HARV$BicyclesHo` 
attribute.  

Be sure to add a title and legend to your map! You might consider a color
palette that has all bike/horse-friendly roads displayed in a bright color.  All
other lines might be grey.

</div>

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/bicycle-map-1.png) 

##Plot Multiple Vector Layers
Now, let's create a plot that combines our tower location (`point_HARV`), 
site boundary (`aoiBoundary_HARV`) and roads (`lines_HARV`) spatial objects. We
will need to BUILD a custom legend as well.

To begin, create a plot with the site boundary as the first layer. Then layer 
the tower location and road data on top using `add=TRUE`.  

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/challenge-answer-1.png) 

To create a legend that includes both the road elements, the tower location and 
the AOI polygon, we will need to build three things

1. a list of all "labels" to use in the legend
2. a list of colors as they appear in our plot
3. a list of symbols to use in the plot

Let's create objects for the labels, colors and symbols so we can easily reuse
them.


    #create a list of all labels
    labels <- c("Tower", "AOI", levels(lines_HARV$TYPE))
    labels

    ## [1] "Tower"      "AOI"        "boardwalk"  "footpath"   "stone wall"
    ## [6] "woods road"

    #create a list of colors to use 
    plotColors <- c("purple", "grey",fill=palette())
    plotColors

    ##                         fill1     fill2     fill3 
    ##  "purple"    "grey" "magenta"    "gray"    "gray"

    #create a list of pch values
    #these are the symbols that will be used for each legend value
    # ?pch will provide more information on values
    plotSym <- c(16,15,15,15,15,15)
    plotSym

    ## [1] 16 15 15 15 15 15

    #Plot multiple shapefiles
    plot_HARV
    
    #to create a custom legend, we need to fake it
    legend("bottomright", 
           legend=labels,
           pch=plotSym, 
           bty="n", 
           col=plotColors,
           cex=.8)

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/customize-legend-1.png) 

We are almost there! It might be more useful to use line symbols in our legend
rather than squares to better represent our data. We can create a line symbol
using `lty = ()`. We have a total of 6 elements in our legend:

1.   Tower Location
2.   AOI
3-6. Road levels (categories)

The `lty` list designates, in order, which of those elements should be
designated as a line (`1`) and which should be designated as a symbol (`NA`).
Our object will thus look like `lty = c(NA,NA,1,1,1,1)`. This tells `R` to use a
line element for`the 3-6 elements in our legend only. 

Once we do this, we need to *modify* our `pch` element. Each *line* element
(3-6) should be represented by a `NA` value - this tells `R` to not use a
symbol, but to instead use a line.



    #Create line object
    lineLegend = c(NA,NA,1,1,1,1)
    lineLegend

    ## [1] NA NA  1  1  1  1

    plotSym <- c(16,15,NA,NA,NA,NA)
    plotSym

    ## [1] 16 15 NA NA NA NA

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

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/refine-legend-1.png) 


<div id="challenge" markdown="1">
##Challenge: Plot Color by Attribute

1. Create a map of the State boundaries in the United States - using the data
located in your downloaded data folder: `NEON-DS-Site-Layout-Files/US-Boundary-Layers\US-State-Boundaries-Census-2014`. 
Each state should be a different color or shade of color. 
HINT: you can use `palette(terrain.colors((50))` to create a palette of 50
colors using the `terrain.colors` `R` palette. 

2. Using the `NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp` shapefile, 
create a map of field site locations, with each point colored by the soil type
(`soilTypeOr`). 
Experiment with using one of the other 
<a href="https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/palettes.html" target="_blank">R Color Palettes</a>.

How many different soil types are there at this particular field site? 

</div>

![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/challenge-code-plot-color-1.png) ![ ]({{ site.baseurl }}/images/rfigs/01-shapefile-attributes/challenge-code-plot-color-2.png) 
