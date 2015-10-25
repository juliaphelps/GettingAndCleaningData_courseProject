---
title:  "Codebook for run_analysis.R and its inputs/outputs"
version:  1
author:  "Julia Phelps"
date authored: "10.24.2015"
---

## Project Description

This project is designed as a course project submission for the class Getting and Cleaning Data, offered through Coursera.

The goal of the course project is to write a script `run_analysis.R` that automates the process of retrieving data, merging/subsetting/labeling that data to create a useful tidy data set, creating a secondary tidy data set that summarizes information from the first, and outputting tables of both tidy data sets in *.txt format.  The script must be accompanied by README and Code Book documents, which thoroughly document all aspects of the analysis and its variables.

##Study Design

The intent of this data cleaning analysis is that the provided `run_analysis.R` script will completely automate the process of:
* downloading a specified group of data sets and loading them into R,
* merging and subsetting selected data sets within the group to obtain a tidy data set within given parameters,
* creating a second "summary" tidy dataset from the first,
* ensuring that all variables within both sets are clearly and appropriately named,
* labeling activity variables to include proper descriptions of activities,
* and writing out the resulting tidy data sets to *.txt files for submission.

The user will simply have to download and source the script in his/her working directory, run the simple command `run_analysis()`, and the script will do the rest.

The script will output two files, saved in a folder within the working directory:

**ADL_cleanData.txt** - A tidy dataset including the mean and standard deviation ("mean" and "std") variables of both the testing and training sets from the original study data.  Appropriate "SubjectID" and "activity" labels are also included.  Dimensions are 10299 rows by 68 columns.

**ADL_cleanData_averages.txt** - A second tidy dataset which summarizes the first set by providing averages of the mean and standard deviation ("mean" and "std") for each individual activity performed by each subject.  Again, appropriate "SubjectID" and "activity" labels are included.  Dimensions are 180 rows by 68 columns.

###Collection of Raw Data
Description of how the data was collected.

###Notes on Original (Raw) Data 

**For more information on the original study and data, please see Overview of Data Sets in the README.md file.**

##Creating the Tidy Data File (ADL_cleanData.txt)
###Guide to create the tidy data file
Description on how to create the tidy data file (1. download the data, ...)/

###Cleaning of the data
Short, high-level description of what the cleaning script does. [link to the readme document that describes the code in greater detail]()

##Description of Variables in ADL_cleanData.txt
General description of the file including:
 - Dimensions of the dataset
 - Summary of the data
 - Variables present in the dataset

(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)

### SubjectID
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |

###Variable 1 (repeat this section for all variables in the dataset)
Short description of what the variable describes.

Some information on the variable including:
 - Class of the variable
 - Unique values/levels of the variable
 - Unit of measurement (if no unit of measurement list this as well)
 - In case names follow some schema, describe how entries were constructed (for example time-body-gyroscope-z has 4 levels of descriptors. Describe these 4 levels). 

(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)
