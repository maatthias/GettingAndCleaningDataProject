# CodeBook

## Here is my code book that describes the variables, the data, and transformations performed to clean up the data within run_analysis.R

### Variables
- trainURL | File Path for the training data
- testURL | File Path for the testing data
- df_train | var for training table 
- df_test | var for testing table
- dt_train | var for training data table
- dt_test | var for testing  data table
- train_subjectURL | File Path for the subject training data
- test_subjectURL | File Path for the subject testing data
- df_subject_train | var for subject training table
- df_subject_test | var for subject testing table
- dt_subject_train | var for subject testing data table
- dt_subject_test | var for subject testing data table
- train_activityURL | File path for the training activity file
- test_activityURL | File path for the testing activity file
- df_activity_train | var for activity training table
- df_activity_test | var for activity testing table
- dt_activity_train | var for activity training data table
- dt_activity_test | var for activity testing data table
- dt_feature | var to read features.txt into
- dt | merged training and test data tables

### Data
- There are 3 logical sets of data.  The subject, activity and the actual data recorded.
- These are identified by data tables above by convention dt_xxxxx.

### Transformations (see code comment for specific executions of each step)
- Step 1 is to merge these 3 logical sets
- Step 2 is to extract only std dev and mean from the merged data set
- Step 3 is to change the default activity identifiers (e.g., 1-6) to meaningful values (e.g., "WALKING")
- Step 4 is to label data set variables (e.g., "fBodyAccMag") with descriptive variable names
