# Data Descriptions

### Data from St. Louis FRED Database

|File Name|Description|
|---|---|
|A939RX0Q048SBEA.csv|Real GDP Per Capita|
|APU000074714_AVG_PRICE_PER_GALLON_MONTHLY.csv|Gasoline Average Price Per Gallon|
|CP.csv|Corporate Profits|
|CPIAUCSL.csv|Consumer Price Index|
|DEXCHUS_YUAN_DOLLAR_EXCHANGE_RATE.csv|Yuan-Dollar Exchange Rate|
|DTWEXBGS.csv|Nominal Broad US Dollar Index|
|EFFRVOL.csv|Effective Federal Funds Volume|
|EXPGSC1.csv|Real Exports|
|GASREGW.csv|Gasoline Weekly Average Price Per Gallon|
|GCEC1.csv|Real Government Consumption Expeditures and Gross Investment|
|GDP.csv|Nominal GDP|
|GDPC1.csv|Real GDP|
|GPDPC1.csv|Real Private Investment|
|HOUST.csv|New Housing Starts|
|HSN1F.csv|New Housing Sales - 1 Unit Structures|
|IMPGSC1.csv|Real Imports|
|MORTGAGE30US.csv|30-Year Mortgage Rate|
|MRSSM44x72USS.csv|Retail Sales|
|NASDAQ100.csv|Nasdaq100 Stock Index|
|PCECC96.csv|Real Personal Consumption Expenditures|
|PERMIT.csv|New Housing Permits|
|PERMIT1.csv|New Housing Permits - 1 Unit Structures|
|POP.csv|Population Estimates|
|TRFVOLUSM227NFWA_VEHICLE_MILES_NSA.csv|Monthly Vehicle Miles, Not Seasonally Adjusted|
|TRFVOLUSM227SFWA_VEHICLE_MILES.csv|Monthly Vehicle Miles|
|UNRATENSA.csv|Monthly Unemployment Rate, Not Seasonally Adjusted|
|WILL5000PR.csv|Willshire 5000 Stock Index|
|WTISPLC_SPOT_CRUDE_WTI_MONTHLY.csv|Monthly Oil Price|


### Case-Shiller Home Price Indices
- `CS_INDEX.xls` - Case-Shiller Indices  
- `CS_SALESPAIR.xls` - Home Sales Pair Counts

### Shiller Housing Data
- `atlanta.txt`  
- `chicago.txt`  
- `dallas.txt`  
- `oakland.txt`  

This is data taken from Bob Shiller's [website](http://www.econ.yale.edu/~shiller/data.htm), accessed June 3rd, 2023.

Housing Price Data, used by Karl Case and Robert Shiller in their papers: "Prices of Single-Family Homes since 1970:  New Indexes for Four Cities," New England Economic Review, Sept/Oct 1987 pp. 45-56, and "The Efficiency of the Market for Single Family Homes," American Economic Review 1989.

There are four data files, one for each city.

- Atlanta   8951 observations - 6 0utliers = 8945 obs.  
- Chicago   15344 observations - 14 outliers = 15330 obs.  
- Dallas    6675 observations - 6 outliers = 6669 obs.  
- Oakland (San Francisco area)  8097  obs. - 31 OUTLIERS =  8066 obs.  

Raw data on individual houses are double sales of individual houses. In each row of the matrix, the first observation is the first sale price, the second observation is the second sale price, the third is the quarter of the first sale (1970-1 = 1) and the fourth is the quarter of the second sale. For Atlanta and Dallas, the final zero on the price is omitted, for Chicago and Oakland, the final two zeros on the price are omitted. The order of the observations is not random. The first part of the file consists of observations where the price changes are positive. Then, there follow negative price changes, and finally, after the word @outliers:@, those observations that were judged to be outliers and which were deleted before our data analysis.

The outliers were deleted because the price change appeared to be in error, on no more information than the price change itself.  Often, the price change was in the vicinity of a factor of ten, suggesting a misplaced decimal in the data.

#### Other
- `stocks.csv` - Daily S&P500 Data
- `prison_population.csv` - Taken from [Hyndman's textbook](https://github.com/robjhyndman/fpp3_slides/tree/main/data)