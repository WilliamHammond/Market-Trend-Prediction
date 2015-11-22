# file:
# Contributers: William Hammond
#               Harry Longwell
# Created: 11/19/2015
# Modified: 11/22/2015

library(nnet)
# Function that prepares the data to put into the neural network. We bind the 
# data leaving the target variable in the right most column. Every column
# corresponds to a different feature. 
#
# Input:
#       dat = data set, last column must be th target variable
#       sizeTrainging = The percent of the data we want to train on
#       datanames = array of names that correspond to feature names
#       shuffle = if TRUE shuffle rowise, if false leave in time order
prepdata <- function(dat,dataNames,sizeTraining = 0.8,  shuffle = FALSE) {
  # Set column names
  colnames(dat) <- dataNames
  # Shuffle row-wise if need be
  if (shuffle == TRUE){
    dat <- dat[sample(nrow(dat)),]
  }
  # Get the number of data points
  num_data <- dim(dat)[1]
  # Find training and testing size
  training_size <- num_data * sizeTraining
  testing_size <- num_data * (1 - sizeTraining)
  # Divid training and testing set 
  train_input <- dat[1:training_size,]
  test_input <- dat[(training_size + 1):(training_size + testing_size),]
  # Remove any row that has an NA in it
  train_input <- train_input[complete.cases(train_input),]
  test_input <- test_input[complete.cases(test_input),]

  return (list(train_input, test_input)) 
}

# Trains neural network, runs prediction and creates visualizations
# Input:
#       trainInput = training input
#       shuffle = if TRUE change title to reflect the fact data is shuffled
runmodel <- function (trainInput, testInput, shuffle = FALSE) {
  model_nnet <- nnet(x=trainInput[,1:ncol(trainInput) - 1], hidden = 1000000000, 
                     y=trainInput[,ncol(trainInput)], size=6,maxit = 10000, linout = TRUE, 
                     trace = TRUE)
  # Run Prediction
  predicted <- predict(model_nnet, testInput, type = "raw")
  # Compute Accuracy
  accuracy=(((predicted-testInput)/testInput)*100)[,ncol(trainInput)]

  jpeg ("test.jpg")
  plot(accuracy, ylim = c(-10,10), ylab = "Percent", 
       xlab = "Year and Month (10/2014 - 09/2015)", title = "Accuracy of Prediction")
  title (main = "Accuracy of Prediction For Future Dates")
  dev.off()
  
  # jpeg ("RandomOrderAccuracy.jpg")
  # plot(accuracy, ylim = c(-10,10), ylab = "Percent", 
  #      xlab = "Year and Month", title = "Accuracy of Prediction")
  # title (main = "Accuracy of Prediction General Case Monroe County")
  # dev.off()  
}