#Download files
dir.create("C:/Users/Dan/Documents/Coursera/Getting and Cleaning Data/Week4")
setwd("C:/Users/Dan/Documents/Coursera/Getting and Cleaning Data/Week4")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Data.zip")
unzip("Data.zip",exdir="Data")
setwd("C:/Users/Dan/Documents/Coursera/Getting and Cleaning Data/Week4/Data/UCI HAR Dataset")

#############################################################################################
#############################################################################################

#Read in feature names used to give names to X_train and X_test
features<-read.table("features.txt",col.names = c("Feature_Number","Feature_Name"))
head(features)
#Read in activity labels for labelling y_train and y_test
activity_labels<-read.table("activity_labels.txt",col.names = c("Activity_Number","Activity_Name"))

#############################################################################################
#############################################################################################

#Read in training data
#Read in Subject_Number data
Subject_Number_train<-read.table("train/subject_train.txt",col.names = "Subject_Number")

#Read in features data
X_train<-read.table("train/X_train.txt",col.names = features$Feature_Name)

#Read in activity data
y_train<-read.table("train/y_train.txt")
y_train<-read.table("train/y_train.txt",col.names = "Activity_Number")
#Create a column Activity Name Column
y_train2<-merge(y_train,activity_labels,by.x="Activity_Number",by.y="Activity_Number",all.x=T)
names(y_train2)

#Create full train Dataset by column binding
train<-cbind(Subject_Number_train,X_train,y_train2)

#############################################################################################
#############################################################################################

#Read in testing data
#Read in Subject_Number data
Subject_Number_test<-read.table("test/subject_test.txt",col.names = "Subject_Number")

#Read in features data
X_test<-read.table("test/X_test.txt",col.names = features$Feature_Name)

#Read in activity data
y_test<-read.table("test/y_test.txt")
y_test<-read.table("test/y_test.txt",col.names = "Activity_Number")
#Create a column Activity Name Column
y_test2<-merge(y_test,activity_labels,by.x="Activity_Number",by.y="Activity_Number",all.x=T)
names(y_test2)

#Create full test Dataset by column binding
test<-cbind(Subject_Number_test,X_test,y_test2)


full<-rbind(train,test)
dim(full)

#Create a vector of column names to keep using the grep function to match mean and std
keep_columns<-c("Subject_Number","Activity_Number","Activity_Name",grep(".mean",names(full),value=T),grep(".std",names(full),value=T))
length(keep_columns)

#Create dataset with Subject_Number,Activity_Number, Activity_Name and measurement mean and std 
full2<-full[,keep_columns]

table(full2$Subject_Number)
full2%>%filter(Subject_Number==1,Activity_Name==1)
class(full2$Activity_Name)
#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################

#For part 5 I wasn't sure if the question was asking for the two way split or both 1 way so I
#have produced both in different datasets
#Split data by subject
split_subject_activity<-split(full2,list(full2$Subject_Number,full2$Activity_Number))

split_subject_activity[[1]]
#Summarise subject
split_subject_activity_summarised<-sapply(split_subject_activity, function(x){
    #Remove non mean/std columns
    y<-x[,-c(1:3)]
    #Calculate mean of remaining columns
    sapply(y,mean)
})
#Transpose output and update row labels
split_subject_activity_summarised<-(t(split_subject_activity_summarised))
dim(split_subject_activity_summarised)
row.names(split_subject_activity_summarised)<-paste0("Subject",rep(1:30,6),rep(activity_labels$Activity_Name,30))

#Return final dataset as a dataframe
split_subject_activity_summarised<-as.data.frame(split_subject_activity_summarised)

#############################################################################################
#############################################################################################
#############################################################################################
#############################################################################################


#Split data by subject
split_subject<-split(full2,c(full2$Subject_Number))

#Summarise subject
split_subject_summarised<-sapply(split_subject, function(x){
    #Remove non mean/std columns
    y<-x[,-c(1:3)]
    #Calculate mean of remaining columns
    sapply(y,mean)
})
#Transpose output for rbinding to activities and update row labels
split_subject_summarised<-(t(split_subject_summarised))
row.names(split_subject_summarised)<-paste0("Subject",c(1:30))

#############################################################################################
#############################################################################################


#Split data by activity
split_activity<-split(full2,c(full2$Activity_Name))

#Summarise subject
split_activity_summarised<-sapply(split_activity, function(x){
    #Remove non mean/std columns
    y<-x[,-c(1:3)]
    #Calculate mean of remaining columns
    sapply(y,mean)
})
#Transpose output for rbinding to activities and update row labels
split_activity_summarised<-(t(split_activity_summarised))
row.names(split_activity_summarised)<-activity_labels$Activity_Name
    
#############################################################################################
#############################################################################################
#Create final summarised dataset
full_summarised<-as.data.frame( rbind(split_subject_summarised,split_activity_summarised))

   

