#Copyright (c) 2015 Benjamin Trapani, Joshua Sussen, Evan Yin
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

import tweepy
import time
from yahoo_finance import Share
from pprint import pprint
import MySQLdb
import sys
import csv
import stockretriever
from collections import defaultdict

def doubleApost(string):
	newString = "";
	lastChar = "";
	for c in string:
		newString += c
		if c== "'" and lastChar!="\\":
			newString += "'"
		lastChar=c
	return newString

def moneyStringToInt(string):
	if string==None:
		return 0

	if string[len(string)-1] == 'B':
		return int(float(string[:len(string)-2]) * 1000000000)
	if string[len(string)-1] == 'M':
		return int(float(string[:len(string)-2]) * 1000000)
	return int(string)

def moneyStringToFloat(string):
	if string==None:
		return float(0)	

	if string[len(string)-1] == 'B':
		return float(string[:len(string)-2]) * 1000000000.0
	if string[len(string)-1] == 'M':
		return float(string[:len(string)-2]) * 1000000.0
	return float(string)

def populateTweet(result, conn):
	tweetTime = result.created_at
	tweetLoc = result.coordinates
	long = None
	lat = None
	
	if tweetLoc is not None:
		lat = tweetLoc['coordinates'][1]
		long = tweetLoc['coordinates'][0]
		print ('lat = ', lat)
		print ('long =', long)

	text = doubleApost(result.text)
	command = ''
	if long != None:
		command = ("REPLACE INTO SM_Tweet \n"
		   	   "VALUES(%i,%i,'%s',\"%d\",\"%d\",'%s',%i,%i);" % (result.id,  result.user.id, tweetTime, lat, long, text[:255], result.favorite_count, result.retweet_count))
	else:
		command = ("REPLACE INTO SM_Tweet (tweetid,userid,created_at,text,favorite_count,retweet_count) \n"
                           "VALUES(%i,%i,'%s','%s',%i,%i);" % (result.id,  result.user.id, tweetTime, text[:255], result.favorite_count, result.retweet_count))
	print("Executing " + command)
	conn.execute(command)

def nameForTicker(ticker):
	file = open('nasdaq100list.csv', 'r')
        labels = ['Symbol','Name']
        stockData = csv.DictReader(file, labels,delimiter=',')
	for line in stockData:
		if line['Symbol'] == ticker:
			return line['Name']
	return ''        
  
def populateCompany(shareString, conn):
	curShare = None
	noStock = True
	while(noStock):
		try:
			curShare = Share(shareString)
			noStock = False		
		except:
			noStock = True
			print('Error fetching stock data, retrying soon.')
			time.sleep(5)
		
	stockname = nameForTicker(shareString)
	file = open('companylist.csv', 'r')
        labels = ['Symbol','Name','LastSale','MarketCap','IPOyear','Sector','industry']
        companyData = csv.DictReader(file, labels, delimiter=',')
	industry = ''
        sector = ''
	for line in companyData:
		if line['Symbol'] == shareString:
			industry = line['industry']
			sector = line['Sector']
			print('Found company, industry = ' + industry + ', sector = ' + sector)
			break

	command = ("REPLACE INTO SM_Company \n"
		   "VALUES('%s','%s','%s');" % (doubleApost(stockname), doubleApost(industry), doubleApost(sector)))
	conn.execute(command)

def fetchStocksList(fileName):
	file = open(fileName, 'r')
	labels = ['Symbol']
	stockData = csv.DictReader(file, labels,delimiter=',')
	rows = list(stockData)
	result = [None]*len(rows)
	for index, line in enumerate(rows):
		result[index] = line['Symbol']
		print('Ticker = ' + result[index])
		
	return result
	
def populateStock(shareString, sqlConnection):
	timedout = True
	curShare = None
	while timedout:
		try:
			curShare = Share(shareString)
			timedout=False
		except:
			timedout=True
			time.sleep(5)
			print('Stock querry timed out, retrying')
	
	if curShare.get_price() == 0:
		return
	
	detailShare = None
	try:
		detailShare = stockretriever.get_current_info([shareString])
		pprint(detailShare)
	except:
		print('Yql error caught, continuing excluding analyst estimates for ' + shareString)
	
	EPSEstimateNextYear = None
	EPSEstimateCurrentYear = None
	EPSEstimateNextQuarter = None
	if(detailShare != None):
		if(detailShare['PriceBook']==None):
			print('No data on this stock, will not populate table.')
			return
		if(detailShare['EPSEstimateNextYear']!=None):
			EPSEstimateNextYear = float(detailShare['EPSEstimateNextYear'])
		if(detailShare['EPSEstimateCurrentYear']!=None):
			EPSEstimateCurrentYear = float(detailShare['EPSEstimateCurrentYear'])
		if(detailShare['EPSEstimateNextQuarter']!=None):
			EPSEstimateNextQuarter = float(detailShare['EPSEstimateNextQuarter'])
	
	sqlStatement = 'default statement'
	if EPSEstimateNextYear != None and EPSEstimateCurrentYear != None and EPSEstimateNextQuarter != None:
  		sqlStatement = ("REPLACE INTO SM_Stock_Data \n"
                       	        "VALUES('%s',\"%f\",%i,%i,\"%f\",\"%f\",'%s',\"%f\",\"%f\",\"%f\");" % (shareString, moneyStringToFloat(curShare.get_price()), moneyStringToInt(curShare.get_volume()), moneyStringToInt(curShare.get_market_cap()), moneyStringToFloat(curShare.get_earnings_share()), moneyStringToFloat(curShare.get_dividend_share()), curShare.get_trade_datetime(), EPSEstimateNextYear, EPSEstimateCurrentYear, EPSEstimateNextQuarter))
 	else:
		sqlStatement = ("REPLACE INTO SM_Stock_Data (ticker,price,volume,mktcap,eps,dividend,refreshdate) \n"
				"VALUES('%s',\"%f\",%i,%i,\"%f\",\"%f\",'%s');" % (shareString, moneyStringToFloat(curShare.get_price()), moneyStringToInt(curShare.get_volume()), moneyStringToInt(curShare.get_market_cap()), moneyStringToFloat(curShare.get_earnings_share()), moneyStringToFloat(curShare.get_dividend_share()), curShare.get_trade_datetime()))
	print('Populating stock with command: ' + sqlStatement)
	sqlConnection.execute(("REPLACE INTO SM_Stock \n"
			      "VALUES('%s','%s')") % (shareString, doubleApost(nameForTicker(shareString))))
	sqlConnection.execute(sqlStatement)		 	

def populateTag(result, tags, sqlConn):
	print("Tag data = ")
	pprint(tags)
	for curText in tags:
		populateTweetTagsMapping(result, curText['text'], sqlConn)
		command = ("REPLACE INTO SM_Tag \n"
		  	   "VALUES('%s');" % curText['text'])
		sqlConn.execute(command)
		print('Populated tag with command:' + command)
	
def populateUser(user, sqlConn):
	command = ("REPLACE INTO SM_User \n"
		   "VALUES(%i,'%s','%s','%s','%s',%i,%i,%i,%i,%i);" % (user.id, user.created_at, doubleApost(user.screen_name), doubleApost(user.description), doubleApost(user.location), user.friends_count, user.followers_count, user.statuses_count, user.favourites_count, user.listed_count))
	sqlConn.execute(command)
	print('Populated user with command:' + command)

def populateCompanyUsersMapping(ticker, userid, conn):
	command = ("REPLACE INTO SM_CompanyUsers_Mapping \n"
		   "VALUES('%s',%i);" % (ticker, userid))
	conn.execute(command)
	print('Populated comp user map with command:' + command)
	
def populateTweetStocksMapping(tweetResult, ticker, sqlConn):
	command = ("REPLACE INTO SM_TweetStocks_Mapping \n"
		   "VALUES(%i,'%s');" % (tweetResult.id, ticker))
	sqlConn.execute(command)	

def populateFavoriteStocksMapping(userid, ticker, conn):
	command = ("REPLACE INTO SM_UserFavoriteStocks_Mapping \n"
                   "VALUES(%i,'%s');" % (userid, ticker))
	conn.execute(command)
	print('Populated user favorite stocks map with command:' + command)

def populateTweetTagsMapping(tweetResult, tag, sqlConn):
	command = ("REPLACE INTO SM_TweetTags_Mapping \n"
		   "VALUES(%i,'%s');" % (tweetResult.id, tag))
	sqlConn.execute(command)

oath = tweepy.OAuthHandler('OK44ZdA6eIAUYG6yLe0h17vDD', 'MQhSgETnJifu30GJ0kmWswISdfxhLRUfB1QzrTUL2QrQov1InI')
oath.set_access_token('2977099301-uqjtR2UU5OeeYEfwaXiZc6LB1WdwgUijB5PZ1Ci',
'KG32FH9ndisVaE0NpddBqnZ5g6PZfepuSNItAuCYbFZfS')

twitterApi = tweepy.API(oath)
results = twitterApi.search('$MSFT',rpp=50)
db = MySQLdb.connect(host="localhost", user="bangerz", passwd="gamera@1234", db="bangerz")
db.set_character_set('utf8')

cursor = db.cursor()
cursor.execute('SET CHARACTER SET utf8;')

tickers = fetchStocksList('nasdaq100list.csv')

if len(sys.argv) > 1 and sys.argv[1] is not None:
	subtickers = tickers[tickers.index(sys.argv[1]):]
else:
	subtickers = tickers

while True:
	for curTicker in subtickers:
		populateStock(curTicker,cursor)
		populateCompany(curTicker,cursor)

		querry = '$'+curTicker
		print ('To search = ' + querry)
		try: 
			results = twitterApi.search(querry,rpp=50)
		except tweepy.error.TweepError:
			print "Tweepy error, continuing"
			db.commit()
			time.sleep(6)
			continue
		for result in results:
			populateTweet(result, cursor)
			populateTweetStocksMapping(result, curTicker, cursor)
			populateTag(result, result.entities.get('hashtags'), cursor)
			populateUser(result.user, cursor)
			populateCompanyUsersMapping(curTicker, result.user.id, cursor)
			populateFavoriteStocksMapping(result.user.id, curTicker, cursor)
		db.commit()
		time.sleep(6)

db.commit();
db.close()

 
