import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm, preprocessing
import pandas as pd
import statistics
from collections import Counter

how_much_better = 10

FEATURES =  ['DE Ratio',
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
             'Shares Short (prior ']


def status_calc(stock, sp500):
  difference = stock - sp500
  if difference > how_much_better:
    return 1
  else:
    return 0


def build_data_set(features=FEATURES):
  df = pd.DataFrame.from_csv('key_stats_acc_NO_NA_5_percent_better.csv', index_col = None)
  df = df.reindex(np.random.permutation(df.index))
  df = df.replace('NaN',0).replace('N/A',0)

  df['Status_2'] = list(map(status_calc, df['stock_p_change'], df['sp500_p_change']))

  X = np.array(df[FEATURES].values)
  # y = (df['Status'].values)
  y = (df['Status_2'].values)

  X = preprocessing.scale(X)

  Z = np.array(df[['stock_p_change','sp500_p_change']])

  return X,y,Z


def analysis():
  X, y, Z        = build_data_set()
  test_size      = 100
  invest_amount  = 10000
  total_invested = 0
  if_market      = 0
  if_strat       = 0

  # print(len(X))

  clf = svm.SVC(kernel='linear', C=1.0)
  clf.fit(X[:-test_size], y[:-test_size])

  correct_count = 0

  for x in range(1, test_size+1):
    if clf.predict([X[-x]])[0] == y[-x]:
      correct_count += 1

    if clf.predict([X[-x]])[0] == 1:
      invest_return = invest_amount + (invest_amount * (Z[-x][0]/100)) # 0th stock_p_change
      market_return = invest_amount + (invest_amount * (Z[-x][1]/100)) # 1st sp500_p_change 
      total_invested += 1
      if_market += market_return
      if_strat  += invest_return

  accuracy = (correct_count/test_size) * 100.00

  # print('------------Training Model--------------')
  # print('Sample size {}'.format(len(X)))
  print('Accuracy', accuracy)
  # print('Total Trades:', total_invested)
  # print('Ending with Strategy:', if_strat)
  # print('Ending with Market:', if_market)

  # compared   = ((if_strat - if_market) / if_market) * 100
  # do_nothing = total_invested * invest_amount
  # avg_market = ((if_market - do_nothing) / do_nothing) * 100
  # avg_strat  = ((if_strat - do_nothing) / do_nothing) * 100

  # print('Compared to market, we earn', str(compared) + '% more')
  # print('Average investment return ', str(avg_strat) + '%')
  # print('Average market return ', str(avg_market) + '%')

  # make investments on forward data based on our predictins above
  data_df = pd.DataFrame.from_csv('forward_NO_NA.csv')
  data_df = data_df.replace('N/A',0).replace('NaN',0)


  X = np.array(data_df[FEATURES].values)
  X = preprocessing.scale(X)
  Z = data_df['Ticker'].values.tolist()

  invest_list = []

  for i in range(len(X)):
    p = clf.predict([X[i]])[0]
    if p == 1:
      invest_list.append(Z[i])

  # llen  = len(invest_list)
  # print('\n--------------- Potential investments based on training model ----------------')
  # print('{} to invest in with an accuracy of {}% for a potential profit'.format(llen, accuracy))
  # print(invest_list)

  return invest_list


## run prediction loop
final_list = []

loops = 15

for x in range(loops):
  stock_list = analysis()
  for e in stock_list:
    final_list.append(e)

x = Counter(final_list)

print(15*'_')
print(x)
for each in x:
  if x[each] > (loops - (loops / 8)):
    print(each)
