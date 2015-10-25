## Collect Data, Clean, and Return Tidy Data Set via run_analysis()
Course Project for Coursera:  Getting and Cleaning Data

--------------------
Version:  1
Author:  Julia Phelps<br>
Date:  10.24.2015<br>
System:
<blockquote>
<p>Operating system:  Windows 8
<br>Rstudio:  v3.2.2, 64-bit
<br>Package(s) Utilized:  dplyr
</p></blockquote>

## Project Description

This project is designed as a course project submission for the class Getting and Cleaning Data, offered through Coursera.

The goal of the course project is to write a script `run_analysis.R` that automates the process of:
* downloading a specified group of data sets and loading them into R,
* merging and subsetting selected data sets within the group to obtain a tidy data set within given parameters,
* creating a second "summary" tidy dataset from the first,
* ensuring that all variables within both sets are clearly and appropriately named,
* labeling activity variables to include proper descriptions of activities,
* and writing out the resulting tidy data sets to *.txt files for submission.

README and Code Book documents, which thoroughly document all aspects of the analysis and its variables, must also be included.

#### Overview of Data Sets

An excerpt from the course project instructions, taken from the Coursera website:

<blockquote>*"One of the most exciting areas in all of data science right now is wearable computing....Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone."*  --reprinted from http://www.coursera.org</blockquote>

The data sets used for this course project are located at:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The information in these sets represent Human Activity Recognition data collected from a group of 30 subjects wearing a Samsung Galaxy S II smartphone on their waists while performing six different "activities of daily living," or ADL.  The Human Activity Recognition Using Smartphones study was authored by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto at Smartlab - Non Linear Complex Systems Laboratory, a Research Laboratory at the DITEN / DIBRIS Departments of the University of Genova, Italy.  ([www.smartlab.ws](www.smartlab.ws)) [citation - CMI]

These sets used in this course project were obtained from the Human Activity Recognition Using Smartphones study that can be found on the Center for Machine Learning and Intelligent Systems at the University of California:  Bren School of Information and Computer Science.  ([http://cml.ics.uci.edu/](http://cml.ics.uci.edu/))  The original study design documentation and data can be found at:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

**For more information about the specifics of the data sets, please refer to the Code Book:  Variables section and the original study design documentation and data (link above).**

## Overview of run_analysis.R

This version of run_analysis.R was wrtten in RStudio v3.2.2 and has not been tested in other versions in R.  It is designed to work exclusively with the ADL datasets from the Human Activity Recognition Using Smartphones study (see Overview of Data Sets, above).  It performs the entire process of directory structure, data collection, data cleaning and tidy data file output for the user.  The script will output two tidy datasets via `write.table()` into a "clean_data" folder within the downloaded files.  See Output from run_analysis.R, located below, for more information. 

run_analysis.R makes use of the *dplyr package*, which it will attempt to load or install/load if not currently loaded in the workspace.  If unable to load *dplyr* for some reason, the script will exit out without attempting any additional steps.  This may be due to something blocking RStudio's normal downloading ability; therefore, it is suggested that you attempt manual download/installation/loading of *dplyr*.  The script will not run without *dplyr*.

## Instructions for using run_analysis()

(Note:  Since run_analysis() is designed to only work with one particular dataset, it is suggested that you download the run_analysis.R script into your selected working directory to keep things organized and easy.)

1)  Set your working directory in RStudio with `setwd()`.

2)  Download run_analysis.R into your working directory.
```
## If on PC:
> download.file("***NEEDS LINK, destfile="run_analysis.R")
## or:
> download.file("***NEEDS LINK, destfile="run_analysis.R", mode="wb")

## If on Mac:
> download.file("***NEEDS LINK, destfile="run_analysis.R", method="curl")
```

3)  Source it into RStudio:
```
## if run_analysis.R is in working directory
> source("run_analysis.R")
```

4)  Run the function:
```
> run_analysis()
```
Note:  When the run_analysis() function starts, you will get system messages indicating that *dplyr* is being loaded or downloaded/loaded, and a confirmation once it is loaded.  Provided that dplyr loads correctly, the rest of the function will begin.  Depending on your machine's specs, the script should only take a couple minutes (at most) to run.

5) To load data back into RStudio:
```
> ADL_cleanData <- read.table("./UCIData/clean_data/ADL_cleanData.txt", header=TRUE)
> ADL_cleanData_averages <- read.table("./UCIData/clean_data/ADL_cleanData_averages.txt", header=TRUE)
```

**Please see the included Code Book (file = codeBook.md) for more information on the Study Design and specific variables.**

## Output from run_analysis.R

`run_analysis()` will:
* create a folder called "UCIData" within your working directory, where it will download and unzip the datasets and information that it uses (total size of data ~ 330MB).
* create a folder within "UCIData" called "clean_data", where it will save two tidy datasets:
  - "ADL_cleanData.txt"
  - "ADL_cleanData_averages.txt"
* output the following message:
```
cleaning/summarization process is complete.

    full tidy dataset written to:
     “./UCIData/clean_data/ADL_cleanData.txt” 

    summarized tidy dataset written to:
     “./UCIData/clean_data/ADL_cleanData_averages.txt” 

    to read into R for further analysis, use read.table() with header=TRUE
```

**ADL_cleanData.txt** - A tidy dataset including the mean and standard deviation ("mean" and "std") variables of both the testing and training sets from the original study data.  Appropriate "SubjectID" and "activity" labels are also included.  Dimensions are 10299 rows by 68 columns.

**ADL_cleanData_averages.txt** - A second tidy dataset which summarizes the first set by providing averages of the mean and standard deviation ("mean" and "std") for each individual activity performed by each subject.  Again, appropriate "SubjectID" and "activity" labels are included.  Dimensions are 180 rows by 68 columns.

**Please see the Code Book (codeBook.md) for more information on the outputted tidy datasets, including Variable Names, Summary Choices and overall Study Design.**

## Sources

Much of the knowledge used to develop this course project was learned from the Getting and Cleaning Data course at Coursera:

[http://www.coursera.org](http://www.coursera.org)

More information on the `dyplr` package can be viewed at:

[https://github.com/hadley/dplyr](https://github.com/hadley/dplyr)

[https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)

The original Human Activity Recognition Using Smartphones study, including design documentation and data, can be found at the *UCI Center for Machine Learning and Intelligent Systems* Machine Learning Repository:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

#### For more information or to report a bug:

juliaphelps (at) gmail (dot) com.