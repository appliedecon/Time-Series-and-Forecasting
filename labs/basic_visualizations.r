# load packages
suppressMessages(library(fable))
suppressMessages(library(tsibble))
suppressMessages(library(scales))
suppressMessages(library(feasts))
suppressMessages(library(forecast))
suppressMessages(library(tidyverse))

# import file
df <- read.csv('PAYNSA.csv')
df %>% head()

# change data from a dataframe to a time series object
employment <- df %>%
mutate(DATE = yearmonth(as.Date(DATE))) %>%
as_tsibble(index=DATE)

employment %>% head()

# basic plot
employment %>% autoplot() + labs(title='Total Employment', x='', y='Employment (in ths.)')

# seasonal plot
employment %>% 
mutate(logEmployment = log(PAYNSA)) %>%
mutate(diffLog = difference(logEmployment)) %>%
gg_season(diffLog) +
labs(title='Seasonal Chart for Total Employment', x='', y='Log Differences')