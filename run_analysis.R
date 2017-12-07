
# 1. Merges the training and the test sets to create one data set.
#load data.table package
library(data.table)

#setwd
setwd("C:/Users/msnyder/OneDrive - Rainforest Alliance/Mgmt/Training/Coursera/DataScience/Course3_GettingAndCleaningData/Week4/project")

#set data set files URLs
trainURL = "./UCI HAR Dataset/train/X_train.txt"
testURL = "./UCI HAR Dataset/test/X_test.txt"

#Set data tables for training and test data
df_train = read.table(trainURL)
df_test = read.table(testURL)

dt_train = data.table(df_train)
dt_test = data.table(df_test)

#set subject file URLs
train_subjectURL = "./UCI HAR Dataset/train/subject_train.txt"
test_subjectURL = "./UCI HAR Dataset/test/subject_test.txt"

#Set data tables for subject files
df_subject_train = read.table(train_subjectURL)
df_subject_test = read.table(test_subjectURL)

dt_subject_train = data.table(df_subject_train)
dt_subject_test = data.table(df_subject_test)

#set activity file URLs
train_activityURL = "./UCI HAR Dataset/train/y_train.txt"
test_activityURL = "./UCI HAR Dataset/test/y_test.txt"

#Set data tables for activity files
df_activity_train = read.table(train_activityURL)
df_activity_test = read.table(test_activityURL)

dt_activity_train = data.table(df_activity_train)
dt_activity_test = data.table(df_activity_test)

#Merge subject tables
dt_subject = rbind(dt_subject_train, dt_subject_test)
#Set name for subject data table
setnames(dt_subject, "subject")

#Merge activity tables
dt_activity = rbind(dt_activity_train, dt_activity_test)
#Set name for activity data table
setnames(dt_activity, "activity")

#Merge training and test data sets
dt_traintest = rbind(dt_train, dt_test)

#Free up memory
rm(dt_train)
rm(df_train)

#Merge columns from subject and activity into subject data table
dt_subject = cbind(dt_subject, dt_activity)

#Now merge ALL columns
dt_traintest = cbind(dt_subject, dt_traintest)
#Set the key to join
setkey(dt_traintest, "subject", "activity")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#Read from features file to get which measurements are mean and std dev
dt_feature <- fread("./UCI HAR Dataset/features.txt")
setnames(dt_feature, names(dt_feature), c("featKey", "featVal"))
#subset by grepping only the mean and std dev obs.
dt_feature = dt_feature[grepl("mean\\(\\)|std\\(\\)", featVal)]

#Switch to descriptive names from keys
dt_feature$featureKey = dt_feature[, paste0("V", featKey)]

#Now subset using variable names
s = c(key(dt_traintest), dt_feature$featureKey)
dt = dt_traintest[, s, with=FALSE]

# 3. Uses descriptive activity names to name the activities in the data set
# Get activity_labels.txt
dt_activity_names = fread("./UCI HAR Dataset/activity_labels.txt")
setnames(dt_activity_names, names(dt_activity_names), c("activityNum", "activityName"))

# 4. Appropriately labels the data set with descriptive variable names.
#Now set the activity names
dt$activity <- as.character(dt$activity)
for (i in 1:6){
        dt$activity[dt$activity == i] <- as.character(dt_activity_names[i,2])
}
dt$activity <- as.factor(dt$activity)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(dt, file = "IndepTidyDS.txt", row.names = FALSE)
