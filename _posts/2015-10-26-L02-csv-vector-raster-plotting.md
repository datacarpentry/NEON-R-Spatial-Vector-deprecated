---
layout: post
title: "Lesson 02: Convert from .csv to Shapefile in R"
date:   2015-10-24
authors: [Joseph Stachelek, Leah Wasser, Megan A. Jones]
contributors: [Sarah Newman]
dateCreated:  2015-10-23
lastModified: 2016-01-07
packagesLibraries: [rgdal, raster]
category: 
mainTag: vector-data-workshop
tags: [vector-data, vector-data-workshop]
description: "This lesson walks through how to convert a .csv file that contains
coordinate information into a spatial object in R."
code1: 02-csv-vector-raster-plotting.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/csv-to-shapefile-R/
comments: false
---

{% include _toc.html %}

##About

This lesson will review how to import spatial points stored in a .csv file into
`R` as a spatial object - a `SpatialPointsDataFrame`. We will also learn how to
reproject data imported in a shapefile format into another projection, create a 
shapefile from a spatial object in `R`, and plot raster and vector data as
layers in the same plot. 

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

#Goals / Objectives
After completing this activity, you will:

* Be able to import .csv files containing x,y coordinate locations into `R`.
* Know how to convert a .csv to a spatial object.
* Understand how to project coordinate locations provided in a Geographic
Coordinate System (Latitude, Longitude) to a projected coordinate system (UTM).
* Be able to plot raster and vector data in the same plot to create a map.

##Things You’ll Need To Complete This Lesson
To complete this lesson: you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

###Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`

* [More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

##Data to Download
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

##Spatial Data in Text Format
The `HARV_PlotLocations.csv` file contains `x, y` (point) locations for some 
<a href="http://www.neoninc.org/science-design/collection-methods/terrestrial-organismal-sampling" target="_blank">  
plots that NEON field crews </a>
are sampling vegetation and other ecological metrics. We would like to:

* Create a map of the locations of these plot locations. 
* Export the data in a `shapefile` format to share with our colleagues. This
shapefile could then be imported into any GIS software.
* Create a map combining a raster Canopy Height Model with the vector
shapefiles.

Spatial data are sometimes in a text file format (`.txt` or `.csv`). If the text
file has an associated `x` and `y` location column, then we can 
convert text format data into n `R` spatial object. If the data are points, 
the  `R` object will be a `SpatialPointsDataFrame`. The `SpatialPointsDataFrame` 
format allows us to store both the `x,y` values that represent the coordinate location
of each point and the columns describing associated metadata or attributes.  

<i class="fa fa-star"></i> **Data Tip:** There is a `SpatialPoints` object (not
`SpatialPointsDataFrame`) in `R` that does not allow you to store associated
attributes. 
{: .notice}

We will use the `rgdal` and `raster` libraries in this tutorial. 


    #load packages
    library(rgdal)  #for vector work; sp package should always load with rgdal. 
    library (raster)   #for metadata/attributes- vectors or rasters
    
    #set working directory to data folder
    #setwd("pathToDirHere")


##Reading in a .csv
To begin we need to read in the .csv file that contains the x,y coordinate
locations of plots at the NEON Harvard Forest Field Site (`HARV_PlotLocations.csv`).
Note we are setting `stringsAsFactors` to FALSE so all of our data import in `character`
rather than `factor` format.


    #Read the .csv file
    plot.locations_HARV <- 
      read.csv("NEON-DS-Site-Layout-Files/HARV/HARV_PlotLocations.csv",
               stringsAsFactors = FALSE)
    
    #look at the data structure
    str(plot.locations_HARV)

    ## 'data.frame':	21 obs. of  43 variables:
    ##  $ X         : num  731405 731934 731754 731724 732125 ...
    ##  $ Y         : num  4713456 4713415 4713115 4713595 4713846 ...
    ##  $ plotID    : chr  "HARV_015" "HARV_033" "HARV_034" "HARV_035" ...
    ##  $ pointID   : int  41 41 41 41 41 41 41 41 41 41 ...
    ##  $ mOrder    : int  4216 12408 45176 106616 185208 225400 356472 371064 385144 495736 ...
    ##  $ country   : chr  "unitedStates" "unitedStates" "unitedStates" "unitedStates" ...
    ##  $ stateProvi: chr  "MA" "MA" "MA" "MA" ...
    ##  $ county    : chr  "Worcester" "Worcester" "Worcester" "Worcester" ...
    ##  $ domainName: chr  "Northeast" "Northeast" "Northeast" "Northeast" ...
    ##  $ domainID  : chr  "D01" "D01" "D01" "D01" ...
    ##  $ siteName  : chr  "Harvard Forest" "Harvard Forest" "Harvard Forest" "Harvard Forest" ...
    ##  $ siteID    : chr  "HARV" "HARV" "HARV" "HARV" ...
    ##  $ plotType  : chr  "distributed" "tower" "tower" "tower" ...
    ##  $ subtype   : chr  "basePlot" "basePlot" "basePlot" "basePlot" ...
    ##  $ subtypeSpe: logi  NA NA NA NA NA NA ...
    ##  $ plotSize  : int  1600 1600 1600 1600 1600 1600 1600 1600 1600 1600 ...
    ##  $ plotDimens: chr  "40m x 40m" "40m x 40m" "40m x 40m" "40m x 40m" ...
    ##  $ referenceP: int  41 41 41 41 41 41 41 41 41 41 ...
    ##  $ decimalLat: num  42.5 42.5 42.5 42.5 42.5 ...
    ##  $ decimalLon: num  -72.2 -72.2 -72.2 -72.2 -72.2 ...
    ##  $ geodeticDa: chr  "WGS84" "WGS84" "WGS84" "WGS84" ...
    ##  $ utmZone   : chr  "18N" "18N" "18N" "18N" ...
    ##  $ easting   : num  731405 731934 731754 731724 732125 ...
    ##  $ northing  : num  4713456 4713415 4713115 4713595 4713846 ...
    ##  $ coordinate: logi  NA NA NA NA NA NA ...
    ##  $ elevation : num  332 342 348 334 353 ...
    ##  $ elevationU: logi  NA NA NA NA NA NA ...
    ##  $ minimumEle: logi  NA NA NA NA NA NA ...
    ##  $ maximumEle: logi  NA NA NA NA NA NA ...
    ##  $ slopeGradi: num  9.65 5.84 1.95 0.32 10.61 ...
    ##  $ slopeAspec: num  125 55 334 332 173 ...
    ##  $ nlcdClass : chr  "deciduousForest" "" "" "" ...
    ##  $ soilTypeOr: chr  "Inceptisols" "Inceptisols" "Inceptisols" "Histosols" ...
    ##  $ inclusionP: logi  NA NA NA NA NA NA ...
    ##  $ coordina_1: chr  "GIS" "GIS" "GIS" "GIS" ...
    ##  $ recordedDa: logi  NA NA NA NA NA NA ...
    ##  $ filteredPo: logi  NA NA NA NA NA NA ...
    ##  $ plotPdop  : logi  NA NA NA NA NA NA ...
    ##  $ plotHdop  : logi  NA NA NA NA NA NA ...
    ##  $ applicable: chr  "div" "bbc|bgc|cdw|dhp|div|hbp|ltr|mfb|sme|vst" "bbc|bgc|cdw|dhp|div|hbp|ltr|mfb|sme|vst" "bbc|bgc|cdw|dhp|div|hbp|ltr|mfb|sme|vst" ...
    ##  $ module    : chr  "R" "T" "T" "T" ...
    ##  $ plot      : chr  "4216R" "12408T" "45176T" "106616T" ...
    ##  $ plotdim   : num  40 40 40 40 40 40 40 40 40 40 ...

Note that `plot.locations_HARV` is a `data.frame` of 21 locations (rows) with 43 variables
(attributes) each.  

<div id="challenge" markdown="1">
##Challenge:  Data Structure & CRS
What is the coordinate reference system (`CRS`) for this data? (Hint: Try what
you may know about finding the `CRS` in spatial data, but don't struggle too
long before reading the next bit.)
</div>


#Determine a Coordinate Reference System
When we create a spatial points `data.frame` from a .csv, there is no inherent
CRS associated with it. We must assign a CRS based knowledge of the coordinate
system the x,y values are in.

How do we know what the correct CRS for the data is? There are several ways we 
know this.  

1.  We collected the data ourselves and know from the GPS what the CRS, x,y
values, and units are. 
2. The source of our .csv file for the data points also has a .txt (or similar)
file with metadata about the data.  For more information on metadata in
associated files check out the
[Understanding Time Series Metadata]({{site.baseurl}}/R/Time-Series-Metadata) 
lesson. 
3. We look at the data in our .csv (now `R` object) to see if it gives any
hints.

First, we'll look at the file names. 

    #view the column names
    names(plot.locations_HARV)

    ##  [1] "X"          "Y"          "plotID"     "pointID"    "mOrder"    
    ##  [6] "country"    "stateProvi" "county"     "domainName" "domainID"  
    ## [11] "siteName"   "siteID"     "plotType"   "subtype"    "subtypeSpe"
    ## [16] "plotSize"   "plotDimens" "referenceP" "decimalLat" "decimalLon"
    ## [21] "geodeticDa" "utmZone"    "easting"    "northing"   "coordinate"
    ## [26] "elevation"  "elevationU" "minimumEle" "maximumEle" "slopeGradi"
    ## [31] "slopeAspec" "nlcdClass"  "soilTypeOr" "inclusionP" "coordina_1"
    ## [36] "recordedDa" "filteredPo" "plotPdop"   "plotHdop"   "applicable"
    ## [41] "module"     "plot"       "plotdim"

Okay, there are several columns related to a CRS.  Let's check out the first to
rows of the `data.frame` to see what information is in these columns.


    #view the first 6 rows
    head(plot.locations_HARV)

    ##          X       Y   plotID pointID mOrder      country stateProvi
    ## 1 731405.3 4713456 HARV_015      41   4216 unitedStates         MA
    ## 2 731934.3 4713415 HARV_033      41  12408 unitedStates         MA
    ## 3 731754.3 4713115 HARV_034      41  45176 unitedStates         MA
    ## 4 731724.3 4713595 HARV_035      41 106616 unitedStates         MA
    ## 5 732125.3 4713846 HARV_036      41 185208 unitedStates         MA
    ## 6 731634.3 4713295 HARV_037      41 225400 unitedStates         MA
    ##      county domainName domainID       siteName siteID    plotType  subtype
    ## 1 Worcester  Northeast      D01 Harvard Forest   HARV distributed basePlot
    ## 2 Worcester  Northeast      D01 Harvard Forest   HARV       tower basePlot
    ## 3 Worcester  Northeast      D01 Harvard Forest   HARV       tower basePlot
    ## 4 Worcester  Northeast      D01 Harvard Forest   HARV       tower basePlot
    ## 5 Worcester  Northeast      D01 Harvard Forest   HARV       tower basePlot
    ## 6 Worcester  Northeast      D01 Harvard Forest   HARV       tower basePlot
    ##   subtypeSpe plotSize plotDimens referenceP decimalLat decimalLon
    ## 1         NA     1600  40m x 40m         41   42.53885  -72.18204
    ## 2         NA     1600  40m x 40m         41   42.53832  -72.17563
    ## 3         NA     1600  40m x 40m         41   42.53568  -72.17794
    ## 4         NA     1600  40m x 40m         41   42.54001  -72.17811
    ## 5         NA     1600  40m x 40m         41   42.54215  -72.17313
    ## 6         NA     1600  40m x 40m         41   42.53733  -72.17932
    ##   geodeticDa utmZone  easting northing coordinate elevation elevationU
    ## 1      WGS84     18N 731405.3  4713456         NA    331.64         NA
    ## 2      WGS84     18N 731934.3  4713415         NA    341.62         NA
    ## 3      WGS84     18N 731754.3  4713115         NA    347.61         NA
    ## 4      WGS84     18N 731724.3  4713595         NA    334.34         NA
    ## 5      WGS84     18N 732125.3  4713846         NA    352.93         NA
    ## 6      WGS84     18N 731634.3  4713295         NA    342.43         NA
    ##   minimumEle maximumEle slopeGradi slopeAspec       nlcdClass  soilTypeOr
    ## 1         NA         NA       9.65     124.57 deciduousForest Inceptisols
    ## 2         NA         NA       5.84      55.04                 Inceptisols
    ## 3         NA         NA       1.95     333.64                 Inceptisols
    ## 4         NA         NA       0.32     331.96                   Histosols
    ## 5         NA         NA      10.61     173.29                 Inceptisols
    ## 6         NA         NA       1.33     310.50                   Histosols
    ##   inclusionP coordina_1 recordedDa filteredPo plotPdop plotHdop
    ## 1         NA        GIS         NA         NA       NA       NA
    ## 2         NA        GIS         NA         NA       NA       NA
    ## 3         NA        GIS         NA         NA       NA       NA
    ## 4         NA        GIS         NA         NA       NA       NA
    ## 5         NA        GIS         NA         NA       NA       NA
    ## 6         NA        GIS         NA         NA       NA       NA
    ##                                applicable module    plot plotdim
    ## 1                                     div      R   4216R      40
    ## 2 bbc|bgc|cdw|dhp|div|hbp|ltr|mfb|sme|vst      T  12408T      40
    ## 3 bbc|bgc|cdw|dhp|div|hbp|ltr|mfb|sme|vst      T  45176T      40
    ## 4 bbc|bgc|cdw|dhp|div|hbp|ltr|mfb|sme|vst      T 106616T      40
    ## 5             bbc|cdw|dhp|hbp|ltr|mfb|vst      T 185208T      40
    ## 6     bbc|bgc|cdw|dhp|hbp|ltr|mfb|sme|vst      T 225400T      40

We have the following information that is relevant to a CRS: 

* X: 73xxxx.3 -- no other information but these match the eastings
* Y: 4713xxx -- no other information but these match the northings
* decimalLat: 42.5xxxx
* decimalLon: -72.1xxx
* geodeticDa: WGS84  -- this is geodetic datum WGS84
* utmZone: 18N
* easting: 73xxxx.3
* northing: 4713xxx

What can we make our of this?   We have a geographic coordinate system (Latitude
and Longitude, both in decimal degrees) and a projected coordinate system (UTM
in Zone18N with Eastings and Northings).  Importantly for the projection we know
that the datum is WGS84.  

#Convert .csv to Shapefile
Before we can combine our plot locations with the boundaries of our field site, 
or other spatial data we need to convert the locations from a .csv file to a
`SpatialPointsDataFrame`.  When we make the conversion, we also have to specify 
what the correct `crs`, datum, and other information.  We do this using a
`proj4string`.  As we are going to be projecting this data on a 2D surface to
make a map. We'll convert to a `SpatialPointsDataFrame` based on the UTM
coordinates. 

What is a `proj4string`? This is a string with specific information about the
`crs` and related information for the data in a spatial file.  The format
changes depending on the projection used.  This format is for UTMs. 
`+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`

* +proj=utm     the projection -- we know our data is in UTM
* +zone=18      the UTM zone -- we know our data is in 18N but N isn't needed
* +datum=WGS84  the datum -- we know our data is in WGS84
* +units=m      the coordinate value units -- UTM is by default meters (m)
* +no_defs      with rare exceptions this default used 
* +ellps=WGS84  which mapping ellipse was used -- we'll match the datum 
* +towgs84=0,0,0  conversion from current datum/ellipse to WGS84 -- nothing,
we're already in WGS84 for both.  

* For more information on <a href="http://proj.maptools.org/faq.html" target="_blank"> proj4.</a>
* For information on datums in `R`: `projInfo(type = "datum")`

Now we can convert the .csv file. 

    #Which data.frame columns represent the UTMs?
    names(plot.locations_HARV)

    ##  [1] "X"          "Y"          "plotID"     "pointID"    "mOrder"    
    ##  [6] "country"    "stateProvi" "county"     "domainName" "domainID"  
    ## [11] "siteName"   "siteID"     "plotType"   "subtype"    "subtypeSpe"
    ## [16] "plotSize"   "plotDimens" "referenceP" "decimalLat" "decimalLon"
    ## [21] "geodeticDa" "utmZone"    "easting"    "northing"   "coordinate"
    ## [26] "elevation"  "elevationU" "minimumEle" "maximumEle" "slopeGradi"
    ## [31] "slopeAspec" "nlcdClass"  "soilTypeOr" "inclusionP" "coordina_1"
    ## [36] "recordedDa" "filteredPo" "plotPdop"   "plotHdop"   "applicable"
    ## [41] "module"     "plot"       "plotdim"

    #X, Y are 1:2 or easting,northing are 23:24.  We can use either.
    
    #create an object defining the CRS in proj4string format
    #could be in the conversion code but this is cleaner coding.
    CRS_plot_HARV<- CRS("+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
                        +ellps=WGS84 +towgs84=0,0,0")
    
    plot.locationsSp_HARV <- SpatialPointsDataFrame(plot.locations_HARV[,23:24],
                    # [,23:24]the columns which represent UTM coordinate locations 
                        plot.locations_HARV,    #the R object to convert
                        proj4string = CRS_plot_HARV)   # assign a CRS 
                                              
    #look at CRS
    crs(plot.locationsSp_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

#Load Shapefiles 
We now have a spatial `R` object. We can plot our data!


    plot(plot.locationsSp_HARV, main="Map of Plot Locations")

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/plot-data-points-1.png) 

    # Save plot 
    Harv_plotLocMap<- recordPlot()

While our points do plot the map isn't very informative.  We can bring in other
spatial objects to create a better map. 

Let's bring in shapefiles for a field site boundary, roads & trails, and a tower
location in Harvard Forest. (If you completed
[Shapefile Metadata & Attributes in R]({{site.baseurl}}/R/shapefile-attributes-in-R/)
lesson you already have these `R` objects).


    #note: readOGR is preferred as it maintains the projection infomation
    #Import Field site boundary
    aoiBoundary_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV",
                                "HarClip_UTMZ18")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV", layer: "HarClip_UTMZ18"
    ## with 1 features
    ## It has 1 fields

    #Import a roads/trails
    lines_HARV <- readOGR( "NEON-DS-Site-Layout-Files/HARV/", "HARV_roads")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV/", layer: "HARV_roads"
    ## with 13 features
    ## It has 15 fields

    #Import a tower point
    point_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV/",
                          "HARVtower_UTM18N")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV/", layer: "HARVtower_UTM18N"
    ## with 1 features
    ## It has 14 fields

These are shapefiles that we want to match up with our, now converted, .csv
file.  It is important to first confirm that both spatial objects have the same 
CRS.


    #check the CRS in shapefile
    crs(plot.locationsSp_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    crs(aoiBoundary_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    crs(lines_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    crs(point_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

Yep, they are all the same.  We can now plot the shapefiles together.  


    #recall the original plot location map; optional
    Harv_plotLocMap
    
    #Add Field Site Boundary polygon & tower point layer to our "Map of Study Area"
    plot(aoiBoundary_HARV, add=TRUE)
    plot (point_HARV, col="red", add=TRUE)
    plot(lines_HARV, add=TRUE)

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/plot-data-maps-1.png) 

    # save this newer map
    Harv_plotLocMap2<- recordPlot()

What happened to the tower?

The extent of the study plot locations covers a larger area than the
`aoiBoundary_HARV` file that we originally originally projected.  


    extent(aoiBoundary_HARV)

    ## class       : Extent 
    ## xmin        : 732128 
    ## xmax        : 732251.1 
    ## ymin        : 4713209 
    ## ymax        : 4713359

    extent (plot.locationsSp_HARV)

    ## class       : Extent 
    ## xmin        : 731405.3 
    ## xmax        : 732275.3 
    ## ymin        : 4712845 
    ## ymax        : 4713846

#Borrow a CRS When Converting to a Spatial.Data.Frame
When we just convert our imported `plot.location_HARV` object to a
`SpatialPointsDataFrame` we assign it a `CRS` using a written out `proj4string`.
However, if we'd already had a Spatial.Data.Frame object with the same `CRS`)
(such as `aoiBoundary_HARV`, `lines_HARV` or `point_HARV`) we could have simply
borrowed the `CRS` from that object to use in the conversion.  

We'd just identify the file from which we'd use the `CRS` when doing the
conversion.  


    plot.locations_HARV_matchCRS <-
                   SpatialPointsDataFrame(plot.locations_HARV[,23:24],
                                          plot.locations_HARV,    # object to convert
                                          proj4string = crs(aoiBoundary_HARV))
                                        #assign CRS to match `aoiBoundary_HARV CRS
    #check to make sure it worked
    crs(plot.locations_HARV_matchCRS)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

WARNING: We still have to know the correct `CRS` for the data and 
use a file with a matching `CRS`.  This doesn't solve our problems if we DO NOT 
know our `CRS`. 

#Create a New Shapefile from A Spatial Object

We can write an `R` spatial object to a shapefile using the `writeOGR` function 
in `rgdal`. To do this we need the following arguments:

* the name of the spatial object (`plot.locationsSp_HARV`)
* the directory where we want to save our shapefile
           (to use current = getwd() or you can specify a different path)
* the name of the new shapefile  ("PlotLocations_HARV")
* the driver which specifies the file format (ESRI Shapefile)

We can now write the shapefile. 


    #write a shapefile
    writeOGR(plot.locationsSp_HARV, getwd(),
             "PlotLocations_HARV", driver="ESRI Shapefile")

    ## Error in writeOGR(plot.locationsSp_HARV, getwd(), "PlotLocations_HARV", : layer exists, use a new layer name


#Spatial Objects in Different CRSs
Too often, we have data that are in different `CRS`s. In order to map these
objects in geographic space we need to reproject one or the other so that 
they will line up on a map.

Let's explore reprojecting a spatial data object using a new study plot 
location (shapefile: "newPlot_latLon").


    #note: readOGR is preferred as it maintains prj info
    newPlots_HARV <- readOGR("NEON-DS-Site-Layout-Files/HARV",
                             "newPlots_latLon")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "NEON-DS-Site-Layout-Files/HARV", layer: "newPlots_latLon"
    ## with 2 features
    ## It has 18 fields

    #add these points to our existing plot  "Map of Study Area"
    Harv_plotLocMap2
    plot(newPlots_HARV, add=TRUE, col=115, pch=19)

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/project-vectors-1.png) 

    #save new plot
    Harv_plotLocMap3<- recordPlot()

We added the new plot locations to our existing plot and nothing happened.  Why?

What is the issue? Typically when data that we know should line up doesn't,
there is a projection issue. (Plus we should ALWAYS check projections/ CRS prior
to starting to work with any new spatial data.)

Often the coordinates can give us a clue as to whether the data are projected or
are in latitude and longitude (a geographic coordinate system).
We can use the `@coords` function to view the coordinates of the points in our
spatial object.


    #view coordinates
    newPlots_HARV@coords

    ##      coords.x1 coords.x2
    ## [1,] -72.17213  42.54278
    ## [2,] -72.17233  42.53955

It appears as if our coordinates for the two new plot locations are in latitude
and longitude. Let's check the CRS of our data to see if it is also in latitude
and longitude.

    crs(newPlots_HARV)

    ## CRS arguments: +proj=longlat +ellps=WGS84 +no_defs

Our `newPlots_HARV` shapefile is in a geographic coordinate system (latitude and 
longitude) instead of the UTM coordinate system of our other shapefiles. These
coordinates are not projected, and we need to reproject them in order to make
things line up in our map.

We can use the `spTransform` function to reproject a vector.


    #double check the CRS of our plots layer
    crs(plot.locationsSp_HARV)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #reproject our vector layer to the projection of our other plot data.
    newPlots_HARV_UTM<- spTransform(newPlots_HARV,
                                   crs(plot.locationsSp_HARV))
    
    #check crs
    crs(newPlots_HARV_UTM)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

Now that the `CRSs` match we can add our new plot points to our existing map.  


    #plot new plot location -- reprojected
    #col & pch parameters to make it stand out!
    Harv_plotLocMap3
    plot(newPlots_HARV_UTM, add=TRUE, col=116, pch=19) 

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/plot-reprojected-points-1.png) 

Yes!  A nice blue point showed up for our new plot... but wait only one.  We 
have two new plots.  Why did only one appear?  

#Plotting - Order of Operations
We had 2 points in our new plots layer, however the only one new point
appeared on our map. This is due to the extent of the map, which is defined by 
the extent of the first layer plotted (all others are "added" to that layer). 

What happens if we create a new plot, but add the roads layer first?


    #add roads to our plot
    plot(lines_HARV, main="Study Area")
    
    #add the study plot locations 
    plot(newPlots_HARV_UTM,add=T, col=116)
    plot(plot.locationsSp_HARV, add=T)
    
    #add the boundary layer 
    plot(aoiBoundary_HARV, col="red", add=TRUE)
    
    #add the tower 
    plot(point_HARV, add =TRUE, pch=16)

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/plot-data-order-1.png) 

We can see all the study plot locations now because we plotted the roads/trails 
layer (`lines_HARV`) first and it is the layer with the largest extent.  

#Plotting - Vector & Raster Layers Together
To create a visually pleasing map or to combine all the data we are interested
in we often need to combine raster and vector layers into one figure. We can
use the base `R` `plot()` command to create a vector-raster layered 
plot. 

We will use a Canopy Height Model (`chm`) from the Harvard forest as the base
layer for a map of our study locations.  


    chm_HARV <- raster("NEON-DS-Airborne-RemoteSensing/HARV/CHM/HARV_chmCrop.tif")

    ## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)

    plot(chm_HARV,
         main="Map of Study Plots\n w/ Canopy Height Model\nNEON Harvard Forest")

    ## Error in plot(chm_HARV, main = "Map of Study Plots\n w/ Canopy Height Model\nNEON Harvard Forest"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'chm_HARV' not found

    plot(lines_HARV, add = TRUE)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    plot(aoiBoundary_HARV, border="forestgreen", add = TRUE)

    ## Error in polypath(x = mcrds[, 1], y = mcrds[, 2], border = border, col = col, : plot.new has not been called yet

    plot(plot.locationsSp_HARV, add = TRUE)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    plot(newPlots_HARV_UTM, col="blue", add=TRUE)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    plot(point_HARV, pch=17, add=TRUE)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

<div id="challenge" markdown="1">
##Challenge: Useful Study Area Maps
Using a Digital Terrain Model
("NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif") 
create a usable map to the study area.  Include the following: 

1. Useful title, figure legends, and axes labels. 
2. Any or all vector layers that we have created. 
3. A customized color ramp. 
4. A color-coded system to identify the different types of roads or trails that
occur in the study site.  

For assistance consider using the 
[Shapefile Metadata & Attributes in R]({{site.baseurl}}/R/shapefile-attributes-in-R/),   
the [Plot Raster Data in R]({{site.baseurl}}/R/Plot-Rasters-In-R/ )   
or the
[Plot Raster Time Series Data in R Using RasterVis and Levelplot]({{site.baseurl}}/R/Plot-Raster-Times-Series-Data-In-R/) 
lessons. 
</div>


    ## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)

    ## Error in plot(DTM_HARV, main = "Map of Study Plots\n w/ Digital Terrain Model\nNEON Harvard Forest"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'DTM_HARV' not found

    ## Error in polypath(x = mcrds[, 1], y = mcrds[, 2], border = border, col = col, : plot.new has not been called yet

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

    ## Error in plot(lines_HARV, add = TRUE, legend("bottom", NULL, labels, fill = labCols, : error in evaluating the argument 'y' in selecting a method for function 'plot': Error in strwidth(legend, units = "user", cex = cex, font = text.font) : 
    ##   plot.new has not been called yet
