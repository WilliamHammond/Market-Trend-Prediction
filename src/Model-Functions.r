# file: Model-Functions.r
# Contributers: William Hammond
#               Harry Longwell
# Created: 11/19/2015
# Modified: 11/22/2015

library(nnet)
# Function that computes and plots PCA for a given data set. 
# Input:
#       dat = data set
#       resultPath = Path to results folder
#       pcaTitle = title to plot
getpca <- function (dat, resultPath, pcaTitle) {
  # Principle Component Analysis
  # Log transform
  log.dat <- log(dat)
  # Apply PCA
  dat.pca <- prcomp(log.dat,
                    center = TRUE,
                    scale. = TRUE) 
  
  # This will pipe out put to file  
  sink (paste(resultPath,pcaTitle, '.txt', sep = ''), append = TRUE, split = FALSE)
  print(summary(dat.pca))
  print(dat.pca)
  # Return output to console
  sink()
  
  # Plot PCA
  jpeg(paste(resultPath,pcaTitle,".jpg", sep = ""))
  plot(dat.pca, type = "l", xaxt = 'n', yaxt = 'n')
  title ( main = pcaTitle)
  dev.off()
}

# Function that prepares the data to put into the neural network. We bind the 
# data leaving the target variable in the right most column. Every column
# corresponds to a different feature. Features are normalized using z-score
#
# Input:
#       dat = data set, last column must be th target variable
#       sizeTrainging = The percent of the data we want to train on
#       datanames = array of names that correspond to feature names
#       shuffle = if TRUE shuffle rowise, if false leave in time order
#       normalization = n for none, z for z score, mm for min-max
prepdata <- function(dat,dataNames,normalization = "n",sizeTraining = 0.8,  shuffle = FALSE, split = FALSE) {
  # Set column names
  colnames(dat) <- dataNames
  # Remove any row that has NA in it
  dat <- dat[complete.cases(dat),]
  if (normalization == "z") {
    dat <- apply(dat, 2, function(x) {
      ((x - mean(x)) / sd(x) )
    }) 
  }
  else if (normalization ==  "mm") {
    dat <- apply(dat, 2, function(x) {
      ((x - min(x)) / (max(x) - min(x)) )
    }) 
  }
  # Shuffle row-wise if need be
  if (shuffle == TRUE){
    dat <- dat[sample(nrow(dat)),]
  }

  # Divid training and testing set 
  if (split == TRUE) {
    # Get the number of data points
    num_data <- dim(dat)[1]
    # Find training and testing size
    training_size <- num_data * sizeTraining
    testing_size <- num_data * (1 - sizeTraining)
    train_input <- dat[1:training_size,]
    test_input <- dat[(training_size + 1):(training_size + testing_size),]
    
    return (list(train_input, test_input))
  } else {
    return (dat)
  }
}

# Trains neural network, runs prediction and creates visualizations
# Input:
#       trainInput = training input
#       shuffle = if TRUE change title to reflect the fact data is shuffled
runmodel <- function (trainInput, testInput,  accuracyTitle, residualTitle, resultPath) {
  model_nnet <- nnet(x=as.data.frame(trainInput[,1:ncol(trainInput) - 1]), hidden = 10, 
                     y=as.data.frame(trainInput[,ncol(trainInput)]), size=20,maxit = 10000, linout = TRUE, 
                     trace = TRUE, decay=1e-3)
  # Run Prediction
  predicted <- predict(model_nnet, testInput, type = "raw")
  # Compute Accuracy
  accuracy <- (((predicted-testInput)/testInput)*100)[,ncol(trainInput)]
  # Find the range we want to limit the plot to
  bounds <- max(abs(ceiling(max(accuracy))),abs(floor(min(accuracy)))) 
  # Create name of the output file
  accuracy_file_name <- paste(resultPath,accuracyTitle, '.jpg', sep = "")
  # Plot and save accuracy
  jpeg (accuracy_file_name)
  plot(accuracy, ylim = c(-bounds,bounds), ylab = "Percent", 
       xlab = "Year and Month (10/2014 - 09/2015)")
  title (main = accuracyTitle)
  dev.off()
}