import urllib.request
import pandas as pd
import time

path = './intraQuarter'

def check_yahoo():
  df = pd.DataFrame()
  # statspath = path + '/_KeyStats'
  # stock_list = [x[0] for x in os.walk(statspath)]
  data = df.from_csv('sp500_tickers.csv', index_col=None)
  stock_list = sorted(data['Ticker'].values)

  for e in stock_list:
    try:
      link = 'https://finance.yahoo.com/quote/'+e+'/key-statistics?p='+e
      resp = urllib.request.urlopen(link).read()

      save = 'forward/'+str(e)+'.html'
      store = open(save,'w')
      store.write(str(resp))
      store.close()
      print(e)
    except Exception as e:
      print(str(e))
      time.sleep(2)



check_yahoo()