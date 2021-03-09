

##########################
#                        #
#  Author: JAGC          #
#  09/03/2021            #
#  Output Tidy Data Set  #
#                        #
##########################


# library packages

install.packages("plyr")
install.packages("data.table")
install.packages("dplyr")
install.packages("knitr")
library(plyr)
library(data.table)
library(dplyr)
library(knitr)



# Unzip dataset
setwd("C:/Users/constanz1970/Desktop/Coursera Projects/Getting and cleaning Data/UCI HAR Dataset")

# Read labels
features_labels <- read.table("./features.txt", col.names = c("n", "functions"))


# Read data set - directory train
subject_train <- read.table("./train/subject_train.txt", header = F)
x_features_train <- read.table("./train/x_train.txt", header = F)
y_activity_train <- read.table("./train/y_train.txt", header = F)
# str(subject_train)
# str(x_features_train)
# str(y_activity_train)

# Read data set - directory test
subject_test <- read.table("./test/subject_test.txt", header = F)
x_features_test <- read.table("./test/x_test.txt", header = F)
y_activity_test <- read.table("./test/y_test.txt", header = F)
# str(subject_test)
# str(x_features_test)
# str(y_activity_test)

# Create datatable by rows
X_Features_Data <- rbind(x_features_train, x_features_test)
names(X_Features_Data) <- features_labels$functions
X_Features_Data

Y_Activity_Data <- rbind(y_activity_train, y_activity_test)
names(Y_Activity_Data) <- "Code"
head(Y_Activity_Data)

Subject_Data <- rbind(subject_train, subject_test)
names(Subject_Data) <- "Subject"
head(Subject_Data)

# Combine datasets
merged_data <- cbind(Subject_Data, X_Features_Data, Y_Activity_Data)

# Get dataset with searched elements
elements_Searched <- select(merged_data, Subject, Code, contains("mean"), contains("std"))

# Correct labels of my final dataset

names(elements_Searched) <- gsub('Acc',"Acceleration",names(elements_Searched))
names(elements_Searched) <- gsub('Gyro',"Gyroscope",names(elements_Searched))
names(elements_Searched) <- gsub('Mag',"Magnitude",names(elements_Searched))
names(elements_Searched) <- gsub('^t',"Time",names(elements_Searched))
names(elements_Searched) <- gsub('^f',"Frequency",names(elements_Searched))
names(elements_Searched) <- gsub('\\.mean',".Mean",names(elements_Searched))
names(elements_Searched) <- gsub('\\.std',".STD",names(elements_Searched))
names(elements_Searched) <- gsub('Freq\\.',"Frequency",names(elements_Searched))
names(elements_Searched) <- gsub('Freq$',"Frequency",names(elements_Searched))
names(elements_Searched) <- gsub('angle',"Angle",names(elements_Searched))
names(elements_Searched) <- gsub('gravity',"Gravity",names(elements_Searched))
elements_Searched

# Create an independent  tidy data set with the average of each variable for each activity and each subject

new_Data <- aggregate(.~Subject + Code, elements_Searched, mean)
new_Data <- new_Data[order(new_Data$Subject, new_Data$Code),]
write.table(new_Data, file = "C:/Users/constanz1970/Desktop/Coursera Projects/Getting and cleaning Data/tidydata.txt", row.names = F)



