## This R script will download into your working directory and clean up the UCI HAR Dataset.  
## The result of this script will be a 'tidy' dataset with the mean and std of the variables for 'mean()' and 'std()' events.
## It will also create a codebook with all of the variable names in the tidy dataset.
## This proceeds in 3 stages:
## Stage 1 will download all data, unzip into the working directory, and process the needed changes to the test set.  
## Stage 2 will process needed changes to the training set.
## Stage 3 will merge the data, make final changes, and saves the "tidy" dataset and a codebook to the working directory.

  ##Stage 1--Loads necessary libraries, downloads all the datafiles and unzip them into the current working directory, and cleans up the test set data.

library(reshape2)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(fileUrl, destfile = "./dataset.zip")  
unzip("./dataset.zip")   

activity_table <- read.table("./UCI HAR Dataset/activity_labels.txt") ##Read in the activity labels and rename the columns to make them more readable.
names(activity_table) <- c("Activity_Number", "Activity") 
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")   ##Read in the raw data from the test set, the feature labels, and include the names of the features into the test set.
features <- read.table("./UCI HAR Dataset/features.txt")
names(test_set) <- features$V2
good_columns <- grep("mean\\(|std\\(", features$V2)   ## identify unnecessary columns
test_set <- test_set[good_columns]
test_set_labels <- read.table("./UCI HAR Dataset/test/y_test.txt") ## reads in the activity codes for the test
names(test_set_labels) <- 'Activity_Number'
test_set <- cbind(test_set, test_set_labels)  ## add the activity numbers to the test set.
good_columns <- grep("mean\\(|std\\(", features$V2)
test_subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")  ## read in the subject activity code
names(test_subject_test) <- 'Subject_Number'
test_set <- cbind(test_set, test_subject_test)  ## add the subject test labels to the test_set data.
test_set <- merge(activity_table, test_set, by.x="Activity_Number", by.y="Activity_Number")  ## Replace the activity number with the character label.

  ## Stage 2, process changes to the training set.

training_set <- read.table("./UCI HAR Dataset/train/X_train.txt")   ##Read in the raw data from the training set, nd include the names of the features into the training set.
names(training_set) <- features$V2
good_columns <- grep("mean\\(|std\\(", features$V2)   ## identify unnecessary columns
training_set <- training_set[good_columns]
training_set_labels <- read.table("./UCI HAR Dataset/train/y_train.txt") ## reads in the activity codes for the training set.
names(training_set_labels) <- 'Activity_Number'
training_set <- cbind(training_set, training_set_labels)  ## add the activity labels to the training set.
training_subject_test <- read.table("./UCI HAR Dataset/train/subject_train.txt")  ## read in the subject number
names(training_subject_test) <- 'Subject_Number'
training_set <- cbind(training_set, training_subject_test)  ## add the subject test labels to the test_set data.
training_set <- merge(activity_table, training_set, by.x="Activity_Number", by.y="Activity_Number")  ## Replace the activity number with the character label.

  ##Stage 3, merge datasets, remove unnecessary columns, and improve labels.


tidy_data <- rbind(training_set, test_set)  ## merge datasets
tidy_data <- tidy_data[ ,2:69]  ## removes an unnecessary column
melt_tidy <- melt(tidy_data, id = c('Activity', 'Subject_Number')) #reshape and compute means
tidy_data <- dcast(melt_tidy, Activity + Subject_Number ~ variable, mean) #reshape and computes means


write.table(tidy_data, file="tidy_data.txt", quote=FALSE, row.names=FALSE, sep=",") ## save dataset

## save the list of variables as a codebook
write.table(names(tidy_data), file="CodeBook.md", quote=FALSE,
            row.names=FALSE, col.names=FALSE, sep="\t")

