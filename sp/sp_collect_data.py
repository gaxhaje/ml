import pandas as pd
import os
from datetime import datetime
import csv
import time

path = 'intraQuarter/_KeyStats'

def collect_dates():
  stock_list = os.listdir(path)
  stock_list = sorted(stock_list)
  df = pd.DataFrame()
  ticker_df = pd.DataFrame()
  tickers = []

  for ticker in stock_list:
    print(ticker)
    tickers.append(ticker.upper().replace('.','_').replace('-','_'))
    each_file = os.listdir(path + '/' + ticker)

    dates = []
    for file in each_file:
      date_stamp = datetime.strptime(file, '%Y%m%d%H%M%S.html')  
      dates.append(date_stamp.strftime('%Y-%m-%d'))

    df[ticker.upper().replace('.','_').replace('-','_')] = pd.Series(dates)
  
  df.to_csv('sp500_training_dates.csv', index = False)
  ticker_df['Ticker'] = pd.Series(tickers) 
  ticker_df.to_csv('sp500_tickers.csv', index = False)

collect_dates()