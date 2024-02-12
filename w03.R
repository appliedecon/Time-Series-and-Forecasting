# Load libraries
# Hint: Rename suppressMessages() to see information the packages are providing
suppressMessages(library(fable))
suppressMessages(library(forecast))
suppressMessages(library(tsibble))
suppressMessages(library(tidyverse))
suppressMessages(library(fabletools))
suppressMessages(library(feasts))
suppressMessages(library(lubridate))
suppressMessages(library(scales))
suppressMessages(library(fpp3))
suppressMessages(library(gridExtra))

###########################
# Adjusted Number of Days #
###########################

fedVolume <- read.csv('data/EFFRVOL.csv')

fedVolumeMonthly <- fedVolume %>%
  filter(EFFRVOL != '.') %>%
  mutate(mdt = floor_date(ymd(DATE),'month')) %>%
  group_by(mdt) %>%
  summarise(Volume=sum(as.numeric(EFFRVOL)), Days=n(), .groups='drop') %>%
  mutate(AverageDaily = Volume/Days) %>%
  as_tsibble(index='mdt') %>%
  filter_index(. ~ "2023 Sep")

# Plot the time series of volume
fed_volume_plot <- fedVolumeMonthly %>% autoplot(Volume) +
  ggtitle('Monthly Effective Federal Funds Volume') +
  ylab('Billions of Dollars') +
  scale_y_continuous(label=scales::dollar_format())


fed_volume_plot

# Plot the differences in days per month
fedVolumeMonthly %>% autoplot(Days) +
  ggtitle('Volume Days Per Month') + ylab('Days')

# Variation in the number of days per month
pct <- (23/19 - 1)*100
paste('Range variation: ', round(pct, 2), '%', sep='')

# Plot the raw and adjusted data
avgDays <- mean(fedVolumeMonthly$Days)

ggplot(fedVolumeMonthly) +
  geom_line(aes(x= mdt, y= Volume), color = 'dodgerblue') +
  geom_line(aes(x= mdt, y = AverageDaily*avgDays), stat = 'identity') + 
  ylab('Monthly') +
  scale_y_continuous(sec.axis = sec_axis(~., name = 'Grossed Daily')) +
  xlab('') +
  ggtitle('Monthly Volume vs. Grossed Average Daily Volume') +
  theme(axis.text.y.left = element_text(colour = "blue"), 
        axis.title.y.left = element_text(colour="blue")
  )

##########################
# Population Adjustments #
##########################

# GDP
gdp <- read.csv('data/gdpc1.csv')
gdp_capita <- read.csv('data/A939RX0Q048SBEA.csv')

gdp <- gdp %>% mutate(DATE = as.Date(DATE)) %>% as_tsibble(index=DATE)
gdp_capita <- gdp_capita %>% mutate(DATE = as.Date(DATE)) %>% as_tsibble(index=DATE)

gdp %>% autoplot(GDPC1) + ylab('Billions of Dollars') + ggtitle('Real Gross Domestic Product, Seasonally Adjusted Annual Rate')
ggsave(paste(plot_prefix, 'gdp.png', sep=''), width=6, height=4)

# GDP per capita
gdp_capita %>% autoplot(A939RX0Q048SBEA) + ylab('Dollar per Capita') + ggtitle('Real Gross Domestic Product Per Capita')
ggsave(paste(plot_prefix, 'gdp_capital.png', sep=''), width=6, height=4)

###############
# Real Prices #
###############

# CPI Trends
cpi <- read.csv('data/CPIAUCSL.csv')

cpi <- cpi %>%
  mutate(mdt = floor_date(ymd(DATE),'month')) %>%
  as_tsibble(index='mdt')

cpi_plot <- cpi %>% autoplot(CPIAUCSL) +
  ggtitle('Consumer Price Index (aka Inflation)') +
  ylab('Index')

# Gas Prices
gas <- read.csv('data/GASREGW.csv')

gas <- gas %>%
  filter(GASREGW != ".") %>%
  mutate(gas_price = as.numeric(GASREGW)) %>%
  select(-GASREGW) %>%
  mutate(DATE = ymd(DATE)) %>%
  as_tsibble(index='DATE')

gas_plot <- gas %>% autoplot(gas_price) +
  ggtitle('All Formulations Gas Price') +
  ylab('Price per Gallon')

# Aggregate gas prices from weekly to monthly
cpi_m <- cpi %>% as_tsibble(index=mdt) %>% select(-DATE)

monthly_gas <- gas %>%
  mutate(mdt = floor_date(DATE, 'month')) %>%
  arrange(mdt, desc(DATE)) %>%
  group_by(mdt) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  arrange(mdt) %>% as_tsibble(index=mdt) %>%
  select(-DATE) %>%
  left_join(cpi_m) %>%
  rename(cpi = CPIAUCSL) %>%
  filter(!is.na(gas_price),!is.na(cpi)) %>%
  mutate(first_cpi = first(cpi)) %>%
  mutate(real_price = gas_price / cpi * first_cpi)

# Plot nominal and real prices
ggplot(monthly_gas) +
  geom_line(aes(x=mdt, y=gas_price),color='purple') +
  geom_line(aes(x=mdt, y=real_price),color='blue') +
  scale_y_continuous(sec.axis = sec_axis(~., name = 'Real Price, in 1990 Dollars')) +
  xlab('') +
  ylab('Nominal') + 
  ggtitle('Nominal vs. Real Gas Prices') +
  theme(axis.text.y.left = element_text(colour = "purple"), 
        axis.title.y.left = element_text(colour="purple"),
        axis.text.y.right = element_text(colour = "blue"), 
        axis.title.y.right = element_text(colour="blue"),   
  )

#########################
# Basic Transformations #
#########################

# Mathematical
food <- aus_retail |>
  filter(Industry == "Food retailing") |>
  summarise(Turnover = sum(Turnover))

f1 <- food %>% autoplot(Turnover)

f2 <- food |> autoplot(sqrt(Turnover)) +
  labs(y = "Square root turnover")

f3 <- food |> mutate(Turnover3c = Turnover^(1/3)) |> autoplot(Turnover3c) +
  labs(y = "Cube root turnover")

f4 <- food |> autoplot(log(Turnover)) +
  labs(y = "Log turnover")

g <- arrangeGrob(f1, f2, f3, f4, ncol=2)
g

# Box-Cox
b1 <- food %>% autoplot(Turnover) + ggtitle('Base Series') + labs(y='Turnover')

b2 <- food |> autoplot(box_cox(Turnover, 0)) + ggtitle('Lambda = 0') +
  labs(y = "Turnover")

b3 <- food |> autoplot(box_cox(Turnover, 0.5)) + ggtitle('Lambda = 0.5') +
  labs(y = "Turnover")

b4 <- food |> autoplot(box_cox(Turnover, 0.9)) + ggtitle('Lambda = 0.9') +
  labs(y = "Turnover")

gf <- arrangeGrob(b1, b2, b3, b4, ncol=2)
gf

###############################
# Additive and Multiplicative #
###############################

# Unemployment Rate
unrate <- read.csv('data/unratensa.csv')
unrate <- unrate %>% mutate(DATE = as.Date(DATE)) %>% as_tsibble(index=DATE)
unrate %>% autoplot(UNRATENSA) + ggtitle('Unemployment Rate') + ylab('Percent') +
  theme(plot.title = element_text(size=8))

# GDP
gdp %>% autoplot(GDPC1) + ylab('Billions of Dollars') + ggtitle('Real Gross Domestic Product, SAAR') +
  theme(plot.title = element_text(size=8))

###################
# Moving Averages #
###################

data("AirPassengers")
ap <- AirPassengers %>% as_tsibble()
names(ap) <- c('Month', 'Passengers')

# Calculate various MAs
apma <- ap %>%
  mutate(`5-MA` = slider::slide_dbl(Passengers, mean, .before=2, .after=2, .complete=TRUE)) %>%
  mutate(`12-MA` = slider::slide_dbl(Passengers, mean, .before=6, .after=5, .complete=TRUE)) %>%
  mutate(`25-MA` = slider::slide_dbl(Passengers, mean, .before=12, .after=12, .complete=TRUE))

# Plot air passengers
apma %>% autoplot(Passengers)

# Plot with various moving averages
ggplot() +
  geom_line(data=apma, aes(x=Month, y=Passengers, colour = "Passengers")) +
  geom_line(data=apma, aes(x=Month, y=`5-MA`, colour = "5-M Moving Average")) +
  geom_line(data=apma, aes(x=Month, y=`12-MA`, colour = "12-M Moving Average")) +
  labs(y="Air Passengers", title="Air Passengers") +
  guides(colour = guide_legend(title='Series'))

f1 <- apma %>% autoplot(Passengers)
f2 <- apma %>% autoplot(`5-MA`)
f3 <- apma %>% autoplot(`12-MA`)
f4 <- apma %>% autoplot(`25-MA`)

g <- arrangeGrob(f1, f2, f3, f4, ncol=2)
g

######################################
# Moving Averages of Moving Averages #
######################################

apma <- apma %>%
  mutate(`2x12-MA` = slider::slide_dbl(`12-MA`, mean, .before=1, .after=0, .complete=TRUE))

ggplot() +
  geom_line(data=apma, aes(x=Month, y=Passengers, colour = "Passengers")) +
  geom_line(data=apma, aes(x=Month, y=`12-MA`, colour = "12-M Moving Average")) +
  geom_line(data=apma, aes(x=Month, y=`2x12-MA`, colour = "2x12-M Moving Average")) +
  labs(y="Air Passengers", title="Air Passengers") +
  guides(colour = guide_legend(title='Series'))

apma <- apma %>%
  mutate(Chg = difference(log(Passengers))) %>%
  mutate(`12-MA Chg` = slider::slide_dbl(Chg, mean, .before=6, .after=5, .complete=TRUE)) %>%
  mutate(`2x12-MA Chg` = slider::slide_dbl(`12-MA Chg`, mean, .before=1, .after=0, .complete=TRUE))

# Based on the differenced data
ggplot() +
  geom_line(data=apma, aes(x=Month, y=Chg, colour = "Passengers")) +
  geom_line(data=apma, aes(x=Month, y=`12-MA Chg`, colour = "12-M Moving Average")) +
  geom_line(data=apma, aes(x=Month, y=`2x12-MA Chg`, colour = "2x12-M Moving Average")) +
  labs(y="Change in Log Air Passengers", title="Air Passengers") +
  guides(colour = guide_legend(title='Series'))

###########################
# Classical Decomposition #
###########################

# Decomp on Air Passengers
ap_cl <- ap %>% model(stl = classical_decomposition(Passengers, type='multiplicative'))

components(ap_cl) |> autoplot() + ggtitle('Classical Decomposition on Passengers')

# Decomp on Log Air Passengers
ap_cl <- ap %>% model(stl = classical_decomposition(log(Passengers), type='additive'))
components(ap_cl) |> autoplot() + ggtitle('Classical Decomposition on Log Passengers')

# Decomp on Log Differenced
lap_cl <- ap %>% mutate(logchg = difference(log(Passengers))) %>% model(stl = classical_decomposition(logchg))
components(lap_cl) |> autoplot(logchg) + ggtitle('Classical Decomposition on Differenced Log Passengers')

#######
# STL #
#######

ap_dc <- ap %>% model(stl = STL(Passengers))
components(ap_dc) |> autoplot() + ggtitle('STL on Passengers')

# Log Air Passengers
logap_dc <- ap %>% model(stl = STL(log(Passengers)))
components(logap_dc) |> autoplot() + ggtitle('STL on Log(Passengers)')

# Rescaling to compare seasonal adjustments
ap_dc_comp <- components(ap_dc) |> as_tsibble()
log_dc_comp <- components(logap_dc) |> as_tsibble() %>% mutate(exp_seasadj = exp(season_adjust))

ggplot() +
  geom_line(data=ap, aes(x=Month, y=Passengers, colour = "Raw Series")) +
  geom_line(data=ap_dc_comp, aes(x=Month, y=season_adjust, colour = "Additive")) +
  geom_line(data=log_dc_comp, aes(x=Month, y=exp_seasadj, colour ='Log Additive')) +
  guides(colour=guide_legend(title="")) 

# Comparing ACFs
ap_dc_comp %>% ACF(diff(season_adjust), lag_max = 48) %>% autoplot()
log_dc_comp %>% ACF(diff(exp_seasadj), lag_max=48) %>% autoplot()

####################################
# Model-based Seasonal Adjustments #
####################################

library(feasts)
library(seasonal)


fit <- ap %>%
  model(X_13ARIMA_SEATS(Passengers))

seasonal_comp <- components(fit)
seasonal_adj <- seasonal_comp %>% select(-`.model`)

# Create trend model to add to the plot
linear_trend_model_sa <- seasonal_adj %>% model(TSLM(season_adjust ~ trend()))
report(linear_trend_model_sa)

linear_trend_model_sa %>% gg_tsresiduals()

sa_trend <- fitted(linear_trend_model_sa)$.fitted

autoplot(ap, Passengers) + ggtitle('Air Passengers (Training Data 1949-1958)') +
  autolayer(seasonal_adj, season_adjust, col='red') +
  geom_line(aes(y=sa_trend), color='red', linetype='dashed')

# Comparing adjusted series
ggplot() +
  geom_line(data=seasonal_adj, aes(Month,season_adjust, colour='X13'))+
  geom_line(data=ap_dc_comp, aes(x=Month, y=season_adjust, colour = "Additive")) +
  geom_line(data=log_dc_comp, aes(x=Month, y=exp_seasadj, colour ='Log Additive')) +
  ylab('Air Passengers') +
  guides(colour=guide_legend(title="")) +
  ggtitle('Seasonal Adjustment Comparison')

# ACF on adjusted series
seasonal_adj %>% ACF(diff(season_adjust)) %>% autoplot()

