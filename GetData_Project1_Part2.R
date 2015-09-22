

#mean_data$Activity <- activities[match(activities$Activity_Code,mean_data$Activity_Code),"Activity"] 

#sum_data <- mean_data %>% group_by(Subject,Activity_Code) %>% summarise_each(funs(mean))

#sum_data$Activity <- activities[match(activities$Activity_Code,sum_data$Activity_Code),"Activity"] 

#final <- select(sum_data,1:2,Activity,3:ncol(sum_data)-1)

features <-data.frame(Feature=character())
n <-ncol(sum_data)
for(i in 1:n ){
  mystr <- strsplit(names(sum_data[,i]),"-")
  q <-lapply(mystr,"[[",1)
  t<- data.frame(Feature=as.character(q[1]))
  activities<- rbind(features,t)  
} 

