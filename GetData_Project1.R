library(dplyr)
library(sqldf)
library(tcltk)
test_data <- read.table(file=".\\UCI HAR Dataset\\test\\X_test.txt")
col_names <-read.table(file=".\\UCI HAR Dataset\\features.txt")
test_subject <-read.table(file=".\\UCI HAR Dataset\\test\\subject_test.txt")
test_activity <-read.table(file=".\\UCI HAR Dataset\\test\\y_test.txt")


colnames(test_data) <-col_names[,2]
colnames(test_subject) <- c("Subject")
colnames(test_activity) <- c("Activity")

test_data <-cbind(test_subject,test_activity,test_data)


train_data <- read.table(file=".\\UCI HAR Dataset\\train\\x_train.txt")
train_subject <-read.table(file=".\\UCI HAR Dataset\\train\\subject_train.txt")
train_activity <-read.table(file=".\\UCI HAR Dataset\\train\\y_train.txt")

colnames(train_data) <-col_names[,2]
colnames(train_subject) <- c("Subject")
colnames(train_activity) <- c("Activity")

train_data <-cbind(train_subject,train_activity,train_data)

full_data <- rbind(test_data,train_data)

full_data <- full_data[ , !duplicated(colnames(full_data))]
mean_data <- select(full_data,contains("Subject",ignore.case=TRUE), contains("mean",ignore.case=TRUE),contains("std",ignore.case=TRUE))
sum_data <- mean_data %>% group_by(Subject) %>% summarise_each(funs(mean))
activities <-data.frame(Activity=character())
n <-ncol(sum_data)
for(i in 1:n ){
     mystr <- strsplit(names(sum_data[,i]),"-")
     q <-lapply(mystr,"[[",1)
     t<- data.frame(Activity=as.character(q[1]))
    activities<- rbind(activities,t)  
} 


