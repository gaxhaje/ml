import pandas as pd
import os
import quandl

quandl.ApiConfig.api_key = open('auth_token.txt', 'r').read()


def stock_price():
  df = pd.DataFrame()
  data = df.from_csv('sp500_tickers.csv', index_col=None)

  for index, ticker_row in data.iterrows():
    try:
      ticker = ticker_row[0].replace('.','_')
      print(ticker)
      name = 'WIKI/'+ticker
      data = quandl.get(name,
                        start_date='2003-12-12',
                        end_date='2015-12-1',
                        column_index=11)  # grab only 'Adj. Close'
      data[ticker] = data['Adj. Close']
      df = pd.concat([df, data[ticker]], axis=1)
    except Exception as e:
      print(str(e))

  df.to_csv('stock_prices.csv')

stock_price()