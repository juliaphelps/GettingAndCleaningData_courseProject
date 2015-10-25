## Code Book for run_analysis() and Its Outputs
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

The goal of the course project is to write a script `run_analysis.R` that automates the process of retrieving data, merging/subsetting/labeling that data to create a useful tidy data set, creating a secondary tidy data set that summarizes information from the first, and outputting tables of both tidy data sets in *.txt format.  The script must be accompanied by README and Code Book documents, which thoroughly document all aspects of the analysis and its variables.

## Study Design

The intent of this data cleaning analysis is that the provided `run_analysis.R` script will completely automate the process of:
* downloading a specified group of data sets and loading them into R,
* merging and subsetting selected data sets within the group to obtain a tidy data set within given parameters,
* creating a second "summary" tidy dataset from the first,
* ensuring that all variables within both sets are clearly and appropriately named,
* labeling activity variables to include proper descriptions of activities,
* and writing out the resulting tidy data sets to *.txt files for submission.

The user will simply have to download and source the script in his/her working directory, run the simple command `run_analysis()`, and the script will do the rest.  When finished, the script will write out two data frames with `write.table()` and output a message:
```
cleaning/summarization process is complete.

    full tidy dataset written to:
     “./UCIData/clean_data/ADL_cleanData.txt” 

    summarized tidy dataset written to:
     “./UCIData/clean_data/ADL_cleanData_averages.txt” 

    to read into R for further analysis, use read.table() with header=TRUE
```
### 1) Required Packages

`run_analysis()` utilizes the `dplyr` package, available from the CRAN network.  To ensure that the script runs correctly, the first step in `run_analysis()` is to use `require()` to attempt to load `dplyr`.  If `dplyr` is successfully loaded, the script will move onto the next step; however, if the `dplyr` package has not been installed on a machine, the script will attempt to install it via `install.packages()` and then load it with `require()`.  If this succeeds, `run_analysis()` will move onto its next step; otherwise, the script will throw an error and return to the parent environment.

### 2) Collection of Raw Data

To make its process as error-proof as possible, `run_analysis()` will next attempt to download the *.zip file of the Human Activity Recognition data set.  First it will create a subfolder in the working directory called "./UCIData", then it will download the *.zip file into this new directory using `download.file()`, and then it will unzip the file's contents into the "./UCIData" directory using `unzip()`.

*Note:  This script was designed for Windows 8 compatability.  If you are using a Mac machine, you may need to modify the download.file() code slightly to work with your system.  Please refer to "Instructions for using run_analysis()" section of README.md for more info.

#### Notes on Original (Raw) Data 

The raw data used in this process consists of several different *.txt files, which are read individually into R by `run_analysis()` for use in different parts of the data-cleaning process.  These files are as follows:
* "./UCIData/UCI HAR Dataset/test/subject_test.txt" - dimensions[2947 x 1]
* "./UCIData/UCI HAR Dataset/test/X_test.txt" - dimensions[2947 x 561]
* "./UCIData/UCI HAR Dataset/test/y_test.txt" - dimensions[2947 x 1]
* "./UCIData/UCI HAR Dataset/train/subject_train.txt" - dimensions[7352 x 1]
* "./UCIData/UCI HAR Dataset/train/X_train.txt" - dimensions[7352 x 561]
* "./UCIData/UCI HAR Dataset/train/y_train.txt" - dimensions[7352 x 1]
* "./UCIData/UCI HAR Dataset/activity_labels.txt" - dimensions[6 x 2]
* "./UCIData/UCI HAR Dataset/features.txt" - dimensions[561 x 2]

**For more information on the original study and data, please see Overview of Data Sets in the README.md file.**

## 3) Creating the Tidy Data Files (ADL_cleanData.txt and ADL_cleanData_averages.txt)
### Guide to creating the full tidy data frame:
`run_analysis()` uses the following code to generate the full tidy data frame, "all_data":
```
    subject_test <- read.table("./UCIData/UCI HAR Dataset/test/subject_test.txt")
    subject_train <- read.table("./UCIData/UCI HAR Dataset/train/subject_train.txt")
    subject_data <- rbind(subject_test, subject_train)
    colnames(subject_data) <- "subjectID"
    
    y_test <- read.table("./UCIData/UCI HAR Dataset/test/y_test.txt")
    y_train <- read.table("./UCIData/UCI HAR Dataset/train/y_train.txt")
    y_temp1 <- rbind(y_test, y_train)
    y_temp2 <- as.vector(y_temp1$V1)
    activity_temp <- read.table("./UCIData/UCI HAR Dataset/activity_labels.txt")
    activity_labels <- factor(activity_temp$V2)
    y_data <- data.frame(factor(y_temp2, labels=activity_labels))
    colnames(y_data) <- "activity"
    
    x_test <- read.table("./UCIData/UCI HAR Dataset/test/X_test.txt")
    x_train <- read.table("./UCIData/UCI HAR Dataset/train/X_train.txt")
    x_temp1 <- rbind(x_test, x_train)
    features <- read.table("./UCIData/UCI HAR Dataset/features.txt")
    colnames(x_temp1) <- features$V2
    x_data <- x_temp1[, grep("mean()", colnames(x_temp1), fixed=TRUE)]
    x_data[, 34:66] <- x_temp1[, grep("std()", colnames(x_temp1), fixed=TRUE)]

    all_data <- cbind(subject_data, y_data, x_data)
```
This merges the test and train data sets for subject, x, and y data.  Column names are created for the x data set using `colnames()` to apply the second column of the "features.txt" data set.  The script also changes the "activity" labels in the y data set from integers to character descriptions by applying a `factor()` of the second column of the "activity_labels.txt" set.  Once the subject, x, and y data sets are created, they are bound together into all_data using `cbind()`.

### Guide to creating the summarized tidy data frame:

`run_analysis()` then creates a second tidy data.frame, "avg_data", which is a summary of the means of each of the feature data columns for each activity, performed by each individual subject.  (E.G. SubjectID= 1, activity=WALKING; SubjectID=2, activity=WALKING_UPSTAIRS; etc.)  This is performed very simply via the following `dplyr` code:
```
avg_data <- as.data.frame(all_data %>% group_by(subjectID, activity) %>% summarize_each(funs(mean)))
    avg_names <- colnames(avg_data[,3:68])
    avg_names <- paste("avg", avg_names, sep="_")
    colnames(avg_data) <- c("subjectID", "activity", avg_names)
```
### Guide to writing the two data sets to file:

Lastly, the script will create a file within "./UCIData" called "clean_data" and write out the two files:
```
if(!file.exists("./UCIData/clean_data")){dir.create("./UCIData/clean_data")}
    write.table(all_data, file="./UCIData/clean_data/ADL_cleanData.txt", row.names = FALSE)
    write.table(avg_data, file="./UCIData/clean_data/ADL_cleanData_averages.txt", row.names = FALSE)
```
It will then return a message indicating a complete process and the location of the files.
```
loc1 <- "./UCIData/clean_data/ADL_cleanData.txt"
    loc2 <- "./UCIData/clean_data/ADL_cleanData_averages.txt"
    return(cat("cleaning/summarization process is complete.

    full tidy dataset written to:
    ",dQuote(loc1),"

    summarized tidy dataset written to:
    ",dQuote(loc2),"

    to read into R for further analysis, use read.table() with header=TRUE"))
```
## 4) To read the two files back into R:
You may run the following code:
```
> ADL_cleanData <- read.table("./UCIData/clean_data/ADL_cleanData.txt", header=TRUE)
> ADL_cleanData_averages <- read.table("./UCIData/clean_data/ADL_cleanData_averages.txt", header=TRUE)
```


## Description of Variables in "ADL_cleanData.txt"

A tidy data set including the mean and standard deviation ("mean" and "std") variables of both the testing and training sets from the original study data.  Appropriate "SubjectID" and "activity" labels are also included.  Dimensions are 10299 rows by 68 columns.

#### Variables in "ADL_cleanData.txt":

| Variable                    | Class         | Units           | Range                                 | Description                          |
| --------------------------- | ------------- | --------------- | ------------------------------------- | ------------------------------------ |
| SubjectID                   | integer       | n/a             | 1 to 3                                | ID number of subject being observed  |
| activity                    | factor        | n/a             | Content Cell                          | ADL Activity performed during observation (see table below:  Labels for "activity" Factor Variables)  |
| tBodyAcc.mean...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration in X  |
| tBodyAcc.mean...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration in Y  |
| tBodyAcc.mean...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration in Z  |
| tGravityAcc.mean...X        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Gravity Acceleration in X  |
| tGravityAcc.mean...Y        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Gravity Acceleration in Y  |
| tGravityAcc.mean...Z        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Gravity Acceleration in Z  |
| tBodyAccJerk.mean...X       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration Jerk in X  |
| tBodyAccJerk.mean...Y       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration Jerk in Y  |
| tBodyAccJerk.mean...Z       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration Jerk in Z  |
| tBodyGyro.mean...X          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope in X  |
| tBodyGyro.mean...Y          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope in Y  |
| tBodyGyro.mean...Z          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope in Z  |
| tBodyGyroJerk.mean...X      | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope Jerk in X  |
| tBodyGyroJerk.mean...Y      | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope Jerk in Y  |
| tBodyGyroJerk.mean...Z      | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope Jerk in Z  |
| tBodyAccMag.mean..          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration Mag  |
| tGravityAccMag.mean..       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Gravity Acceleration Mag  |
| tBodyAccJerkMag.mean..      | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Acceleration Jerk Mag  |
| tBodyGyroMag.mean..         | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope Mag  |
| tBodyGyroJerkMag.mean..     | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Body Gyroscope Jerk Mag  |
| fBodyAcc.mean...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration in X  |
| fBodyAcc.mean...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration in Y  |
| fBodyAcc.mean...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration in Z  |
| fBodyAccJerk.mean...X       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration Jerk in X  |
| fBodyAccJerk.mean...Y       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration Jerk in Y  |
| fBodyAccJerk.mean...Z       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration Jerk in Z  |
| fBodyGyro.mean...X          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Gyroscope in X  |
| fBodyGyro.mean...Y          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Gyroscope in Y  |
| fBodyGyro.mean...Z          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Gyroscope in Z  |
| fBodyAccMag.mean..          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration Mag  |
| fBodyBodyAccJerkMag.mean..  | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Acceleration Jerk Mag  |
| fBodyBodyGyroMag.mean..     | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Gyroscope Mag  |
| fBodyBodyGyroJerkMag.mean.. | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated mean of Fast Fourier Tranform of Body Gyroscope Jerk Mag  |
| tBodyAcc.std...X            | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration in X  |
| tBodyAcc.std...Y            | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration in Y  |
| tBodyAcc.std...Z            | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration in Z  |
| tGravityAcc.std...X         | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Gravity Acceleration in X  |
| tGravityAcc.std...Y         | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Gravity Acceleration in Y  |
| tGravityAcc.std...Z         | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Gravity Acceleration in Z  |
| tBodyAccJerk.std...X        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration Jerk in X  |
| tBodyAccJerk.std...Y        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration Jerk in Y  |
| tBodyAccJerk.std...Z        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration Jerk in Z  |
| tBodyGyro.std...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope in X  |
| tBodyGyro.std...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope in Y  |
| tBodyGyro.std...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope in Z  |
| tBodyGyroJerk.std...X       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope Jerk in X  |
| tBodyGyroJerk.std...Y       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope Jerk in Y  |
| tBodyGyroJerk.std...Z       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope Jerk in Z  |
| tBodyAccMag.std..           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration Mag  |
| tGravityAccMag.std..        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Gravity Acceleration Mag  |
| tBodyAccJerkMag.std..       | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Acceleration Jerk Mag  |
| tBodyGyroMag.std..          | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope Mag  |
| tBodyGyroJerkMag.std..      | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Body Gyroscope Jerk Mag  |
| fBodyAcc.std...X            | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration in X  |
| fBodyAcc.std...Y            | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration in Y  |
| fBodyAcc.std...Z            | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration in Z  |
| fBodyAccJerk.std...X        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration Jerk in X  |
| fBodyAccJerk.std...Y        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration Jerk in Y  |
| fBodyAccJerk.std...Z        | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration Jerk in Z  |
| fBodyGyro.std...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Gyroscope in X  |
| fBodyGyro.std...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Gyroscope in Y  |
| fBodyGyro.std...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Gyroscope in Z  |
| fBodyAccMag.std..           | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration Mag  |
| fBodyBodyAccJerkMag.std..   | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Acceleration Jerk Mag  |
| fBodyBodyGyroMag.std..      | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Gyroscope Mag  |
| fBodyBodyGyroJerkMag.std..  | numeric       | radians/second  | normalized and bounded within [-1,1]  | estimated standard deviation of Fast Fourier Tranform of Body Gyroscope Jerk Mag  |

#### Labels for "activity" Factor Variables in "ADL_cleanData.txt":

| Activity                   | Factor        |
| -------------------------- | ------------- |
| WALKING                    | 1             |
| WALKING_UPSTAIRS           | 2             |
| WALKING_DOWNSTAIRS
         | 3             | 
| SITTING                    | 4             | 
| STANDING                   | 5             | 
| LAYING                     | 6             | 

## Description of Variables in "ADL_cleanData_averages.txt":

A second tidy dataset which summarizes the first set by providing averages of the mean and standard deviation ("mean" and "std") for each individual activity performed by each subject.  Again, appropriate "SubjectID" and "activity" labels are included.  Dimensions are 180 rows by 68 columns.

#### Variables in "ADL_cleanData_averages.txt":


| Variable                        | Class         | Units           | Range                                 | Description                          |
| ------------------------------- | ------------- | --------------- | ------------------------------------- | ------------------------------------ |
| SubjectID                       | numeric       | n/a             | 1 to 3                                | ID number of subject being observed  |
| activity                        | character     | n/a             | Content Cell                          | ADL Activity being performed during observation  |
| avg_tBodyAcc.mean...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAcc.mean...X for each activity performed by each subject  |
| avg_tBodyAcc.mean...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAcc.mean...Y for each activity performed by each subject  |
| avg_tBodyAcc.mean...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAcc.mean...Z for each activity performed by each subject  |
| avg_tGravityAcc.mean...X        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAcc.mean...X for each activity performed by each subject  |
| avg_tGravityAcc.mean...Y        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAcc.mean...Y for each activity performed by each subject  |
| avg_tGravityAcc.mean...Z        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAcc.mean...Z for each activity performed by each subject  |
| avg_tBodyAccJerk.mean...X       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerk.mean...X for each activity performed by each subject  |
| avg_tBodyAccJerk.mean...Y       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerk.mean...Y for each activity performed by each subject  |
| avg_tBodyAccJerk.mean...Z       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerk.mean...Z for each activity performed by each subject  |
| avg_tBodyGyro.mean...X          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyro.mean...X for each activity performed by each subject  |
| avg_tBodyGyro.mean...Y          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyro.mean...Y for each activity performed by each subject  |
| avg_tBodyGyro.mean...Z          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyro.mean...Z for each activity performed by each subject  |
| avg_tBodyGyroJerk.mean...X      | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerk.mean...X for each activity performed by each subject  |
| avg_tBodyGyroJerk.mean...Y      | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerk.mean...Y for each activity performed by each subject  |
| avg_tBodyGyroJerk.mean...Z      | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerk.mean...Z for each activity performed by each subject  |
| avg_tBodyAccMag.mean..          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccMag.mean.. for each activity performed by each subject  |
| avg_tGravityAccMag.mean..       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAccMag.mean.. for each activity performed by each subject  |
| avg_tBodyAccJerkMag.mean..      | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccMag.mean.. for each activity performed by each subject  |
| avg_tBodyGyroMag.mean..         | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerkMag.mean.. for each activity performed by each subject  |
| avg_tBodyGyroJerkMag.mean..     | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerkMag.mean.. for each activity performed by each subject  |
| avg_fBodyAcc.mean...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAcc.mean...X for each activity performed by each subject  |
| avg_fBodyAcc.mean...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAcc.mean...Y for each activity performed by each subject  |
| avg_fBodyAcc.mean...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAcc.mean...Z for each activity performed by each subject  |
| avg_fBodyAccJerk.mean...X       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccJerk.mean...X for each activity performed by each subject  |
| avg_fBodyAccJerk.mean...Y       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccJerk.mean...Y for each activity performed by each subject  |
| avg_fBodyAccJerk.mean...Z       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccJerk.mean...Z for each activity performed by each subject  |
| avg_fBodyGyro.mean...X          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyGyro.mean...X for each activity performed by each subject  |
| avg_fBodyGyro.mean...Y          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyGyro.mean...Y for each activity performed by each subject  |
| avg_fBodyGyro.mean...Z          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyGyro.mean...Z for each activity performed by each subject  |
| avg_fBodyAccMag.mean..          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccMag.mean.. for each activity performed by each subject  |
| avg_fBodyBodyAccJerkMag.mean..  | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyBodyAccJerkMag.mean.. for each activity performed by each subject  |
| avg_fBodyBodyGyroMag.mean..     | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyBodyGyroMag.mean.. for each activity performed by each subject  |
| avg_fBodyBodyGyroJerkMag.mean.. | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyBodyGyroJerkMag.mean.. for each activity performed by each subject  |
| avg_tBodyAcc.std...X            | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAcc.std...X for each activity performed by each subject  |
| avg_tBodyAcc.std...Y            | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAcc.std...Y for each activity performed by each subject  |
| avg_tBodyAcc.std...Z            | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAcc.std...Z for each activity performed by each subject  |
| avg_tGravityAcc.std...X         | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAcc.std...X for each activity performed by each subject  |
| avg_tGravityAcc.std...Y         | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAcc.std...Y for each activity performed by each subject  |
| avg_tGravityAcc.std...Z         | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAcc.std...Z for each activity performed by each subject  |
| avg_tBodyAccJerk.std...X        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerk.std...X for each activity performed by each subject  |
| avg_tBodyAccJerk.std...Y        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerk.std...Y for each activity performed by each subject  |
| avg_tBodyAccJerk.std...Z        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerk.std...Z for each activity performed by each subject  |
| avg_tBodyGyro.std...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyro.std...X for each activity performed by each subject  |
| avg_tBodyGyro.std...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyro.std...Y for each activity performed by each subject  |
| avg_tBodyGyro.std...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyro.std...Z for each activity performed by each subject  |
| avg_tBodyGyroJerk.std...X       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerk.std...X for each activity performed by each subject  |
| avg_tBodyGyroJerk.std...Y       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerk.std...Y for each activity performed by each subject  |
| avg_tBodyGyroJerk.std...Z       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerk.std...Z for each activity performed by each subject  |
| avg_tBodyAccMag.std..           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccMag.std.. for each activity performed by each subject  |
| avg_tGravityAccMag.std..        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tGravityAccMag.std.. for each activity performed by each subject  |
| avg_tBodyAccJerkMag.std..       | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyAccJerkMag.std.. for each activity performed by each subject  |
| avg_tBodyGyroMag.std..          | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroMag.std.. for each activity performed by each subject  |
| avg_tBodyGyroJerkMag.std..      | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of tBodyGyroJerkMag.std.. for each activity performed by each subject  |
| avg_fBodyAcc.std...X            | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAcc.std...X for each activity performed by each subject |
| avg_fBodyAcc.std...Y            | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAcc.std...Y for each activity performed by each subject  |
| avg_fBodyAcc.std...Z            | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAcc.std...Z for each activity performed by each subject  |
| avg_fBodyAccJerk.std...X        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccJerk.std...X for each activity performed by each subject  |
| avg_fBodyAccJerk.std...Y        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccJerk.std...Y for each activity performed by each subject  |
| avg_fBodyAccJerk.std...Z        | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccJerk.std...Z for each activity performed by each subject  |
| avg_fBodyGyro.std...X           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyGyro.std...X for each activity performed by each subject  |
| avg_fBodyGyro.std...Y           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyGyro.std...Y for each activity performed by each subject  |
| avg_fBodyGyro.std...Z           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyGyro.std...Z for each activity performed by each subject  |
| avg_fBodyAccMag.std..           | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyAccMag.std.. for each activity performed by each subject  |
| avg_fBodyBodyAccJerkMag.std..   | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyBodyAccJerkMag.std.. for each activity performed by each subject  |
| avg_fBodyBodyGyroMag.std..      | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyBodyGyroMag.std.. for each activity performed by each subject  |
| avg_fBodyBodyGyroJerkMag.std..  | numeric       | radians/second  | normalized and bounded within [-1,1]  | average of fBodyBodyGyroJerkMag.std.. for each activity performed by each subject  |

#### Labels for "activity" Factor Variables in "ADL_cleanData_averages.txt":

| Activity                   | Factor        |
| -------------------------- | ------------- |
| WALKING                    | 1             |
| WALKING_UPSTAIRS           | 2             |
| WALKING_DOWNSTAIRS
         | 3             | 
| SITTING                    | 4             | 
| STANDING                   | 5             | 
| LAYING                     | 6             | 

### For more information, please see the README.md file or contact author at juliaphelps (at) gmail (dot) com.