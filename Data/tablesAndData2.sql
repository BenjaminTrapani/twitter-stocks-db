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
-- phpMyAdmin SQL Dump
-- version 4.0.3
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2015 at 10:35 PM
-- Server version: 5.5.41-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";



USE `bangerz`;

--
CREATE DATABASE IF NOT EXISTS `gsmp` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `gsmp`;

-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_MarketCapPerSectorView`
--
CREATE TABLE IF NOT EXISTS `SM_MarketCapPerSectorView` (
`sector` varchar(128)
,`SUM(mktcap)` decimal(53,0)
);
-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_MinEpsEstimateNextYearPerIndustry`
--
CREATE TABLE IF NOT EXISTS `SM_MinEpsEstimateNextYearPerIndustry` (
`industry` varchar(128)
,`MIN(epsestimatenextyear)` float
);
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
-- --------------------------------------------------------

--
-- Table structure for table `SM_Stock`
--

CREATE TABLE IF NOT EXISTS `SM_Stock` (
  `ticker` varchar(8) NOT NULL DEFAULT '',
  `stockname` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ticker`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SM_Stock`
--

INSERT INTO `SM_Stock` (`ticker`, `stockname`) VALUES
('AAL', ' American Airlines Group Inc.'),
('AAPL', ' Apple Inc.'),
('ADBE', ' Adobe Systems Incorporated'),
('ADI', ' Analog Devices Inc.'),
('ADP', ' Automatic Data Processing Inc.'),
('ADSK', ' Autodesk Inc.'),
('AKAM', ' Akamai Technologies Inc.'),
('ALTR', ' Altera Corporation'),
('ALXN', ' Alexion Pharmaceuticals Inc.'),
('AMAT', ' Applied Materials Inc.'),
('AMGN', ' Amgen Inc.'),
('AMZN', ' Amazon.com Inc.'),
('ATVI', ' Activision Blizzard Inc'),
('AVGO', ' Avago Technologies Limited'),
('BBBY', ' Bed Bath &amp; Beyond Inc.'),
('BIDU', ' Baidu Inc.'),
('BIIB', ' Biogen Inc.'),
('BRCM', ' Broadcom Corporation'),
('CA', ' CA Inc.'),
('CELG', ' Celgene Corporation'),
('CERN', ' Cerner Corporation'),
('CHKP', ' Check Point Software Technologies Ltd.'),
('CHRW', ' C.H. Robinson Worldwide Inc.'),
('CHTR', ' Charter Communications Inc.'),
('CMCSA', ' Comcast Corporation'),
('CMCSK', ' Comcast Corporation'),
('COST', ' Costco Wholesale Corporation'),
('CSCO', ' Cisco Systems Inc.'),
('CTRX', ' Catamaran Corporation'),
('CTSH', ' Cognizant Technology Solutions Corporation'),
('CTXS', ' Citrix Systems Inc.'),
('DISCA', ' Discovery Communications Inc.'),
('DISCK', ' Discovery Communications Inc.'),
('DISH', ' DISH Network Corporation'),
('DLTR', ' Dollar Tree Inc.'),
('DTV', ' DIRECTV'),
('EA', ' Electronic Arts Inc.'),
('EBAY', ' eBay Inc.'),
('ESRX', ' Express Scripts Holding Company'),
('EXPD', ' Expeditors International of Washington Inc.'),
('FAST', ' Fastenal Company'),
('FB', ' Facebook Inc.'),
('FISV', ' Fiserv Inc.'),
('FOX', ' Twenty-First Century Fox Inc.'),
('FOXA', ' Twenty-First Century Fox Inc.'),
('GILD', ' Gilead Sciences Inc.'),
('GMCR', ' Keurig Green Mountain Inc.'),
('GOOG', ' Google Inc.'),
('GOOGL', ' Google Inc.'),
('GRMN', ' Garmin Ltd.'),
('HSIC', ' Henry Schein Inc.'),
('ILMN', ' Illumina Inc.'),
('INTC', ' Intel Corporation'),
('INTU', ' Intuit Inc.'),
('ISRG', ' Intuitive Surgical Inc.'),
('KLAC', ' KLA-Tencor Corporation'),
('KRFT', ' Kraft Foods Group Inc.'),
('LBTYA', ' Liberty Global plc'),
('LBTYK', ' Liberty Global plc'),
('LLTC', ' Linear Technology Corporation'),
('LMCA', ' Liberty Media Corporation'),
('LMCK', ' Liberty Media Corporation'),
('LRCX', ' Lam Research Corporation'),
('LVNTA', ' Liberty Interactive Corporation'),
('MAR', ' Marriott International'),
('MAT', ' Mattel Inc.'),
('MDLZ', ' Mondelez International Inc.'),
('MNST', ' Monster Beverage Corporation'),
('MSFT', ' Microsoft Corporation'),
('MU', ' Micron Technology Inc.'),
('MYL', ' Mylan N.V.'),
('NFLX', ' Netflix Inc.'),
('NTAP', ' NetApp Inc.'),
('NVDA', ' NVIDIA Corporation'),
('NXPI', ' NXP Semiconductors N.V.'),
('ORLY', ' O''Reilly Automotive Inc.'),
('PAYX', ' Paychex Inc.'),
('PCAR', ' PACCAR Inc.'),
('PCLN', ' The Priceline Group Inc.'),
('QCOM', ' QUALCOMM Incorporated'),
('QVCA', ' Liberty Interactive Corporation'),
('REGN', ' Regeneron Pharmaceuticals Inc.'),
('ROST', ' Ross Stores Inc.'),
('SBAC', ' SBA Communications Corporation'),
('SBUX', ' Starbucks Corporation'),
('SIAL', ' Sigma-Aldrich Corporation'),
('SIRI', ' Sirius XM Holdings Inc.'),
('SNDK', ' SanDisk Corporation'),
('SPLS', ' Staples Inc.'),
('SRCL', ' Stericycle Inc.'),
('STX', ' Seagate Technology.'),
('SYMC', ' Symantec Corporation'),
('TRIP', ' TripAdvisor Inc.'),
('TSCO', ' Tractor Supply Company'),
('TSLA', ' Tesla Motors Inc.'),
('TXN', ' Texas Instruments Incorporated'),
('VIAB', ' Viacom Inc.'),
('VIP', ' VimpelCom Ltd.'),
('VOD', ' Vodafone Group Plc'),
('VRSK', ' Verisk Analytics Inc.'),
('VRTX', ' Vertex Pharmaceuticals Incorporated'),
('WBA', ' Walgreens Boots Alliance Inc.'),
('WDC', ' Western Digital Corporation'),
('WFM', ' Whole Foods Market Inc.'),
('WYNN', ' Wynn Resorts Limited'),
('XLNX', ' Xilinx Inc.'),
('YHOO', ' Yahoo! Inc.');

-- --------------------------------------------------------

--
-- Stand-in structure for view `SM_StockTagsView`
--
CREATE TABLE IF NOT EXISTS `SM_StockTagsView` (
`ticker` varchar(8)
,`tag` varchar(256)
);
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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
