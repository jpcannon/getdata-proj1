#Code Book for Getting Data Project 1
##Information from original dataset. This has been abreviated to only include relevant information of the post processed data.

##Original file definition
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation onent with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

##Processing the data
The initial dataset was processed using 'run_analysis.r'. The output from the R process is 'combined UCI HAR Dataset.txt'
The dataset was left in a WIDE format specifically. I don't believe that this violates the tidy rules
#####Note: I use different variables for each step. This was to allow checking of the changes made on each step. You may want to use reuse variables on some of these steps to reduce memory footprint.

1.) Read in the features that will serve as column names on the final set
```r
Read the files
# Read in Column names
col_names <-read.table(file=".\\UCI HAR Dataset\\features.txt")
```
This will have the original names
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
4  4  tBodyAcc-std()-X
5  5  tBodyAcc-std()-Y
6  6  tBodyAcc-std()-Z

2.) Clean up the feature names
```
# Clean them up
col_names[,2] <- gsub("\\(\\)", " ", col_names[,2])
col_names[,2] <- gsub("\\(", " ", col_names[,2])
col_names[,2] <- gsub("\\)", " ", col_names[,2])
col_names[,2] <- gsub("\\,", " ", col_names[,2])
col_names[,2] <- gsub("\\-", " ", col_names[,2])
col_names[,2] <- trimws(col_names[,2])
col_names[,2] <- gsub(" ", ".", col_names[,2])
col_names[,2] <- gsub("..", ".", col_names[,2], fixed = TRUE)
```
This will produce R friendly column names
```
V1              V2
1  1 tBodyAcc.mean.X
2  2 tBodyAcc.mean.Y
3  3 tBodyAcc.mean.Z
4  4  tBodyAcc.std.X
5  5  tBodyAcc.std.Y
6  6  tBodyAcc.std.Z
```
3.) Read in Activity names and codes s
```
# Read in the activity types
activities <-read.table(file=".\\UCI HAR Dataset\\activity_labels.txt")
colnames(activities) <- c("Activity_Code","Activity")
```
This will contain
```
  Activity_Code           Activity
  1             1            WALKING
  2             2   WALKING_UPSTAIRS
  3             3 WALKING_DOWNSTAIRS
  4             4            SITTING
  5             5           STANDING
  6             6             LAYING
```
4.) Read in the Test data and add Subject and Activity_Code columns
```
# Read in test data
test_data <- read.table(file=".\\UCI HAR Dataset\\test\\X_test.txt")
test_subject <-read.table(file=".\\UCI HAR Dataset\\test\\subject_test.txt")
test_activity <-read.table(file=".\\UCI HAR Dataset\\test\\y_test.txt")

# Add column names
colnames(test_data) <-col_names[,2]
colnames(test_subject) <- c("Subject")
colnames(test_activity) <- c("Activity_Code")
```
5.) Combine the Subject, Activity ,and Data datasets
```
# combine the files
test_data <-cbind(test_subject,test_activity,test_data)
```
The first 5 cols of the result should look like this
```
  Subject Activity_Code tBodyAcc.mean.X tBodyAcc.mean.Y tBodyAcc.mean.Z
1       2             5       0.2571778     -0.02328523     -0.01465376
2       2             5       0.2860267     -0.01316336     -0.11908252
3       2             5       0.2754848     -0.02605042     -0.11815167
4       2             5       0.2702982     -0.03261387     -0.11752018
5       2             5       0.2748330     -0.02784779     -0.12952716
6       2             5       0.2792199     -0.01862040     -0.11390197
```

6.) Do Set 4 & 5 with Training datasets 
```
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
```
7.) Combine Test and Training datasets
```
# Put Test and Training datasets together
full_data <- rbind(test_data,train_data)
```
At this point you should have 10299 rows and 563 columns

8.) Remove duplicates created from cleaning column names. These columns are not needed in the final dataset
```
# remove duplicate columns
full_data <- full_data[ , !duplicated(colnames(full_data))]
```
9.) Select the columns that are either Mean or Std features
```
#select only the columns that we want
mean_data <- select(full_data,contains("Subject",ignore.case=TRUE),
                    contains("Activity",ignore.case=TRUE),
                    contains("mean",ignore.case=TRUE),
                    contains("std",ignore.case=TRUE))
```                    
Now you should be down to 89 columns

10.) Add Activity Name, reorder results without Activity_Code

```
# Replace Activity code with Activity name
for(i in 1:nrow(mean_data)) {
  mean_data[i,"Activity"] <- activities[mean_data[i,]$Activity_Code,"Activity"]
}

# Loose Activity_code and move Activity to 2nd column
select_data <- select(mean_data,1,Activity,4:ncol(mean_data)-1)
```
Now the first 5 columns of your dataset should look like
```
   Subject Activity tBodyAcc.mean.X tBodyAcc.mean.Y tBodyAcc.mean.Z
30       2 STANDING       0.2883747    -0.008547660     -0.10705876
31       2 STANDING       0.2859050    -0.007744730     -0.10273652
32       2  SITTING       0.2964871    -0.014684879     -0.13980848
33       2  SITTING       0.2772354    -0.025677001     -0.11843072
34       2  SITTING       0.2782907    -0.014536086     -0.10524253
35       2  SITTING       0.2781599    -0.007667826     -0.09927102
```
#####Note: I printed rows 30-35 so that you can see some different Activities

11.) Reduce data to the Average of Subject by Activity 
```
# Average all the data for a given Subject and Activity
final <- select_data %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
```
At this point you should have 88 columns and 180 rows

12.) Final step is write out dataset named "combined UCI HAR Dataset.txt"
```
# Write out file
write.table(final,file="combined UCI HAR Dataset.txt",row.names = FALSE)
```

## Definition of 'combined UCI HAR Dataset.txt'

###Columns in code:
Subject:            The numeric representation of the subject being measured                            
Activity:           The activity occuring during measurment
##Measurment names include measurment type:
mean,std,meanFreq,gravityMean,gravity (NOTE: gravity in and of itself is neither a std or mean measurement, however in our
case it is attached to a tBodyAccMean measurement so I included it.

Measurment names may also include a directional component( X, Y, Z ). 
Usually it is at the end of the variable name, with the exception of the angle variable where it is between the measurment description and the measurment type.
All variables have been summated as an average of the Subject and Activity.

Name						    | Description
--------------------------------|--------------------
tBodyAcc.mean.X					| Body Acceleration Mean of X direction                
tBodyAcc.mean.Y                 | Body Acceleration Mean of Y direction                    
tBodyAcc.mean.Z                 | Body Acceleration Mean of Z direction                    
tGravityAcc.mean.X              | Gravity Acceleration Mean of X direction                       
tGravityAcc.mean.Y              | Gravity Acceleration Mean of Y direction                        
tGravityAcc.mean.Z              | Gravity Acceleration Mean of Z direction                        
tBodyAccJerk.mean.X             | Body Acceleration Jerk Mean of X direction
tBodyAccJerk.mean.Y             | Body Acceleration Jerk Mean of Y direction    
tBodyAccJerk.mean.Z             | Body Acceleration Jerk Mean of Z direction
tBodyGyro.mean.X                | Body Gyro Mean of X direction   
tBodyGyro.mean.Y                | Body Gyro Mean of Y direction      
tBodyGyro.mean.Z                | Body Gyro Mean of Z direction      
tBodyGyroJerk.mean.X            | Body Gyro Jerk Mean of X direction     
tBodyGyroJerk.mean.Y            | Body Gyro Jerk Mean of Y direction     
tBodyGyroJerk.mean.Z            | Body Gyro Jerk Mean of Z direction     
tBodyAccMag.mean                | Body Acceleration Magnitude Mean    
tGravityAccMag.mean             | Gravity Acceleration Magnitude Mean   
tBodyAccJerkMag.mean            | Body Acceleration Jerk Magnitude Mean    
tBodyGyroMag.mean               | Body Gyro Magnitude Mean  
tBodyGyroJerkMag.mean           | Body Gyro Jerk Magnitude Mean
fBodyAcc.mean.X                 | Body Acceleration Mean of X direction 
fBodyAcc.mean.Y                 | Body Acceleration Mean of Y direction    
fBodyAcc.mean.Z                 | Body Acceleration Mean of Z direction     
fBodyAcc.meanFreq.X             | Body Acceleration Mean Frequency of X direction     
fBodyAcc.meanFreq.Y             | Body Acceleration Mean Frequency of Y direction    
fBodyAcc.meanFreq.Z             | Body Acceleration Mean Frequency of Z direction     
fBodyAccJerk.mean.X             | Body Acceleration Jerk Mean of X direction     
fBodyAccJerk.mean.Y             | Body Acceleration Jerk Mean of Y direction   
fBodyAccJerk.mean.Z             | Body Acceleration Jerk Mean of Z direction    
fBodyAccJerk.meanFreq.X         | Body Acceleration Jerk Mean Frequency of X direction     
fBodyAccJerk.meanFreq.Y         | Body Acceleration Jerk Mean Frequency of Y direction    
fBodyAccJerk.meanFreq.Z         | Body Acceleration Jerk Mean Frequency of Z direction     
fBodyGyro.mean.X                | Body Gyro Mean of X direction
fBodyGyro.mean.Y                | Body Gyro Mean of Y direction   
fBodyGyro.mean.Z                | Body Gyro Mean of Z direction    
fBodyGyro.meanFreq.X            | Body Gyro Mean Frequency of X direction    
fBodyGyro.meanFreq.Y            | Body Gyro Mean Frequency of Y direction     
fBodyGyro.meanFreq.Z            | Body Gyro Mean Frequency of Z direction     
fBodyAccMag.mean                | Body Acceleration Magnitude Mean 
fBodyAccMag.meanFreq            | Body Acceleration Magnitude   
fBodyBodyAccJerkMag.mean        | Body Body Acceleration Jerk Magnitude Mean    
fBodyBodyAccJerkMag.meanFreq    | Body Body Acceleration Jerk Magnitude Mean Frequency    
fBodyBodyGyroMag.mean           | Body Body Gyro Magnitude Mean   
fBodyBodyGyroMag.meanFreq       | Body Body Gyro Magnitude Mean Frequency    
fBodyBodyGyroJerkMag.mean       | Body Body Gyro Jerk Magnitude Magnitude    
fBodyBodyGyroJerkMag.meanFreq   | Body Body Gyro Jerk Magnitude Mean Frequency

  
####Additional vectors were obtained by averaging the signals in a signal window sample. 
####These are used on the angle() variable. Angle Variables are generalized

Name						    	  | Description
--------------------------------------|--------------------
angle.tBodyAccMean.gravity   		  | Angle Body Acceleration Mean of Gravity
angle.tBodyAccJerkMean.gravityMean 	  | Angle Body Acceleration Jerk Mean of Gravity
angle.tBodyGyroMean.gravityMean       | Angle Body Gyro Mean of Mean of Gravity Mean
angle.tBodyGyroJerkMean.gravityMean   |	Angle Body Gyro Jerk Mean of Gravity Mean
angle.X.gravityMean					  | Angle Gravity of Mean in X direction
angle.Y.gravityMean            		  | Angle Gravity of Mean in Y direction    
angle.Z.gravityMean                   | Angle Gravity of Mean in Z direction

#### End of Angled Veriables            


Name						    | Description
--------------------------------|--------------------
tBodyAcc.std.X                  | Body Acceleration Standard Deviation of X    
tBodyAcc.std.Y                  | Body Acceleration Standard Deviation of Y      
tBodyAcc.std.Z					| Body Acceleration Standard Deviation of Z  
tGravityAcc.std.X               | Gravity Acceleration Standard Deviation of X      
tGravityAcc.std.Y               | Gravity Acceleration Standard Deviation of Y         
tGravityAcc.std.Z               | Gravity Acceleration Standard Deviation of Z          
tBodyAccJerk.std.X              | Body Acceleration Jerk Standard Deviation of X          
tBodyAccJerk.std.Y              | Body Acceleration Jerk Standard Deviation of Y             
tBodyAccJerk.std.Z              | Body Acceleration Jerk Standard Deviation of Z              
tBodyGyro.std.X                 | Body Gyro Standard Deviation of X              
tBodyGyro.std.Y                 | Body Gyro Standard Deviation of Y                 
tBodyGyro.std.Z                 | Body Gyro Standard Deviation of Z                  
tBodyGyroJerk.std.X             | Body Gyro Jerk Standard Deviation of X                  
tBodyGyroJerk.std.Y             | Body Gyro Jerk Standard Deviation of Y                     
tBodyGyroJerk.std.Z             | Body Gyro Jerk Standard Deviation of Z                      
tBodyAccMag.std                 | Body Acceleration Standard Deviation
tGravityAccMag.std              | Gravity Acceleration Magnitude Standard Deviation   
tBodyAccJerkMag.std             | Body Acceleration Jerk Magnitude Standard Deviation   
tBodyGyroMag.std                | Body Gyro Magnitude Standard Deviation    
tBodyGyroJerkMag.std            | Body Gyro Jerk Magnitude Standard Deviation   
fBodyAcc.std.X                  | Body Acceleration Standard Deviation of X    
fBodyAcc.std.Y                  | Body Acceleration Standard Deviation of Y     
fBodyAcc.std.Z                  | Body Acceleration Standard Deviation of Z   
fBodyAccJerk.std.X              | Body Acceleration Jerk Standard Deviation of X    
fBodyAccJerk.std.Y              | Body Acceleration Jerk Standard Deviation of Y    
fBodyAccJerk.std.Z              | Body Acceleration Jerk Standard Deviation of Z   
fBodyGyro.std.X                 | Body Gyro Standard Deviation of X   
fBodyGyro.std.Y                 | Body Gyro Standard Deviation of Y    
fBodyGyro.std.Z                 | Body Gyro Standard Deviation of Z   
fBodyAccMag.std                 | Body Acceleration Magnitude Standard Deviation    
fBodyBodyAccJerkMag.std         | Body Body Acceleration Jerk Magnitude Standard Deviation    
fBodyBodyGyroMag.std            | Body Body Gyro Magnitude Standard Deviation   
fBodyBodyGyroJerkMag.std        | Body Body Gyro Jerk Magnitude Standard Deviation

#### End of Variables             


