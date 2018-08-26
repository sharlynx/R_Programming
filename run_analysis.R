library(plyr)

# download the data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile="Dataset.zip"
download.file(fileURL, destfile=zipfile, method="curl")

outDir <- "/Users/xieyin/Documents/19-R-coursera-Duke/3-Getting\ and\ Cleaning\ Data/W4"
unzip(zipfile, exdir = outDir )

# read data
training.x <- read.table("UCI HAR Dataset/train/X_train.txt")
training.y <- read.table("UCI HAR Dataset/train/y_train.txt")

test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("UCI HAR Dataset/test/y_test.txt")

subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# merge data
merge.x <- rbind(training.x, test.x)
merge.y <- rbind(training.y, test.y)
merge.subject <- rbind(subject.train, subject.test)


# extracts only the measurements on the mean and std deviation
features <- read.table("UCI HAR Dataset/features.txt")
# dim(features) check the dimension
# head(features) check the name with std and mean in it

features_mean_std <- grep("std|mean\\(\\)", features$V2)  # get the column number of features with std/mean in it, \\ is the symbol to escape special characters

# create a table with the features we want
x_extract <- merge.x[, features_mean_std]

# set the column names
names(x_extract) <- features[features_mean_std, 2]

# Use activity names to name the activities
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") # walking, walking_upstairs, ...

merge.y[, 1] <- activity_labels[merge.y[, 1], 2] # use the first column of merge.y，to match the index of activity_labels

# head(merge.y) check merge.y
names(merge.y) <- "activity"

# label the data set with descriptive variable names
names(merge.subject) <- "subject" 

# bind data into a single data table
all_data <- cbind(x_extract, merge.y, merge.subject)

# from the data set above, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

tidy <- ddply(.data = all_data, .variables = c("subject", "activity"), .fun = numcolwise(mean))
write.table(tidy, "tidy.txt", row.names = FALSE)
