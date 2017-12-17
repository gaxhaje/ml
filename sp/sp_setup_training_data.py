import pandas as pd
import numpy as np
import os
import time
from datetime import datetime, timedelta

from time import mktime
import matplotlib.pyplot as plt
from matplotlib import style
style.use('dark_background')

import re


def key_stats(gather=['Total Debt/Equity',
                      'Trailing P/E',
                      'Price/Sales',
                      'Price/Book',
                      'Profit Margin',
                      'Operating Margin',
                      'Return on Assets',
                      'Return on Equity',
                      'Revenue Per Share',
                      'Market Cap',
                      'Enterprise Value',
                      'Forward P/E',
                      'PEG Ratio',
                      'Enterprise Value/Revenue',
                      'Enterprise Value/EBITDA',
                      'Revenue',
                      'Gross Profit',
                      'EBITDA',
                      'Net Income Avl to Common ',
                      'Diluted EPS',
                      'Earnings Growth',
                      'Revenue Growth',
                      'Total Cash',
                      'Total Cash Per Share',
                      'Total Debt',
                      'Current Ratio',
                      'Book Value Per Share',
                      'Cash Flow',
                      'Beta',
                      'Held by Insiders',
                      'Held by Institutions',
                      'Shares Short (as of',
                      'Short Ratio',
                      'Short % of Float',
                      'Shares Short (prior ']):


  df = pd.DataFrame(columns = ['Date',
                               'Unix',
                               'Ticker',
                               'Price',
                               'stock_p_change',
                               'SP500',
                               'sp500_p_change',
                               'Difference',
                               'DE Ratio',
                               'Trailing P/E',
                               'Price/Sales',
                               'Price/Book',
                               'Profit Margin',
                               'Operating Margin',
                               'Return on Assets',
                               'Return on Equity',
                               'Revenue Per Share',
                               'Market Cap',
                               'Enterprise Value',
                               'Forward P/E',
                               'PEG Ratio',
                               'Enterprise Value/Revenue',
                               'Enterprise Value/EBITDA',
                               'Revenue',
                               'Gross Profit',
                               'EBITDA',
                               'Net Income Avl to Common ',
                               'Diluted EPS',
                               'Earnings Growth',
                               'Revenue Growth',
                               'Total Cash',
                               'Total Cash Per Share',
                               'Total Debt',
                               'Current Ratio',
                               'Book Value Per Share',
                               'Cash Flow',
                               'Beta',
                               'Held by Insiders',
                               'Held by Institutions',
                               'Shares Short (as of',
                               'Short Ratio',
                               'Short % of Float',
                               'Shares Short (prior ',                                
                               'Status'])

  data_df   = df.from_csv('sp500_tickers.csv', index_col = None)
  sp500_df  = pd.DataFrame.from_csv('sp500_index.csv', index_col = None)
  ticker_df = pd.DataFrame.from_csv('sp500_ticker_prices.csv', index_col = None)
  dates_df  = pd.DataFrame.from_csv('sp500_training_dates.csv', index_col = None)
  file_df   = pd.DataFrame.from_csv('sp500_ticker_file_list.csv', index_col = None)

  for index, file_row in file_df.iterrows():
    file       = file_row[0]
    filename   = file.rsplit('/',1)[1]
    ticker     = file.rsplit('/',1)[0].rsplit('/',1)[1].replace('.','_').replace('-','_').upper()
    date_stamp = datetime.strptime(file.rsplit('/',1)[1], '%Y%m%d%H%M%S.html')
    unix_time  = time.mktime(date_stamp.timetuple())
    source     = open(file).read()

    print(ticker)
    
    try:
      value_list = []

      for each_data in gather:
        try:
          regex = re.escape(each_data) + r'.*?(\d{1,8}\.\d{1,8}M?B?|N/A)%?</td>'
          value = re.search(regex, source)
          value = (value.group(1))

          if 'B' in value:
            value = float(value.replace('B', ''))*1000000000
          elif 'M' in value:
            value = float(value.replace('M', ''))*1000000

          value_list.append(value)
        except Exception as e:
          value = 'N/A'
          value_list.append(value)

    except Exception as e:
      pass

    # when we go toards the end we will not have data for the sp500 for one year later
    try:
      date = date_stamp.strftime('%Y-%m-%d')

      # sp500 date and price
      sp500_mask  = (sp500_df['Date'] == date)
      sp500_row   = sp500_df.loc[sp500_mask]
      sp500_price = round(float(sp500_row['Adj Close']), 2)


      #ticker date and time
      ticker_mask  = (ticker_df['Date'] == date)
      ticker_row   = ticker_df.loc[ticker_mask].replace('NaN', '-99999999') # we don't have prices for every date
      ticker_price = round(float(ticker_row[ticker]), 2)

      # get the sp500 row for 'one year later' from the current row
      date_stamp     = datetime.strptime(date, '%Y-%m-%d')
      unix_time      = time.mktime(date_stamp.timetuple())
      one_year_later = int(unix_time + 31536000)

      # if date falls on a weekend switch to the firday before
      one_year_date = datetime.fromtimestamp(one_year_later)
      weekday = one_year_date.strftime('%A')

      if (weekday == 'Saturday'):
        one_year_date =  one_year_date - timedelta(days=1)
      if (weekday == 'Sunday'):
        one_year_date = one_year_date - timedelta(days=2)

      # sp500 price one year from current date
      sp500_date_1y  = one_year_date.strftime('%Y-%m-%d')
      sp500_mask_1y  = (sp500_df['Date'] == sp500_date_1y)
      sp500_row_1y   = sp500_df.loc[sp500_mask_1y]
      raw            = sp500_row_1y['Adj Close']
      sp500_price_1y = -99999999 if raw.empty else round(float(raw), 2)


      # ticker price one year from current date
      ticker_mask_1y  = (ticker_df['Date'] == sp500_date_1y)
      ticker_row_1y   = ticker_df.loc[ticker_mask_1y].replace('NaN', '-99999999') # we don't have prices for every date
      ticker_price_1y = round(float(ticker_row_1y[ticker]), 2)

      # calculate the price change and difference
      ticker_p_change = round((((ticker_price_1y - ticker_price) / ticker_price) * 100), 2)
      sp500_p_change  = round((((sp500_price_1y - sp500_price) / sp500_price) * 100), 2)
      difference      = round(ticker_p_change - sp500_p_change, 2)

      if difference > 5: # outperforms by greater than 5%
        status = 1 # outperform
      else:
        status = 0 # underperform

      # append data
      if value_list.count('N/A') > 3:
        pass
      else:
        df = df.append({'Date':date_stamp,
                        'Unix':unix_time,
                        'Ticker':ticker,
                        'Price':ticker_price,
                        'stock_p_change':ticker_p_change,
                        'SP500':sp500_price,
                        'sp500_p_change':sp500_p_change,
                        'Difference':difference,
                        'DE Ratio':value_list[0],
                        'Trailing P/E':value_list[1],
                        'Price/Sales':value_list[2],
                        'Price/Book':value_list[3],
                        'Profit Margin':value_list[4],
                        'Operating Margin':value_list[5],
                        'Return on Assets':value_list[6],
                        'Return on Equity':value_list[7],
                        'Revenue Per Share':value_list[8],
                        'Market Cap':value_list[9],
                        'Enterprise Value':value_list[10],
                        'Forward P/E':value_list[11],
                        'PEG Ratio':value_list[12],
                        'Enterprise Value/Revenue':value_list[13],
                        'Enterprise Value/EBITDA':value_list[14],
                        'Revenue':value_list[15],
                        'Gross Profit':value_list[16],
                        'EBITDA':value_list[17],
                        'Net Income Avl to Common ':value_list[18],
                        'Diluted EPS':value_list[19],
                        'Earnings Growth':value_list[20],
                        'Revenue Growth':value_list[21],
                        'Total Cash':value_list[22],
                        'Total Cash Per Share':value_list[23],
                        'Total Debt':value_list[24],
                        'Current Ratio':value_list[25],
                        'Book Value Per Share':value_list[26],
                        'Cash Flow':value_list[27],
                        'Beta':value_list[28],
                        'Held by Insiders':value_list[29],
                        'Held by Institutions':value_list[30],
                        'Shares Short (as of':value_list[31],
                        'Short Ratio':value_list[32],
                        'Short % of Float':value_list[33],
                        'Shares Short (prior ':value_list[34],
                        'Status':status},
                        ignore_index=True)


    except Exception as e:
      pass # we do not date into the future when start reaching the end of the sp500 file.

  # write out data
  df.to_csv('key_stats_acc_NO_NA_5_percent_better.csv', index = False)

key_stats()