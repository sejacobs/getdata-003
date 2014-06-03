 The R script run_analysis.R will download the data into your working directory and clean up the UCI HAR Dataset.  
 The result of this script will be a 'tidy' dataset with the mean and std of the variables for 'mean()' and 'std()' events 
 by activity and subject number.  
 The script will save this file to your working directory, and it will also save a codebook with all of the variable names in the tidy dataset.
 
 This proceeds in 3 stages:
 
 Stage 1 will download all data, unzip into the working directory, and process the needed changes to the test set.  
 Stage 2 will process needed changes to the training set.
 Stage 3 will merge the data, make final changes, and saves the "tidy" dataset and a codebook to the working directory.
