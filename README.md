CleaningDataCourseProject
=========================

###Course Project for Coursera Data Science Specialization : Getting and Cleaning Data
This project is part of the [Getting and Cleaning Data Course](https://www.coursera.org/course/getdata) from [Coursera](www.coursera.org).

###Data Description.

This project extracts a subset of Samsung Galaxy S Intertial Measurements and creates a tidy summary of the data.
The [course data](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) is part of the UCI Machine Learning Repository. The 
description of the data can be obtained [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

###Script Description

The main script for this project [run_analysis.R](https://github.com/MattLWhitaker/CleaningDataCourseProject/blob/master/run_analysis.R)
As written it assumes that the script is in a folder with the test and training folders in subfolders (test and train). The files with the
activity labels and the field descriptors are assumed to be in the same folder as the the script. These are easily changed in the data sources
section of the script.

The script has three main sections:

#### Data Sources

This section lists the folders and file names to run the script. Edit these if the data is not in the default location.

    *test data
        -TEST_FOLDER: Folder relative to the current folder holding the test data
        -TEST_MEASUREMENT_FILE: File containing the test measurements
        -TEST_SUBJECT_FILE: File containing the subjects for each test
        -TEST_ACTIVITY_FILE: File containing the the activity code for each test

    *train data
        -TRAIN_FOLDER: Folder relative to the current folder holding the training data
        -TRAIN_MEASUREMENT_FILE: File containing the training measurements
        -TRAIN_SUBJECT_FILE: File containing the subjects for each training test
        -TRAIN_ACTIVITY_FILE: File containing the the activity code for each training test

    *common data
        -COMMON_DATA_FOLDER: Folder containing the common data.
        -FEATURES_KEY_FILE: File containing the description of the measurement fields
        -ACTIVITY_KEY_FILE: File containing the key to the activity codes
        -EXTRACT_MEASURE: Vector measurements to be extracted from the data file

    *cleaned data storage
        -SAVE_DATA_FOLDER: Folder in which to store the tidy data set
        -CLEAN_DATA_FILE: File name for tidy data set
        
        
#### Subroutines

Normally these would be placed in a separate source code file but for ease of review are included here.

    *getMeasureIndices(featureKey,measures): Uses grep to find all the indices in the featureKey that contain exact matches for the desired                 measures in the the vector of measurement strings (measure)
    
    *getDataTable(dataFolder,measureFile,subjectFile,actFile,extractIdx,measureNames): Open the measurement, activity and subject files for a group of measurements. Only the columns in extractIdx are kept in the data table. The subject and activity codes are column bound to the data. The measureNames are used as variables names for the measurement columns.

#### Main Script
This is where the actual extraction and tidying of the data occurs.
1. The feature key file is read in to a data table and is passed tot he getMeasureIndices routines to extract the indices of the measurements containing "mean()" or "std()". The measurement names of the desired indices are extracted from the mesurement data table to be used as column names.

2. The activity lookup data table is read from the activity key file.

3. The test data set is loaded using the getDataTable subroutine.

4. The training data set is loaded using the getDataTable subroutine.

5. The data sets in 3 and 4 are row bound to gather them together in one data set and merged with the activity code lookup table to provide human readable names on the activities. The activity nmmes nd subject_id's were converted to factors.

6. Using aggregate function the data was aggregated by all the combinations of subject and activities and the mean taken of each comination.

7. The data was saved to a comma delimited text file.

#### Code Book

The code book for the tideied data can found in [Course project Code Book.txt](https://github.com/MattLWhitaker/CleaningDataCourseProject/blob/master/Course%20Project%20Code%20Book.txt)
