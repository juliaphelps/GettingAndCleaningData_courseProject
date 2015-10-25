## This script was written on a Windows 8 machine using R Studio v3.2.2.

## To run this script, simply execute the command "run_analysis()".  The
## script will do the rest!

## Note:  depending on your machine, you may need to modify the mode in
## download.file() to work with your operating system (e.g. possibly
## replace mode="wb" with method="curl" on Mac).



run_analysis <- function(){
    
    if(require("dplyr")){
        print("dplyr package is loaded")
    } else {
        print("attempting to install dplyr package")
        install.packages("dplyr")
        if(require("dplyr")){
            print("dplyr package installed and loaded")
        } else {
            stop("Error:  unable to install dplyr packages")
        }
    }
    
    if(!file.exists("./UCIData")){dir.create("./UCIData")}
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(url, destfile = "./UCIData/ADLdata.zip", mode="wb")
    unzip("./UCIData/ADLdata.zip", exdir = "./UCIData")
    
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
    
    avg_data <- as.data.frame(all_data %>% group_by(subjectID, activity) %>% summarize_each(funs(mean)))
    avg_names <- colnames(avg_data[,3:68])
    avg_names <- paste("avg", avg_names, sep="_")
    colnames(avg_data) <- c("subjectID", "activity", avg_names)
    
    if(!file.exists("./UCIData/clean_data")){dir.create("./UCIData/clean_data")}
    write.table(all_data, file="./UCIData/clean_data/ADL_cleanData.txt", row.names = FALSE)
    write.table(avg_data, file="./UCIData/clean_data/ADL_cleanData_averages.txt", row.names = FALSE)
    
    loc1 <- "./UCIData/clean_data/ADL_cleanData.txt"
    loc2 <- "./UCIData/clean_data/ADL_cleanData_averages.txt"
    return(cat("cleaning/summarization process is complete.

    full tidy dataset written to:
    ",dQuote(loc1),"

    summarized tidy dataset written to:
    ",dQuote(loc2),"

    to read into R for further analysis, use read.table() with header=TRUE"))

}

## All done!  Hooray!