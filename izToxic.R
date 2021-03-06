#Project Name: izToxic
#Name: Faraz Khalid
#Description: A solution to classify toxic, severe toxic, obscene, threat, insult and identity hate comments.
#The data was taken from kaggle (source: https://www.kaggle.com/c/jigsaw-toxic-comment-classification-challenge/data).

#Project Description: The project was done in in Apache Spark using SparkR.

#Load SparkR library that lets us use R in Apache Spark.
library(SparkR)

#Loading data (databricks community version was used for this project)
toxic <- read.csv(file="/dbfs/FileStore/tables/train.csv", header=TRUE, sep=",")

#For checking purposes, only 50000 rows were being utilized as databricks cluster is only 6 gigabytes and does not perform very well if the dataset is too large.
toxic <- toxic[1:50000,]
#remove ID as they do not have influence on toxicity of a comment.
toxic <- toxic[-c(1)]

#Make multi-nomial problem a binary classification problem as it is more easier to tackle it in pieces.
#Dropped all columns except comment and toxic (one of the toxicity levels out of 6)
toxic <- toxic[-c(3:7)]

#rearranging column which has text as we want it to be second and not first. This is made for simplification of tasks.
toxic$comment = toxic$comment_text
toxic <- toxic[-c(1)]

library(tm)
toxic_corpus <- Corpus(VectorSource(toxic$comment))
toxic_clean <- tm_map(toxic_corpus, content_transformer(tolower))  
toxic_clean <- tm_map(toxic_clean, removeNumbers) 
toxc_clean <- tm_map(toxic_clean, removePunctuation) 
toxic_clean <- tm_map(toxic_clean, removeWords, stopwords())
toxic_clean <- tm_map(toxic_clean, stripWhitespace)

toxic_indices <- which(toxic$toxic == 1)
nonToxic_indices <- which(toxic$toxic == 0)

library(wordcloud)

wordcloud(toxic_clean[toxic_indices],min.freq=40, max.words = Inf) #toxic wordcloud

wordcloud(toxic_clean[nonToxic_indices],min.freq=40)

#------------------------------------------------------
#MODEL AND OTHER THINGS BELOW THIS
#------------------------------------------------------

#Creating a Matrix to classify toxic only.

# CREATE THE DOCUMENT-TERM MATRIX
doc_matrix <- create_matrix(toxic$comment, language="english", removeNumbers=TRUE,
stemWords=TRUE, removeSparseTerms=.998)

container <- create_container(doc_matrix, toxic$toxic, trainSize=1:7500,
testSize=7501:10000, virgin=FALSE)

SVM <- train_model(container,"SVM")
#RF <- train_model(container,"RF")


SVM_CLASSIFY <- classify_model(container, SVM)
#RF_CLASSIFY <- classify_model(container, RF)

analytics <- create_analytics(container,
cbind(SVM_CLASSIFY))

summary(analytics)

topic_summary <- analytics@label_summary
alg_summary <- analytics@algorithm_summary
ens_summary <-analytics@ensemble_summary
doc_summary <- analytics@document_summary
analytics@document_summary

SVM <- cross_validate(container, 4, "SVM")

analytics@document_summary

#write.csv(analytics@document_summary, file = "DocumentSummary.csv")

toxic = read.csv(file="train.csv", header = TRUE)
toxic <- toxic[1:10000,]

#toxic <- toxic[-c(1)]
toxic <- toxic[-c(1,3,5:8)]
toxic$comment = toxic$comment_text
toxic <- toxic[-c(1)]

doc_matrix <- create_matrix(toxic$comment, language="english", removeNumbers=TRUE,
stemWords=TRUE, removeSparseTerms=.998)

container <- create_container(doc_matrix, toxic$severe_toxic, trainSize=1:7500,
testSize=7501:10000, virgin=FALSE)

SVM <- train_model(container,"SVM")

SVM_CLASSIFY <- classify_model(container, SVM)

analytics <- create_analytics(container,
cbind(SVM_CLASSIFY))

summary(analytics)

topic_summary <- analytics@label_summary
alg_summary <- analytics@algorithm_summary
ens_summary <-analytics@ensemble_summary
doc_summary <- analytics@document_summary
```

CLASSIFY OBSCENE
```{r}
toxic = read.csv(file="train.csv", header = TRUE)
toxic <- toxic[1:10000,]

#toxic <- toxic[-c(1)]
toxic <- toxic[-c(1,3,4,6:8)]
toxic$comment = toxic$comment_text
toxic <- toxic[-c(1)]

doc_matrix <- create_matrix(toxic$comment, language="english", removeNumbers=TRUE,
stemWords=TRUE, removeSparseTerms=.998)

container <- create_container(doc_matrix, toxic$obscene, trainSize=1:7500,
testSize=7501:10000, virgin=FALSE)

SVM <- train_model(container,"SVM")

SVM_CLASSIFY <- classify_model(container, SVM)

analytics <- create_analytics(container,
cbind(SVM_CLASSIFY))

summary(analytics)

toxic = read.csv(file="train.csv", header = TRUE)
toxic <- toxic[1:10000,]

#toxic <- toxic[-c(1)]
toxic <- toxic[-c(1,3,4,5,7,8)]
toxic$comment = toxic$comment_text
toxic <- toxic[-c(1)]

doc_matrix <- create_matrix(toxic$comment, language="english", removeNumbers=TRUE,
stemWords=TRUE, removeSparseTerms=.998)

container <- create_container(doc_matrix, toxic$threat, trainSize=1:7500,
testSize=7501:10000, virgin=FALSE)

SVM <- train_model(container,"SVM")

SVM_CLASSIFY <- classify_model(container, SVM)

analytics <- create_analytics(container,
cbind(SVM_CLASSIFY))

summary(analytics)

toxic = read.csv(file="train.csv", header = TRUE)
toxic <- toxic[1:10000,]

#toxic <- toxic[-c(1)]
toxic <- toxic[-c(1,3,4,5,6,8)]
toxic$comment = toxic$comment_text
toxic <- toxic[-c(1)]

doc_matrix <- create_matrix(toxic$comment, language="english", removeNumbers=TRUE,
stemWords=TRUE, removeSparseTerms=.998)

container <- create_container(doc_matrix, toxic$insult, trainSize=1:7500,
testSize=7501:10000, virgin=FALSE)

SVM <- train_model(container,"SVM")

SVM_CLASSIFY <- classify_model(container, SVM)

analytics <- create_analytics(container,
cbind(SVM_CLASSIFY))

summary(analytics)