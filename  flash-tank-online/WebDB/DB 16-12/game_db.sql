-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 16, 2012 at 01:59 PM
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
-- Table structure for table `login`
--

CREATE TABLE IF NOT EXISTS `login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `login` date NOT NULL,
  `logout` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_userid` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `policy`
--

CREATE TABLE IF NOT EXISTS `policy` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `des` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `policy`
--

INSERT INTO `policy` (`id`, `name`, `des`) VALUES
(1, 'USER', 'USER choi game binh thuong'),
(2, 'GM', 'GM theo doi va quan ly game'),
(3, 'MANAGER', 'Xem report hang thang'),
(4, 'ADMIN', 'Quyen Cao Nhat');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `pass` varchar(10) NOT NULL,
  `policy` int(11) NOT NULL,
  `win` int(10) unsigned NOT NULL,
  `lose` int(10) unsigned NOT NULL,
  `iLogin` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_policy` (`policy`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `pass`, `policy`, `win`, `lose`, `iLogin`) VALUES
(1, 'thanhtri', '123456', 4, 0, 0, 0),
(2, 'tanloc', '123456', 4, 0, 0, 0),
(3, 'trongnghia', '123456', 4, 0, 0, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `fk_userid` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_policy` FOREIGN KEY (`policy`) REFERENCES `policy` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
