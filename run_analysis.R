#load the column names for X variables and level designations for Y variables (activity) [test data]
feat <- read.table("features.txt")
act <- read.table("activity_labels.txt")
act[,2] <- factor(act[,2], levels = act[,2])

# load the data.frame for X variables, calling the variable names from the "features.txt" file [test data]
testX <- read.table("./test/X_test.txt")
names(testX) <- feat$V2

#extract variables that have 'mean()' or 'std()'
testX <- cbind(testX[,grepl("mean()", names(testX), fixed = TRUE)], testX[,grepl("std()", names(testX), fixed = TRUE)])

# load the data.frame for Y variables (activities). Redefine the data.frame factors for merging later [test data]
testY <- read.table("./test/Y_test.txt")
for (i in 1:length(testY$V1)) {testY$V2[i] = as.character(act[testY[i,1],2])}
testY$V2 <- as.factor(testY$V2)
names(testY) <- c("activity.code", "activity")
testY[,2] <- factor(testY[,2], levels = act[,2])

# load the data.frame for subjects [test data]
testSub <- read.table("./test/subject_test.txt", col.names = "subject")

# merge all 3 test data.frames, add a column to remind the type of data for once theye are merged (test data)
testMerge <- cbind(testX, testY, testSub)
testMerge$data.type <- rep("test", times = length(testY[,1]))

#duplicate all of the above steps for [training data]
trainX <- read.table("./train/X_train.txt", col.names = feat$V2)
names(trainX) <- feat$V2
trainX <- cbind(trainX[,grepl("mean()", names(trainX), fixed = TRUE)], trainX[,grepl("std()", names(trainX), fixed = TRUE)])


trainY <- read.table("./train/Y_train.txt")
for (i in 1:length(trainY$V1)) {trainY$V2[i] = as.character(act[trainY[i,1],2])}
trainY$V2 <- as.factor(trainY$V2)
names(trainY) <- c("activity.code", "activity")
trainY[,2] <- factor(trainY[,2], levels = act[,2])

trainSub <- read.table("./train/subject_train.txt", col.names = "subject")
trainMerge <- cbind(trainX, trainY, trainSub)
trainMerge$data.type <- rep("training", times = length(trainY[,1]))

#merge both data frames
wholeMerge <- rbind(trainMerge, testMerge)

#I did not want to change the column names as the documentation of the original study is good enough

#From now on we are creating a data.frame that is tidied.
#This new data frame will have column means of the mean variables (collected in the previous parts) for every subject and activity.

#subset the merged data.frame according to columns having 'mean()' in their variable names and bind them with "activity" and "subject"
means <- cbind(wholeMerge$activity.code, wholeMerge$activity, wholeMerge$subject, wholeMerge[,grepl("mean()", names(wholeMerge), fixed = TRUE)])

#rename subject and activity columns (previously; wholeMerge$activity, wholeMerge$subject)
names(means)[1:3] <- c("activity.code", "activity", "subject")

#initiate a data.frame to fill it in using for loops (I could not fully comprehend the 'apply' functions so here goes old school programming)
tidy <- data.frame(matrix(NA, nrow = 30*6, ncol = length(names(means))))
names(tidy) <- names(means)
tidy[,1] <- as.integer(tidy[,1])

k = 0

#first split the data as list for each subject
spl <- split(means, means$subject)

# we'll run 2 for loops to fill in the data frame according to 2 variables
for (i in 1:30){
  
  #we'll split the first levels list into another list for each subject according to activity
  spl2 <- split(spl[[i]], spl[[i]][,2])
  
  for (j in 0:5){
    a = i + j + k
    #fill the first 3 columns of the initiated tidy data with appropriate; activity code, activity and subject repectively.
    tidy[(a), 1] = j + 1
    tidy[(a), 2] = as.character(act$V2[(j + 1)])
    tidy[(a), 3] = i
    
    # assign the remaining columns of each activity line with running column means function on the secon split list
    tidy[(a),4:36] = colMeans(spl2[[j + 1]][,4:36])
    
  }
  k = k + 5  
}

# get rid of activity codes and set the 'subject' column as the first.
tidy <- tidy[, c(3, 2, 4:36)]

#finally write the txt file.
write.table(tidy, "coursera_get.clean_project.txt", sep = ",")
