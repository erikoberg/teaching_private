# -*- coding: utf-8 -*-
"""
Created on Thu Mar 29 12:37:41 2018

@author: Erik
"""


from __future__ import division
import numpy as np
import pandas as pd
import datetime
from pandas_datareader import data
import matplotlib.pyplot as plt
import statsmodels.tsa.filters.hp_filter as hp_filter


#Data import and sorting
start = datetime.datetime(1975,01,01)
u_rate = data.DataReader(["UNRATE"], "fred", start)
u_rate = 1/3*(u_rate + u_rate.shift(-1) + u_rate.shift(-2))
u_rate['date'] = u_rate.index

ave_earnings = data.DataReader(["AHETPI"], "fred", start)
#ave_earnings['date'] = ave_earnings.index

price_index =  data.DataReader(["PCEPILFE"], "fred", start)
#price_index['date'] = price_index.index

real_average_earnings = pd.DataFrame(ave_earnings['AHETPI']/price_index['PCEPILFE'])*100
real_average_earnings = 1/3*(real_average_earnings + real_average_earnings.shift(-1) + real_average_earnings.shift(-2))
real_average_earnings.columns = ['real_average_earnings']
real_average_earnings['date'] = real_average_earnings.index

prod = data.DataReader(["ULQELP01USQ661S"], "fred", start) 
prod['date'] = prod.index


#Merge
df = real_average_earnings.merge(u_rate, how = 'inner')
df = df.merge(prod, how='inner')
df.columns = ['real_average_earnings', 'date', 'urate', 'prod']
df.set_index(df['date'], inplace=True)

#Filter data
#Detrend
df['real_average_earnings_cycle'], df['real_average_earnings_trend']= hp_filter.hpfilter(df['real_average_earnings'], 1600)
df['urate_cycle'], df['urate_trend']= hp_filter.hpfilter(df['urate'], 1600)
df['prod_cycle'], df['prod_trend']= hp_filter.hpfilter(df['prod'], 1600)



#Graphs
plt.rcParams['figure.figsize'] = 10, 6
fig, ax1 = plt.subplots()
ax1.plot(df['date'], df['real_average_earnings_cycle'], 'b-')
ax1.plot(df['date'], df['prod_cycle'], 'r--')
ax1.set_xlim([datetime.date(1975, 1, 1), datetime.date(2018, 1, 1)])
ax1.legend(['Average real hourly earnings', 'Productivity'], loc=1)
ax1.set_xlabel('Date', fontsize=14)
ax1.set_ylabel('Percent', fontsize=14)
ax1.grid(color='grey', linestyle='--', linewidth=1, alpha=0.2)
plt.savefig("../figures/wages_prod.pdf")
plt.show()

plt.rcParams['figure.figsize'] = 10, 6
fig, ax1 = plt.subplots()
ax1.plot(df['date'], df['real_average_earnings_cycle'], 'b-')
ax1.plot(df['date'], df['urate_cycle'], 'r--')
ax1.set_xlim([datetime.date(1975, 1, 1), datetime.date(2018, 1, 1)])
ax1.legend(['Average real hourly earnings', 'urate'], loc=1)
ax1.set_xlabel('Date', fontsize=14)
ax1.set_ylabel('Percent', fontsize=14)
ax1.grid(color='grey', linestyle='--', linewidth=1, alpha=0.2)
plt.savefig("../figures/wages_urate.pdf")
plt.show()

#np.corrcoef(df['real_average_earnings_cycle'], df['prod_cycle'])












##Data import and sorting
#start = datetime.datetime(1950,01,01)
#real_comp = data.DataReader(["COMPRNFB"], "fred", start)
#real_comp['date']=real_comp.index
#real_prod = data.DataReader(["OPHNFB"], "fred", start) 
#real_prod['date']=real_prod.index
#
#df = real_comp.merge(real_prod, how = 'inner')
#df.columns = ['real_comp', 'date', 'real_prod']
#df.set_index(df['date'], inplace=True)
##df.drop(['date'])
#
##Filter data
##Detrend
#df['real_comp_cycle'], df['real_comp_trend']= hp_filter.hpfilter(df['real_comp'], 1600)
#df['real_prod_cycle'], df['real_prod_trend']= hp_filter.hpfilter(df['real_prod'], 1600)
#
##Graphs
#plt.rcParams['figure.figsize'] = 10, 6
#
#fig, ax1 = plt.subplots()
#ax1.plot(df['date'], df['real_comp_cycle'], 'b-')
#ax1.plot(df['date'], df['real_prod_cycle'], 'r--')
#ax1.set_xlim([datetime.date(1980, 1, 1), datetime.date(2017, 1, 1)])
#ax1.legend(['hourly real compensation', 'output per hour'], loc=1)
#ax1.set_xlabel('Date', fontsize=14)
#ax1.set_ylabel('Percent', fontsize=14)
#ax1.grid(color='grey', linestyle='--', linewidth=1, alpha=0.2)
##plt.savefig("../figures/prod_urate_srate.pdf")
#plt.show()
