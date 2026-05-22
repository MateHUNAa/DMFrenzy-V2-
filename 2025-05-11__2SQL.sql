-- --------------------------------------------------------
-- Hoszt:                        127.0.0.1
-- Szerver verzió:               11.4.4-MariaDB - mariadb.org binary distribution
-- Szerver OS:                   Win64
-- HeidiSQL Verzió:              12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Struktúra mentése tábla dmf1. codem_notification
CREATE TABLE IF NOT EXISTS `codem_notification` (
  `identifier` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.codem_notification: ~1 rows (hozzávetőleg)
INSERT INTO `codem_notification` (`identifier`, `data`) VALUES
	('license:bd82d20c8b77af4762525b1b8ee241ba09e4aa39', '{"display":true,"position":"top-right","sound":true}');

-- Struktúra mentése tábla dmf1. discorduser
CREATE TABLE IF NOT EXISTS `discorduser` (
  `UserId` varchar(50) DEFAULT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `AvatarUrl` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.discorduser: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. dmf_cup
CREATE TABLE IF NOT EXISTS `dmf_cup` (
  `teamName` varchar(50) NOT NULL DEFAULT 'MATEHUN',
  `user1` varchar(50) DEFAULT NULL,
  `user2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`teamName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.dmf_cup: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. duty-time
CREATE TABLE IF NOT EXISTS `duty-time` (
  `userId` int(35) NOT NULL,
  `workedTime` datetime DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.duty-time: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` int(11) NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.items: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.jobs: ~16 rows (hozzávetőleg)
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
	('brazils', 'Brazils', 1),
	('cfx', '97', 1),
	('chicago', 'Chicago', 1),
	('crew', '1441', 1),
	('cry', 'Cry', 1),
	('existence', 'Existence', 1),
	('japan', 'Japan', 1),
	('lovelys', 'Lovelys', 1),
	('lunar', '777', 1),
	('notfound', 'Not Found', 1),
	('resistence', 'Resistence', 1),
	('royal', 'RoyalFive ♛', 1),
	('skibidisigmas', 'Skibidi Sigmas', 1),
	('srt', 'SRT', 1),
	('tizenharom', '1312', 1),
	('unemployed', 'unemployed', 0);

-- Struktúra mentése tábla dmf1. job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2570 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.job_grades: ~46 rows (hozzávetőleg)
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(133, 'chicago', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(134, 'chicago', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(135, 'chicago', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(136, 'cry', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(137, 'cry', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(138, 'cry', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(139, 'existence', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(140, 'existence', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(141, 'existence', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(142, 'notfound', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(143, 'notfound', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(144, 'notfound', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(145, 'tizenharom', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(146, 'tizenharom', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(147, 'tizenharom', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(148, 'lunar', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(149, 'lunar', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(150, 'lunar', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(151, 'royal', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(152, 'royal', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(153, 'royal', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(154, 'srt', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(155, 'srt', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(156, 'srt', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(157, 'brazils', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(158, 'brazils', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(159, 'brazils', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(160, 'resistence', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(161, 'resistence', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(162, 'resistence', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(163, 'crew', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(164, 'crew', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(165, 'crew', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(166, 'cfx', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(167, 'cfx', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(168, 'cfx', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(169, 'japan', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(170, 'japan', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(171, 'japan', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(172, 'skibidisigmas', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(173, 'skibidisigmas', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(174, 'skibidisigmas', 2, 'boss', 'Leader', 0, '{}', '{}'),
	(2566, 'unemployed', 0, 'unemployed', 'unemployed', 0, '{}', '{}'),
	(2567, 'lovelys', 0, 'tag', 'Tag', 0, '{}', '{}'),
	(2568, 'lovelys', 1, 'alboss', 'Al leader', 0, '{}', '{}'),
	(2569, 'lovelys', 2, 'boss', 'Leader', 0, '{}', '{}');

-- Struktúra mentése tábla dmf1. leaderboard
CREATE TABLE IF NOT EXISTS `leaderboard` (
  `guildid` int(11) DEFAULT NULL,
  `channelId` int(11) DEFAULT NULL,
  `messageId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.leaderboard: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. management_outfits
CREATE TABLE IF NOT EXISTS `management_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tábla adatainak mentése dmf1.management_outfits: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. mate-killcam
CREATE TABLE IF NOT EXISTS `mate-killcam` (
  `identifier` varchar(255) NOT NULL,
  `music-url` varchar(255) DEFAULT NULL,
  `background-url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.mate-killcam: ~1 rows (hozzávetőleg)
INSERT INTO `mate-killcam` (`identifier`, `music-url`, `background-url`) VALUES
	('bd82d20c8b77af4762525b1b8ee241ba09e4aa39', 'https://www.youtube.com/watch?v=WdJLJ2yotJw', NULL);

-- Struktúra mentése tábla dmf1. mate-mute
CREATE TABLE IF NOT EXISTS `mate-mute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mutedIdentifier` varchar(255) NOT NULL,
  `mutedUntil` timestamp NULL DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.mate-mute: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. mate-peds
CREATE TABLE IF NOT EXISTS `mate-peds` (
  `identifier` varchar(50) DEFAULT NULL,
  `ped` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.mate-peds: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. mate_factionkd
CREATE TABLE IF NOT EXISTS `mate_factionkd` (
  `job` varchar(255) NOT NULL,
  `kills` int(11) NOT NULL DEFAULT 0,
  `deaths` int(11) NOT NULL DEFAULT 0,
  `headshots` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.mate_factionkd: ~1 rows (hozzávetőleg)
INSERT INTO `mate_factionkd` (`job`, `kills`, `deaths`, `headshots`) VALUES
	('lovelys', 0, 0, 0);

-- Struktúra mentése tábla dmf1. mate_kd
CREATE TABLE IF NOT EXISTS `mate_kd` (
  `identifier` varchar(255) NOT NULL,
  `kills` int(11) NOT NULL DEFAULT 0,
  `deaths` int(11) NOT NULL DEFAULT 0,
  `headshot` int(11) NOT NULL DEFAULT 0,
  `discordid` varchar(255) DEFAULT NULL,
  `npc_killed` int(11) DEFAULT NULL,
  `player_name` varchar(255) DEFAULT 'NOT SET',
  `rang` varchar(255) DEFAULT NULL,
  `highestKS` int(11) DEFAULT 0,
  PRIMARY KEY (`identifier`),
  KEY `Index 3` (`rang`),
  CONSTRAINT `FK_mate_kd_rime_rang` FOREIGN KEY (`rang`) REFERENCES `rime_rang` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.mate_kd: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. mate_vipsystem
CREATE TABLE IF NOT EXISTS `mate_vipsystem` (
  `discordId` varchar(255) NOT NULL DEFAULT 'NAN',
  `level` tinyint(4) NOT NULL DEFAULT 0,
  `experiation_date` datetime NOT NULL,
  `create_date` datetime NOT NULL DEFAULT current_timestamp(),
  `roleId` varchar(50) NOT NULL,
  PRIMARY KEY (`discordId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.mate_vipsystem: ~1 rows (hozzávetőleg)
INSERT INTO `mate_vipsystem` (`discordId`, `level`, `experiation_date`, `create_date`, `roleId`) VALUES
	('575342593630797825', 1, '2025-06-22 15:21:27', '2025-05-21 14:20:27', '123');

-- Struktúra mentése tábla dmf1. outfits
CREATE TABLE IF NOT EXISTS `outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(46) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `ped` longtext DEFAULT NULL,
  `components` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.outfits: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(46) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `parking` varchar(60) DEFAULT NULL,
  `pound` varchar(60) DEFAULT NULL,
  `mileage` float DEFAULT 0,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.owned_vehicles: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(46) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.ox_inventory: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Tábla adatainak mentése dmf1.playerskins: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tábla adatainak mentése dmf1.player_outfits: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. player_outfit_codes
CREATE TABLE IF NOT EXISTS `player_outfit_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_player_outfit_codes_player_outfits` (`outfitid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tábla adatainak mentése dmf1.player_outfit_codes: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. rime_rang
CREATE TABLE IF NOT EXISTS `rime_rang` (
  `name` varchar(255) NOT NULL DEFAULT 'Rookie',
  `label` varchar(255) NOT NULL,
  `required_kills` int(11) NOT NULL DEFAULT 250,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.rime_rang: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. ticket
CREATE TABLE IF NOT EXISTS `ticket` (
  `GuildID` varchar(50) DEFAULT NULL,
  `ChannelID` varchar(50) DEFAULT NULL,
  `DiscordUserID` varchar(50) DEFAULT NULL,
  `Type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.ticket: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. ticket_categorys
CREATE TABLE IF NOT EXISTS `ticket_categorys` (
  `GuildId` varchar(50) DEFAULT NULL,
  `CategoryId` varchar(50) DEFAULT NULL,
  `CategoryName` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.ticket_categorys: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. ticket_system
CREATE TABLE IF NOT EXISTS `ticket_system` (
  `GuildId` varchar(50) DEFAULT NULL,
  `ChannelId` varchar(50) DEFAULT NULL,
  `MessageId` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.ticket_system: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. users
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(46) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` int(11) DEFAULT 188,
  `skin` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_seen` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `comserv` text DEFAULT '',
  `firstJoin` int(11) DEFAULT unix_timestamp(),
  `jail` text DEFAULT '',
  `ban` text DEFAULT '',
  `dutyTime` int(11) DEFAULT 0,
  `playedTime` int(11) DEFAULT 0,
  `discordid` varchar(255) DEFAULT NULL,
  `discord_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discord_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(50) DEFAULT 'MATEHUN',
  `lastname` varchar(50) DEFAULT 'MATEHUN',
  `dateofbirth` varchar(50) DEFAULT NULL,
  `favouritesGamemode` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[]',
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.users: ~1 rows (hozzávetőleg)
INSERT INTO `users` (`identifier`, `accounts`, `group`, `inventory`, `job`, `job_grade`, `loadout`, `metadata`, `position`, `sex`, `height`, `skin`, `status`, `is_dead`, `id`, `disabled`, `created_at`, `last_seen`, `comserv`, `firstJoin`, `jail`, `ban`, `dutyTime`, `playedTime`, `discordid`, `discord_url`, `discord_name`, `firstname`, `lastname`, `dateofbirth`, `favouritesGamemode`) VALUES
	('bd82d20c8b77af4762525b1b8ee241ba09e4aa39', '{"bank":50000,"money":10000,"black_money":99}', 'developer', '[{"metadata":{"registered":"MateHUN","components":[],"durability":100,"serial":"281823ZRI107391","ammo":0},"slot":1,"count":1,"name":"WEAPON_APPISTOL"},{"slot":2,"count":95,"name":"armour"},{"slot":3,"count":99,"name":"black_money"},{"slot":4,"count":10000,"name":"money"}]', 'unemployed', 0, '[]', '{"health":200,"armor":72}', '{"z":243.3905029296875,"y":-804.0263671875,"x":-70.68132019042969,"heading":351.4960632324219}', NULL, 188, NULL, NULL, 0, 176, 0, '2025-05-10 17:25:18', '2025-05-22 23:25:40', '', 1746897918, '', '', 0, 15168, '575342593630797825', 'https://cdn.discordapp.com/avatars/575342593630797825/d35c0ebf35bc2499a2a29771b0233f9a.png?size=1024', '𝓜𝓪𝓽𝓮𝓗𝓤𝓝', 'MATEHUN', 'MATEHUN', NULL, '[]');

-- Struktúra mentése tábla dmf1. vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `model` varchar(60) NOT NULL,
  `shop` varchar(60) DEFAULT NULL,
  `name` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  UNIQUE KEY `car` (`model`,`shop`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.vehicles: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. vehicle_categories
CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Tábla adatainak mentése dmf1.vehicle_categories: ~0 rows (hozzávetőleg)

-- Struktúra mentése tábla dmf1. vip_roles
CREATE TABLE IF NOT EXISTS `vip_roles` (
  `guildId` varchar(50) DEFAULT NULL,
  `roleId` varchar(50) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `roleName` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tábla adatainak mentése dmf1.vip_roles: ~0 rows (hozzávetőleg)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
