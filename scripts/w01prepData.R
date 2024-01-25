suppressMessages(library(tidyverse))
suppressMessages(library(lubridate))

if(Sys.info()['sysname'] == 'Windows') {
  dataPath <- 'C:/Users/chris/OneDrive/Documents/Time Series/time-series-scratch/data/'
  } else{dataPath <- '/Users/christophermcgraw/desktop/time-series-scratch/data/'}

# remove NAs, correct datatypes, find last obs. per month, convert to ts object
nasdaq <- read.csv(paste(dataPath,'nasdaq100.csv',sep=''))
nasdaq <- nasdaq %>%
  filter(NASDAQ100 != '.') %>%
  mutate(DATE = as.Date(DATE), NASDAQ100 = as.numeric(NASDAQ100)) %>%
  mutate(MDT = floor_date(DATE, 'month')) %>%
  group_by(MDT) %>%
  arrange(desc(DATE)) %>%
  mutate(INDEX = row_number()) %>%
  ungroup() %>%
  filter(INDEX == 1, DATE < as.Date('2023-08-01')) %>%
  select(MDT, NASDAQ100) %>%
  arrange(MDT)

nasdaq100 <- ts(nasdaq$NASDAQ100, start=c(1986,1), frequency = 12)
