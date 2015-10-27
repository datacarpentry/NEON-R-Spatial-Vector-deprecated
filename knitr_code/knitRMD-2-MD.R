################## 

# This code takes an Rmd file and knits it to both jekyll flavored markdown and purls it
# to an R script to be included with the lesson. 
##################

#Inputs
gitRepoPath <-"~/Documents/GitHub/NEON-R-Spatial-Vector/"
#gitRepoPathPC <- 

#specify the file that you want to knit
#file <- "00-open-a-shapefile.Rmd"
#file <- "01-shapefile-attributes.Rmd"
#file <- "02-csv-vector-raster-plotting.Rmd"
file <- "03-vector-raster-integration-advanced.Rmd"

date <- "2015-10-26-L"
#/Users/lwasser/Documents/GitHub/NEON-R-Spatial-Vector

# Determine whether i'm on a MAC or PC, then define paths
if(.Platform$OS.type == "windows") {
  print("defining windows paths")
  #this is the path to the github repo on my PC
  gitRepoPath <- "C:/Users/lwasser/Documents/GitHub/NEON-DC-DataLesson-Hackathon/" 
} else {
    print("defining MAC paths")
    #this is the MAC path to the github repo
    #gitRepoPath <- "~/Documents/GitHub_Lwasser/NEON_DataSkills/"
    gitRepoPath <- "~/Documents/GitHub/NEON-R-Spatial-Vector/"
    }

#this is the path where the markdown files will be stored in the repo
#you can modify i depending upon which module you are working on.
#repoCodePath <- "_posts/"

#get the working dir where the data are stored
wd <- getwd()

#copy .Rmd file to local working directory where the data are located
#file.copy(from = (paste0(gitRepoPath,repoCodePath,file)), to=wd, overwrite = TRUE)

#specify where should the file go within the GH repo
#postsDir <- ("_posts/SPATIALDATA/")
postsDir <- ("_posts/")

#define the IMAGE file path
imagePath <- "images/rfigs/"
# poth to RMD files

require(knitr)

#set the base url for images and links in the md file
base.url="{{ site.baseurl }}/"
input=file
opts_knit$set(base.url = base.url)
#setup path to images
print(paste0(imagePath, sub(".Rmd$", "", basename(input)), "/"))

figDir <- print(paste0("images/", sub(".Rmd$", "", basename(input)), "/"))

#make sure image directory exists
#if it doesn't exist, create it
#note this will fail if the sub dir doesn't exist
if (file.exists(paste0(wd,"/","images"))){
    print("image dir exists - all good")
  } else {
    #create image directory structure
    dir.create(file.path(wd, "images/"))
    dir.create(file.path(wd, "images/rfigs"))
    dir.create(file.path(wd, figDir))
    print("image directories created!")
  }

fig.path <- paste0("images/rfigs/", sub(".Rmd$", "", basename(input)), "/")

opts_chunk$set(fig.path = fig.path)
opts_chunk$set(fig.cap = " ")
#render_jekyll()
render_markdown(strict = TRUE)

mdFile <- paste0(gitRepoPath,postsDir,date ,sub(".Rmd$", "", basename(input)), ".md")


#knit the markdown doc
#add a date so jekyll recognizes it.
knit(input, output = mdFile, envir = parent.frame())

#### COPY EVERYTHING OVER to the GIT SITE###

#copy image directory over
file.copy(paste0(wd,"/",imagePath), paste0(gitRepoPath,"images/"), recursive=TRUE)

#copy rmd file to the rmd directory on git
file.copy(paste0(wd,"/",file), gitRepoPath, recursive=TRUE)

#delete local repo copies of RMD files just so things are cleaned up??

## OUTPUT STUFF TO R ##
#output code in R format
rCodeOutput <- paste0(gitRepoPath, sub(".Rmd$", "", basename(input)), ".R")
rCodeOutput
#purl the code to R
purl(file, output = rCodeOutput)

