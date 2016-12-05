#this code creates a random ordered vector consisting of 300 trues and 100 falses

#read in credit data to eventually make a training and test set from it
client <- read.csv("data/scaled-client.csv")

set.seed (420)

#train set will be size 20
true <- !logical(20)
false <- logical(7)
vec <- c(true, false)


train <- sample(vec, replace = FALSE)
#test set is the rest of 7 observations
test <- (! train )

#create the training and test set from the data itself
train_set <- client[train,]

test_set <- client[test,]

#store train and test data in an Rdata file
#this data will be used everytime we build a model
save(train_set, test_set, file = "data/train_test.RData")
