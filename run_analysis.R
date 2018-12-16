setwd("/Users/home/UCI HAR Dataset")
features <- read.table("features.txt") ## 561 obs. of  2 variables
row <- grep("mean()", features$"V2")
row1 <- grep("std()", features$"V2")
rows <- append(row,row1, after=length(row)) ## column numbers with mean() or std()
rows <- sort(rows)
feature_names <- features[rows,] ##extracting feature names

x_test<-read.table("test/X_test.txt") ## 2947 obs. of  561 variables V1, V2 etc
xtest_new <- x_test[,rows] ## x_test with only colums containing mean()orstd() 2947 obs. of  79 variables
colnames(xtest_new) <- feature_names$"V2"

x_train<-read.table("train/X_train.txt") ## 7352 obs. of  561 variables V1, V2 etc
xtrain_new <- x_train[,rows] ## x_train with only colums containing mean()orstd() 7352 obs. of  79 variables
colnames(xtrain_new) <- feature_names$"V2"

x_subject_test<-read.table("test/subject_test.txt") 
x_subject_train<-read.table("train/subject_train.txt") 
colnames(x_subject_test) <- c("Subject")
colnames(x_subject_train) <- c("Subject")

y_test<-read.table("test/y_test.txt")
y_train<-read.table("train/y_train.txt")
activityLabel <- read.table("activity_labels.txt")
y_activity_test<- merge(y_test, activityLabel, by.x=1)
colnames(y_activity_test) <- c("ActivityLabel", "ActivityDescription")
y_activity_train<- merge(y_train, activityLabel, by.x=1)
colnames(y_activity_train) <- c("ActivityLabel", "ActivityDescription")

x_test_data <- cbind(x_subject_test,y_activity_test, xtest_new) ##combine subject data to X test data
x_train_data <- cbind(x_subject_train, y_activity_train, xtrain_new) ##combine subject data to X train data

final_data <- rbind(x_test_data, x_train_data) ## 10299 obs, 80 Variables combine all rows of xtest and xtrain data

##renaming col names
names(final_data)<-gsub("^t", "time", names(final_data))
names(final_data)<-gsub("^f", "frequency", names(final_data))
names(final_data)<-gsub("Acc", "Accelerometer", names(final_data))
names(final_data)<-gsub("Gyro", "Gyroscope", names(final_data))
names(final_data)<-gsub("Mag", "Magnitude", names(final_data))
names(final_data)<-gsub("BodyBody", "Body", names(final_data))
names(final_data)<-gsub("std()", "SD()", names(final_data))

f_data<-final_data[-2]

#grouping and finding mean
test<-aggregate(f_data[, 3:81], list(f_data$Subject,f_data$ActivityDescription), mean)
colnames(test)[1] <- "Subject"
colnames(test)[2] <- "ActivityDescription"

#writing to a file
write.csv(test,"tidy_data.csv")
write.table(test,"tidy_data.txt",row.name=FALSE)


