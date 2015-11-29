# File: Monroe-Model.r
# Contributers: William Hammond
#               Harry Longwell
# Created:  11/22/2015
# Modified: 11/22/2015
#
# Description: This program loads in zillow data for California State and creates
#              a neural network used to predict median market value based 
#              off of measures of market health.

source('model.r')

data_path <- '../data/state/'
result_path <- '../results/California/'

## Load in response variables''
sold_for_gain <- read.csv( file = paste(data_path, 'State_PctOfHomesSellingForGain_AllHomes.csv', sep = ''))
sold_for_gain <- sold_for_gain[sold_for_gain$RegionName == 'California',]
sold_for_gain <- t(subset(sold_for_gain, select = X2010.10:X2015.09))

increasing_in_value <- read.csv ( file = paste(data_path, 'State_PctOfHomesIncreasingInValues_AllHomes.csv', sep =''))
increasing_in_value <- increasing_in_value[increasing_in_value$RegionName == 'California',]
increasing_in_value <- t(subset(increasing_in_value, select = X2010.10:X2015.09))

pct_price_reduced <-read.csv ( file = paste(data_path, 'State_PctOfListingsWithPriceReductions_AllHomes.csv', sep = ''))
pct_price_reduced <- pct_price_reduced[pct_price_reduced$RegionName == 'California',]
pct_price_reduced <- t(subset(pct_price_reduced, select = X2010.10:X2015.09))

median_pct_price_reduced <-read.csv ( file = paste(data_path, 'State_MedianPctOfPriceReduction_AllHomes.csv', sep = ''))
median_pct_price_reduced <- median_pct_price_reduced[median_pct_price_reduced$RegionName == 'California',]
median_pct_price_reduced <- t(subset(median_pct_price_reduced, select = X2010.10:X2015.09))

ratio_foreclose <- read.csv ( file = paste(data_path, 'State_HomesSoldAsForeclosures-Ratio_AllHomes.csv', sep = ''))
ratio_foreclose <- ratio_foreclose [ratio_foreclose$RegionName == 'California',]
ratio_foreclose <- t(subset(ratio_foreclose, select = X2010.10:X2015.09))

inventory_measure <- read.csv ( file = paste(data_path, 'InventoryMeasure_State_Public.csv', sep = ''))
inventory_measure <- inventory_measure [inventory_measure$RegionName == 'California',]
inventory_measure <- t(subset(inventory_measure, select = X2010.10:X2015.09))

price_to_rent = read.csv(file = paste(data_path, 'State_PriceToRentRatio_AllHomes.csv', sep = ''))
price_to_rent <- price_to_rent[price_to_rent$RegionName == 'California',]
price_to_rent <- t(subset(price_to_rent, select = X2010.10:X2015.09))

# Target Variable
median_sold_price <- read.csv( file = paste(data_path, 'State_MedianSoldPrice_AllHomes.csv', sep = ''))
median_sold_price <- median_sold_price[median_sold_price$RegionName == 'Kentucky',]
median_sold_price <- t(subset(median_sold_price, select = X2010.10:X2015.09))

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
runmodel(training_input, testing_input, "California-Future-Accuracy", "test", result_path)