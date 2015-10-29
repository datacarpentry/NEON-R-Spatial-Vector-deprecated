---
layout: post
title: "Lesson 02: CSV to Shapefile in R"
date:   2015-10-24
authors: "Joseph Stachelek, Leah Wasser"
dateCreated:  2015-10-23
lastModified: 2015-10-26
tags: [module-1]
description: "This lesson walks through how to convert a csv file contains coordinate information into a spatial object in R."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/csv-to-shapefile-R/
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


> ##Goals / Objectives
> After completing this activity, you will:
>
> * Import csv file containing x,y coordinate locations.
> * Convert the csv to a spatial object
> * Project coordinate locations provided in a Geographic Coordinate System (Latitude, Longitide) to projected (UTM)
> * 

<div id="objectives">
<strong>R Skill Level:</strong> Beginner / Intermediate

<h3>Goals / Objectives</h3>
After completing this activity, you will:
<ol>
<li>Import a time series formated csv file.</li>
<li>Modify a date field that contains non-date characters and turn it into a proper
date formated field.</li>
<li>Plot the data.</li>
<li>Convert time to a local time zone.</li>
</ol>

<h3>R Libraries to Install</h3>
<ul>

</ul>

<h3>Data to Download</h3>
 

<h3>Pre-reqs</h3>
<p>.</p>
</div>

###Lesson 02 - How to convert csv with spatial locations to a spatial data frame


Objectives
* Understand how to convert a csv with spatial points to a spatial object in R.
* Convert to spatial points data frame
* Know how to plot a spatial points data
* Know how to create a basic map of a raster with a shapefile overlay
* Be able to compare and align the projections of raster and vector objects


Sometimes spatial data are downloaded or stored in a text file format (`txt` or 
csv`). We can convert these data in text format, into a spatial object in R `SpatialPointsDataFrame`. Note that there is a `SpatialPoints` object in R that 
does not allow you to store associated `attributes. The `SpatialPointsDataFrame 
allows you to store columns from your `data.frame` in the object.



    #first load libraries
    library(rgdal)
    library(raster)

##Reading in our CSV

The `HARV_PlotLocations.csv` file contains x,y locations for some plots that 
(NEON)[http://www.neoninc.org] field crew are sampling vegetation and other 
ecological metrics. We would like to create a map that includes the locations of 
these plot locations. We also would like to export the data in a `shapefile` 
format to share with our colleagues. This shapefile can also be imported into any
`GIS` software.

To begin, let's read in the `csv` file that contains the x,y coordinate locations.


    #Leah's notes
    setwd("~/Documents/data/1_DataPortal_Workshop/1_WorkshopData")
    
    #Read the csv file
    plot.location <- read.csv("boundaryFiles/HARV/HARV_PlotLocations.csv")
    
    #look at the data structure
    head(plot.location)

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

When we create a spatial points dataframe from a csv, there is no inherent `CRS` 
associated with it. We can assign a CRS if we know what the coordinate system 
the x,y values are in.

In this case, the CRS of our csv is UTM zone 18N (similar to our boundary shapefiles) 
that we opened previously. If the object is not still open in R, let's open up a 
shapefile that is in that project. Next, we will convert our imported `plot.location` 
object to a `SpatialPointsDataFrame` and assign it a CRS using the shapefile.


NOTE: it is important to first CONFIRM that the CRS of our CSV coordinates is the 
SAME as the CRS of the shapefile. We can figure that out by looking at the metadata 
for the CSV file which we hopefully have!

#NOTE: create metadata for this file!


    #note: read ogr is preferred as it maintains prj info
    aoiBoundary <- readOGR("boundaryFiles/HARV/","HarClip_UTMZ18")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "boundaryFiles/HARV/", layer: "HarClip_UTMZ18"
    ## with 1 features
    ## It has 1 fields

    #check the CRS
    crs(aoiBoundary)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #the x,y location values for the dataset are available in 
    #the x and y columns. We can use that for our spatial data point object
    #we know the csv file coordinates are in the same CRS as the other shapefiles.
    #we can assign this to the SpatialPointsDataFrame when we import it.
    plot.locationSp <- SpatialPointsDataFrame(plot.location[,1:2],
                                                    plot.location,
                                                    proj4string = crs(aoiBoundary))
    
    #look at CRS
    crs(plot.locationSp)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

Now, we have created a `SpatialPointsDataFrame` object in R using a csv file! 
The `R` object has a CRS that matches the CRS of our shapefiles. Let's plot our 
data!



    #plot the points
    #use main = to add a title to the map
    plot(plot.locationSp, main="Map of Study Area")
    
    #let's add the polygon layer to our plot
    plot(aoiBoundary, add=TRUE)
    
    #add roads to our plot
    roads <- readOGR("boundaryFiles/HARV/","HARV_roadStream")

    ## Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open layer

    plot(roads, add=TRUE)

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/plot-data-1.png) 

#Create a New Shapefile from A Spatial Object

We can write an R spatial object to a shapefile using the `writeOGR` function 
in `rgdal`. To do this we need the following arguments

* the name of the spatial object
* the director where we want to save our shapefile
* the name of the new shapefile
* the driver which specifies the file format (in this case a shapefile)



    #write a shapefile
    writeOGR(plot.locationSp, getwd(), "newFile", driver="ESRI Shapefile")

    ## Error in writeOGR(plot.locationSp, getwd(), "newFile", driver = "ESRI Shapefile"): layer exists, use a new layer name

#Dealing with Spatial objects in different CRS'

Often, we have data that are in different CRS'. In order to map these objects
in the same visual space, we need to then reproject them. We can use the 
`spTransform` function to reproject a vector.

In this case, we have a shapefile called `newPlots_latLon` that is in a 
geographic coordinate system (latitude and longitude). Let's read these data in
and try to add them to our map


    #note: read ogr is preferred as it maintains prj info
    newPlots <- readOGR("boundaryFiles/HARV/","newPlots_latLon")

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "boundaryFiles/HARV/", layer: "newPlots_latLon"
    ## with 2 features
    ## It has 18 fields

    #http://www.statmethods.net/advgraphs/parameters.html
    #add these points to our plot
    plot(newPlots, add=TRUE, col=115, pch=19)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet

We tried to add the newPlots to our existing plot and nothing happened? What
is the issue? Typically when data that we know should line up, doesn't, there
is a projection issue. Let's check it out.

First, let's look at the data in our new plots layer.
Often the coordinates themselves can give us a clue as to whether the data are
projected OR are in latitude and longitude (geographic coordinate system).
We can use the `@coords` function to view the coordinates of the points in our
spatial object.


    #view coordinates
    newPlots@coords

    ##      coords.x1 coords.x2
    ## [1,] -72.17213  42.54278
    ## [2,] -72.17233  42.53955

    #it appears as if our coordinates are in lat / long
    #let's check the CRS of our data to see what's going on
    crs(newPlots)

    ## CRS arguments: +proj=longlat +ellps=WGS84 +no_defs

We've added points to our map. However, they are not appearing in our study area.
This is because our shapefile is in a GEOGRAPHIC (latitude and longitude) reference 
system. They are not projected. We will need to project the data to `UTM` which is
what our other shapefiles are in to make things line up.

We will use `spTransform` to do project our data.



    #let's double check the crs of our plots layer
    crs(plot.locationSp)

    ## CRS arguments:
    ##  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84
    ## +towgs84=0,0,0

    #reproject our vector layer to the projection of our other plot data.
    newPlots_UTMZ18N<- spTransform(newPlots,crs(plot.locationSp))
    #try to plot the data
    plot(newPlots_UTMZ18N, add=TRUE, col=116,pch=19)

    ## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet


#ON YOUR OWN -- 
#Plotting - Order of Operations

Note that we had 2 points in our new plots layer, however the only one new point
appeared on our map. This is due to the extent of the map, which was defined by 
the order in which layers were added. 

What happens if we create a new plot, but add the roads layer first?


    #add roads to our plot
    plot(roads, main="Study Area")
    #plot the points
    #use main = to add a title to the map
    plot(newPlots_UTMZ18N,add=T, col=116,pch=19)
    
    plot(plot.locationSp, add=T)
    
    #let's add the polygon layer to our plot
    plot(aoiBoundary, add=TRUE)

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/plot-data-2-1.png) 

#this could also be on your own -- they know how to plot rasters.

##Create a vector-raster overlay map

We will use the base graphics `plot()` command to create a vector-raster overlay 
plot. Next, we will load a raster from disk user the `raster` command, plot this 
raster, and overlay the lines and squareplot shapefiles using the `add` argument. 


    chm <- raster("NEON_RemoteSensing/HARV/CHM/HARV_chmCrop.tif")
    
    #notice that the `\n` command allows you to split title lines into two.
    
    plot(chm, main="Tree Height\nHarvard Forest")
    
    plot(roads, add = TRUE)
    plot(aoiBoundary, add = TRUE)

![ ]({{ site.baseurl }}/images/rfigs/02-csv-vector-raster-plotting/Plot vector-raster overlay-1.png) 

    plot(plot.location_spatial, add = TRUE, pch=19)

    ## Error in plot(plot.location_spatial, add = TRUE, pch = 19): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'plot.location_spatial' not found
