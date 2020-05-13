library(dplyr)
compileDataset <-
        function(X_directory,
                 Y_directory,
                 subject_directory) {
                # Can call this function using
                # compileDataset("test/X_test.txt","test/y_test.txt","test/subject_test.txt")
                # compileDataset("train/X_train.txt","train/y_train.txt","train/subject_train.txt")
                
                # X dataframe
                # 1. Compute the directory of X.txt
                # 2. Read X.txt into a dataframe
                # 3. Read column names of X from features.txt, label the dataframe's columns name as "ID", "colNames"
                # 4. Parse the column name from features dataframe into X dataframe
                # 5. Get mean and standard deviation column names based on "mean()" and "std()" keyword
                # 6. Filter out the required columns from X based on step 5
                # 7. Add an "ID" column to X to preserve ordering
                X_directory <-
                        paste(getwd(), "/", X_directory, sep = "")
                X <- read.table(X_directory)
                features <-
                        read.table("features.txt", col.names = c("ID", "colNames"))
                colnames(X) <- features$colNames
                mean_or_std_columns <-
                        grep("mean\\(\\)|std\\(\\)", features$colNames, value = TRUE)
                X <- X[mean_or_std_columns]
                X$ID <- seq.int(nrow(X))
                
                # Y dataframe
                # 1. Compute the directory of Y.txt
                # 2. Read Y.txt into a dataframe
                # 3. Rename the first column names of Y as "activityNumber" 
                # 4. Add an "ID" column to Y to preserve ordering
                # 5. Read activity_labels.txt into a dataframe, name the columns as "activityNumber" and "activity"
                # 6. Merge the Y and activity_labels based on "activityNumber"
                # 7. Reorder the dataframe based on "ID" 
                # 8. Drop "activityNumber" columns
                Y_directory <-
                        paste(getwd(), "/", Y_directory, sep = "")
                Y <- read.table(Y_directory)
                colnames(Y) <- c("activityNumber")
                Y$ID <- seq.int(nrow(Y))
                activity_labels <- read.table("activity_labels.txt")
                colnames(activity_labels) <-
                        c("activityNumber", "activity")
                Y <- merge(Y, activity_labels, all = TRUE)
                Y <- Y[order(Y$ID), ]
                Y <- subset(Y, select = -c(activityNumber))
                
                # subject dataframe
                # 1. Compute the directory of subject.txt
                # 2. Read subject into a dataframe
                # 3. Name the first column of subject dataframe as "subject"
                # 4. Add an "ID" column to subject dataframe to preserve ordering
                subject_directory <-
                        paste(getwd(), "/", subject_directory, sep = "")
                subject <- read.table(subject_directory)
                colnames(subject) <- c("subject")
                subject$ID <- seq.int(nrow(subject))
                
                # Merging
                # 1. Merge X, Y into a new dataframe based on "ID"
                # 2. Merge the newly formed dataframe from step 1 with subject dataframe based on "ID"
                # 3. Then drop ID column since it's no longer relevant
                # 4. Rearrange the columns to be subject, activity, followed by mean and standard deviation values
                dataset <- merge(X, Y, by = "ID", all = TRUE)
                dataset <-
                        merge(dataset, subject, by = "ID", all = TRUE)
                dataset <- subset(dataset, select = -c(ID))
                dataset <-
                        subset(dataset,
                               select = c("subject", "activity", mean_or_std_columns))
                
                return (dataset)
        }

combineDatasets <-
        function(X_test_directory = "test/X_test.txt",
                 Y_test_directory = "test/y_test.txt",
                 subject_test_directory = "test/subject_test.txt",
                 X_train_directory = "train/X_train.txt",
                 Y_train_directory = "train/y_train.txt",
                 subject_train_directory = "train/subject_train.txt") {
                
                # Compile train dataset
                train_dataset <-
                        compileDataset(X_test_directory,
                                       Y_test_directory,
                                       subject_test_directory)
                # Compile test dataset
                test_dataset <-
                        compileDataset(X_train_directory,
                                       Y_train_directory,
                                       subject_train_directory)
                
                # Combine all the rows of train and test dataset
                full_dataset <- rbind(train_dataset, test_dataset)
                
                return(full_dataset)
                
        }

compileTidyDataset <-
        function(X_test_directory = "test/X_test.txt",
                 Y_test_directory = "test/y_test.txt",
                 subject_test_directory = "test/subject_test.txt",
                 X_train_directory = "train/X_train.txt",
                 Y_train_directory = "train/y_train.txt",
                 subject_train_directory = "train/subject_train.txt")  {
                
                # Compile combined dataset
                combined_dataset <-
                        combineDatasets(
                                X_test_directory,
                                Y_test_directory,
                                subject_test_directory,
                                X_train_directory,
                                Y_train_directory,
                                subject_train_directory
                        )
                
                # Group the dataset based on "subject","activity"
                tidy_dataset <-
                        group_by(combined_dataset, subject, activity)
                
                # Find the mean of all the columns based on "subject" and "activity" grouping
                tidy_dataset <- summarise_each(tidy_dataset, mean)
                write.table(tidy_dataset,"tidy_dataset.txt",row.names = FALSE)
                return (tidy_dataset)
                
        }