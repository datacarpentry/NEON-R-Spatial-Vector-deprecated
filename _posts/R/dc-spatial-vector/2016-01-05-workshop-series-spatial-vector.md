---
layout: post_by_workshop-series
title: "Workshop Series: Work with Spatial Vector Data in R"
estimatedTime: 3.0 Hours
packagesLibraries: [rgdal, sp, raster]
date:   2015-1-15
dateCreated:   2015-10-15
lastModified: 2015-01-05
authors: [Joseph Stachelek, Leah A. Wasser ]
workshopSeriesName: vector-data-series
categories: [data-workshop]
tags: [R, spatial-data-gis, vector-data]
mainTag: vector-data-series
description: "This tutorials that comprise this workshop cover how to 
open, work with and plot with spatial data, in vector format (points, lines and polygons) in R. 
Topics covered include working with spatial metadata: extent and coordinate reference system,
working with spatial attributes and plotting data by attributes. Data used
in this series cover NEON Harvard Forest Field Site and are in Shapefile and .csv
format." 
code1: 
workshopName: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: data-workshop/spatial-vector-series
comments: false
---

{% include _toc.html %}

##Workshop: Vector Data - Shapefiles in R
This **tutorials that comprise this workshop ** cover how to 
open, work with and plot with spatial data, in vector format (points, lines and polygons) in R. 
Topics covered include working with spatial metadata: extent and coordinate reference system,
working with spatial attributes and plotting data by attributes. Data used
in this series cover NEON Harvard Forest Field Site and are in Shapefile and .csv
format.

**R Skill Level:** Beginner - you've got the basics of `R` down but haven't worked with
spatial data in `R` before.

<div id="objectives" markdown="1">

#Goals / Objectives
After completing the lessons in this WORKSHOP SERIES you will know how to:

 * B
 
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

**Data Carpentry Lesson Series:** This workshop part of a larger 
[spatio-temporal Data Carpentry Workshop ]({{ site.baseurl }}self-paced-tutorials/spatio-temporal-workshop)
that includes working with
[raster data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-raster-series) 
and  
[tabular time series in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series).
</div> 

##List lessons associated with this workshop series BELOW.


