---
layout: post
title: "Lesson 01: Work With Shapefile Attributes in R"
date:   2015-10-25
authors: "Joseph Stachelek, Leah Wasser"
dateCreated:  2015-10-23
lastModified: 2015-10-26
tags: [module-1]
description: "This post explains the nature of shapefile attributes. Participants will be able to locate and query shapefile attributes as well as subset shapefiles by specific attribute values."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/shapefile-attributes-in-R/
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
This lesson explains what an attribute is associated with shapefiles and also
how to work with attributes in `R`. It covers how to identify and query shapefile 
attributes as well as subset shapefiles by specific attribute values.

###Goals / Objectives
After completing this activity, you will:

 * Be able to query shapefile attributes
 * Be able to subset shapefiles based on specific attributes
 
 
 
 
##Querying shapefile attributes

    library(rgdal)
    #in case the libraries and data are not still loaded
    
    #Import a polygon shapefile 
    aoiBoundary <- readOGR("boundaryFiles/HARV/", "HarClip_UTMZ18")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    #Import a line shapefile
    lines <- readOGR( "boundaryFiles/HARV/",layer = "HARV_roadStream")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

    #Import a point shapefile 
    point <- readOGR("boundaryFiles/HARV/", "HARVtower_UTM18N")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file

Recall from the previous lesson that shapefile metadata can include a _class_, 
a _features_ count, an _extent_, and a _coordinate reference system_ (crs). 
Shapefile _attributes_ include measurements that correspond to the geometry of 
the shapefile features.

Metadata can be extracted individually using the `class()`, `length()`, `extent()`, 
`crs()`, `R` commands. Attributes can be extracted using the `slot()` command. 


    #view class
    class(x = aoiBoundary)

    ## Error in eval(expr, envir, enclos): object 'aoiBoundary' not found

    class(x = lines)

    ## [1] "standardGeneric"
    ## attr(,"package")
    ## [1] "methods"

    class(x = point)

    ## Error in eval(expr, envir, enclos): object 'point' not found

    #view features count
    length(x = aoiBoundary)

    ## Error in eval(expr, envir, enclos): object 'aoiBoundary' not found

    length(x = lines)

    ## [1] 1

    length(x = point)

    ## Error in eval(expr, envir, enclos): object 'point' not found

    #view crs - note - this only works with the raster package loaded
    crs(x = aoiBoundary)

    ## Error in crs(x = aoiBoundary): error in evaluating the argument 'x' in selecting a method for function 'crs': Error: object 'aoiBoundary' not found

    crs(x = lines)

    ## [1] NA

    crs(x = point)

    ## Error in crs(x = point): error in evaluating the argument 'x' in selecting a method for function 'crs': Error: object 'point' not found

    #view extent
    extent(x = squarePlot)

    ## Error in extent(x = squarePlot): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'squarePlot' not found

    extent(x = lines)

    ## Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'extent' for signature '"standardGeneric"'

    extent(x = point)

    ## Error in extent(x = point): error in evaluating the argument 'x' in selecting a method for function 'extent': Error: object 'point' not found

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

    ## Error in eval(expr, envir, enclos): no slot of name "data" for this object of class "standardGeneric"

    #view all attribute data for the lines spatial object
    lines@data 

    ## Error in eval(expr, envir, enclos): no slot of name "data" for this object of class "standardGeneric"

    #view just the tope 5 attributes for the lines spatial object
    head(lines@data)

    ## Error in head(lines@data): error in evaluating the argument 'x' in selecting a method for function 'head': Error: no slot of name "data" for this object of class "standardGeneric"

    #view attributes for the other spatial objects
    aoiBoundary@data

    ## Error in eval(expr, envir, enclos): object 'aoiBoundary' not found

    point@data

    ## Error in eval(expr, envir, enclos): object 'point' not found

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

    ## Error in lines$TYPE: object of type 'closure' is not subsettable

    #view unique attributes in the lines shapefiles within the Type field
    levels(lines$TYPE)

    ## Error in levels(lines$TYPE): error in evaluating the argument 'x' in selecting a method for function 'levels': Error in lines$TYPE : object of type 'closure' is not subsettable

#How do you access the LEVELS when working with categorical variables in a shapefile?

##Subsetting shapefiles

Using the `$` symbol, we were able to access the values associated with a 
particular `Attribute` in a shapefile. Next, we will use this syntax to select 
a subset of features from a spatial object in `R`. 

Note how our subsetting operation reduces the _features_ count from 13 to 2. 


    #view all attributes in the TYPE column
    lines$TYPE

    ## Error in lines$TYPE: object of type 'closure' is not subsettable

    #select features that are of TYPE "footpath"
    lines[lines$TYPE == "footpath",]

    ## Error in lines[lines$TYPE == "footpath", ]: error in evaluating the argument 'i' in selecting a method for function '[': Error in lines$TYPE : object of type 'closure' is not subsettable


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

    ## Error in slot(object = lines, name = "data"): no slot of name "data" for this object of class "standardGeneric"

    #you can also write
    type <- lines@data$TYPE

    ## Error in eval(expr, envir, enclos): no slot of name "data" for this object of class "standardGeneric"

    col <- rep(x= "black", length = length(type))

    ## Error in eval(expr, envir, enclos): object 'type' not found

    col[type == "footpath"] <- "red"

    ## Error in col[type == "footpath"] <- "red": object 'type' not found

    plot(x=lines, col=col,add=T)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

#some other challenge?
#maybe plotting should be it's own lesson in this set??


