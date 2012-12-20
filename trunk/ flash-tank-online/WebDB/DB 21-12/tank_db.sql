-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 20, 2012 at 09:43 PM
-- Server version: 5.5.24-log
-- PHP Version: 5.4.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `tank_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `battles`
--

CREATE TABLE IF NOT EXISTS `battles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game` varchar(12) DEFAULT NULL,
  `time` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29 ;

--
-- Dumping data for table `battles`
--

INSERT INTO `battles` (`id`, `game`, `time`) VALUES
(1, 'tank', '2012-12-19'),
(2, 'tank', '2012-12-19'),
(3, 'tank', '2012-12-19'),
(4, 'tank', '2012-12-19'),
(5, 'tank', '2012-12-19'),
(6, 'tank', '2012-12-19'),
(7, 'tank', '2012-12-19'),
(8, 'tank', '2012-12-19'),
(9, 'tank', '2012-12-19'),
(10, 'tank', '2012-12-19'),
(11, 'tank', '2012-12-19'),
(12, 'tank', '2012-12-19'),
(13, 'tank', '2012-12-19'),
(14, 'tank', '2012-12-19'),
(15, 'tank', '2012-12-19'),
(16, 'tank', '2012-12-19'),
(17, 'tank', '2012-12-19'),
(18, 'tank', '2012-12-19'),
(19, 'tank', '2012-12-19'),
(20, 'tank', '2012-12-20'),
(21, 'tank', '2012-12-20'),
(22, 'tank', '2012-12-20'),
(23, 'tank', '2012-12-20'),
(24, 'tank', '2012-12-20'),
(25, 'tank', '2012-12-21'),
(26, 'tank', '2012-12-21'),
(27, 'tank', '2012-12-21'),
(28, 'tank', '2012-12-21');

-- --------------------------------------------------------

--
-- Table structure for table `battles_detail`
--

CREATE TABLE IF NOT EXISTS `battles_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idbattle` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `result` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `battles_detail`
--

INSERT INTO `battles_detail` (`id`, `idbattle`, `iduser`, `result`) VALUES
(1, 28, 2, 1),
(2, 28, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `logins`
--

CREATE TABLE IF NOT EXISTS `logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `time` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_userid` (`id_user`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

--
-- Dumping data for table `logins`
--

INSERT INTO `logins` (`id`, `id_user`, `time`) VALUES
(1, 1, '2012-01-19'),
(2, 1, '2012-12-17'),
(3, 1, '2012-12-17'),
(4, 1, '2012-12-17'),
(5, 1, '2012-12-17'),
(6, 1, '2012-12-17'),
(7, 1, '2012-12-17'),
(8, 1, '2012-12-17'),
(9, 1, '2012-12-17'),
(10, 1, '2012-12-17'),
(11, 2, '2012-12-19'),
(12, 1, '2012-12-19'),
(13, 1, '2012-12-21'),
(14, 2, '2012-12-21'),
(15, 2, '2012-12-21'),
(16, 1, '2012-12-21'),
(17, 2, '2012-12-21'),
(18, 2, '2012-12-21'),
(19, 1, '2012-12-21');

-- --------------------------------------------------------

--
-- Table structure for table `logouts`
--

CREATE TABLE IF NOT EXISTS `logouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user` (`userID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `logouts`
--

INSERT INTO `logouts` (`id`, `userID`, `time`) VALUES
(1, 1, '2038-01-19 03:14:07'),
(2, 1, '2012-12-17 01:24:53'),
(3, 1, '2012-12-17 01:47:34'),
(4, 1, '2012-12-17 01:49:19'),
(5, 1, '2012-12-17 01:51:34'),
(6, 1, '2012-12-17 01:52:09');

-- --------------------------------------------------------

--
-- Table structure for table `policys`
--

CREATE TABLE IF NOT EXISTS `policys` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `des` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `policys`
--

INSERT INTO `policys` (`id`, `name`, `des`) VALUES
(1, 'USER', 'USER choi game binh thuong'),
(2, 'GM', 'GM theo doi va quan ly game'),
(3, 'MANAGER', 'Xem report hang thang'),
(4, 'ADMIN', 'Quyen Cao Nhat');

-- --------------------------------------------------------

--
-- Table structure for table `sexs`
--

CREATE TABLE IF NOT EXISTS `sexs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sex` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `sexs`
--

INSERT INTO `sexs` (`id`, `sex`) VALUES
(1, 'male'),
(2, 'female');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `pass` varchar(10) NOT NULL,
  `policy` int(11) NOT NULL,
  `win` int(10) unsigned NOT NULL,
  `lose` int(10) unsigned NOT NULL,
  `iLogin` tinyint(1) NOT NULL,
  `real_name` text,
  `phone_num` varchar(16) DEFAULT NULL,
  `cmnd` varchar(16) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `sex` int(11) DEFAULT NULL,
  `address` text,
  `email` varchar(30) DEFAULT NULL,
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_policy` (`policy`),
  KEY `fk_sex` (`sex`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `pass`, `policy`, `win`, `lose`, `iLogin`, `real_name`, `phone_num`, `cmnd`, `birthday`, `sex`, `address`, `email`, `reg_date`) VALUES
(1, 'thanhtri', '123456', 3, 0, 1, 0, 'Truong Mai Thanh Tri', NULL, NULL, '1991-12-04', 1, NULL, 'tmthanhtri@gmail.com', '2012-12-18 17:00:00'),
(2, 'tanloc', '123456', 3, 1, 0, 0, NULL, NULL, NULL, '1991-12-02', NULL, NULL, NULL, '2012-12-18 17:00:00'),
(3, 'trongnghia', '123456', 3, 9, 4, 0, NULL, NULL, NULL, '1990-12-23', NULL, NULL, NULL, '2012-12-18 17:00:00'),
(4, 'test1', '123456', 1, 0, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2012-12-18 17:00:00'),
(5, 'test5', '123456', 2, 0, 0, 0, '', '', '', NULL, 1, '', '', '0000-00-00 00:00:00');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `logins`
--
ALTER TABLE `logins`
  ADD CONSTRAINT `fk_userid` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`);

--
-- Constraints for table `logouts`
--
ALTER TABLE `logouts`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`userID`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_policy` FOREIGN KEY (`policy`) REFERENCES `policys` (`id`),
  ADD CONSTRAINT `fk_sex` FOREIGN KEY (`sex`) REFERENCES `sexs` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
