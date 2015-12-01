# File: Monroe-Model.r
# Contributers: William Hammond
#               Harry Longwell
# Created:  11/22/2015
# Modified: 11/22/2015
#
# Description: This program loads in zillow data for monroe county and creates
#              a neural network used to predict median market value based 
#              off of measures of market health.
source('Model-Functions.r')

data_path <- '../data/county/'
result_path <- '../results/Monroe/'

## Load in response variables

sold_for_gain <- read.csv( file = paste(data_path, 'County_PctOfHomesSellingForGain_AllHomes.csv', sep = ''))
sold_for_gain <- sold_for_gain[sold_for_gain$Metro == 'Rochester',]
sold_for_gain <- t(subset(sold_for_gain, select = X2010.10:X2015.09))
#sold_for_gain <- as.data.frame(approx(sold_for_gain, n = 500)$y)

increasing_in_value <- read.csv ( file = paste(data_path, 'County_PctOfHomesIncreasingInValues_AllHomes.csv', sep =''))
increasing_in_value <- increasing_in_value[increasing_in_value$Metro == 'Rochester',]
increasing_in_value <- increasing_in_value[increasing_in_value$RegionName == 'Monroe',]
increasing_in_value <- t(subset(increasing_in_value, select = X2010.10:X2015.09))
#increasing_in_value <-as.data.frame(approx(increasing_in_value, n = 500)$y)

pct_price_reduced <-read.csv ( file = paste(data_path, 'County_PctOfListingsWithPriceReductions_AllHomes.csv', sep = ''))
pct_price_reduced <- pct_price_reduced[pct_price_reduced$RegionName == 'Monroe',]
pct_price_reduced <- pct_price_reduced[pct_price_reduced$State == 'NY',]
pct_price_reduced <- t(subset(pct_price_reduced, select = X2010.10:X2015.09))
#pct_price_reduced <- as.data.frame(approx(pct_price_reduced, n = 500)$y)

median_pct_price_reduced <-read.csv ( file = paste(data_path, 'County_MedianPctOfPriceReduction_AllHomes.csv', sep = ''))
median_pct_price_reduced <- median_pct_price_reduced[median_pct_price_reduced$RegionName == 'Monroe',]
median_pct_price_reduced <- median_pct_price_reduced[median_pct_price_reduced$State == 'NY',]
median_pct_price_reduced <- t(subset(median_pct_price_reduced, select = X2010.10:X2015.09))
#median_pct_price_reduced <- as.data.frame(approx(median_pct_price_reduced, n = 500)$y)

ratio_foreclose <- read.csv ( file = paste(data_path, 'County_HomesSoldAsForeclosures-Ratio_AllHomes.csv', sep = ''))
ratio_foreclose <- ratio_foreclose [ratio_foreclose$RegionName == 'Monroe',]
ratio_foreclose <- ratio_foreclose [ratio_foreclose$Metro == 'Rochester',]

jpeg(paste(result_path,"Ratio-Sold-AsForeclosure",".jpg", sep = ""))
plot(t(subset(ratio_foreclose, select = X2000.01:X2015.09)), ylab = "Ratio",
     main = "Ratio-Of Homes Sold As Foreclosure Resale", xlab = "01/2000 - 09/2015")
dev.off()

ratio_foreclose <- t(subset(ratio_foreclose, select = X2010.10:X2015.09))
#ratio_foreclose <- as.data.frame(approx(ratio_foreclose, n = 500)$y)

inventory_measure <- read.csv ( file = paste(data_path, 'InventoryMeasure_County_Public.csv', sep = ''))
inventory_measure <- inventory_measure [inventory_measure$CountyName == 'Monroe',]
inventory_measure <- inventory_measure [inventory_measure$Metro == 'Rochester',]
inventory_measure <- t(subset(inventory_measure, select = X2010.10:X2015.09))
#inventory_measure <- as.data.frame(approx(inventory_measure, n = 500)$y)

price_to_rent <- read.csv(file = paste(data_path, 'County_PriceToRentRatio_AllHomes.csv', sep = ''))
price_to_rent <- price_to_rent[price_to_rent$RegionName == 'Monroe',]
price_to_rent <- price_to_rent[price_to_rent$State == 'NY',]
price_to_rent <- t(subset(price_to_rent, select = X2010.10:X2015.09))
#price_to_rent <- as.data.frame(approx(price_to_rent, n = 500)$y)

turnover <- read.csv(file = paste(data_path, 'County_Turnover_AllHomes.csv', sep = ''))
turnover <- turnover[turnover$RegionName == 'Monroe',]
turnover <- turnover[turnover$State == 'NY',]

jpeg(paste(result_path,"Turnover",".jpg", sep = ""))
plot(t(subset(turnover, select = X2000.01:X2015.09)), ylab = "Turnover",
     main = "Turnover", xlab = "01/2000 - 09/2015")
dev.off()

turnover <- t(subset(turnover, select = X2010.10:X2015.09))

# sales <- read.csv(file = paste(data_path, 'Sales_County.csv', sep = ''))
# sales <- sales[sales$RegionName == 'Monroe',]
# sales <- sales[sales$State == 'New York',]
# sales <- t(subset(sales, select = X2010.10:X2015.09))

# Target Variable
median_sold_price <- read.csv( file = paste(data_path, 'County_MedianSoldPrice_AllHomes.csv', sep = ''))
median_sold_price <- median_sold_price[median_sold_price$Metro == 'Rochester',]
median_sold_price <- median_sold_price[median_sold_price$RegionName == 'Monroe',]
median_sold_price <- t(subset(median_sold_price, select = X2010.10:X2015.09))
#median_sold_price <- as.data.frame(approx(median_sold_price, n = 500)$y)

# Create array of columns names used for dataframe
names <- c('price_to_rent','inventory_measure','ratio_foreclosure','sold_for_gain',
           'increasing_in_value', 'pct_price_reduced','median_sold_price','turnover' )
# Bind all of the features into a dataframe 
housing_dat = as.data.frame(cbind(price_to_rent,inventory_measure,ratio_foreclose,
                                  sold_for_gain,increasing_in_value,pct_price_reduced,median_sold_price, turnover))
# Run PCA
getpca(prepdata(housing_dat,names, normalization = "mm"), result_path, "PCA-Monroe-County-1-turnover", names)

# Prepare training and testing data
prepared_data <- prepdata(housing_dat, names, normalization = "z", split = TRUE)
training_input <- as.data.frame(prepared_data[1])
testing_input <- as.data.frame(prepared_data[2])

# Run the model and save the results
runmodel(training_input, testing_input, "Monroe-Future-Accuracy-turnover", "test", result_path)
