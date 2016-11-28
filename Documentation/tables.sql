/*Copyright (c) 2015 Benjamin Trapani, Joshua Sussen, Evan Yin
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

--
-- Table structure for table `SM_Company`
--

CREATE TABLE IF NOT EXISTS `SM_Company` (
  `stockname` varchar(128) NOT NULL DEFAULT '',
  `industry` varchar(128) DEFAULT NULL,
  `sector` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`stockname`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
The (SM_Company) table contains information about the company behind a security. The table contains the name of the company (stockname), the industry in which the company operates (industry) and the sector of the company (sector). Every security (SM_Stock) references exactly one row in (SM_Company). A row in (SM_Company) references at least one (SM_Stock) and can reference an indefinite number of securities, depending on how the company is traded.
*/


-- --------------------------------------------------------

--
-- Table structure for table `SM_CompanyUsers_Mapping`
--

CREATE TABLE IF NOT EXISTS `SM_CompanyUsers_Mapping` (
  `stockname` varchar(64) NOT NULL DEFAULT '',
  `userid` bigint(32) NOT NULL DEFAULT '0',
  PRIMARY KEY (`stockname`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table is simply a mapping table between the table (SM_Company) and (SM_User). Simply perform a join between the source table and the mapping table on the primary key of the source table and the corresponding key in the mapping table to get all of the corresponding primary keys in the second table.
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_CurrentYearEstimatedEPSPerTagView`
--
CREATE TABLE IF NOT EXISTS `SM_CurrentYearEstimatedEPSPerTagView` (
`tag` varchar(256)
,`epsestimateavg` double
);

/*
This view displays tags and the average current year estimated EPS(earnings per share) for stocks mentioned with the given tag as of the most recent trade dates for all stocks. The tags are sorted in descending order by the average estimated EPS.
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_CurrentYearEstimatePerSector`
--
CREATE TABLE IF NOT EXISTS `SM_CurrentYearEstimatePerSector` (
`sector` varchar(128)
,`AVG(epsestimatecurrentyear)` double
);

/*
This view displays the average of the most recent EPS estimates for all securities in all sectors contained in our database, and sorts sectors in descending order by the average EPS estimates of the securities in the given sector.
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_GullibleUsersView`
--
CREATE TABLE IF NOT EXISTS `SM_GullibleUsersView` (
`userid` bigint(32)
,`created_at` datetime
,`screen_name` varchar(64)
,`description` varchar(256)
,`location` varchar(32)
,`friends_count` int(11)
,`followers_count` int(11)
,`statuses_count` int(11)
,`favourites_count` int(11)
,`listed_count` int(11)
,`averageesteps` double
);

/*
This table contains all the information about users and the average current year estimated earnings per share as of the most recent refresh date of the securities mentioned by each user. The users are sorted in descending order by the average current year estimated earnings per share of all of the securities they have mentioned. See documentation on (SM_User) for more details.
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_MarketCapPerSectorView`
--
CREATE TABLE IF NOT EXISTS `SM_MarketCapPerSectorView` (
`sector` varchar(128)
,`SUM(mktcap)` decimal(53,0)
);

/*
This table displays all of the sectors contained in our database and the corresponding total market cap of all of the securities in the given sector as of the most recent refresh date of all of the securities.
*/
-- --------------------------------------------------------


--
-- Stand-in structure for view `SM_MinEpsEstimateNextYearPerIndustry`
--
CREATE TABLE IF NOT EXISTS `SM_MinEpsEstimateNextYearPerIndustry` (
`industry` varchar(128)
,`MIN(epsestimatenextyear)` float
);

/*
This view displays all of the industries which contain at least one security in our database. For each industry, the minimum estimated earnings per share for all securities in the given industry for the next year as of the most recent refresh date of the securities is displayed. 
*/

-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_MostInfluentialUsers`
--
CREATE TABLE IF NOT EXISTS `SM_MostInfluentialUsers` (
`userid` bigint(32)
,`created_at` datetime
,`screen_name` varchar(64)
,`description` varchar(256)
,`location` varchar(32)
,`friends_count` int(11)
,`followers_count` int(11)
,`statuses_count` int(11)
,`favourites_count` int(11)
,`listed_count` int(11)
);

/*
This view displays all of the information about users in our database that have the most influence, as determined by the number of followers they have. Users are sorted in descending order by (followers_count). See the documentation for (SM_User) for more details.
*/
-- --------------------------------------------------------

--
-- Table structure for table `SM_Stock`
--

CREATE TABLE IF NOT EXISTS `SM_Stock` (
  `ticker` varchar(8) NOT NULL DEFAULT '',
  `stockname` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table represents a stock in our database. (ticker) is the symbol of the stock. And (stockname) is the name of the company that is behind the symbol. An example entry would be (ticker)='AAPL' and (stockname)='Apple'.
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_StockTagsView`
--
CREATE TABLE IF NOT EXISTS `SM_StockTagsView` (
`ticker` varchar(8)
,`tag` varchar(256)
);

/*
This view maps (SM_Stock) to (SM_Tag), which involves a large number of joins between other tables, making the view convenient for analyzing patterns between what is mentioned with a security and what things are common between securities. (ticker) is the symbol of the security, and (tag) is a tag associated with (ticker) in an (SM_Tweet).
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_StockTweetView`
--
CREATE TABLE IF NOT EXISTS `SM_StockTweetView` (
`ticker` varchar(8)
,`stockname` varchar(128)
,`price` float
,`volume` bigint(32)
,`mktcap` bigint(32)
,`eps` float
,`dividend` float
,`refreshdate` datetime
,`epsestimatenextyear` float
,`epsestimatecurrentyear` float
,`epsestimatenextquarter` float
,`tweetid` bigint(32)
);

/*
This view maps (SM_Stock) to (SM_Tweet), which is necessary as stocks can be mentioned in many tweets and a tweet can mention many stocks. The view contains all the information about the given (SM_Stock) and also contains the tweet id (tweetid) that the security was mentioned in. See the documentation for (SM_Stock_Data) for more information.
*/
-- --------------------------------------------------------

--
-- Table structure for table `SM_Stock_Data`
--

CREATE TABLE IF NOT EXISTS `SM_Stock_Data` (
  `ticker` varchar(8) NOT NULL DEFAULT '',
  `price` float DEFAULT NULL,
  `volume` bigint(32) DEFAULT NULL,
  `mktcap` bigint(32) DEFAULT NULL,
  `eps` float DEFAULT NULL,
  `dividend` float DEFAULT NULL,
  `refreshdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `epsestimatenextyear` float DEFAULT NULL,
  `epsestimatecurrentyear` float DEFAULT NULL,
  `epsestimatenextquarter` float DEFAULT NULL,
  PRIMARY KEY (`ticker`,`refreshdate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table contains major data related to a security with respect to the date of the information. That is why the table has a composite primary key made up of the (ticker) of the security and the (refreshdate) of all of the other fields describing the security. (price) is the price of the security. (volume) is the number of shares of this security traded since the beginning of the day. (mktcap) is the market capitalization of the security. (eps) is the earnings per share of the security. (dividend) is the dividend of the security. (refreshdate) is the time corresponding to the data in the rest of the fields, and this information is synchronized by Yahoo Finance. (epsestimatenextyear) is the earnings per share estimate of the security for the upcoming year. (epsestimantencurrentyear) represents the earnings per share estimate of the security for the current year, and (epsestimatenextquarter) represents the earnings per share estimate for the security for the next quarter. 
*/
-- --------------------------------------------------------

--
-- Table structure for table `SM_Tag`
--

CREATE TABLE IF NOT EXISTS `SM_Tag` (
  `tag` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table represents a tag in our database. (tag) is a tag associated with at least one (SM_Tweet). (tag) can be at most 256 characters long. 
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_TagUserIDView`
--
CREATE TABLE IF NOT EXISTS `SM_TagUserIDView` (
`tag` varchar(256)
,`userid` bigint(32)
);
/*
This view maps tags to the the user ids (userid) of the users that have tagged at least one (SM_Tweet) with the given (tag). 
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_tickertweetuser`
--
CREATE TABLE IF NOT EXISTS `SM_tickertweetuser` (
`ticker` varchar(8)
,`tweetid` bigint(32)
,`text` varchar(256)
,`userid` bigint(32)
,`created_at` datetime
,`screen_name` varchar(64)
,`description` varchar(256)
,`location` varchar(32)
,`friends_count` int(11)
,`followers_count` int(11)
,`statuses_count` int(11)
,`favourites_count` int(11)
,`listed_count` int(11)
);

/*
This table maps all of the information about an (SM_User) to a ticker associated with (SM_Stock) and at least one (SM_Stock_Data). See the documentation for (SM_User) for more information. 
*/
-- --------------------------------------------------------

--
-- Table structure for table `SM_Tweet`
--

CREATE TABLE IF NOT EXISTS `SM_Tweet` (
  `tweetid` bigint(32) NOT NULL DEFAULT '-1',
  `userid` bigint(32) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `latitude_coord` double DEFAULT NULL,
  `longitude_coord` double DEFAULT NULL,
  `text` varchar(256) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `favorite_count` bigint(20) DEFAULT NULL,
  `retweet_count` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`tweetid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table represents all of the data about a Twitter Tweet relevant to the security trading domain. Each (SM_Tweet) mentions at least one (SM_Stock). (tweetid) and (userid) are numeric integer identifiers used by Twitter to identify this tweet and the user who posted the tweet uniquely. See (SM_User) for details information about users. (created_at) is the date at which this tweet was posted. (latitude_coord) and (longitude_coord) are the coordinates at which this Tweet was posted, if available. (text) is the text of the tweet, (favorite_count) is the number of times other users have favourited this tweet, and (retweet_count) is the number of times other users have re-tweeted this tweet. 
*/
-- --------------------------------------------------------

--
-- Table structure for table `SM_TweetStocks_Mapping`
--

CREATE TABLE IF NOT EXISTS `SM_TweetStocks_Mapping` (
  `tweetid` bigint(32) NOT NULL,
  `ticker` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`tweetid`,`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table is a mapping between (SM_Tweet) and (SM_Stock), in addition to providing a mapping between (SM_Tweet) and (SM_Stock_Data). (tweetid) is the unique integer id of the tweet associated with the given (ticker), which references (ticker) in (SM_Stock) and (SM_Stock_Data). (tweetid) references (tweetid) in (SM_Tweet).
*/

-- --------------------------------------------------------

--
-- Table structure for table `SM_TweetTags_Mapping`
--

CREATE TABLE IF NOT EXISTS `SM_TweetTags_Mapping` (
  `tweetid` bigint(32) NOT NULL,
  `tag` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`tweetid`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table is a mapping between (SM_Tweet) and (SM_Tag). (tweetid) is the unique integer id of the (SM_Tweet) referenced by a given row in (SM_TweetTags_Mapping) and (tag) references a (SM_Tag) associated with the corresponding (tweetid).
*/

-- --------------------------------------------------------

--
-- Table structure for table `SM_User`
--

CREATE TABLE IF NOT EXISTS `SM_User` (
  `userid` bigint(32) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `screen_name` varchar(64) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `location` varchar(32) DEFAULT NULL,
  `friends_count` int(11) DEFAULT NULL,
  `followers_count` int(11) DEFAULT NULL,
  `statuses_count` int(11) DEFAULT NULL,
  `favourites_count` int(11) DEFAULT NULL,
  `listed_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table represents a Twitter user in our database. Every Twitter user in our database has mentioned at least one security in his or her tweets. (userid) is the uniqe integer id given to each user on Twitter and is manged by Twitter. (created_at) is the date at which the given (SM_User) created their account on Twitter. (screen_name) is the name that is displayed to other users on Twitter in order to identify this user, and is typically the user's name. (description) is a self-provided textual description of the user, that can be at most 256 characters. (location) is a textual description of the location of the user, and is once again provided by the user. (friends_count) is an unsigned integer representing the number of friends this (SM_User) has on Twitter. (followers_count) indicates the number of users who follow this user. (statuses_count) represents the total number of statuses that this user has posted during their time on Twitter. (favourites_count) represents the total number of times this user has favorited other tweets. (listed_count) is the number of public lists that this user is a member of. 
*/
-- --------------------------------------------------------

--
-- Table structure for table `SM_UserFavoriteStocks_Mapping`
--

CREATE TABLE IF NOT EXISTS `SM_UserFavoriteStocks_Mapping` (
  `userid` bigint(32) NOT NULL DEFAULT '0',
  `ticker` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`userid`,`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
This table provides a mapping between users and the securities that they have mentioned in their tweets. More specifically, this table provides a mapping between (SM_User) and both (SM_Stock) and (SM_Stock_Data). 
*/
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_UserStockView`
--
CREATE TABLE IF NOT EXISTS `SM_UserStockView` (
`userid` bigint(32)
,`created_at` datetime
,`screen_name` varchar(64)
,`description` varchar(256)
,`location` varchar(32)
,`friends_count` int(11)
,`followers_count` int(11)
,`statuses_count` int(11)
,`favourites_count` int(11)
,`listed_count` int(11)
,`ticker` varchar(8)
);
-- --------------------------------------------------------
/*
This view expands on the information provided by (SM_UserFavoriteStocks_Mapping) and displays all of the information from (SM_User) in addition to the (ticker) of the stock mentioned at least once by the given (SM_User). This view allows users to quickly analyze patterns in the users who mention a specific security.
*/

--
-- Structure for view `SM_CurrentYearEstimatedEPSPerTagView`
--
DROP TABLE IF EXISTS `SM_CurrentYearEstimatedEPSPerTagView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_CurrentYearEstimatedEPSPerTagView` AS select `SM_Tag`.`tag` AS `tag`,avg(`SM_Stock_Data`.`epsestimatecurrentyear`) AS `epsestimateavg` from (((((`SM_Tag` join `SM_TweetTags_Mapping` on((`SM_TweetTags_Mapping`.`tag` = `SM_Tag`.`tag`))) join `SM_Tweet` on((`SM_Tweet`.`tweetid` = `SM_TweetTags_Mapping`.`tweetid`))) join `SM_TweetStocks_Mapping` on((`SM_TweetStocks_Mapping`.`tweetid` = `SM_Tweet`.`tweetid`))) join `SM_Stock` on((`SM_Stock`.`ticker` = `SM_TweetStocks_Mapping`.`ticker`))) join `SM_Stock_Data` on((`SM_Stock`.`ticker` = `SM_Stock_Data`.`ticker`))) where (`SM_Stock_Data`.`refreshdate` = (select max(`SM_Stock_Data`.`refreshdate`) from `SM_Stock_Data` where (`SM_Stock_Data`.`ticker` = `SM_Stock`.`ticker`))) group by `SM_Tag`.`tag` order by avg(`SM_Stock_Data`.`epsestimatecurrentyear`) desc;

-- --------------------------------------------------------

--
-- Structure for view `SM_CurrentYearEstimatePerSector`
--
DROP TABLE IF EXISTS `SM_CurrentYearEstimatePerSector`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_CurrentYearEstimatePerSector` AS select `SM_Company`.`sector` AS `sector`,avg(`SM_Stock_Data`.`epsestimatecurrentyear`) AS `AVG(epsestimatecurrentyear)` from ((`SM_Stock` join `SM_Stock_Data` on((`SM_Stock`.`ticker` = `SM_Stock_Data`.`ticker`))) join `SM_Company` on((`SM_Company`.`stockname` = `SM_Stock`.`stockname`))) where (`SM_Stock_Data`.`refreshdate` = (select max(`SM_Stock_Data`.`refreshdate`) from `SM_Stock_Data` where (`SM_Stock_Data`.`ticker` = `SM_Stock`.`ticker`))) group by `SM_Company`.`sector`;

-- --------------------------------------------------------

--
-- Structure for view `SM_GullibleUsersView`
--
DROP TABLE IF EXISTS `SM_GullibleUsersView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_GullibleUsersView` AS select `SM_User`.`userid` AS `userid`,`SM_User`.`created_at` AS `created_at`,`SM_User`.`screen_name` AS `screen_name`,`SM_User`.`description` AS `description`,`SM_User`.`location` AS `location`,`SM_User`.`friends_count` AS `friends_count`,`SM_User`.`followers_count` AS `followers_count`,`SM_User`.`statuses_count` AS `statuses_count`,`SM_User`.`favourites_count` AS `favourites_count`,`SM_User`.`listed_count` AS `listed_count`,avg(`SM_Stock_Data`.`epsestimatecurrentyear`) AS `averageesteps` from (((`SM_User` join `SM_UserFavoriteStocks_Mapping` on((`SM_UserFavoriteStocks_Mapping`.`userid` = `SM_User`.`userid`))) join `SM_Stock` on((`SM_Stock`.`ticker` = `SM_UserFavoriteStocks_Mapping`.`ticker`))) join `SM_Stock_Data` on((`SM_Stock`.`ticker` = `SM_Stock_Data`.`ticker`))) where (`SM_Stock_Data`.`refreshdate` = (select max(`SM_Stock_Data`.`refreshdate`) from `SM_Stock_Data` where (`SM_Stock_Data`.`ticker` = `SM_Stock`.`ticker`))) group by `SM_User`.`userid` order by avg(`SM_Stock_Data`.`epsestimatecurrentyear`) desc;

-- --------------------------------------------------------

--
-- Structure for view `SM_MarketCapPerSectorView`
--
DROP TABLE IF EXISTS `SM_MarketCapPerSectorView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_MarketCapPerSectorView` AS select `SM_Company`.`sector` AS `sector`,sum(`SM_Stock_Data`.`mktcap`) AS `SUM(mktcap)` from ((`SM_Stock` join `SM_Stock_Data` on((`SM_Stock`.`ticker` = `SM_Stock_Data`.`ticker`))) join `SM_Company` on((`SM_Company`.`stockname` = `SM_Stock`.`stockname`))) where (`SM_Stock_Data`.`refreshdate` = (select max(`SM_Stock_Data`.`refreshdate`) from `SM_Stock_Data` where (`SM_Stock_Data`.`ticker` = `SM_Stock`.`ticker`))) group by `SM_Company`.`sector`;

-- --------------------------------------------------------

--
-- Structure for view `SM_MinEpsEstimateNextYearPerIndustry`
--
DROP TABLE IF EXISTS `SM_MinEpsEstimateNextYearPerIndustry`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_MinEpsEstimateNextYearPerIndustry` AS select `SM_Company`.`industry` AS `industry`,min(`SM_Stock_Data`.`epsestimatenextyear`) AS `MIN(epsestimatenextyear)` from ((`SM_Stock` join `SM_Stock_Data` on((`SM_Stock`.`ticker` = `SM_Stock_Data`.`ticker`))) join `SM_Company` on((`SM_Company`.`stockname` = `SM_Stock`.`stockname`))) where (`SM_Stock_Data`.`refreshdate` = (select max(`SM_Stock_Data`.`refreshdate`) from `SM_Stock_Data` where (`SM_Stock_Data`.`ticker` = `SM_Stock`.`ticker`))) group by `SM_Company`.`sector`;

-- --------------------------------------------------------

--
-- Structure for view `SM_MostInfluentialUsers`
--
DROP TABLE IF EXISTS `SM_MostInfluentialUsers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_MostInfluentialUsers` AS select `SM_User`.`userid` AS `userid`,`SM_User`.`created_at` AS `created_at`,`SM_User`.`screen_name` AS `screen_name`,`SM_User`.`description` AS `description`,`SM_User`.`location` AS `location`,`SM_User`.`friends_count` AS `friends_count`,`SM_User`.`followers_count` AS `followers_count`,`SM_User`.`statuses_count` AS `statuses_count`,`SM_User`.`favourites_count` AS `favourites_count`,`SM_User`.`listed_count` AS `listed_count` from `SM_User` order by `SM_User`.`followers_count` desc;

-- --------------------------------------------------------

--
-- Structure for view `SM_StockTagsView`
--
DROP TABLE IF EXISTS `SM_StockTagsView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_StockTagsView` AS select `SM_TweetStocks_Mapping`.`ticker` AS `ticker`,`SM_TweetTags_Mapping`.`tag` AS `tag` from (`SM_TweetTags_Mapping` join `SM_TweetStocks_Mapping` on((`SM_TweetTags_Mapping`.`tweetid` = `SM_TweetStocks_Mapping`.`tweetid`)));

-- --------------------------------------------------------

--
-- Structure for view `SM_StockTweetView`
--
DROP TABLE IF EXISTS `SM_StockTweetView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_StockTweetView` AS select `SM_Stock`.`ticker` AS `ticker`,`SM_Stock`.`stockname` AS `stockname`,`SM_Stock_Data`.`price` AS `price`,`SM_Stock_Data`.`volume` AS `volume`,`SM_Stock_Data`.`mktcap` AS `mktcap`,`SM_Stock_Data`.`eps` AS `eps`,`SM_Stock_Data`.`dividend` AS `dividend`,`SM_Stock_Data`.`refreshdate` AS `refreshdate`,`SM_Stock_Data`.`epsestimatenextyear` AS `epsestimatenextyear`,`SM_Stock_Data`.`epsestimatecurrentyear` AS `epsestimatecurrentyear`,`SM_Stock_Data`.`epsestimatenextquarter` AS `epsestimatenextquarter`,`SM_TweetStocks_Mapping`.`tweetid` AS `tweetid` from ((`SM_Stock_Data` join `SM_Stock` on((`SM_Stock_Data`.`ticker` = `SM_Stock`.`ticker`))) join `SM_TweetStocks_Mapping` on((`SM_Stock`.`ticker` = `SM_TweetStocks_Mapping`.`ticker`))) order by `SM_TweetStocks_Mapping`.`tweetid` desc;

-- --------------------------------------------------------

--
-- Structure for view `SM_TagUserIDView`
--
DROP TABLE IF EXISTS `SM_TagUserIDView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_TagUserIDView` AS select `SM_TweetTags_Mapping`.`tag` AS `tag`,`SM_Tweet`.`userid` AS `userid` from ((`SM_TweetTags_Mapping` join `SM_Tweet` on((`SM_Tweet`.`tweetid` = `SM_TweetTags_Mapping`.`tweetid`))) join `SM_User` on((`SM_Tweet`.`userid` = `SM_User`.`userid`)));

-- --------------------------------------------------------

--
-- Structure for view `SM_tickertweetuser`
--
DROP TABLE IF EXISTS `SM_tickertweetuser`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_tickertweetuser` AS select `SM_TweetStocks_Mapping`.`ticker` AS `ticker`,`SM_Tweet`.`tweetid` AS `tweetid`,`SM_Tweet`.`text` AS `text`,`SM_User`.`userid` AS `userid`,`SM_User`.`created_at` AS `created_at`,`SM_User`.`screen_name` AS `screen_name`,`SM_User`.`description` AS `description`,`SM_User`.`location` AS `location`,`SM_User`.`friends_count` AS `friends_count`,`SM_User`.`followers_count` AS `followers_count`,`SM_User`.`statuses_count` AS `statuses_count`,`SM_User`.`favourites_count` AS `favourites_count`,`SM_User`.`listed_count` AS `listed_count` from ((`SM_TweetStocks_Mapping` join `SM_Tweet` on((`SM_TweetStocks_Mapping`.`tweetid` = `SM_Tweet`.`tweetid`))) join `SM_User` on((`SM_User`.`userid` = `SM_Tweet`.`userid`)));

-- --------------------------------------------------------

--
-- Structure for view `SM_UserStockView`
--
DROP TABLE IF EXISTS `SM_UserStockView`;

CREATE ALGORITHM=UNDEFINED DEFINER=`gsmp`@`localhost` SQL SECURITY DEFINER VIEW `SM_UserStockView` AS select `SM_User`.`userid` AS `userid`,`SM_User`.`created_at` AS `created_at`,`SM_User`.`screen_name` AS `screen_name`,`SM_User`.`description` AS `description`,`SM_User`.`location` AS `location`,`SM_User`.`friends_count` AS `friends_count`,`SM_User`.`followers_count` AS `followers_count`,`SM_User`.`statuses_count` AS `statuses_count`,`SM_User`.`favourites_count` AS `favourites_count`,`SM_User`.`listed_count` AS `listed_count`,`SM_UserFavoriteStocks_Mapping`.`ticker` AS `ticker` from (`SM_User` join `SM_UserFavoriteStocks_Mapping` on((`SM_User`.`userid` = `SM_UserFavoriteStocks_Mapping`.`userid`)));

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
