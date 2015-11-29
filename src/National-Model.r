# File: Monroe-Model.r
# Contributers: William Hammond
#               Harry Longwell
# Created:  11/22/2015
# Modified: 11/22/2015
#
# Description: This program loads in zillow data for California State and creates
#              a neural network used to predict median market value based 
#              off of measures of market health.

source('Model-Functions.r')

data_path <- '../data/state/'
result_path <- '../results/National/'

## Load in response variables''
sold_for_gain <- read.csv( file = paste(data_path, 'State_PctOfHomesSellingForGain_AllHomes.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(sold_for_gain)[1]
sold_for_gain <- stack(sold_for_gain)$values
sold_for_gain <- sold_for_gain[(number_of_states * 3):length(sold_for_gain)]

increasing_in_value <- read.csv ( file = paste(data_path, 'State_PctOfHomesIncreasingInValues_AllHomes.csv', sep =''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(increasing_in_value)[1]
increasing_in_value <- stack(increasing_in_value)$values
increasing_in_value <- increasing_in_value[(number_of_states * 3):length(increasing_in_value)]

pct_price_reduced <-read.csv ( file = paste(data_path, 'State_PctOfListingsWithPriceReductions_AllHomes.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(pct_price_reduced)[1]
pct_price_reduced <- stack(pct_price_reduced)$values
pct_price_reduced <- pct_price_reduced[(number_of_states * 3):length(pct_price_reduced)]

median_pct_price_reduced <-read.csv ( file = paste(data_path, 'State_MedianPctOfPriceReduction_AllHomes.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(median_pct_price_reduced)[1]
median_pct_price_reduced <- stack(median_pct_price_reduced)$values
median_pct_price_reduced <- median_pct_price_reduced[(number_of_states*3):length(median_pct_price_reduced)]

ratio_foreclose <- read.csv ( file = paste(data_path, 'State_HomesSoldAsForeclosures-Ratio_AllHomes.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(ratio_foreclose)[1]
ratio_foreclose <- stack(ratio_foreclose)$values
ratio_foreclose <- ratio_foreclose[(number_of_states*3):length(ratio_foreclose)]

inventory_measure <- read.csv ( file = paste(data_path, 'InventoryMeasure_State_Public.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(inventory_measure)[1]
inventory_measure <- stack(inventory_measure)$values
inventory_measure <- inventory_measure[(number_of_states*3):length(inventory_measure)]

price_to_rent = read.csv(file = paste(data_path, 'State_PriceToRentRatio_AllHomes.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(price_to_rent)[1]
price_to_rent <- stack(price_to_rent)$values
price_to_rent <- price_to_rent[(number_of_states*3):length(price_to_rent)]

# Target Variable
median_sold_price <- read.csv( file = paste(data_path, 'State_MedianSoldPrice_AllHomes.csv', sep = ''))
# When we call stack, the first n elements will be indices where n is the number of states
number_of_states <- dim(median_sold_price)[1]
median_sold_price <- stack(median_sold_price)$values
median_sold_price <- median_sold_price[(number_of_states*3):length(median_sold_price)]

# Create array of columns names used for dataframe
names <- c('ratio_foreclose', 'inventory_measure','price_to_rent','sold_for_gain',
           'increasing_in_value', 'pct_price_reduced','median_sold_price' )
# Bind all of the features into a dataframe 
housing_dat = as.data.frame(cbind(ratio_foreclose, inventory_measure,price_to_rent,
                                  sold_for_gain,increasing_in_value,pct_price_reduced,median_sold_price))
# Prepare training and testing data
prepared_data <- prepdata(housing_dat, names,normalization = "z", shuffle = TRUE, split = TRUE)
training_input <- as.data.frame(prepared_data[1])
testing_input <- as.data.frame(prepared_data[2])
# Run the model and save th eresults
getpca(prepdata(housing_dat,names, normalization = "mm"), result_path, "PCA-National-1-No-Sold-For-Gain", names)
runmodel(training_input, testing_input, "National-1-No-Sold-For_", "test", result_path)