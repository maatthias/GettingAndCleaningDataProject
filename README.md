# GettingAndCleaningDataProject
Submitted project for Getting and Cleaning Data

See CodeBook.md for descriptions of variables.  Below is summation of the data and transformations.
run_analysis.R is the commented R execution script.

Preliminary setup loads data.table library and reads subject, activity and actual measurement data sets.  

Once subject data training and test data sets are merged they are column combined (cbind) with the measurements (dt_traintest).

The features that are mean and std dev measurements are grepped out of dt_feature then are joined with the measurements via merge.

Then the activity variables are given meaningful names by looking them up in dt_activity_names.

Finally, a tidy set is created to satisfy Step 5 by using aggregate function of data.table.
