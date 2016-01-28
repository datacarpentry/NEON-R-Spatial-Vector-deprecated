---
layout: tutorial
title: "Self-paced Tutorial: Working with Spatial Vector Data Series"
estimatedTime: 3.0 Hours
packagesLibraries: [rgdal, sp, raster, ggplot2]
date:   2015-1-15 20:49:52
dateCreated:   2015-10-15 17:00:00
lastModified: 2015-01-05 13:00:00
authors: [Megan A. Jones, Leah A. Wasser, Joseph Stachelek]
categories: [self-paced-tutorial]
tags: []
mainTag: vector-data
description: "This self-paced tutorial explain how to work with spatial data in
 a vector format in R.  The data set used consists of shapefiles for the NEON
 Harvard Forest and San Joaquin Experimental Range field sites. The data skills
 taught are applicable to all types of data contained in shapefiles.  The
 tutorial consists of four sequential lessons." 
code1: 
workshopName: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: tutorial/spatial-vector-series
comments: false
---

This self-paced tutorial explain how to work with spatial data in
 a vector format in R.  The data set used consists of shapefiles for the NEON
 Harvard Forest and San Joaquin Experimental Range field sites. The data skills
 taught are applicable to all types of data contained in shapefiles.  The
 tutorial consists of four sequential lessons. 


<div id="objectives" markdown="1">

#Goals / Objectives
After completing this lesson, you will:

 * OVERALL GOALS or list for each lesson? 


##Things You’ll Need To Complete This Lesson

###Setup RStudio
To complete the tutorial series you will need an updated version of R and,
 preferably, RStudio installed on your computer.
 <a href = "http://cran.r-project.org/">R</a> is a programming language
 that specializes in statistical computing. It is a powerful tool for
 exploratory data analysis. To interact with R, we strongly recommend 
<a href="http://www.rstudio.com/">RStudio</a>, an interactive development 
environment (IDE). 


###Install R Packages
You can chose to install packages with each lesson or you can download all 
of the necessary R Packages now. 

* **rgdal:** `install.packages("rgdal")`
* **sp:** `install.packages("sp")`
* **raster:** `install.packages("raster")`
* **ggplot2:** `install.packages("ggplot2")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

<\div>


