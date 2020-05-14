# Getting-and-Cleaning-Data-Course-Project
## 3 Main functions 
### First function : Compile Dataset
This function will compile the X dataset which contains all the measurements, Y dataset which contains all the activity and subject dataset which contains the subject based on each file directory\
Example usage of this function : 
```R
X_test_directory <- "test/X_test.txt"
Y_test_direcotry <- "test/Y_test.txt"
subject_test_direcotry <- "test/subject_test.txt"

dataset <- compileDataset(X_test_directory,Y_test_directory,subject_test_directory)
```
### Second function : Combine Dataset
This function will combine two datasets into 1 single dataset\
Example usage of this function : 
```R
X_test_directory <- "test/X_test.txt"
Y_test_direcotry <- "test/Y_test.txt"
subject_test_direcotry <- "test/subject_test.txt"
X_train_directory <- "train/X_train.txt"
Y_train_directory <- "train/y_train.txt"
subject_train_directory <- "train/subject_train.txt"

full_dataset <- combineDatasets(X_test_directory,Y_test_directory,subject_test_directory,X_train_directory,Y_train_directory,subject_train_directory)
```
For this project purpose, the default value of each arguments are set in the function as well, so the function can be called using 
```R
full_dataset <- combineDatasets()
```
### Third function : Compile tidy dataset
This function will compile the tidy dataset based on the full dataset compiled, it will group the data based on subject and activity. Then, it will summarise the data based on average value of each respective columns. Finally, it will write the dataset into a txt file.\
Example usage of this function : 
```R
X_test_directory <- "test/X_test.txt"
Y_test_direcotry <- "test/Y_test.txt"
subject_test_direcotry <- "test/subject_test.txt"
X_train_directory <- "train/X_train.txt"
Y_train_directory <- "train/y_train.txt"
subject_train_directory <- "train/subject_train.txt"

compileTidyDataset(X_test_directory,Y_test_directory,subject_test_directory,X_train_directory,Y_train_directory,subject_train_directory)
```
For this project purpose, the default value of each arguments are set in the function as well, so the function can be called using 
```R
compileTidyDataset()
```
A file called **tidy_dataset.txt** will then be compiled within the code folder.
