######################################################################
##  Prog:  run_analysis.R
##  Author: Joe Cannon
##  Date:   09/21/2015
##  Description: This is an R program for taking measurments from training and test
##  datasets, 
##    cleaning the headers          
##    adding headers
##    combining them
##    adding subject and activity columns
##    selecting only the mean and std columns
##    writing the cleaned dataset to a new file
######################################################################
library(dplyr)

# Read in Column names
col_names <-read.table(file=".\\UCI HAR Dataset\\features.txt")

# Clean them up
col_names[,2] <- gsub("\\(\\)", " ", col_names[,2])
col_names[,2] <- gsub("\\(", " ", col_names[,2])
col_names[,2] <- gsub("\\)", " ", col_names[,2])
col_names[,2] <- gsub("\\,", " ", col_names[,2])
col_names[,2] <- gsub("\\-", " ", col_names[,2])
col_names[,2] <- trimws(col_names[,2])
col_names[,2] <- gsub(" ", ".", col_names[,2])
col_names[,2] <- gsub("..", ".", col_names[,2], fixed = TRUE)

# Read in the activity types
activities <-read.table(file=".\\UCI HAR Dataset\\activity_labels.txt")
colnames(activities) <- c("Activity_Code","Activity")



# Read in test data
test_data <- read.table(file=".\\UCI HAR Dataset\\test\\X_test.txt")
test_subject <-read.table(file=".\\UCI HAR Dataset\\test\\subject_test.txt")
test_activity <-read.table(file=".\\UCI HAR Dataset\\test\\y_test.txt")

# Add column names
colnames(test_data) <-col_names[,2]
colnames(test_subject) <- c("Subject")
colnames(test_activity) <- c("Activity_Code")

# combine the files
test_data <-cbind(test_subject,test_activity,test_data)


# Read in training data
train_data <- read.table(file=".\\UCI HAR Dataset\\train\\x_train.txt")
train_subject <-read.table(file=".\\UCI HAR Dataset\\train\\subject_train.txt")
train_activity <-read.table(file=".\\UCI HAR Dataset\\train\\y_train.txt")

# Add column names
colnames(train_data) <-col_names[,2]
colnames(train_subject) <- c("Subject")
colnames(train_activity) <- c("Activity_Code")

# combine files
train_data <-cbind(train_subject,train_activity,train_data)

# Put Test and Training datasets together
full_data <- rbind(test_data,train_data)

# remove duplicate columns
full_data <- full_data[ , !duplicated(colnames(full_data))]

#select only the columns that we want
mean_data <- select(full_data,contains("Subject",ignore.case=TRUE),
                    contains("Activity",ignore.case=TRUE),
                    contains("mean",ignore.case=TRUE),
                    contains("std",ignore.case=TRUE))

# Replace Activity code with Activity name
for(i in 1:nrow(mean_data)) {
  mean_data[i,"Activity"] <- activities[mean_data[i,]$Activity_Code,"Activity"]
}

# Loose Activity_code and move Activity to 2nd column
final <- select(mean_data,1,Activity,4:ncol(mean_data)-1)

# Write out file
write.csv(final,file="combined UCI HAR Dataset.csv",row.names = FALSE)

########  All done :-)  #########
