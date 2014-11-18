## Read data and assign column names

features <- read.table("UCI HAR Dataset/features.txt", quote="\"")
colnames(features) <- c("feature_id","feature")

X_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"")
colnames(X_train) <- features$feature
  
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"")
colnames(X_test) <- features$feature

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"")
colnames(subject_train) <- c("subject_id")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"")
colnames(subject_test) <- c("subject_id")

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
colnames(y_train) <- c("activity_id")

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")
colnames(y_test) <- c("activity_id")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"")
colnames(activity_labels) <- c("activity_id", "activity")


## Merge the training and the test sets to create one data set.

X_train_cbind <- cbind(X_train, subject_train, y_train)
X_test_cbind <- cbind(X_test, subject_test, y_test)

X <- rbind(X_train_cbind, X_test_cbind)


## Extract only the measurements on the mean and standard deviation for each measurement. 

# the mean and standard deviation for each measurement
features_subset <- subset(features, grepl("mean()", feature, fixed=T) | grepl("std()", feature, fixed=T))

# we want to preserve the two last columns containing subject and activity id's
nColX <- ncol(X)
data <- X[,c(features_subset$feature_id, nColX-1, nColX)]


## Use descriptive activity names to name the activities in the data set

data <- merge(data, activity_labels, by = "activity_id")


## Appropriately label the data set with descriptive variable names. 

# done already


## Create an independent tidy data set with the average of each variable for each activity and each subject

# average of each variable for each activity and each subject
library(plyr)
avg <- ddply(data, .(subject_id, activity_id, activity), colwise(mean))

write.table(avg, file="data.txt", row.names=FALSE)

