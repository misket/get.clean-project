##Getting and Cleaning Data Project

This repo is set for the Getitng and Celaning Data Course provided by coursera.org. The question that is bing answered can be found at https://class.coursera.org/getdata-002/human_grading/view/courses/972080/assessments/3/submissions

The information about the dataset can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The main objective is to create a tidy dataframe from 6 different data files. 3 of them are test data and 3 of them are training data (provided in the above link.)

Additionally the data files involve the details of 'activities' and the 'features' (the former is the level names for the activity factors assigned to Y_test and Y_train datasets, while the latter is essentially the column names of the two data files; X_test.txt and X_train.txt)

###Reading and preparing the 'test' data

Firstly we load the column names for X variables (features.txt) and level designations for Y variables (activity_labels.txt)

Next, we load the dataframe for X test variables (X_test.txt), calling the variable names from the dataframe created previously (feat)

As the project problem suggest we will only take the mean and standard deviation variables for the testX dataframe. Here I have decided to take only the variables with 'mean()' and 'std()' in their names

Next, we load the dataframe for Y variables (Y_test.txt). Then using a for loop we fill a second column with the appropriate activity names. Lastly we redefine the dataframe factors for the sake of clean data.

Next, we load the dataframe for subjects (subjects_test.txt)

Finally we merge all of the 3 dataframes and add a column to remind the type of data for once they are merged with the training datasets

We duplicate all of the above steps for the training dataset.

###Merging both dataframes

Once the dataframes are merged they are called wholeMerge. 

I did not want to change the column names as the documentation of the original study is good enough

###Tidying the merged dataframe

As the project requires, this new dataframe will have column means of the mean variables for each subject according to activity involved.

First we subset the merged dataframe according to columns having 'mean()' in their variable names and bind them with "activity_code", "activity" and "subject"

Next, we need to initiate a dataframe to fill with tidy data. 

Now we are ready to fill in our data. (I could not fully comprehend the 'apply' functions so here goes old school for looping)

First we need to split the data as list for each subject

###The for Loop

We'll run 2 for loops to fill in the data frame cleanly according to 2 variables (1st 'subject', 2nd 'activity')
  
  Inside the first loop (subject) we'll split the main list (spl) into another list for each subject according to activity

  Once the large list's ith element is split for activities we create a new loop (activity)
  
    We fill the first 3 columns of the empty tidy dataframe with appropriate; activity code, activity and subject repectively.
       
    Then we assign the remaining columns of each activity line with running column means function on the second split list for each j (activity of a subject)
    
Note that I have kept the activity codes so far to make sure everything worked fine. Now we need to get rid of them and set the 'subject' column as the first.

###Finally we create the cleaned txt file.
