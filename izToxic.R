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