library(dplyr)

#reading the data:
activities_labels <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))
features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", col.names = c("id","features"))
subject_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", col.names = features$features)
y_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", col.names = features$features)
y_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "code")

#1.Merges the training and the test sets to create one data set:
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)
all_merged <- cbind(x_merged,y_merged,subject_merged)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
dataset <- select(all_merged,subject, code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set
dataset$code <- activities_labels[dataset$code, 2]

#4. Appropriately labels the data set with descriptive variable names. 
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))

names(dataset)[2] = "activity"
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dataset_2 <- dataset %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
