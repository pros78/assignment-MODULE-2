setwd("C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile = "C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT"
download.file(fileURL, file.path(destfile, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")
library(tidyselect)


# 1.Merges the training and the test sets to create one data set.

# 1.1 Voy a leer primero los archivos de training pero teniendo en cuenta que las cabeceras de X_train están en features.

activity_lbs <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/activity_labels.txt",
                           header=FALSE, sep='')

features <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/features.txt",
                       header=FALSE, sep='')
training_subject <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/train/subject_train.txt",
                                header=FALSE, sep='')
X_train <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/train/X_train.txt",
                               header=FALSE, col.names=features$V2,sep='')
y_train <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/train/y_train.txt",
                      header=FALSE, sep='')

# Tengo que asignar a los valores de v1 en y_train los nombres de activity_lbs y no sé cómo hacerlo. Creo que puedo hacerlo con un recode (primer argumento el viejo y el segundo el nuevo)
label <- recode(y_train$V1, '1'="walking", '2'="walking_upstairs", '3'="walking_downstairs", '4'="sitting", '5'="standing", '6'="laying")
y_train <- cbind(y_train, label)

# 1.2 Combino los archivos de training:

training1 <- cbind(y_train, X_train) %>% select(!`V1`) 
training2 <- cbind(training_subject, training1)

# 1.3 Leo los archivos de test pero teniendo en cuenta que las cabeceras de X_train están en features.

subject_test <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/test/subject_test.txt",
                               header=FALSE, sep='')
X_test <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/test/X_test.txt",
                      header=FALSE, col.names=features$V2,sep='')
y_test <- read.table(file="C:/Users/pros/OneDrive - CNMC/Documentos/Formación/CURSOS COURSERA 2024/2. GETTING AND CLEANING DATA/ASSIGNMENT/UCI HAR Dataset/test/y_test.txt",
                      header=FALSE, sep='')
#Hago lo mismo que antes con las etiquetas antes de juntarlos.

label <- recode(y_test$V1, '1'="walking", '2'="walking_upstairs", '3'="walking_downstairs", '4'="sitting", '5'="standing", '6'="laying")
y_test <- cbind(y_test, label)

# 1.4 Combino los archivos de test:

training3 <- cbind(y_test, X_test) %>% select(!`V1`) 
training4 <- cbind(subject_test, training3)

# 1.5 Combino training y test y renombro V1:

dataset <- rbind(training2, training4) %>% rename("Subject"='V1')



# 2.Extracts only the measurements on the mean and standard deviation for each measurement.

# i need to select for each feature only mean (mean) and standard deviation (std) con un select.

# tidyselect::vars_select(names(df), matches('^[Bb]'))

dataset2 <- dataset %>% select(vars_select(names(dataset), contains(c("Subject", "label",".mean",".std"))))

# 3.Uses descriptive activity names to name the activities in the data set

#done in 1.1 and 1.3



# 4.Appropriately labels the data set with descriptive variable names. 




# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#dataset3 <- dataset2 %>% group_by(Subject,label) %>% colMeans(dataset2,na.rm=T) colmeans no me fucniona he perdido mucho tiempo.

dataset3 <- dataset2 %>%  group_by(Subject, label) %>% summarise(across(everything(), mean))

# upload your data set as a txt file created with write.table() using row.name=FALSE 

write.table(dataset3, file = "assignment.txt", sep = "\t",row.names = FALSE)

