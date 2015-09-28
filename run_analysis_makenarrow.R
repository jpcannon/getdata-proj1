######################################################################
##  Prog:  run_analysis.R
##  Author: Joe Cannon
##  Date:   09/21/2015
##  Description: This is an R program for taking the resulting table of run_analysis
##  and convert it to a NARROW dataset
######################################################################

library(dplyr)
library(tidyr)

widetab <- read.table(file="combined UCI HAR Dataset.txt",header=TRUE )
anglevars <- select(widetab, Subject,Activity, contains('angle'), 
                    -(contains('angle.X')),
                    -(contains('angle.Y')),
                    -(contains('angle.Z')))
angleDvars <- select(widetab, Subject,Activity,  
                     contains('angle.X'),
                     contains('angle.Y'),
                     contains('angle.Z'))
mainvars <-select(widetab, -(contains('angle')))
tv<-mainvars %>%
  gather(key, value, -Subject, -Activity) %>%
  separate(key, into = c("Feature", "Measure","Direction"), sep = "\\.") 

tq<-anglevars %>%
  gather(key, value, -Subject, -Activity) %>%
  separate(key, into = c("Direction","Feature", "Measure"), sep = "\\.")%>%
  select(Subject,Activity,Feature,Measure,Direction,value)

td<-angleDvars %>%
  gather(key, value, -Subject, -Activity) %>%
  separate(key, into = c("Feature", "Direction","Measure"), sep = "\\.")%>%
  select(Subject,Activity,Feature,Measure,Direction,value)

tt<-rbind(tv,tq,td)
ft<- spread(tt,Feature,value)
# Write out file
write.table(ft,file="combined UCI HAR Dataset Narrow.txt",row.names = FALSE)

########  All done :-)  #########
