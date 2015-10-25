## Collect Data, Clean, and Return Tidy Data Set via run_analysis()
Course Project for Coursera:  Getting and Cleaning Data

--------------------
Author:  Julia Phelps<br>
Date:  10.24.2015<br>
System:
<blockquote>
<p>Operating system:  Windows 8
<br>Rstudio:  v3.2.2, 64-bit
<br>Package(s) Utilized:  dplyr
</p></blockquote>

## Project Description:

## Overview of run_analysis.R

This version of run_analysis.R was wrtten in RStudio v3.2.2 and has not been tested in other versions in R.  It is designed to work exclusively with the ADL datasets __________________.  <<size>>  It performs the entire process of directory structure, data collection, data cleaning and tidy data file output for the user.  The script will output two tidy datasets via `write.table()` into a "clean_data" folder within the downloaded files.  See **Output from run_analysis.R** below for more information. 

run_analysis.R makes use of the *dplyr package*, which it will attempt to load or install/load if not currently loaded in the workspace.  If unable to load *dplyr* for some reason, the script will exit out without attempting any additional steps.  This may be due to something blocking RStudio's normal downloading ability; therefore, it is suggested that you attempt manual download/installation/loading of *dplyr*.  The script will not run without it.

## Instructions for using run_analysis()

(Note:  Since run_analysis() is designed to only work with one particular dataset, it is suggested that you download the run_analysis.R script into your selected working directory to keep things organized and easy.)

1)  Set your working directory in RStudio with `setwd()`.

2)  Download run_analysis.R into your working directory.

3)  Source it into RStudio:
	## if run_analysis.R is in working directory
	> source("run_analysis.R")

4)  Run the function:
	> run_analysis()

Depending on your machine's specs, the script should only take a couple minutes (at most) to run.

## Output from run_analysis.R

## About the Data

## Sources

dyplr

