# file:
# Contributers: William Hammond
#               Harry Longwell
# Created: 11/19/2015
# Modified: 11/19/2015

data_path <- '../data/'

## Load in response variables

sold_for_gain <- read.csv( file = paste(data_path, 'County_PctOfHomesSellingForGain_AllHomes.csv', sep = ''))
sold_for_gain <- sold_for_gain[sold_for_gain$Metro == 'Rochester',]
sold_for_gain <- t(sold_for_gain[,108:183])

increasing_in_value <- read.csv ( file = paste(data_path, 'County_PctOfHomesIncreasingInValues_AllHomes.csv', sep =''))
increasing_in_value <- increasing_in_value[increasing_in_value$Metro == 'Rochester',]
increasing_in_value <- t(increasing_in_value[,108:183])

# Target Variable
median_sold_price <- read.csv( file = paste(data_path, 'County_MedianSoldPrice_AllHomes.csv', sep = ''))
median_sold_price <- median_sold_price[median_sold_price$Metro == 'Rochester',]
median_sold_price <- median_sold_price[median_sold_price$RegionName == 'Monroe',]
median_sold_price <- t(median_sold_price[,108:183])