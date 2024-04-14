# Final Project

## Description
You can choose various items you forecast using the data. You will need to produce out-of-sample forecasts for the next 12 months. You must choose one of the following options:

1. Using aggregated data, produce forecasts for four (4) different metrics. **You can use any of the metrics for this option. You will need to accurately calculate the national aggregates for the metrics - if using non-count metrics, you’ll need to calculate weighted averages.**
2. Using data aggregated at the state, produce forecasts for one (1) metric that is based on counts (so it can be aggregated) for each state, including the national aggregate using the bottoms-up method. Compare your national forecast against one you create for that metric strictly at the national level. **You can only use the metrics that are counts for this option.**
3. Produce forecasts at the county level for MD, VA, PA, DE, and NJ. Use a variety of techniques to forecast one metric for the county, state, and five-state aggregate. **You can only use the metrics that are counts for this option.**

## What Should be Included
- Presentation (PDF)
- Code with comments and output, or a Juypter Notebook containing the code and narrative.

## Evaluation
- 30% Overall Professionalism of Presentation
- 20% Data Analysis, including visualizations
- 50% Rigor of your forecasts

## Data Source
Data originally comes from the [National Association of Realtors](https://www.realtor.com/research/data/).

Data should be attributed to Realtor.com® Economic Research.

## Data Dictionary

|Column|Logical|Description|
|---|---|---|
|month_date_yyyy_mm|	Month Date|	Monthly date in a YYYYMM format.|
|county_name|	County Name|	The of the county.|
|active_listing_count	|Active Listing Count|	The count of active listings within the specified geography during the specified month. The active listing count tracks the number of for sale properties on the market, excluding pending listings where a pending status is available. This is a snapshot measure of how many active listings can be expected on any given day of the specified month.|
|average_listing_price|	Avg Listing Price|	The average listing price within the specified geography during the specified month.|
|median_listing_price_per_square_foot|	Median List Price Per Sqft|	The median listing price per square foot within the specified geography during te specified month.|
|median_listing_price	|Median Listing Price|	The median listing price within the specified geography during the specified month.|
|median_square_feet	|Median Listing Sqft	|The median listing square feet within the specified geography during the specified month.|
|new_listing_count	|New Listing |	The count of new listings added to the market within the specified geography. The new listing count represents a typical week’s worth of new listings in a given month. The new listing count can be multiplied by the number of weeks in a month to produce a monthly new listing count.|
|pending_listing_count|	Pending Listing Count	|The count of pending listings within the specified geography during the specified month, if a pending definition is available for that geography. This is a snapshot measure of how many pending listings can be expected on any given day of the specified month.|
|total_listing_count|	Total Listing Count	|The total of both active listings and pending listings within the specified geography during the specified month. This is a snapshot measure of how many total listings can be expected on any given day of the specified month.|
