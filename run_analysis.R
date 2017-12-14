
# 1. Merges the training and the test sets to create one data set.
#load data.table package
library(data.table)

#setwd
setwd("~Coursera/DataScience/Course3_GettingAndCleaningData/Week4/project")

#set data set files URLs
trainURL = "./UCI HAR Dataset/train/X_train.txt"
testURL = "./UCI HAR Dataset/test/X_test.txt"

#Read train and test data sets into data.tables
dt_train = fread(trainURL)
dt_test = fread(testURL)

#set subject file URLs
train_subjectURL = "./UCI HAR Dataset/train/subject_train.txt"
test_subjectURL = "./UCI HAR Dataset/test/subject_test.txt"

#Read subject files into data.tables
dt_subject_train = fread(train_subjectURL)
dt_subject_test = fread(test_subjectURL)

#set activity file URLs
train_activityURL = "./UCI HAR Dataset/train/y_train.txt"
test_activityURL = "./UCI HAR Dataset/test/y_test.txt"

#Put activity data into data.tables
dt_activity_train = fread(train_activityURL)
dt_activity_test = fread(test_activityURL)

#Merge subject tables
dt_subject = rbind(dt_subject_train, dt_subject_test)
#Rename header
setnames(dt_subject, "subject")

#Merge activity tables
dt_activity = rbind(dt_activity_train, dt_activity_test)
#Rename header
setnames(dt_activity, "activity")

#Merge training and test data sets
dt_traintest = rbind(dt_train, dt_test)

#Merge columns from subject and activity into subject data table
dt_subject = cbind(dt_subject, dt_activity)

#Now bring the subject columns to combined data table
dt_traintest = cbind(dt_subject, dt_traintest)
#Set the key to join later
setkey(dt_traintest, subject, activity)

#Free up memory
rm(dt_train)
rm(dt_test)
rm(dt_subject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#Read from features file to get which measurements are mean and std dev
dt_feature <- fread("./UCI HAR Dataset/features.txt")
#rename headers of dt_feature
setnames(dt_feature, names(dt_feature), c("featNum", "featVal"))
#subset by grepping only the mean and std dev obs.
dt_feature = dt_feature[grepl("mean\\(\\)|std\\(\\)", featVal)]

#Create featureVName to help switch to descriptive names from keys
dt_feature$featureVName = dt_feature[, paste0("V", featNum)]

#Now subset combining variable names
s = c(key(dt_traintest), dt_feature$featureVName)
dt = dt_traintest[, s, with=FALSE]

#Free up memory
rm(dt_traintest)

#Melt to transform data set by row for tidiness
dt = data.table(melt(dt, key(dt), variable.name = "featureVName"))

#Now join data set with only mean and std dev observations
#dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by = "featureCode", all.x = TRUE)
dt =  merge(dt, dt_feature[, list(featNum, featVal, featureVName)], by="featureVName", all.x = TRUE)

# 3. Uses descriptive activity names to name the activities in the data set
# Get activity_labels.txt
dt_activity_names = fread("./UCI HAR Dataset/activity_labels.txt")
setnames(dt_activity_names, names(dt_activity_names), c("activity", "activityName"))

# 4. Appropriately labels the data set with descriptive variable names.
#Now set the activity names
dt$activity <- as.character(dt$activity)
for (i in 1:6){
        dt$activity[dt$activity == i] <- as.character(dt_activity_names[i,2])
}
dt$activity <- as.factor(dt$activity)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dt_tidy = aggregate(dt[,4],list(activity=dt$activity, subject=dt$subject), mean)
setnames(dt_tidy, "value", "avg")
write.table(dt_tidy, file = "IndepTidyDS.txt", row.names = FALSE)
