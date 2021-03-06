## Course Project for Getting and Cleaning Data
##  Matt Whitaker 2014
## data sources
##test data
TEST_FOLDER <- "./test"                 ## Folder relative to the current folder holding the test data
TEST_MEASUREMENT_FILE <- "X_test.txt"   ## File containing the test measurements
TEST_SUBJECT_FILE <- "subject_test.txt" ## File containing the subjects for each test
TEST_ACTIVITY_FILE <- "y_test.txt"      ## File containing the the activity code for each test

##train data
TRAIN_FOLDER <- "./train"               ## Folder relative to the current folder holding the training data
TRAIN_MEASUREMENT_FILE <- "X_train.txt" ## File containing the training measurements
TRAIN_SUBJECT_FILE <-"subject_train.txt"## File containing the subjects for each training test
TRAIN_ACTIVITY_FILE <- "y_train.txt"    ## File containing the the activity code for each training test

##common data
COMMON_DATA_FOLDER <- "."               ## Folder containing the common data.
FEATURES_KEY_FILE  <- "features.txt"    ## File containing the description of the measurement fields
ACTIVITY_KEY_FILE <- "activity_labels.txt" ##File containing the key to the activity codes
EXTRACT_MEASURE <- c("mean()","std()")  ## Vector measurements to be extracted from the data file

## cleaned data storage
SAVE_DATA_FOLDER <- "./clean_data"      ## Folder in which to store the tidy data set
CLEAN_DATA_FILE <- "COURSE_PROJECT_TIDY_DATA.TXT" ##File name for tidy data set


##SUBROUINES 
##subroutine to get the measurement indices we want to extract from the data
getMeasureIndices <- function(featureKey,measures){
    
    ## now find all the feature indices that we want to extract
    extractIdx <- integer()
    for (n in seq_along(measures)){
        extractIdx <- c(extractIdx,grep(measures[n],featureKey$V2, fixed = TRUE))
    }
    extractIdx <- unique(sort(extractIdx))
    return(extractIdx)
}

## subroutine to create a dataset from the measurement file, subject file and activity file
getDataTable <- function(dataFolder,measureFile,subjectFile,actFile,extractIdx,measureNames){
    ## get the measurement data and extract the columns we need
    measureFN <- file.path(dataFolder,measureFile)
    measureData <- read.table(measureFN)
    measureData <- measureData[,extractIdx]
    colnames(measureData) <- measureNames
    
    ## get the subject data
    subjectFN <- file.path(dataFolder,subjectFile)
    subjectData <- read.table(subjectFN, col.names = "subject_ID")
    
    ##get the activity data
    actFN <- file.path(dataFolder,actFile)
    actData <- read.table(actFN, col.names = "activity_ID")
     
    measureData <- cbind(subjectData,actData,measureData)
    return(measureData) ##for now
}

##MAIN SCRIPT BODY

## find the measurements that we want to extract
    ##load the features key
    featureFN <- file.path(COMMON_DATA_FOLDER,FEATURES_KEY_FILE)
    featureKey <- read.table(featureFN,colClasses = "character")
    extractIdx <- getMeasureIndices(featureKey,EXTRACT_MEASURE)
    extractNames <- featureKey$V2[extractIdx]

## get the activity lookup table
    activityFN <- file.path(COMMON_DATA_FOLDER,ACTIVITY_KEY_FILE)
    activityTable <- read.table(activityFN,colClasses = c("numeric","character"),col.names = c("activity_ID","activity_name"))

## create the test  data set
    measureDataSet <- getDataTable(TEST_FOLDER,
                                   TEST_MEASUREMENT_FILE,
                                   TEST_SUBJECT_FILE,
                                   TEST_ACTIVITY_FILE,
                                   extractIdx,
                                   extractNames)

## create the training data set
    trainDataSet <- getDataTable(TRAIN_FOLDER,
                                   TRAIN_MEASUREMENT_FILE,
                                   TRAIN_SUBJECT_FILE,
                                   TRAIN_ACTIVITY_FILE,
                                   extractIdx,
                                   extractNames)

## merge the data sets
    allDataSet = rbind(measureDataSet,trainDataSet)
    allDataSet = merge(allDataSet,activityTable)
    allDataSet$activity_name <- as.factor(allDataSet$activity_name)
    allDataSet$subject_ID <- as.factor(allDataSet$subject_ID)

## summarize the first data set by activity and subject
    aggregateData <- aggregate(x = allDataSet[,3:68], by=list(allDataSet$activity_name,allDataSet$subject_ID), FUN = "mean")
    colnames(aggregateData)[1:2] = c("activity_name","subject_id")
    aggregateData$subject_id <- as.numeric(aggregateData$subject_id)

## save the summary
    saveFN = file.path(SAVE_DATA_FOLDER,CLEAN_DATA_FILE)
    if (!file.exists(SAVE_DATA_FOLDER)){dir.create(SAVE_DATA_FOLDER)}
    write.table(aggregateData,saveFN,row.names = FALSE,sep = ",")
    









