'''
This program processed the raw data in the processed_data folder
'''

import json
import pandas as pd
import re
import datetime

today_dt = datetime.date.today().strftime('%Y%m%d')

'''
Get the list of valid city files
'''
vld_cities = open('config/cities.json')
vld_cities = json.load(vld_cities)
cities = vld_cities['city_list']

def process_file(fl):
    with open(fl, 'r') as f:
        dat = f.readlines()

    '''
    Remove any leading/trailing spaces and replace multiple spaces
    '''
    dat = [re.sub('\s+', ' ', x.strip()).split() for x in dat]

    '''
    Push to a dataframe and set correct types
    '''
    df = pd.DataFrame(dat, columns = ['price_0', 'price_t', 'qtr_0', 'qtr_t'])
    df[['price_0', 'price_t']] = df[['price_0', 'price_t']].apply(pd.to_numeric)

    return df


city_dfs = {}
for city in cities:
    city_dfs[city] = process_file(f'raw_data/{city}.txt')

city_df = pd.concat(city_dfs)
city_df = city_df.reset_index()
city_df = city_df.rename(columns = {'level_0':'city', 'level_1': 'city_obsn'})

city_df.to_pickle(f'processed_data/{today_dt}')
print('Output saved.')