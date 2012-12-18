-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 18, 2012 at 07:58 PM
-- Server version: 5.5.24-log
-- PHP Version: 5.4.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `game_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `battles`
--

CREATE TABLE IF NOT EXISTS `battles` (
  `id` int(11) unsigned NOT NULL DEFAULT '0',
  `game` varchar(12) DEFAULT NULL,
  `time` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `battles_detail`
--

CREATE TABLE IF NOT EXISTS `battles_detail` (
  `idbattle` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `result` int(11) NOT NULL,
  PRIMARY KEY (`idbattle`,`iduser`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

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
(12, 1, '2012-12-19');

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
  PRIMARY KEY (`id`),
  KEY `fk_policy` (`policy`),
  KEY `fk_sex` (`sex`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `pass`, `policy`, `win`, `lose`, `iLogin`, `real_name`, `phone_num`, `cmnd`, `birthday`, `sex`, `address`, `email`) VALUES
(1, 'thanhtri', '123456', 4, 0, 0, 0, 'Truong Mai Thanh Tri', NULL, NULL, NULL, 1, NULL, 'tmthanhtri@gmail.com'),
(2, 'tanloc', '123456', 4, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'trongnghia', '123456', 4, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
  ADD CONSTRAINT `fk_sex` FOREIGN KEY (`sex`) REFERENCES `sexs` (`id`),
  ADD CONSTRAINT `fk_policy` FOREIGN KEY (`policy`) REFERENCES `policys` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
