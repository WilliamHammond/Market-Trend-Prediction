# file:
# Contributers: William Hammond
#               Harry Longwell
# Created: 11/19/2015
# Modified: 11/19/2015
library(nnet)
library(neuralnet)

data_path <- '../data/'

## Load in response variables

sold_for_gain <- read.csv( file = paste(data_path, 'County_PctOfHomesSellingForGain_AllHomes.csv', sep = ''))
sold_for_gain <- sold_for_gain[sold_for_gain$Metro == 'Rochester',]
sold_for_gain <- t(subset(sold_for_gain, select = X2010.10:X2015.09))

increasing_in_value <- read.csv ( file = paste(data_path, 'County_PctOfHomesIncreasingInValues_AllHomes.csv', sep =''))
increasing_in_value <- increasing_in_value[increasing_in_value$Metro == 'Rochester',]
increasing_in_value <- increasing_in_value[increasing_in_value$RegionName == 'Monroe',]
increasing_in_value <- t(subset(increasing_in_value, select = X2010.10:X2015.09))

pct_price_reduced <-read.csv ( file = paste(data_path, 'County_PctOfListingsWithPriceReductions_AllHomes.csv', sep = ''))
pct_price_reduced <- pct_price_reduced[pct_price_reduced$RegionName == 'Monroe',]
pct_price_reduced <- pct_price_reduced[pct_price_reduced$State == 'NY',]
pct_price_reduced <- t(subset(pct_price_reduced, select = X2010.10:X2015.09))

median_pct_price_reduced <-read.csv ( file = paste(data_path, 'County_MedianPctOfPriceReduction_AllHomes.csv', sep = ''))
median_pct_price_reduced <- median_pct_price_reduced[median_pct_price_reduced$RegionName == 'Monroe',]
median_pct_price_reduced <- median_pct_price_reduced[median_pct_price_reduced$State == 'NY',]
median_pct_price_reduced <- t(subset(median_pct_price_reduced, select = X2010.10:X2015.09))

ratio_foreclose <- read.csv ( file = paste(data_path, 'County_HomesSoldAsForeclosures-Ratio_AllHomes.csv', sep = ''))
ratio_foreclose <- ratio_foreclose [ratio_foreclose$RegionName == 'Monroe',]
ratio_foreclose <- ratio_foreclose [ratio_foreclose$Metro == 'Rochester',]
ratio_foreclose <- t(subset(ratio_foreclose, select = X2010.10:X2015.09))

inventory_measure <- read.csv ( file = paste(data_path, 'InventoryMeasure_County_Public.csv', sep = ''))
inventory_measure <- inventory_measure [inventory_measure$CountyName == 'Monroe',]
inventory_measure <- inventory_measure [inventory_measure$Metro == 'Rochester',]
inventory_measure <- t(subset(inventory_measure, select = X2010.10:X2015.09))

price_to_rent = read.csv(file = paste(data_path, 'County_PriceToRentRatio_AllHomes.csv', sep = ''))
price_to_rent <- price_to_rent[price_to_rent$RegionName == 'Monroe',]
price_to_rent <- price_to_rent[price_to_rent$State == 'NY',]
price_to_rent <- t(subset(price_to_rent, select = X2010.10:X2015.09))


# Target Variable
median_sold_price <- read.csv( file = paste(data_path, 'County_MedianSoldPrice_AllHomes.csv', sep = ''))
median_sold_price <- median_sold_price[median_sold_price$Metro == 'Rochester',]
median_sold_price <- median_sold_price[median_sold_price$RegionName == 'Monroe',]
median_sold_price <- t(subset(median_sold_price, select = X2010.10:X2015.09))

names <- c('ratio_foreclose', 'inventory_measure','price_to_rent','sold_for_gain',
           'increasing_in_value', 'pct_price_reduced','median_sold_price' )
housing_dat = as.data.frame(cbind(ratio_foreclose, inventory_measure,price_to_rent,
                    sold_for_gain,increasing_in_value,pct_price_reduced,median_sold_price))
colnames(housing_dat) <- names

