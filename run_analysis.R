
## Download,unzip and read relevent files 
urlfile="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(getwd(), "Dataset.zip")
download.file(urlfile, f)
unzip(f)


## Read Activity tables for train and test 
ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

## Read Subject tables for train and test 
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)


## Read Feature tables for train and test 
FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

 ## Merging Activity, Subject and Features into one single data set
ActivityAll<- rbind(ActivityTrain, ActivityTest)
SubjectAll <- rbind(SubjectTrain, SubjectTest)
FeaturesAll<- rbind(FeaturesTrain, FeaturesTest)

names(SubjectAll)<-c("subject")
names(ActivityAll)<- c("activity")
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
Subj_Act <- cbind(SubjectAll, ActivityAll)
Data_All <- cbind(FeaturesAll, Subj_Act)

##Extracting mean and standard deviation 

SubSet_Featurenames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
Sub_selected<-c(as.character(SubSet_Featurenames), "subject", "activity" )

Data_Final=subset(Data_All,select=Sub_selected)

##Harness descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

Data_Final$activity<-factor(Data_Final$activity);
Data_Final$activity<- factor(Data_Final$activity,labels=as.character(activityLabels$V2))

## Appropriately labels the data set with descriptive variable names, as follows :



#- prefix t  is replaced by  time
#- Acc is replaced by Accelerometer
#- Gyro is replaced by Gyroscope
#- prefix f is replaced by frequency
#- Mag is replaced by Magnitude
#- BodyBody is replaced by Body

names(Data_Final)<-gsub("^t", "time", names(Data_Final))
names(Data_Final)<-gsub("^f", "frequency", names(Data_Final))
names(Data_Final)<-gsub("Acc", "Accelerometer", names(Data_Final))
names(Data_Final)<-gsub("Gyro", "Gyroscope", names(Data_Final))
names(Data_Final)<-gsub("Mag", "Magnitude", names(Data_Final))
names(Data_Final)<-gsub("BodyBody", "Body", names(Data_Final))

## Creates a second,independent tidy data set and data are extracted into tidydata.txt file 

library(plyr);

Data2<-aggregate(. ~subject + activity, Data_Final, mean)
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
