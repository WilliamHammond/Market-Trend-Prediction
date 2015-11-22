# File: Monroe-Model.r
# Contributers: William Hammond
#               Harry Longwell
# Created:  11/22/2015
# Modified: 11/22/2015
#
# Description: This program loads in zillow data for New York State and creates
#              a neural network used to predict median market value based 
#              off of measures of market health.

source('model.r')

data_path <- '../data/'
result_path <- '../results/NewYork/'

## Load in response variables''





# Create array of columns names used for dataframe
names <- c('ratio_foreclose', 'inventory_measure','price_to_rent','sold_for_gain',
           'increasing_in_value', 'pct_price_reduced','median_sold_price' )
# Bind all of the features into a dataframe 
housing_dat = as.data.frame(cbind(ratio_foreclose, inventory_measure,price_to_rent,
                                  sold_for_gain,increasing_in_value,pct_price_reduced,median_sold_price))
# Prepare training and testing data
prepared_data <- prepdata(housing_dat, names)
training_input <- as.data.frame(prepared_data[1])
testing_input <- as.data.frame(prepared_data[2])
# Run the model and save th eresults
runmodel(training_input, testing_input, "NewYork-Future-Accuracy", "test", result_path)