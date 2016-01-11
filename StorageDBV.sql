-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Янв 11 2016 г., 12:03
-- Версия сервера: 5.5.46-0ubuntu0.14.04.2
-- Версия PHP: 5.5.9-1ubuntu4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `StorageDBV`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_product`(IN `name` VARCHAR(50), IN `categ` VARCHAR(50), IN `country` VARCHAR(20), IN `cost` FLOAT, IN `mycount` INT, IN `branch` INT)
begin
declare prod_id integer;
insert into Product (product_name, product_category,
product_made, product_cost)
values(name,categ,country,cost);
set prod_id = (select max(product_id) from Product);
insert into BranchProduct (product_id,branch_id,product_rest)
values(prod_id,branch,mycount);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_product`(name varchar(50), categ varchar(50), country varchar(20), cost float, my_count integer, branch integer)
begin
declare prod_id integer;
set prod_id = (select product_id from Product where product_name = name and product_category = categ and product_made = country);
update Product set product_cost=cost where product_id=prod_id;
update BranchProduct set product_rest = product_rest + my_count where product_id = prod_id and branch_id = branch;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_branch`(user Varchar(30))
begin
	select branch_id, branch_address from Branch
	where branch_id in
	(select branch_id from Manager where user_id in
     (select id from auth_user where username=user));
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_manager`(user varchar(30))
begin
    select manager_id from Manager
    where user_id in (select id from auth_user where
                      username=user);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `make_order`(m_id integer, b_id integer, cl_name varchar(50), cl_addr varchar(50), cl_birth date, totalcost integer, o_date date)
begin
	declare c_id integer;
	set c_id =(select client_id from Client where client_name=cl_name);
	insert into OrderTable (manager_id, client_id, branch_id, order_totalcost, order_address, order_date)
	values(m_id, c_id, b_id, totalcost, cl_addr, o_date);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_product`(p_id integer, p_count integer)
begin
	declare o_id integer;
	set o_id = (select max(order_id) from OrderTable);
	insert into OrderProduct (order_id, product_id, product_count)
	values(o_id, p_id, p_count);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `products_in_branch`(IN `branch` INT)
begin
	select Product.product_id, product_name, product_cost, product_made, product_category, product_rest from Product join BranchProduct 
	on Product.product_id=BranchProduct.product_id
	where BranchProduct.branch_id=branch;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_group_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissi_permission_id_84c5c92e_fk_auth_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_permission`
--

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_01ab375a_uniq` (`content_type_id`,`codename`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=46 ;

--
-- Дамп данных таблицы `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add client', 1, 'add_client'),
(2, 'Can change client', 1, 'change_client'),
(3, 'Can delete client', 1, 'delete_client'),
(4, 'Can add product', 2, 'add_product'),
(5, 'Can change product', 2, 'change_product'),
(6, 'Can delete product', 2, 'delete_product'),
(7, 'Can add branch', 3, 'add_branch'),
(8, 'Can change branch', 3, 'change_branch'),
(9, 'Can delete branch', 3, 'delete_branch'),
(10, 'Can add manager', 4, 'add_manager'),
(11, 'Can change manager', 4, 'change_manager'),
(12, 'Can delete manager', 4, 'delete_manager'),
(13, 'Can add auto', 5, 'add_auto'),
(14, 'Can change auto', 5, 'change_auto'),
(15, 'Can delete auto', 5, 'delete_auto'),
(16, 'Can add driver', 6, 'add_driver'),
(17, 'Can change driver', 6, 'change_driver'),
(18, 'Can delete driver', 6, 'delete_driver'),
(19, 'Can add ordertable', 7, 'add_ordertable'),
(20, 'Can change ordertable', 7, 'change_ordertable'),
(21, 'Can delete ordertable', 7, 'delete_ordertable'),
(22, 'Can add branchproduct', 8, 'add_branchproduct'),
(23, 'Can change branchproduct', 8, 'change_branchproduct'),
(24, 'Can delete branchproduct', 8, 'delete_branchproduct'),
(25, 'Can add orderproduct', 9, 'add_orderproduct'),
(26, 'Can change orderproduct', 9, 'change_orderproduct'),
(27, 'Can delete orderproduct', 9, 'delete_orderproduct'),
(28, 'Can add log entry', 10, 'add_logentry'),
(29, 'Can change log entry', 10, 'change_logentry'),
(30, 'Can delete log entry', 10, 'delete_logentry'),
(31, 'Can add permission', 11, 'add_permission'),
(32, 'Can change permission', 11, 'change_permission'),
(33, 'Can delete permission', 11, 'delete_permission'),
(34, 'Can add group', 12, 'add_group'),
(35, 'Can change group', 12, 'change_group'),
(36, 'Can delete group', 12, 'delete_group'),
(37, 'Can add user', 13, 'add_user'),
(38, 'Can change user', 13, 'change_user'),
(39, 'Can delete user', 13, 'delete_user'),
(40, 'Can add content type', 14, 'add_contenttype'),
(41, 'Can change content type', 14, 'change_contenttype'),
(42, 'Can delete content type', 14, 'delete_contenttype'),
(43, 'Can add session', 15, 'add_session'),
(44, 'Can change session', 15, 'change_session'),
(45, 'Can delete session', 15, 'delete_session');

-- --------------------------------------------------------

--
-- Структура таблицы `auth_user`
--

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=122 ;

--
-- Дамп данных таблицы `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$24000$8jrrMWWsXgwx$LzXYLCjSLSPGI1KCJtgH+3koP/HMaP74ygmoCSDMjpg=', '2016-01-07 17:50:40', 1, 'admin', '', '', '', 1, 1, '2016-01-04 09:13:06'),
(2, 'pbkdf2_sha256$24000$yuc9MncEzVUm$q6vRu9l5vX7YhKUNZeqFEoktiSpcef09SqbBC5PdjQ4=', '2016-01-11 08:48:10', 0, 'manager1', 'Новикова Елена', '', '', 0, 1, '2016-01-04 13:01:32'),
(3, 'pbkdf2_sha256$24000$JgIOQBh7kCFa$OoCo0amPEQrIiuWayg6k38PUcJ/+LhmNS2QpECtMcks=', NULL, 0, 'manager2', 'Суворов Павел', '', '', 0, 1, '2016-01-04 13:01:32'),
(4, 'pbkdf2_sha256$24000$h46Ndm80ue9q$Ee+m98JKLC1a7YO4C0lwVX0eHguXdNzW16PjdNw4rUY=', NULL, 0, 'manager3', 'Мишин Максим', '', '', 0, 1, '2016-01-04 13:01:32'),
(5, 'pbkdf2_sha256$24000$uIAd9TjA3kqJ$xwqt7r/S+OZ/uT6FyW3ZAVczeHEE42OQVP10OQ8pCLc=', NULL, 0, 'manager4', 'Некрасов Эраст', '', '', 0, 1, '2016-01-04 13:01:32'),
(6, 'pbkdf2_sha256$24000$UmLDnq8rqdlF$5Pihe6ciKd/RHWCz7ttrEL370YRdY8/lKiM3o6xbFrE=', NULL, 0, 'manager5', 'Лебедева Любовь', '', '', 0, 1, '2016-01-04 13:01:32'),
(7, 'pbkdf2_sha256$24000$v8G2t9np5l9i$cIAgNWyXSUvaXuOOvxMYJBtdDsIzKiCfIJ73lqIUfH4=', NULL, 0, 'manager6', 'Миронов Пётр', '', '', 0, 1, '2016-01-04 13:01:33'),
(8, 'pbkdf2_sha256$24000$pHVesuUNnvzd$2Loesqvqsm6hBcz+wUw5Jo/geIatK9xrP39OJYavfMY=', NULL, 0, 'manager7', 'Сидоров Ярослав', '', '', 0, 1, '2016-01-04 13:01:33'),
(9, 'pbkdf2_sha256$24000$x8cE31uOogVp$f2QiaAmSJTfC9N1iE5GUNz72gwgg7HoITv4KoJ7M6dQ=', NULL, 0, 'manager8', 'Комиссаров Станислав', '', '', 0, 1, '2016-01-04 13:01:33'),
(10, 'pbkdf2_sha256$24000$6pTBPknETdPM$wylx5yzUl5F3RSH3//98vDeRumB+EvXMhcuFwyY69Bw=', NULL, 0, 'manager9', 'Ковалёва Таисия', '', '', 0, 1, '2016-01-04 13:01:33'),
(11, 'pbkdf2_sha256$24000$IH6Paoeni8WH$ymC/rgYcuNW9vkWlRhOqVpoINRE4Dw/cjU+ltEOr3gQ=', NULL, 0, 'manager10', 'Крюков Анатолий', '', '', 0, 1, '2016-01-04 13:01:33'),
(12, 'pbkdf2_sha256$24000$gaxglt2Jdgtt$/fA3v3LYQZsMZASSAW3zG50zvD4mwZ9689Bk06kZO0Q=', NULL, 0, 'manager11', 'Гришин Эдуард', '', '', 0, 1, '2016-01-04 13:01:33'),
(13, 'pbkdf2_sha256$24000$5srS18yf935V$GUZs8gF1/0ysEpx1f6KeJVrk5Jg0RaHtDxdDyouHIv4=', NULL, 0, 'manager12', 'Ефимова Анастасия', '', '', 0, 1, '2016-01-04 13:01:33'),
(14, 'pbkdf2_sha256$24000$mLPh6dmLla2m$Bq8ZGWxnyTctuUlxOxru3UhnyiONLdoFccDbL/QArmA=', NULL, 0, 'manager13', 'Мартынов Фёдор', '', '', 0, 1, '2016-01-04 13:01:33'),
(15, 'pbkdf2_sha256$24000$TkcD2goZmSs0$cXfov7+k2R7yg9GyIUQL3iwWZXo78Odx2jOF+s76K8c=', NULL, 0, 'manager14', 'Трофимов Вадим', '', '', 0, 1, '2016-01-04 13:01:33'),
(16, 'pbkdf2_sha256$24000$iIWlMqYNuDwF$8PFXImrnRlorbEuwepvEQZODZV0QlarYlPs43yY1gus=', NULL, 0, 'manager15', 'Стрелкова Александра', '', '', 0, 1, '2016-01-04 13:01:33'),
(17, 'pbkdf2_sha256$24000$mMBGGGjhNlBX$VXi2tgGgyG/tf1FWbvgNjdaba7v10cIlir600t9uUNQ=', NULL, 0, 'manager16', 'Шашков Артём', '', '', 0, 1, '2016-01-04 13:01:33'),
(18, 'pbkdf2_sha256$24000$oTUPA773yNt2$pgVcw7QmwEUS2shRMzT8ABiv+i4GyUJUGBurXt4CFsc=', NULL, 0, 'manager17', 'Герасимова Майя', '', '', 0, 1, '2016-01-04 13:01:33'),
(19, 'pbkdf2_sha256$24000$pePpI1usVa21$LOWuvJEozCudLFk/rozLO3j1DlFIn3Srb8kyrZy678o=', NULL, 0, 'manager18', 'Филатова Валерия', '', '', 0, 1, '2016-01-04 13:01:33'),
(20, 'pbkdf2_sha256$24000$tn74MmrJRH5e$vtkeIQaPxctF2BavHY+wlynKoJtAT+nYzvYD2tm0shE=', NULL, 0, 'manager19', 'Мясникова Ксения', '', '', 0, 1, '2016-01-04 13:01:33'),
(21, 'pbkdf2_sha256$24000$PDNE18JADmeb$01l1QPnEm6eIlgRfm+RZ8d+01GWBfolX0ysH2T5DOWE=', NULL, 0, 'manager20', 'Третьякова Ярослава', '', '', 0, 1, '2016-01-04 13:01:33'),
(22, 'pbkdf2_sha256$24000$Wa6PDJKKW7NG$5v+3VN0HlXJPeWqhn+l5Jrp5jysstSkdehuIsDmU0ck=', NULL, 0, 'manager21', 'Фролов Анатолий', '', '', 0, 1, '2016-01-04 13:01:33'),
(23, 'pbkdf2_sha256$24000$FLO2QzjTL6DR$m8oJcw3CiSmZqvEQ55rKrGSrWCYqp0F53X/52/e5Z/w=', NULL, 0, 'manager22', 'Сазонов Фёдор', '', '', 0, 1, '2016-01-04 13:01:33'),
(24, 'pbkdf2_sha256$24000$mrY7bYumXJQC$BujuhG/PoP/ue7JMNLYu2fkTrAUBs8qIsnroE8ZC6cY=', NULL, 0, 'manager23', 'Прохорова Алина', '', '', 0, 1, '2016-01-04 13:01:33'),
(25, 'pbkdf2_sha256$24000$4zOiCxPjtUmn$RXrQuDXileBkZIJlxqSX12H9Qs8xRYfmU22Bw61V4lk=', NULL, 0, 'manager24', 'Якушев Григорий', '', '', 0, 1, '2016-01-04 13:01:33'),
(26, 'pbkdf2_sha256$24000$7042Rlxo4AFz$Hh5TLs66Aa5ECbeswsZ6EiMnTX4uVR35uvg3QwKy5Q0=', NULL, 0, 'manager25', 'Агафонова Марина', '', '', 0, 1, '2016-01-04 13:01:34'),
(27, 'pbkdf2_sha256$24000$XvLyh6LzOJAj$/1mblxPzK84AqX4hLd4X/hWy8okjbthSa7J+/p5Nziw=', NULL, 0, 'manager26', 'Агафонов Михаил', '', '', 0, 1, '2016-01-04 13:01:34'),
(28, 'pbkdf2_sha256$24000$coyWdPXM6T0g$LmCKLWq8iPiBbSAPsvamH+VNrUSCcU/3kKFkfYds9C0=', NULL, 0, 'manager27', 'Анисимов Александр', '', '', 0, 1, '2016-01-04 13:01:34'),
(29, 'pbkdf2_sha256$24000$3XXPjMJxL3HF$WnkW4s8WnX/5eI7FKL1vndKfx2hp/yc+D6oD8g3VVC8=', NULL, 0, 'manager28', 'Сазонова Галина', '', '', 0, 1, '2016-01-04 13:01:34'),
(30, 'pbkdf2_sha256$24000$sZXw4n6wwBHP$f2Ie8uojrthbiX9i3o6oJ9j7q/dALx5F7HSOt+YkHBs=', NULL, 0, 'manager29', 'Суханов Трофим', '', '', 0, 1, '2016-01-04 13:01:34'),
(31, 'pbkdf2_sha256$24000$wGROJmmyXxAX$w+JWPnOcLnS+Iq1Ak7l1qlNJambjmGH0EF+FUU6El6o=', NULL, 0, 'manager30', 'Лебедев Федот', '', '', 0, 1, '2016-01-04 13:01:34'),
(32, 'pbkdf2_sha256$24000$j8hZxvlIirqB$QjiC7CrFIC0ZoSB/l0et4TB07bzPlcQ3aKJvGgJFDl0=', NULL, 0, 'manager31', 'Тарасова Фаина', '', '', 0, 1, '2016-01-04 13:01:34'),
(33, 'pbkdf2_sha256$24000$d8OOrVJuclfo$HP5WTwCmDtE4AvXsGayHNhR1B+S6QJRfHijKkLNnqRM=', '2016-01-07 15:38:51', 0, 'manager32', 'Субботин Вадим', '', '', 0, 1, '2016-01-04 13:01:34'),
(34, 'pbkdf2_sha256$24000$V8ChOjJYCfLe$4Ib/Ur94dbjnxJd27iFhVjFS64d1Sk/auHmZtSundYs=', NULL, 0, 'manager33', 'Турова Марина', '', '', 0, 1, '2016-01-04 13:01:34'),
(35, 'pbkdf2_sha256$24000$Y0Lvpr59QGwR$s41jxV6+QlRHJgZWDs7ruMHO+ceoMdYP67a7rjSeooY=', NULL, 0, 'manager34', 'Соловьёв Роман', '', '', 0, 1, '2016-01-04 13:01:34'),
(36, 'pbkdf2_sha256$24000$jmhgr7cZ7HMS$vNbCtlOPmd0/DA3NKpSMd/fQaKJVxrRU2E9OC+FMoSM=', NULL, 0, 'manager35', 'Семёнов Сергей', '', '', 0, 1, '2016-01-04 13:01:34'),
(37, 'pbkdf2_sha256$24000$Diyt84gXLga8$mtA4lBHmhGwCwwlzF0spfpsyhL53ZxJ9ArzyVHLPzsI=', NULL, 0, 'manager36', 'Артемьев Павел', '', '', 0, 1, '2016-01-04 13:01:34'),
(38, 'pbkdf2_sha256$24000$PwioHKGMqAkb$HbZZiTESlYExfeQVm2Oe/lmO02ZNa+TIO0t1UjPU3H0=', NULL, 0, 'manager37', 'Емельянова София', '', '', 0, 1, '2016-01-04 13:01:34'),
(39, 'pbkdf2_sha256$24000$vlgfPIWwii6z$XunVlIufa8ryZh+Mb6IcJsXC2a5v0y316cg4pjtYK78=', NULL, 0, 'manager38', 'Крылова Василиса', '', '', 0, 1, '2016-01-04 13:01:34'),
(40, 'pbkdf2_sha256$24000$CscPlNvnslPh$D+XPUQeyVb5/KhQgRiMhacZzGu+D4Ipq0t5ZEfxuq7c=', NULL, 0, 'manager39', 'Родионов Герасим', '', '', 0, 1, '2016-01-04 13:01:34'),
(41, 'pbkdf2_sha256$24000$BoLoyWwzFxH8$Pl/MFNBPvy8SomOxIuBy3HsgNY6aMaWSIZCVIQEbUP4=', NULL, 0, 'manager40', 'Кононов Герман', '', '', 0, 1, '2016-01-04 13:01:34'),
(42, 'pbkdf2_sha256$24000$T6t0kEJrAsjv$UqrB6Zu3QSPuY7YhVgxHULsDKqd5zKLx6lg3lVNiux0=', NULL, 0, 'manager41', 'Потапова Снежана', '', '', 0, 1, '2016-01-04 13:01:34'),
(43, 'pbkdf2_sha256$24000$CJx0mpSj9TCd$gqZEvDnPeCNFvvBpYUMHutNxCR0zG4rAnoNrvhTLWfc=', NULL, 0, 'manager42', 'Абрамов Арсений', '', '', 0, 1, '2016-01-04 13:01:35'),
(44, 'pbkdf2_sha256$24000$imhcDBioDpW5$hoIF3iSl4Lqcx2QTiksRySqq7ac/W25Tesn72n/sc54=', NULL, 0, 'manager43', 'Шилов Иннокентий', '', '', 0, 1, '2016-01-04 13:01:35'),
(45, 'pbkdf2_sha256$24000$YYvjOZdAbWy5$BYnHDq36Tm013b/XFeBH4Im71Fgejt4Kvyky6nZHNrY=', NULL, 0, 'manager44', 'Исаев Геннадий', '', '', 0, 1, '2016-01-04 13:01:35'),
(46, 'pbkdf2_sha256$24000$EvPQPhz7PXVn$28ILleZNOW4qYpw83MntELXE+b5xe+QTNoZ+JnHFq7E=', NULL, 0, 'manager45', 'Горбачёва Алина', '', '', 0, 1, '2016-01-04 13:01:35'),
(47, 'pbkdf2_sha256$24000$ysh7EGvaa0Uf$YUyd1p9ro+QQLbQVN4m6fuO4KAWTlbhM+e3ORukavrw=', NULL, 0, 'manager46', 'Цветков Борис', '', '', 0, 1, '2016-01-04 13:01:35'),
(48, 'pbkdf2_sha256$24000$8DTzbFV6IEhM$5n9AcCR8KIeNvqNq+RZSfz7xkOkVwxk2QJek8oHHbwg=', NULL, 0, 'manager47', 'Орлова Фаина', '', '', 0, 1, '2016-01-04 13:01:35'),
(49, 'pbkdf2_sha256$24000$D9i4tF2APMdk$asEByAg8n5NzJE8TlnmBwIbR7Do02zR2I7Voi1KCsbg=', NULL, 0, 'manager48', 'Гришин Вениамин', '', '', 0, 1, '2016-01-04 13:01:35'),
(50, 'pbkdf2_sha256$24000$Mzty1J1PWlSi$Veb3hgBS7ElY+2oo6rJxi1pBwaftNR9adfvDSAdu5+w=', NULL, 0, 'manager49', 'Денисов Семён', '', '', 0, 1, '2016-01-04 13:01:35'),
(51, 'pbkdf2_sha256$24000$YQHuDg2wm5dm$AWgV8++ptUJkiRA4ssQSAWnVi5di8dOyV7DeJsokq7E=', NULL, 0, 'manager50', 'Голубева Любовь', '', '', 0, 1, '2016-01-04 13:01:35'),
(52, 'pbkdf2_sha256$24000$OQ1wbBlmRFbG$WmOtAwB8Pw0JVBob0wFqRrMivPbv+67sjhfp9V5Lqac=', NULL, 0, 'manager51', 'Алексеев Егор', '', '', 0, 1, '2016-01-04 13:01:35'),
(53, 'pbkdf2_sha256$24000$MdgJvdpaV038$TDwg8OGU9yttzFVX4Pkq8jDhrkdSsA63SNE4hvvCUh8=', NULL, 0, 'manager52', 'Самойлова Нина', '', '', 0, 1, '2016-01-04 13:01:35'),
(54, 'pbkdf2_sha256$24000$HJm0USHhoKxj$FHQ1dHNMC//Bac+8PkbBBluDiiwW1f0Io5NG8CDC5Ug=', NULL, 0, 'manager53', 'Мясников Семён', '', '', 0, 1, '2016-01-04 13:01:35'),
(55, 'pbkdf2_sha256$24000$rz2vFRGYDWdU$Hdh6r4R+WsUxEanL0splE2hTT5RNpF0FNgajU+3POrs=', NULL, 0, 'manager54', 'Бобылёва Нонна', '', '', 0, 1, '2016-01-04 13:01:35'),
(56, 'pbkdf2_sha256$24000$b6njqx0IVk3C$C0P3F2UeAI6nGvDb1w4lBpIEHg7Mumn+aeQ1xu2sil0=', NULL, 0, 'manager55', 'Николаева Василиса', '', '', 0, 1, '2016-01-04 13:01:35'),
(57, 'pbkdf2_sha256$24000$CA4llkW0bK2q$y1/2e/JMJG79Hp4x08ErQPEKiak4SqjosQY+AVLYf2g=', NULL, 0, 'manager56', 'Одинцова Елизавета', '', '', 0, 1, '2016-01-04 13:01:35'),
(58, 'pbkdf2_sha256$24000$uVnWlABrXmAS$pFzJep7d72opUdQ+9xWLYS0jykR+eisLQlauNmBR9KE=', NULL, 0, 'manager57', 'Морозов Ефим', '', '', 0, 1, '2016-01-04 13:01:35'),
(59, 'pbkdf2_sha256$24000$J0numSQUBbsH$ltnStcQ3HpKAzzwnoI/uHrM+/9gwYUDUOYzwXR5Ut0U=', NULL, 0, 'manager58', 'Молчанова Снежана', '', '', 0, 1, '2016-01-04 13:01:35'),
(60, 'pbkdf2_sha256$24000$tbVMTkFKKe0j$y1fHQyspeWko8pF3ZGAOB9yyhzjMy7bES/wBdqteDUs=', NULL, 0, 'manager59', 'Медведев Александр', '', '', 0, 1, '2016-01-04 13:01:35'),
(61, 'pbkdf2_sha256$24000$IMnR1M4E4sS7$mbX0ek6T8XyX3jCZT8Qn8cYmHylncYWB1XYrV11EqHE=', NULL, 0, 'manager60', 'Колесников Николай', '', '', 0, 1, '2016-01-04 13:01:35'),
(62, 'pbkdf2_sha256$24000$Xm40SAFikQSj$n+boifjtCgW5X+QVNePRJDo2jL7eLgtzx0bE+cmPvZM=', NULL, 0, 'manager61', 'Мельников Ярослав', '', '', 0, 1, '2016-01-04 13:01:35'),
(63, 'pbkdf2_sha256$24000$IeuZ2zVddBMJ$75Ts3IDbcUUCXLxcioNMZZAy8NHdclhqk8bMxTrYuvI=', NULL, 0, 'manager62', 'Турова Ярослава', '', '', 0, 1, '2016-01-04 13:01:36'),
(64, 'pbkdf2_sha256$24000$NoJbnPp3o7Nw$wa5E1GvWtxDbzIllVriTkIjFFk23maEV6TTPwPmMHtc=', NULL, 0, 'manager63', 'Щербакова Ярослава', '', '', 0, 1, '2016-01-04 13:01:36'),
(65, 'pbkdf2_sha256$24000$g4EvxjEdqc5n$WShRe6XFB/tfHR+PTK9PCDNE/6ta1DAnQCsVs0SG8Gk=', NULL, 0, 'manager64', 'Зайцев Артём', '', '', 0, 1, '2016-01-04 13:01:36'),
(66, 'pbkdf2_sha256$24000$8TouhbIW6BPI$EmfsoQkvHy79WEP1Mp7R/QUK6G4DsJsmUK7Akxv/Y0I=', NULL, 0, 'manager65', 'Попова Анастасия', '', '', 0, 1, '2016-01-04 13:01:36'),
(67, 'pbkdf2_sha256$24000$wkbv8rgVKWbk$x9Th6cLvT9/JhB0yK8nTwqHpdZXgUKJQS0+LhkcVPXI=', NULL, 0, 'manager66', 'Афанасьев Тимофей', '', '', 0, 1, '2016-01-04 13:01:36'),
(68, 'pbkdf2_sha256$24000$Lb1J7dAZHRut$bqg23KW0yjCxbO0RrA0pRgswg2rJQydytR2UwWeWZ9M=', NULL, 0, 'manager67', 'Мухина Раиса', '', '', 0, 1, '2016-01-04 13:01:36'),
(69, 'pbkdf2_sha256$24000$uFIe1FjoXYMs$I4tUM+2tMs3EdgPgq80OkOfgX/TRkWMrD3Opi0saJdg=', NULL, 0, 'manager68', 'Стрелкова Анна', '', '', 0, 1, '2016-01-04 13:01:36'),
(70, 'pbkdf2_sha256$24000$4U6FrF8vpAUX$Lkxa4DzUiXexWK/WHxKVSqgUs6Bx86oKOgNyVVDVXNk=', NULL, 0, 'manager69', 'Меркушева Галина', '', '', 0, 1, '2016-01-04 13:01:36'),
(71, 'pbkdf2_sha256$24000$N9CHsH8K8Oby$dRFqwmRbfphIJbarj24lkqvx+OiOwWnFVqr92Id4/4M=', NULL, 0, 'manager70', 'Зиновьева Анна', '', '', 0, 1, '2016-01-04 13:01:36'),
(72, 'pbkdf2_sha256$24000$IbvUvdKqkyxu$yo9jSfMu6I7wFIZjSqe/g+vBGMwLi0aU6RPS7IlmvFM=', NULL, 0, 'manager71', 'Ширяев Тимофей', '', '', 0, 1, '2016-01-04 13:01:36'),
(73, 'pbkdf2_sha256$24000$VCtqtZXoHgiU$2ek8mx4rM+pHMGeSMq6GAQBEj+4j6/oATLo+UwxOREw=', NULL, 0, 'manager72', 'Дорофеев Ростислав', '', '', 0, 1, '2016-01-04 13:01:36'),
(74, 'pbkdf2_sha256$24000$yfmYjNr8F89V$iesAoOrq7fKby54gnilo4+msVyGAMYJAVTNtG7MLF6Q=', NULL, 0, 'manager73', 'Степанов Герман', '', '', 0, 1, '2016-01-04 13:01:36'),
(75, 'pbkdf2_sha256$24000$ALgA3fjZqqE9$ZkJMKzjgTrOMqlTu3UKUFpfG75ib+H9nu49xZ71TP0U=', NULL, 0, 'manager74', 'Молчанова Мария', '', '', 0, 1, '2016-01-04 13:01:36'),
(76, 'pbkdf2_sha256$24000$tF375jfjbIzQ$fFQfaCIIwEjUftshhOYNKldarbej3xhGFU6EzrOMl9s=', NULL, 0, 'manager75', 'Белякова София', '', '', 0, 1, '2016-01-04 13:01:36'),
(77, 'pbkdf2_sha256$24000$KmOpKfyPbI7J$URzWKl4kPYsQzSy0wkVl10gq73le7TiFFdh8SjH9sGw=', NULL, 0, 'manager76', 'Гаврилов Степан', '', '', 0, 1, '2016-01-04 13:01:36'),
(78, 'pbkdf2_sha256$24000$Xxy7TX2m0smu$0kQHaDoG7WvJWQMj9qFGCThcK5twztOEkTnOgiX+9Vs=', NULL, 0, 'manager77', 'Агафонов Демьян', '', '', 0, 1, '2016-01-04 13:01:36'),
(79, 'pbkdf2_sha256$24000$M9KdAoWGbzPV$xgsMW2tJuqU+5m1V81yQ4lkUXFfTvmgXfnX6FO/SSq8=', NULL, 0, 'manager78', 'Зайцева Юлия', '', '', 0, 1, '2016-01-04 13:01:36'),
(80, 'pbkdf2_sha256$24000$llrs3tTwfAtO$OI+/XMINUd6mKDEghG/m0y+LJyJeDDPDuFQY4ECJT28=', NULL, 0, 'manager79', 'Корнилова Анастасия', '', '', 0, 1, '2016-01-04 13:01:36'),
(81, 'pbkdf2_sha256$24000$0DRc5yHp95ON$4yfVg0BLTppD3nA16i7+C8qpCNwEDTSpI8L4fsOabAA=', NULL, 0, 'manager80', 'Муравьёва Ирина', '', '', 0, 1, '2016-01-04 13:01:37'),
(82, 'pbkdf2_sha256$24000$fDqGomRTxFl8$HHA7KoyLcGpamYROKX9qNGCCqHNSaEJa8wEbaAh/nR0=', NULL, 0, 'manager81', 'Филиппова Вероника', '', '', 0, 1, '2016-01-04 13:01:37'),
(83, 'pbkdf2_sha256$24000$Q4jXuqgsYxqu$IBbZWuTML99yHuC1rM1C5wuRFyHdcYgVJUb6f/oZS6A=', NULL, 0, 'manager82', 'Гуляева Оксана', '', '', 0, 1, '2016-01-04 13:01:37'),
(84, 'pbkdf2_sha256$24000$M2Vaofswf0Lb$6FHjtoLcAyM9eyr6QB3VgzjwajN4TgMyA56oJAIQdhA=', NULL, 0, 'manager83', 'Гаврилова Раиса', '', '', 0, 1, '2016-01-04 13:01:37'),
(85, 'pbkdf2_sha256$24000$ZBwhTV05wPN6$0IlBnMWdE7vldDxxmiQoYFHiMINKtXPOaBmqmIR5zLw=', NULL, 0, 'manager84', 'Петухов Владислав', '', '', 0, 1, '2016-01-04 13:01:37'),
(86, 'pbkdf2_sha256$24000$8mrEc6uZrlym$fN0Hwx5q+JzeZuefZV/nDe06ui1Z/oeqnPSjgclsYcA=', NULL, 0, 'manager85', 'Кулагина Галина', '', '', 0, 1, '2016-01-04 13:01:37'),
(87, 'pbkdf2_sha256$24000$eya5YM5Pb1pw$HDmvA2P1T6EIEjAl7ng1Cije+4gRy3XE+4acW4zgTvw=', '2016-01-07 15:41:49', 0, 'manager86', 'Гришина Полина', '', '', 0, 1, '2016-01-04 13:01:37'),
(88, 'pbkdf2_sha256$24000$uXtbz0TrISNs$K9L6pNQND9oSti1VJevytOadObgabvmYonH0iQkoH9E=', NULL, 0, 'manager87', 'Морозова Маргарита', '', '', 0, 1, '2016-01-04 13:01:37'),
(89, 'pbkdf2_sha256$24000$zGoWi2SRfIWU$8pi3cP6wFtz1bOy/HFfzK22nKnzxDYg6xSsQJ0To+OM=', NULL, 0, 'manager88', 'Белозёров Алексей', '', '', 0, 1, '2016-01-04 13:01:37'),
(90, 'pbkdf2_sha256$24000$CYCf32Avi2m1$EOmfR2pI9s4TVsossp+Na98RnDPsLT7HptUVmr3MrYc=', NULL, 0, 'manager89', 'Герасимов Макар', '', '', 0, 1, '2016-01-04 13:01:37'),
(91, 'pbkdf2_sha256$24000$THfg2BjSsUbd$W3v8bOYfbcL5DEi/DWgS9FTq8pZJcCBLzNDE2WfvXs4=', NULL, 0, 'manager90', 'Осипова Анна', '', '', 0, 1, '2016-01-04 13:01:37'),
(92, 'pbkdf2_sha256$24000$EyXr7dvC8vBc$yQTjU9sukKWQM7G3J5Szgn3FnqmelzeqDUKr07PpeqU=', NULL, 0, 'manager91', 'Тимофеева Светлана', '', '', 0, 1, '2016-01-04 13:01:37'),
(93, 'pbkdf2_sha256$24000$6c4AamHMLS3x$SXfkShwynUZLRngyij/OhSH9YhT8jg6HOv9d5X99lsI=', NULL, 0, 'manager92', 'Сазонова Тамара', '', '', 0, 1, '2016-01-04 13:01:37'),
(94, 'pbkdf2_sha256$24000$qqWnb36qos75$HzxrV3IKSzIPRR4lOnu/dEOSOTyYWJre7AsiRYuu1sM=', NULL, 0, 'manager93', 'Григорьева Полина', '', '', 0, 1, '2016-01-04 13:01:37'),
(95, 'pbkdf2_sha256$24000$38ePkL48bhkC$3xngoZN/asoSUv+ObGMmkqq1lBlsKZiSPbiUJmmNZmA=', NULL, 0, 'manager94', 'Панов Валерий', '', '', 0, 1, '2016-01-04 13:01:37'),
(96, 'pbkdf2_sha256$24000$WxRUsfdXfD8B$qDAqKtMuzc187m+4MdB1Lu9y6y8a8q/KiBlOpNpqxUs=', NULL, 0, 'manager95', 'Щукина Марина', '', '', 0, 1, '2016-01-04 13:01:37'),
(97, 'pbkdf2_sha256$24000$QlpakatxNkEo$f9Xc/R/UOuCa8j2E4NzptYwJFp9LEAZ1uyzDo3vjZX8=', NULL, 0, 'manager96', 'Вишнякова Жанна', '', '', 0, 1, '2016-01-04 13:01:37'),
(98, 'pbkdf2_sha256$24000$14hVrFjgw8jn$emIk4PX6YR7xaMcqKlkglCcf0N/OnsaV5GY0c5vD1u8=', NULL, 0, 'manager97', 'Лазарева Татьяна', '', '', 0, 1, '2016-01-04 13:01:37'),
(99, 'pbkdf2_sha256$24000$XL7X1cLe0jyZ$oEOkdYoYW+jj3TZfIBy8Tc70g//g0jskeRbUcrJICp0=', NULL, 0, 'manager98', 'Федотова София', '', '', 0, 1, '2016-01-04 13:01:37'),
(100, 'pbkdf2_sha256$24000$1W5CDa7vwdzH$6ij2huLpy7TgzXOdYFxZBkVe3ohW4eV7PDos9E4aTLk=', NULL, 0, 'manager99', 'Колобова Снежана', '', '', 0, 1, '2016-01-04 13:01:37'),
(101, 'pbkdf2_sha256$24000$dEpz0fXM7TBP$ybaApdgXScz9DQBbtGT492RvFUXlpbuzRzt5cPYxwDs=', NULL, 0, 'manager100', 'Куликова София', '', '', 0, 1, '2016-01-04 13:01:38'),
(102, 'pbkdf2_sha256$24000$ahPtrdWbENEo$k+uUwbIBQpEDHgwjMuHA8NOu6epwzXqLQPQ0tJfr8F0=', NULL, 0, 'manager101', 'Зайцева Маргарита', '', '', 0, 1, '2016-01-04 13:01:38'),
(103, 'pbkdf2_sha256$24000$B2eWE8yg5k2H$wkqyG+cG03bv7Qt8h/JSgoPtn8As3yLXlj+jaCVgBxQ=', NULL, 0, 'manager102', 'Савельева Евгения', '', '', 0, 1, '2016-01-04 13:01:38'),
(104, 'pbkdf2_sha256$24000$q1cZqmudPsqI$4KEHBZuE1i/1/SORuof/PMIGIW3dQkH+zhJYHNJn5Ug=', NULL, 0, 'manager103', 'Крылов Николай', '', '', 0, 1, '2016-01-04 13:01:38'),
(105, 'pbkdf2_sha256$24000$jOPtkp93kYG4$AeheF9jX/7EJ1F92I8MquYGB8JALCZCRcbvJXi38B9o=', NULL, 0, 'manager104', 'Архипова Екатерина', '', '', 0, 1, '2016-01-04 13:01:38'),
(106, 'pbkdf2_sha256$24000$ttgFFrrzot1h$Uo/cESm8HOk5Fz4IXMLMf/aPseGFTt1uvFPHS1wuOzQ=', NULL, 0, 'manager105', 'Архипов Демьян', '', '', 0, 1, '2016-01-04 13:01:38'),
(107, 'pbkdf2_sha256$24000$DwsurranKFIz$hvqUjCDGn6Epnf+8P63zlp29SRPIkDxaUrAF7vq/dJI=', NULL, 0, 'manager106', 'Максимова Ульяна', '', '', 0, 1, '2016-01-04 13:01:38'),
(108, 'pbkdf2_sha256$24000$eSsQqb6i9Dq8$K/dGrD51NejupbmqZvzTIveQL6G38090LnsAOxMXuGA=', NULL, 0, 'manager107', 'Громов Богдан', '', '', 0, 1, '2016-01-04 13:01:38'),
(109, 'pbkdf2_sha256$24000$5C7o3pzg5TjC$zibcvKPYgreXeUBjllzG/NSpmES5eKGUKJYtwYBPBSI=', NULL, 0, 'manager108', 'Никитин Константин', '', '', 0, 1, '2016-01-04 13:01:38'),
(110, 'pbkdf2_sha256$24000$T6Vk430Jh6X8$oTnzBlpYbSdAy2W0OXDzKm3zHv5agG0tEUvN6VO2M3c=', NULL, 0, 'manager109', 'Федотов Игнатий', '', '', 0, 1, '2016-01-04 13:01:38'),
(111, 'pbkdf2_sha256$24000$8jwMsRAmPy3z$7DwvxeFCxPqtRHnL39tXqWdJuGWpaKSE1jzES4qQpIo=', NULL, 0, 'manager110', 'Кулагина Галина', '', '', 0, 1, '2016-01-04 13:01:38'),
(112, 'pbkdf2_sha256$24000$Z5tAVejhCzNg$TyjEvlXI1Goab1CU071IDer/C3Jbf+Neuk/aw7si860=', NULL, 0, 'manager111', 'Ширяев Роман', '', '', 0, 1, '2016-01-04 13:01:38'),
(113, 'pbkdf2_sha256$24000$TtXFtx3yUBao$eiQwB+z4rL/7cGwZY/shynULR5Xi2ajU9F8xCQ0XS8k=', NULL, 0, 'manager112', 'Ермакова Валентина', '', '', 0, 1, '2016-01-04 13:01:38'),
(114, 'pbkdf2_sha256$24000$4l0L15d48miU$4fzOeCbJ5jCJNsw4rZheEJrBHaebEn9QYgFHso8rdPg=', NULL, 0, 'manager113', 'Щукина Василиса', '', '', 0, 1, '2016-01-04 13:01:38'),
(115, 'pbkdf2_sha256$24000$kvGLCHCYxTQI$vvkC2NMSU3gMsdvLpTsKI/yUFkupK4/cTCkal863S1o=', NULL, 0, 'manager114', 'Лукина Карина', '', '', 0, 1, '2016-01-04 13:01:38'),
(116, 'pbkdf2_sha256$24000$1m7fqPWT15ew$qfPgK3viezbl3+OCEVpBylo/7dOOa63TvtSZoKVXT7Q=', NULL, 0, 'manager115', 'Григорьев Игорь', '', '', 0, 1, '2016-01-04 13:01:38'),
(117, 'pbkdf2_sha256$24000$Jt0ducuxCcJY$yBFQ4HU9QsSNvKJ9su89d0hG4QnHQORg8e9t7ikN83Q=', NULL, 0, 'manager116', 'Зиновьев Христофор', '', '', 0, 1, '2016-01-04 13:01:38'),
(118, 'pbkdf2_sha256$24000$DAfBItOGjh8c$z9QMUxZy1hooQdeidR7EMVli8MNXLJ9V8Qm1XRvSdrs=', NULL, 0, 'manager117', 'Аксёнов Олег', '', '', 0, 1, '2016-01-04 13:01:39'),
(119, 'pbkdf2_sha256$24000$Hys5DRr1AfqZ$AFWrFdh3/511kKeb4JG6q4t/5ikSmToDop/yjnIMha8=', NULL, 0, 'manager118', 'Чернова Елизавета', '', '', 0, 1, '2016-01-04 13:01:39'),
(120, 'pbkdf2_sha256$24000$TXtS9gx6Smmm$VRmlkK1YPhJxAPDqBV+E1hs9PLuSNoSDKQGvMyZ1lvM=', NULL, 0, 'manager119', 'Зыков Эдуард', '', '', 0, 1, '2016-01-04 13:01:39'),
(121, 'pbkdf2_sha256$24000$vjW2B4VkYOOr$pNeMcUl6yKOSJPGE6K/IU8gmo0226R1PmJ845SD59kU=', NULL, 0, 'manager120', 'Медведева Карина', '', '', 0, 1, '2016-01-04 13:01:39');

-- --------------------------------------------------------

--
-- Структура таблицы `auth_user_groups`
--

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `auth_user_user_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_perm_permission_id_1fbb5f2c_fk_auth_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `Auto`
--

CREATE TABLE IF NOT EXISTS `Auto` (
  `auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `auto_model` varchar(50) NOT NULL,
  `auto_number` varchar(12) NOT NULL,
  `branch_id` int(11) NOT NULL,
  PRIMARY KEY (`auto_id`),
  KEY `auto` (`auto_id`),
  KEY `auto_b` (`branch_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=61 ;

--
-- Дамп данных таблицы `Auto`
--

INSERT INTO `Auto` (`auto_id`, `auto_model`, `auto_number`, `branch_id`) VALUES
(1, 'Hyundai Porter', 'в466ок97RUS', 1),
(2, 'Hyundai Porter', 'е565рв177RUS', 1),
(3, 'Iveco Daily', 'с916рс77RUS', 1),
(4, 'Газель Next', 'м544ур777RUS', 1),
(5, 'Peugeot Boxer', 'т513хх777RUS', 1),
(6, 'Fiat Ducato', 'у993ер777RUS', 1),
(7, 'Hyundai Porter', 'н386кх197RUS', 1),
(8, 'Hyundai Porter', 'р797ар97RUS', 1),
(9, 'Ford Transit', 'х449оу197RUS', 1),
(10, 'Hyundai Porter', 'у189уа97RUS', 1),
(11, 'Fiat Ducato', 'м029ур197RUS', 2),
(12, 'Iveco Daily', 'е387ух177RUS', 2),
(13, 'Fiat Ducato', 'м960нр197RUS', 2),
(14, 'Peugeot Boxer', 'т098мх777RUS', 2),
(15, 'Peugeot Boxer', 'а414вк77RUS', 2),
(16, 'Peugeot Boxer', 'н765ом197RUS', 2),
(17, 'Hyundai Porter', 'с991ва197RUS', 2),
(18, 'Ford Transit', 'а603оа777RUS', 2),
(19, 'Hyundai Porter', 'с863хр77RUS', 2),
(20, 'Peugeot Boxer', 'к672ух177RUS', 2),
(21, 'Iveco Daily', 'у609ну197RUS', 3),
(22, 'Газель Next', 'е839ку177RUS', 3),
(23, 'Hyundai Porter', 'е048ув197RUS', 3),
(24, 'Ford Transit', 'т572тс97RUS', 3),
(25, 'Iveco Daily', 'у212уе97RUS', 3),
(26, 'Iveco Daily', 'о365ме97RUS', 3),
(27, 'Iveco Daily', 'а640рт777RUS', 3),
(28, 'Iveco Daily', 'в731ма177RUS', 3),
(29, 'Fiat Ducato', 'а285вн177RUS', 3),
(30, 'Ford Transit', 'а252ну197RUS', 3),
(31, 'Hyundai Porter', 'к186ак197RUS', 4),
(32, 'Iveco Daily', 'к407ах197RUS', 4),
(33, 'Газель Next', 'н245кр97RUS', 4),
(34, 'Peugeot Boxer', 'м011ус97RUS', 4),
(35, 'Hyundai Porter', 'у735мв197RUS', 4),
(36, 'Fiat Ducato', 'х308ом197RUS', 4),
(37, 'Hyundai Porter', 'р403вс177RUS', 4),
(38, 'Iveco Daily', 'х575кк77RUS', 4),
(39, 'Fiat Ducato', 'в717нк97RUS', 4),
(40, 'Газель Next', 'с341ов777RUS', 4),
(41, 'Fiat Ducato', 'т468хх777RUS', 5),
(42, 'Iveco Daily', 'о108ах97RUS', 5),
(43, 'Hyundai Porter', 'к095рх177RUS', 5),
(44, 'Ford Transit', 'е419хн777RUS', 5),
(45, 'Hyundai Porter', 'р239ом197RUS', 5),
(46, 'Ford Transit', 'р970се777RUS', 5),
(47, 'Fiat Ducato', 'н850хк97RUS', 5),
(48, 'Peugeot Boxer', 'р088ун97RUS', 5),
(49, 'Peugeot Boxer', 'т559хв77RUS', 5),
(50, 'Hyundai Porter', 'е540ум77RUS', 5),
(51, 'Ford Transit', 'т287вк177RUS', 6),
(52, 'Peugeot Boxer', 'р063ху177RUS', 6),
(53, 'Iveco Daily', 'р670ау177RUS', 6),
(54, 'Iveco Daily', 'с032сн197RUS', 6),
(55, 'Peugeot Boxer', 'в847ос777RUS', 6),
(56, 'Fiat Ducato', 'е341ат197RUS', 6),
(57, 'Fiat Ducato', 'а612уа197RUS', 6),
(58, 'Газель Next', 'т126на177RUS', 6),
(59, 'Ford Transit', 'о086ав97RUS', 6),
(60, 'Iveco Daily', 'х653хо197RUS', 6);

-- --------------------------------------------------------

--
-- Структура таблицы `Branch`
--

CREATE TABLE IF NOT EXISTS `Branch` (
  `branch_id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_address` varchar(100) NOT NULL,
  PRIMARY KEY (`branch_id`),
  KEY `branch` (`branch_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `Branch`
--

INSERT INTO `Branch` (`branch_id`, `branch_address`) VALUES
(1, 'Сумская ул.'),
(2, 'ул. Ватутина'),
(3, 'Пятницкая ул.'),
(4, 'ул. Костякова'),
(5, 'ул. Хромова'),
(6, 'ул. Михайлова');

-- --------------------------------------------------------

--
-- Структура таблицы `BranchProduct`
--

CREATE TABLE IF NOT EXISTS `BranchProduct` (
  `branchproduct_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_rest` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`branchproduct_id`),
  KEY `branchproduct` (`branchproduct_id`),
  KEY `branchproduct_b` (`branch_id`),
  KEY `branchproduct_p` (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=705 ;

--
-- Дамп данных таблицы `BranchProduct`
--

INSERT INTO `BranchProduct` (`branchproduct_id`, `product_rest`, `branch_id`, `product_id`) VALUES
(1, 6, 1, 1),
(2, 4, 1, 2),
(3, 4, 1, 3),
(4, 3, 1, 4),
(5, 3, 1, 5),
(6, 2, 1, 6),
(7, 0, 1, 7),
(8, 2, 1, 8),
(9, 0, 1, 9),
(10, 9, 1, 10),
(11, 1, 1, 11),
(12, 2, 1, 12),
(13, 4, 1, 13),
(14, 1, 1, 14),
(15, 3, 1, 15),
(16, 7, 1, 16),
(17, 7, 1, 17),
(18, 2, 1, 18),
(19, 4, 1, 19),
(20, 1, 1, 20),
(21, 0, 1, 21),
(22, 7, 1, 22),
(23, 0, 1, 23),
(24, 0, 1, 24),
(25, 1, 1, 25),
(26, 0, 1, 26),
(27, 5, 1, 27),
(28, 1, 1, 28),
(29, 6, 1, 29),
(30, 7, 1, 30),
(31, 10, 1, 31),
(32, 9, 1, 32),
(33, 0, 1, 33),
(34, 9, 1, 34),
(35, 9, 1, 35),
(36, 7, 1, 36),
(37, 3, 1, 37),
(38, 7, 1, 38),
(39, 8, 1, 39),
(40, 4, 1, 40),
(41, 7, 1, 41),
(42, 1, 1, 42),
(43, 3, 1, 43),
(44, 2, 1, 44),
(45, 4, 1, 45),
(46, 2, 1, 46),
(47, 10, 1, 47),
(48, 7, 1, 48),
(49, 5, 1, 49),
(50, 5, 1, 50),
(51, 7, 1, 51),
(52, 7, 1, 52),
(53, 0, 1, 53),
(54, 3, 1, 54),
(55, 1, 1, 55),
(56, 5, 1, 56),
(57, 2, 1, 57),
(58, 8, 1, 58),
(59, 7, 1, 59),
(60, 5, 1, 60),
(61, 3, 1, 61),
(62, 3, 1, 62),
(63, 6, 1, 63),
(64, 5, 1, 64),
(65, 2, 1, 65),
(66, 6, 1, 66),
(67, 0, 1, 67),
(68, 5, 1, 68),
(69, 1, 1, 69),
(70, 7, 1, 70),
(71, 6, 1, 71),
(72, 8, 1, 72),
(73, 7, 1, 73),
(74, 3, 1, 74),
(75, 3, 1, 75),
(76, 6, 1, 76),
(77, 8, 1, 77),
(78, 9, 1, 78),
(79, 7, 1, 79),
(80, 7, 1, 80),
(81, 2, 1, 81),
(82, 7, 1, 82),
(83, 2, 1, 83),
(84, 5, 1, 84),
(85, 6, 1, 85),
(86, 0, 1, 86),
(87, 3, 1, 87),
(88, 9, 1, 88),
(89, 5, 1, 89),
(90, 2, 1, 90),
(91, 10, 1, 91),
(92, 7, 1, 92),
(93, 9, 1, 93),
(94, 4, 1, 94),
(95, 6, 1, 95),
(96, 5, 1, 96),
(97, 9, 1, 97),
(98, 7, 1, 98),
(99, 0, 1, 99),
(100, 3, 1, 100),
(101, 0, 1, 101),
(102, 7, 1, 102),
(103, 1, 1, 103),
(104, 10, 1, 104),
(105, 7, 1, 105),
(106, 6, 1, 106),
(107, 2, 1, 107),
(108, 2, 1, 108),
(109, 3, 1, 109),
(110, 5, 1, 110),
(111, 7, 1, 111),
(112, 10, 1, 112),
(113, 5, 1, 113),
(114, 10, 1, 114),
(115, 3, 2, 1),
(116, 3, 2, 2),
(117, 0, 2, 3),
(118, 0, 2, 4),
(119, 0, 2, 5),
(120, 1, 2, 6),
(121, 7, 2, 7),
(122, 1, 2, 8),
(123, 10, 2, 9),
(124, 10, 2, 10),
(125, 8, 2, 11),
(126, 7, 2, 12),
(127, 7, 2, 13),
(128, 3, 2, 14),
(129, 0, 2, 15),
(130, 4, 2, 16),
(131, 0, 2, 17),
(132, 8, 2, 18),
(133, 2, 2, 19),
(134, 6, 2, 20),
(135, 1, 2, 21),
(136, 3, 2, 22),
(137, 7, 2, 23),
(138, 2, 2, 24),
(139, 4, 2, 25),
(140, 2, 2, 26),
(141, 10, 2, 27),
(142, 9, 2, 28),
(143, 6, 2, 29),
(144, 10, 2, 30),
(145, 3, 2, 31),
(146, 2, 2, 32),
(147, 7, 2, 33),
(148, 9, 2, 34),
(149, 9, 2, 35),
(150, 9, 2, 36),
(151, 6, 2, 37),
(152, 0, 2, 38),
(153, 10, 2, 39),
(154, 7, 2, 40),
(155, 9, 2, 41),
(156, 2, 2, 42),
(157, 2, 2, 43),
(158, 5, 2, 44),
(159, 2, 2, 45),
(160, 2, 2, 46),
(161, 7, 2, 47),
(162, 7, 2, 48),
(163, 8, 2, 49),
(164, 4, 2, 50),
(165, 0, 2, 51),
(166, 7, 2, 52),
(167, 1, 2, 53),
(168, 8, 2, 54),
(169, 0, 2, 55),
(170, 10, 2, 56),
(171, 2, 2, 57),
(172, 9, 2, 58),
(173, 10, 2, 59),
(174, 8, 2, 60),
(175, 9, 2, 61),
(176, 5, 2, 62),
(177, 10, 2, 63),
(178, 0, 2, 64),
(179, 6, 2, 65),
(180, 5, 2, 66),
(181, 4, 2, 67),
(182, 4, 2, 68),
(183, 4, 2, 69),
(184, 5, 2, 70),
(185, 7, 2, 71),
(186, 1, 2, 72),
(187, 8, 2, 73),
(188, 10, 2, 74),
(189, 5, 2, 75),
(190, 0, 2, 76),
(191, 7, 2, 77),
(192, 9, 2, 78),
(193, 2, 2, 79),
(194, 8, 2, 80),
(195, 8, 2, 81),
(196, 6, 2, 82),
(197, 8, 2, 83),
(198, 1, 2, 84),
(199, 0, 2, 85),
(200, 1, 2, 86),
(201, 2, 2, 87),
(202, 2, 2, 88),
(203, 7, 2, 89),
(204, 8, 2, 90),
(205, 2, 2, 91),
(206, 6, 2, 92),
(207, 4, 2, 93),
(208, 3, 2, 94),
(209, 0, 2, 95),
(210, 6, 2, 96),
(211, 1, 2, 97),
(212, 4, 2, 98),
(213, 7, 2, 99),
(214, 7, 2, 100),
(215, 3, 2, 101),
(216, 1, 2, 102),
(217, 9, 2, 103),
(218, 9, 2, 104),
(219, 0, 2, 105),
(220, 0, 2, 106),
(221, 5, 2, 107),
(222, 7, 2, 108),
(223, 6, 2, 109),
(224, 7, 2, 110),
(225, 4, 2, 111),
(226, 7, 2, 112),
(227, 4, 2, 113),
(228, 8, 2, 114),
(229, 4, 3, 1),
(230, 2, 3, 2),
(231, 10, 3, 3),
(232, 7, 3, 4),
(233, 4, 3, 5),
(234, 5, 3, 6),
(235, 9, 3, 7),
(236, 1, 3, 8),
(237, 7, 3, 9),
(238, 6, 3, 10),
(239, 6, 3, 11),
(240, 0, 3, 12),
(241, 8, 3, 13),
(242, 8, 3, 14),
(243, 1, 3, 15),
(244, 6, 3, 16),
(245, 2, 3, 17),
(246, 0, 3, 18),
(247, 5, 3, 19),
(248, 4, 3, 20),
(249, 0, 3, 21),
(250, 3, 3, 22),
(251, 8, 3, 23),
(252, 4, 3, 24),
(253, 6, 3, 25),
(254, 1, 3, 26),
(255, 9, 3, 27),
(256, 10, 3, 28),
(257, 10, 3, 29),
(258, 10, 3, 30),
(259, 4, 3, 31),
(260, 4, 3, 32),
(261, 6, 3, 33),
(262, 3, 3, 34),
(263, 4, 3, 35),
(264, 1, 3, 36),
(265, 5, 3, 37),
(266, 1, 3, 38),
(267, 5, 3, 39),
(268, 3, 3, 40),
(269, 1, 3, 41),
(270, 10, 3, 42),
(271, 0, 3, 43),
(272, 7, 3, 44),
(273, 7, 3, 45),
(274, 1, 3, 46),
(275, 10, 3, 47),
(276, 2, 3, 48),
(277, 7, 3, 49),
(278, 4, 3, 50),
(279, 9, 3, 51),
(280, 2, 3, 52),
(281, 9, 3, 53),
(282, 6, 3, 54),
(283, 0, 3, 55),
(284, 10, 3, 56),
(285, 2, 3, 57),
(286, 0, 3, 58),
(287, 7, 3, 59),
(288, 8, 3, 60),
(289, 6, 3, 61),
(290, 2, 3, 62),
(291, 5, 3, 63),
(292, 8, 3, 64),
(293, 0, 3, 65),
(294, 5, 3, 66),
(295, 10, 3, 67),
(296, 1, 3, 68),
(297, 0, 3, 69),
(298, 4, 3, 70),
(299, 5, 3, 71),
(300, 10, 3, 72),
(301, 4, 3, 73),
(302, 0, 3, 74),
(303, 3, 3, 75),
(304, 8, 3, 76),
(305, 6, 3, 77),
(306, 0, 3, 78),
(307, 6, 3, 79),
(308, 8, 3, 80),
(309, 4, 3, 81),
(310, 10, 3, 82),
(311, 7, 3, 83),
(312, 6, 3, 84),
(313, 9, 3, 85),
(314, 8, 3, 86),
(315, 3, 3, 87),
(316, 0, 3, 88),
(317, 2, 3, 89),
(318, 8, 3, 90),
(319, 3, 3, 91),
(320, 1, 3, 92),
(321, 6, 3, 93),
(322, 8, 3, 94),
(323, 2, 3, 95),
(324, 2, 3, 96),
(325, 5, 3, 97),
(326, 7, 3, 98),
(327, 8, 3, 99),
(328, 5, 3, 100),
(329, 4, 3, 101),
(330, 0, 3, 102),
(331, 7, 3, 103),
(332, 7, 3, 104),
(333, 7, 3, 105),
(334, 1, 3, 106),
(335, 1, 3, 107),
(336, 1, 3, 108),
(337, 0, 3, 109),
(338, 6, 3, 110),
(339, 7, 3, 111),
(340, 4, 3, 112),
(341, 2, 3, 113),
(342, 0, 3, 114),
(343, 5, 4, 1),
(344, 4, 4, 2),
(345, 6, 4, 3),
(346, 4, 4, 4),
(347, 9, 4, 5),
(348, 0, 4, 6),
(349, 7, 4, 7),
(350, 7, 4, 8),
(351, 4, 4, 9),
(352, 2, 4, 10),
(353, 2, 4, 11),
(354, 10, 4, 12),
(355, 1, 4, 13),
(356, 2, 4, 14),
(357, 2, 4, 15),
(358, 10, 4, 16),
(359, 5, 4, 17),
(360, 6, 4, 18),
(361, 9, 4, 19),
(362, 4, 4, 20),
(363, 5, 4, 21),
(364, 0, 4, 22),
(365, 1, 4, 23),
(366, 7, 4, 24),
(367, 5, 4, 25),
(368, 3, 4, 26),
(369, 0, 4, 27),
(370, 8, 4, 28),
(371, 2, 4, 29),
(372, 2, 4, 30),
(373, 3, 4, 31),
(374, 5, 4, 32),
(375, 8, 4, 33),
(376, 4, 4, 34),
(377, 9, 4, 35),
(378, 0, 4, 36),
(379, 0, 4, 37),
(380, 2, 4, 38),
(381, 8, 4, 39),
(382, 6, 4, 40),
(383, 5, 4, 41),
(384, 0, 4, 42),
(385, 9, 4, 43),
(386, 7, 4, 44),
(387, 0, 4, 45),
(388, 7, 4, 46),
(389, 10, 4, 47),
(390, 6, 4, 48),
(391, 3, 4, 49),
(392, 7, 4, 50),
(393, 9, 4, 51),
(394, 0, 4, 52),
(395, 2, 4, 53),
(396, 10, 4, 54),
(397, 7, 4, 55),
(398, 4, 4, 56),
(399, 0, 4, 57),
(400, 7, 4, 58),
(401, 9, 4, 59),
(402, 9, 4, 60),
(403, 7, 4, 61),
(404, 3, 4, 62),
(405, 2, 4, 63),
(406, 2, 4, 64),
(407, 7, 4, 65),
(408, 6, 4, 66),
(409, 6, 4, 67),
(410, 1, 4, 68),
(411, 3, 4, 69),
(412, 1, 4, 70),
(413, 5, 4, 71),
(414, 8, 4, 72),
(415, 7, 4, 73),
(416, 2, 4, 74),
(417, 10, 4, 75),
(418, 2, 4, 76),
(419, 7, 4, 77),
(420, 7, 4, 78),
(421, 4, 4, 79),
(422, 4, 4, 80),
(423, 5, 4, 81),
(424, 4, 4, 82),
(425, 8, 4, 83),
(426, 1, 4, 84),
(427, 1, 4, 85),
(428, 4, 4, 86),
(429, 4, 4, 87),
(430, 3, 4, 88),
(431, 10, 4, 89),
(432, 0, 4, 90),
(433, 0, 4, 91),
(434, 7, 4, 92),
(435, 6, 4, 93),
(436, 3, 4, 94),
(437, 5, 4, 95),
(438, 2, 4, 96),
(439, 1, 4, 97),
(440, 6, 4, 98),
(441, 10, 4, 99),
(442, 6, 4, 100),
(443, 2, 4, 101),
(444, 2, 4, 102),
(445, 5, 4, 103),
(446, 7, 4, 104),
(447, 8, 4, 105),
(448, 4, 4, 106),
(449, 1, 4, 107),
(450, 7, 4, 108),
(451, 2, 4, 109),
(452, 1, 4, 110),
(453, 10, 4, 111),
(454, 7, 4, 112),
(455, 4, 4, 113),
(456, 5, 4, 114),
(457, 10, 5, 1),
(458, 4, 5, 2),
(459, 7, 5, 3),
(460, 1, 5, 4),
(461, 4, 5, 5),
(462, 7, 5, 6),
(463, 7, 5, 7),
(464, 1, 5, 8),
(465, 2, 5, 9),
(466, 7, 5, 10),
(467, 2, 5, 11),
(468, 9, 5, 12),
(469, 3, 5, 13),
(470, 0, 5, 14),
(471, 10, 5, 15),
(472, 2, 5, 16),
(473, 10, 5, 17),
(474, 4, 5, 18),
(475, 6, 5, 19),
(476, 9, 5, 20),
(477, 5, 5, 21),
(478, 10, 5, 22),
(479, 0, 5, 23),
(480, 4, 5, 24),
(481, 3, 5, 25),
(482, 8, 5, 26),
(483, 3, 5, 27),
(484, 8, 5, 28),
(485, 2, 5, 29),
(486, 8, 5, 30),
(487, 3, 5, 31),
(488, 1, 5, 32),
(489, 10, 5, 33),
(490, 9, 5, 34),
(491, 4, 5, 35),
(492, 8, 5, 36),
(493, 9, 5, 37),
(494, 9, 5, 38),
(495, 0, 5, 39),
(496, 2, 5, 40),
(497, 8, 5, 41),
(498, 6, 5, 42),
(499, 8, 5, 43),
(500, 9, 5, 44),
(501, 9, 5, 45),
(502, 1, 5, 46),
(503, 1, 5, 47),
(504, 9, 5, 48),
(505, 2, 5, 49),
(506, 10, 5, 50),
(507, 9, 5, 51),
(508, 9, 5, 52),
(509, 6, 5, 53),
(510, 5, 5, 54),
(511, 8, 5, 55),
(512, 9, 5, 56),
(513, 0, 5, 57),
(514, 2, 5, 58),
(515, 4, 5, 59),
(516, 2, 5, 60),
(517, 3, 5, 61),
(518, 3, 5, 62),
(519, 7, 5, 63),
(520, 10, 5, 64),
(521, 9, 5, 65),
(522, 6, 5, 66),
(523, 0, 5, 67),
(524, 10, 5, 68),
(525, 7, 5, 69),
(526, 3, 5, 70),
(527, 1, 5, 71),
(528, 2, 5, 72),
(529, 9, 5, 73),
(530, 1, 5, 74),
(531, 10, 5, 75),
(532, 0, 5, 76),
(533, 6, 5, 77),
(534, 9, 5, 78),
(535, 0, 5, 79),
(536, 8, 5, 80),
(537, 10, 5, 81),
(538, 2, 5, 82),
(539, 0, 5, 83),
(540, 9, 5, 84),
(541, 10, 5, 85),
(542, 4, 5, 86),
(543, 2, 5, 87),
(544, 1, 5, 88),
(545, 6, 5, 89),
(546, 9, 5, 90),
(547, 10, 5, 91),
(548, 5, 5, 92),
(549, 1, 5, 93),
(550, 7, 5, 94),
(551, 2, 5, 95),
(552, 7, 5, 96),
(553, 4, 5, 97),
(554, 9, 5, 98),
(555, 8, 5, 99),
(556, 0, 5, 100),
(557, 4, 5, 101),
(558, 8, 5, 102),
(559, 2, 5, 103),
(560, 3, 5, 104),
(561, 5, 5, 105),
(562, 1, 5, 106),
(563, 6, 5, 107),
(564, 5, 5, 108),
(565, 10, 5, 109),
(566, 5, 5, 110),
(567, 0, 5, 111),
(568, 6, 5, 112),
(569, 7, 5, 113),
(570, 8, 5, 114),
(571, 7, 6, 1),
(572, 2, 6, 2),
(573, 9, 6, 3),
(574, 7, 6, 4),
(575, 4, 6, 5),
(576, 10, 6, 6),
(577, 4, 6, 7),
(578, 9, 6, 8),
(579, 7, 6, 9),
(580, 3, 6, 10),
(581, 0, 6, 11),
(582, 0, 6, 12),
(583, 10, 6, 13),
(584, 1, 6, 14),
(585, 5, 6, 15),
(586, 3, 6, 16),
(587, 8, 6, 17),
(588, 10, 6, 18),
(589, 1, 6, 19),
(590, 0, 6, 20),
(591, 0, 6, 21),
(592, 5, 6, 22),
(593, 9, 6, 23),
(594, 4, 6, 24),
(595, 8, 6, 25),
(596, 6, 6, 26),
(597, 4, 6, 27),
(598, 9, 6, 28),
(599, 1, 6, 29),
(600, 9, 6, 30),
(601, 2, 6, 31),
(602, 0, 6, 32),
(603, 5, 6, 33),
(604, 10, 6, 34),
(605, 4, 6, 35),
(606, 4, 6, 36),
(607, 2, 6, 37),
(608, 1, 6, 38),
(609, 0, 6, 39),
(610, 3, 6, 40),
(611, 2, 6, 41),
(612, 2, 6, 42),
(613, 3, 6, 43),
(614, 5, 6, 44),
(615, 1, 6, 45),
(616, 5, 6, 46),
(617, 10, 6, 47),
(618, 10, 6, 48),
(619, 4, 6, 49),
(620, 2, 6, 50),
(621, 2, 6, 51),
(622, 6, 6, 52),
(623, 5, 6, 53),
(624, 3, 6, 54),
(625, 5, 6, 55),
(626, 1, 6, 56),
(627, 8, 6, 57),
(628, 5, 6, 58),
(629, 0, 6, 59),
(630, 10, 6, 60),
(631, 4, 6, 61),
(632, 1, 6, 62),
(633, 2, 6, 63),
(634, 5, 6, 64),
(635, 10, 6, 65),
(636, 4, 6, 66),
(637, 9, 6, 67),
(638, 5, 6, 68),
(639, 9, 6, 69),
(640, 10, 6, 70),
(641, 10, 6, 71),
(642, 0, 6, 72),
(643, 0, 6, 73),
(644, 7, 6, 74),
(645, 5, 6, 75),
(646, 8, 6, 76),
(647, 5, 6, 77),
(648, 3, 6, 78),
(649, 3, 6, 79),
(650, 0, 6, 80),
(651, 9, 6, 81),
(652, 6, 6, 82),
(653, 1, 6, 83),
(654, 7, 6, 84),
(655, 3, 6, 85),
(656, 10, 6, 86),
(657, 5, 6, 87),
(658, 5, 6, 88),
(659, 8, 6, 89),
(660, 9, 6, 90),
(661, 2, 6, 91),
(662, 10, 6, 92),
(663, 3, 6, 93),
(664, 7, 6, 94),
(665, 0, 6, 95),
(666, 5, 6, 96),
(667, 6, 6, 97),
(668, 2, 6, 98),
(669, 8, 6, 99),
(670, 9, 6, 100),
(671, 0, 6, 101),
(672, 5, 6, 102),
(673, 2, 6, 103),
(674, 7, 6, 104),
(675, 8, 6, 105),
(676, 2, 6, 106),
(677, 7, 6, 107),
(678, 4, 6, 108),
(679, 3, 6, 109),
(680, 9, 6, 110),
(681, 6, 6, 111),
(682, 10, 6, 112),
(683, 9, 6, 113),
(684, 7, 6, 114);

-- --------------------------------------------------------

--
-- Структура таблицы `Client`
--

CREATE TABLE IF NOT EXISTS `Client` (
  `client_id` int(11) NOT NULL AUTO_INCREMENT,
  `client_name` varchar(50) DEFAULT NULL,
  `client_passport` varchar(11) DEFAULT NULL,
  `client_birthday` date DEFAULT NULL,
  PRIMARY KEY (`client_id`),
  KEY `client` (`client_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=101 ;

--
-- Дамп данных таблицы `Client`
--

INSERT INTO `Client` (`client_id`, `client_name`, `client_passport`, `client_birthday`) VALUES
(1, 'Шубина Юлия', '4682 253662', '1962-08-27'),
(2, 'Субботина Юлия', '4579 161583', '1959-06-01'),
(3, 'Рябов Герасим', '4606 918784', '1986-05-17'),
(4, 'Гущин Валерий', '4684 621497', '1964-05-12'),
(5, 'Елисеев Павел', '4585 246004', '1965-04-25'),
(6, 'Гусева Майя', '4500 588619', '1980-04-05'),
(7, 'Юдина Александра', '4695 741845', '1975-04-14'),
(8, 'Пестова Ульяна', '4512 231769', '1992-09-29'),
(9, 'Самойлова Надежда', '4698 714798', '1978-04-07'),
(10, 'Полякова Ярослава', '4514 540866', '1994-02-12'),
(11, 'Доронина Антонина', '4605 123730', '1985-03-04'),
(12, 'Назарова Ярослава', '4684 336441', '1964-10-24'),
(13, 'Зимин Максим', '4675 980831', '1955-07-03'),
(14, 'Князева Нонна', '4587 509027', '1967-04-01'),
(15, 'Зиновьева Кира', '4596 397271', '1976-08-10'),
(16, 'Зуев Трофим', '4677 538034', '1957-12-19'),
(17, 'Родионов Прохор', '4504 539449', '1984-03-25'),
(18, 'Якушева Варвара', '4684 840199', '1964-10-02'),
(19, 'Тюрина Майя', '4608 776711', '1988-11-26'),
(20, 'Шашкова Кира', '4689 491259', '1969-06-05'),
(21, 'Марков Михаил', '4608 162555', '1988-01-13'),
(22, 'Боброва Варвара', '4698 838330', '1978-02-26'),
(23, 'Васильева Валерия', '4509 333897', '1989-04-17'),
(24, 'Пономарёв Антон', '4577 805942', '1957-08-20'),
(25, 'Воронцова Виктория', '4505 870236', '1985-05-23'),
(26, 'Бобров Леонтий', '4595 993015', '1975-07-27'),
(27, 'Кудрявцева Юлия', '4587 441233', '1967-03-27'),
(28, 'Суворов Вячеслав', '4587 124707', '1967-05-04'),
(29, 'Жданов Фёдор', '4683 198109', '1963-02-21'),
(30, 'Тюрина Регина', '4679 690851', '1959-05-29'),
(31, 'Зайцева Надежда', '4510 187156', '1990-11-09'),
(32, 'Елисеева Людмила', '4691 188586', '1971-06-22'),
(33, 'Пономарёв Герасим', '4582 965405', '1962-10-17'),
(34, 'Авдеева Жанна', '4694 171095', '1974-12-08'),
(35, 'Киселёв Ростислав', '4514 561341', '1994-02-27'),
(36, 'Кузьмина Раиса', '4691 098308', '1971-05-20'),
(37, 'Потапова Полина', '4689 217770', '1969-09-29'),
(38, 'Тимофеева Оксана', '4580 993802', '1960-03-27'),
(39, 'Сорокин Константин', '4502 796939', '1982-02-02'),
(40, 'Алексеева Нонна', '4679 910783', '1959-11-30'),
(41, 'Зыкова Анна', '4596 868546', '1976-08-17'),
(42, 'Беспалов Всеволод', '4513 042103', '1993-09-09'),
(43, 'Филатова Алина', '4678 137771', '1958-01-01'),
(44, 'Борисова Ангелина', '4595 113165', '1975-12-30'),
(45, 'Гаврилова Алина', '4502 140316', '1982-01-25'),
(46, 'Якушев Валерий', '4613 964226', '1993-07-05'),
(47, 'Нестеров Федот', '4601 626441', '1981-07-05'),
(48, 'Ильин Роман', '4609 394280', '1989-02-14'),
(49, 'Рябова Юлия', '4689 626805', '1969-04-25'),
(50, 'Журавлёв Владимир', '4598 597948', '1978-05-15'),
(51, 'Комарова Жанна', '4680 701728', '1960-04-30'),
(52, 'Новикова Яна', '4691 113801', '1971-05-28'),
(53, 'Жуков Роман', '4514 152932', '1994-12-05'),
(54, 'Якушева Светлана', '4598 327269', '1978-11-27'),
(55, 'Филиппова Ульяна', '4696 995775', '1976-03-25'),
(56, 'Воронцова Виктория', '4697 613212', '1977-12-30'),
(57, 'Блинова Елена', '4576 530729', '1956-01-06'),
(58, 'Тимофеев Анатолий', '4514 155374', '1994-08-21'),
(59, 'Шилов Игнатий', '4683 889001', '1963-09-15'),
(60, 'Гусева Виктория', '4515 156442', '1995-11-27'),
(61, 'Громов Федот', '4675 945525', '1955-01-22'),
(62, 'Ермаков Даниил', '4576 390086', '1956-12-10'),
(63, 'Сидорова Оксана', '4502 475371', '1982-06-21'),
(64, 'Лобанов Митрофан', '4615 223225', '1995-01-23'),
(65, 'Белоусова Надежда', '4612 988576', '1992-12-25'),
(66, 'Николаева Надежда', '4603 073302', '1983-02-11'),
(67, 'Кабанов Демьян', '4585 217670', '1965-10-26'),
(68, 'Филатова Кира', '4578 690827', '1958-06-20'),
(69, 'Савин Леонтий', '4697 611532', '1977-06-09'),
(70, 'Ширяева Нонна', '4512 792574', '1992-08-05'),
(71, 'Шубина Мария', '4602 306575', '1982-02-26'),
(72, 'Пахомов Христофор', '4693 973206', '1973-07-10'),
(73, 'Блинова Татьяна', '4577 456510', '1957-08-15'),
(74, 'Сафонова Екатерина', '4509 622602', '1989-11-22'),
(75, 'Пономарёв Глеб', '4683 701082', '1963-11-24'),
(76, 'Родионов Артур', '4575 604093', '1955-05-17'),
(77, 'Владимирова София', '4575 085201', '1955-11-25'),
(78, 'Кудрявцев Всеволод', '4589 366034', '1969-06-04'),
(79, 'Хохлова Прасковья', '4579 207530', '1959-10-14'),
(80, 'Рожкова Анжелика', '4678 376776', '1958-01-08'),
(81, 'Меркушева Антонина', '4683 812349', '1963-05-09'),
(82, 'Большакова Наталья', '4600 230014', '1980-01-15'),
(83, 'Филиппова Марина', '4513 420488', '1993-03-16'),
(84, 'Силин Александр', '4593 279427', '1973-04-21'),
(85, 'Журавлёва Фаина', '4689 421194', '1969-09-22'),
(86, 'Гаврилова Жанна', '4696 215926', '1976-04-15'),
(87, 'Миронова Таисия', '4600 616844', '1980-07-11'),
(88, 'Чернова Любовь', '4576 728844', '1956-01-08'),
(89, 'Копылов Александр', '4601 208659', '1981-01-05'),
(90, 'Тимофеев Арсений', '4591 284416', '1971-11-25'),
(91, 'Елисеева Полина', '4588 794112', '1968-02-26'),
(92, 'Белоусова Алла', '4611 013714', '1991-04-17'),
(93, 'Голубев Иван', '4604 112888', '1984-12-30'),
(94, 'Шестаков Гавриил', '4588 919915', '1968-02-17'),
(95, 'Стрелков Сергей', '4589 687300', '1969-04-25'),
(96, 'Третьяков Артур', '4502 977094', '1982-04-12'),
(97, 'Журавлёв Андрей', '4515 174789', '1995-12-15'),
(98, 'Попова Валерия', '4515 523107', '1995-08-25'),
(99, 'Ширяева Снежана', '4510 199172', '1990-11-13'),
(100, 'Калинина Зоя', '4505 167766', '1985-07-19');

-- --------------------------------------------------------

--
-- Структура таблицы `django_admin_log`
--

CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin__content_type_id_c4bce8eb_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Дамп данных таблицы `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2016-01-04 09:41:59', '242', 'Vladislav', 1, 'Added.', 13, 1),
(2, '2016-01-07 17:03:54', '2', 'manager1', 2, 'Changed user_permissions.', 13, 1),
(3, '2016-01-07 17:07:57', '2', 'manager1', 2, 'Changed user_permissions.', 13, 1),
(4, '2016-01-07 17:15:21', '2', 'manager1', 2, 'Changed is_staff and is_superuser.', 13, 1),
(5, '2016-01-07 17:50:55', '2', 'manager1', 2, 'Changed is_staff, is_superuser and user_permissions.', 13, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `django_content_type`
--

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Дамп данных таблицы `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(10, 'admin', 'logentry'),
(12, 'auth', 'group'),
(11, 'auth', 'permission'),
(13, 'auth', 'user'),
(14, 'contenttypes', 'contenttype'),
(15, 'sessions', 'session'),
(5, 'VStorage', 'auto'),
(3, 'VStorage', 'branch'),
(8, 'VStorage', 'branchproduct'),
(1, 'VStorage', 'client'),
(6, 'VStorage', 'driver'),
(4, 'VStorage', 'manager'),
(9, 'VStorage', 'orderproduct'),
(7, 'VStorage', 'ordertable'),
(2, 'VStorage', 'product');

-- --------------------------------------------------------

--
-- Структура таблицы `django_migrations`
--

CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25 ;

--
-- Дамп данных таблицы `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2016-01-04 09:07:18'),
(2, 'auth', '0001_initial', '2016-01-04 09:07:20'),
(3, 'admin', '0001_initial', '2016-01-04 09:07:21'),
(4, 'admin', '0002_logentry_remove_auto_add', '2016-01-04 09:07:21'),
(5, 'contenttypes', '0002_remove_content_type_name', '2016-01-04 09:07:21'),
(6, 'auth', '0002_alter_permission_name_max_length', '2016-01-04 09:07:21'),
(7, 'auth', '0003_alter_user_email_max_length', '2016-01-04 09:07:22'),
(8, 'auth', '0004_alter_user_username_opts', '2016-01-04 09:07:22'),
(9, 'auth', '0005_alter_user_last_login_null', '2016-01-04 09:07:22'),
(10, 'auth', '0006_require_contenttypes_0002', '2016-01-04 09:07:22'),
(11, 'auth', '0007_alter_validators_add_error_messages', '2016-01-04 09:07:22'),
(12, 'sessions', '0001_initial', '2016-01-04 09:07:22'),
(13, 'VStorage', '0001_initial', '2016-01-04 09:08:27'),
(14, 'VStorage', '0002_manager_user_id', '2016-01-04 10:04:55'),
(15, 'VStorage', '0003_remove_manager_user_id', '2016-01-04 10:17:55'),
(16, 'VStorage', '0004_manager_user_id', '2016-01-04 10:17:55'),
(17, 'VStorage', '0005_auto_20160104_1318', '2016-01-04 10:19:28'),
(18, 'VStorage', '0006_auto_20160104_1322', '2016-01-04 10:23:10'),
(19, 'VStorage', '0007_remove_product_product_description', '2016-01-06 11:31:06'),
(20, 'VStorage', '0008_auto_20160111_0954', '2016-01-11 06:55:00'),
(21, 'VStorage', '0009_auto_20160111_0954', '2016-01-11 06:55:00'),
(22, 'VStorage', '0010_auto_20160111_1005', '2016-01-11 07:05:42'),
(23, 'VStorage', '0011_auto_20160111_1010', '2016-01-11 07:10:43'),
(24, 'VStorage', '0012_auto_20160111_1015', '2016-01-11 07:15:51');

-- --------------------------------------------------------

--
-- Структура таблицы `django_session`
--

CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('k2j07n4jq7nhu2r1l915spou3nn2ggd3', 'NDYzY2VlNmIyZDU2M2FkODM1MDlmODdmMGQxMmMwY2FmN2RiMWZlZDp7ImJhc2tldCI6W119', '2016-01-25 08:48:16');

-- --------------------------------------------------------

--
-- Структура таблицы `Driver`
--

CREATE TABLE IF NOT EXISTS `Driver` (
  `driver_id` int(11) NOT NULL AUTO_INCREMENT,
  `driver_name` varchar(50) NOT NULL,
  `driver_birthday` date NOT NULL,
  `driver_salary` int(11) NOT NULL,
  `driver_recruitment` date NOT NULL,
  `auto_id` int(11) NOT NULL,
  PRIMARY KEY (`driver_id`),
  KEY `driver` (`driver_id`),
  KEY `driver_a` (`auto_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=61 ;

--
-- Дамп данных таблицы `Driver`
--

INSERT INTO `Driver` (`driver_id`, `driver_name`, `driver_birthday`, `driver_salary`, `driver_recruitment`, `auto_id`) VALUES
(1, 'Кондратьев Макар', '1981-10-27', 42070, '1998-03-28', 1),
(2, 'Мартынов Иннокентий', '1955-02-20', 49481, '2000-09-30', 2),
(3, 'Белозёров Федот', '1982-04-15', 35975, '1984-12-21', 3),
(4, 'Сидоров Валерий', '1957-01-08', 67356, '2003-12-25', 4),
(5, 'Одинцов Владимир', '1982-12-27', 58022, '1999-04-15', 5),
(6, 'Ширяев Александр', '1963-07-05', 53786, '1990-08-15', 6),
(7, 'Ковалёв Макар', '1980-02-25', 37892, '1996-12-10', 7),
(8, 'Миронов Олег', '1984-06-03', 55377, '2014-07-20', 8),
(9, 'Тетерин Герман', '1990-09-29', 56543, '2015-02-24', 9),
(10, 'Семёнов Герман', '1987-11-18', 49030, '1987-09-22', 10),
(11, 'Гурьев Яков', '1962-11-04', 35430, '1989-07-03', 11),
(12, 'Бобылёв Тихон', '1967-06-29', 55817, '2008-01-30', 12),
(13, 'Лапин Руслан', '1979-04-18', 36296, '1997-07-06', 13),
(14, 'Дорофеев Митрофан', '1962-09-29', 44417, '2014-03-14', 14),
(15, 'Беляев Вячеслав', '1987-04-14', 35987, '1994-10-10', 15),
(16, 'Харитонов Денис', '1960-09-16', 36067, '2009-08-11', 16),
(17, 'Туров Гавриил', '1968-10-15', 51938, '2012-07-23', 17),
(18, 'Васильев Тимофей', '1979-05-11', 36286, '2005-02-23', 18),
(19, 'Рогов Георгий', '1986-02-07', 42038, '1997-08-26', 19),
(20, 'Ершов Вениамин', '1970-07-31', 41356, '2015-11-09', 20),
(21, 'Киселёв Руслан', '1978-01-02', 43424, '2008-01-16', 21),
(22, 'Макаров Семён', '1969-10-29', 64991, '2005-08-02', 22),
(23, 'Мухин Демьян', '1955-04-19', 69509, '2011-06-15', 23),
(24, 'Морозов Леонид', '1966-11-17', 42719, '1989-05-18', 24),
(25, 'Прохоров Максим', '1981-12-14', 68011, '1994-07-02', 25),
(26, 'Ермаков Евгений', '1969-05-06', 57086, '2008-04-16', 26),
(27, 'Козлов Вениамин', '1989-07-01', 37484, '2003-10-24', 27),
(28, 'Никонов Евгений', '1957-02-17', 66839, '2008-08-11', 28),
(29, 'Зуев Анатолий', '1985-01-30', 49388, '2011-12-27', 29),
(30, 'Жданов Николай', '1984-07-11', 35260, '1984-07-14', 30),
(31, 'Дмитриев Григорий', '1986-03-31', 36311, '2005-07-15', 31),
(32, 'Цветков Василий', '1982-01-30', 37252, '1992-07-30', 32),
(33, 'Новиков Антон', '1959-07-17', 41763, '2008-04-14', 33),
(34, 'Семёнов Демьян', '1973-08-30', 69629, '1986-10-12', 34),
(35, 'Третьяков Аркадий', '1956-01-01', 54198, '1985-10-26', 35),
(36, 'Суханов Глеб', '1977-08-02', 47842, '1992-03-04', 36),
(37, 'Лукин Трофим', '1987-03-03', 59928, '2002-02-17', 37),
(38, 'Дмитриев Глеб', '1985-05-11', 43086, '2008-12-27', 38),
(39, 'Шашков Егор', '1975-07-05', 51132, '2002-06-10', 39),
(40, 'Захаров Денис', '1973-12-20', 45624, '2002-07-30', 40),
(41, 'Моисеев Прохор', '1977-08-03', 40875, '2012-07-06', 41),
(42, 'Баранов Артур', '1985-05-02', 57285, '2001-03-09', 42),
(43, 'Кудрявцев Антон', '1983-06-20', 61132, '2014-08-25', 43),
(44, 'Никифоров Демьян', '1962-11-09', 59327, '2004-11-20', 44),
(45, 'Баранов Митрофан', '1966-11-17', 42230, '1980-01-27', 45),
(46, 'Туров Богдан', '1987-11-27', 45756, '1992-03-06', 46),
(47, 'Бирюков Михаил', '1980-10-26', 44454, '1994-06-27', 47),
(48, 'Блохин Дмитрий', '1966-01-02', 57976, '2012-04-22', 48),
(49, 'Исаков Гавриил', '1955-10-29', 39088, '1995-07-12', 49),
(50, 'Карпов Матвей', '1971-04-08', 38981, '1992-08-13', 50),
(51, 'Гаврилов Ярослав', '1978-11-23', 37173, '2005-04-14', 51),
(52, 'Титов Дорофей', '1966-03-21', 54660, '2014-09-20', 52),
(53, 'Волков Егор', '1989-09-09', 66986, '2012-12-23', 53),
(54, 'Куликов Илья', '1959-02-21', 58863, '1993-05-04', 54),
(55, 'Князев Митрофан', '1962-12-06', 60522, '2012-02-19', 55),
(56, 'Панфилов Леонтий', '1957-02-22', 42099, '1998-06-08', 56),
(57, 'Кириллов Виктор', '1978-06-03', 40438, '2006-04-19', 57),
(58, 'Карпов Евгений', '1971-01-17', 62637, '1987-04-11', 58),
(59, 'Гришин Вениамин', '1967-09-30', 55882, '1989-11-23', 59),
(60, 'Кириллов Георгий', '1988-11-17', 35539, '2004-02-10', 60);

-- --------------------------------------------------------

--
-- Структура таблицы `Manager`
--

CREATE TABLE IF NOT EXISTS `Manager` (
  `manager_id` int(11) NOT NULL AUTO_INCREMENT,
  `manager_name` varchar(50) NOT NULL,
  `manager_birthday` date NOT NULL,
  `manager_recruitment` date NOT NULL,
  `manager_salary` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`manager_id`),
  UNIQUE KEY `Manager_user_id_id_6d83acf9_uniq` (`user_id`),
  KEY `manager` (`manager_id`),
  KEY `manager_b` (`branch_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=121 ;

--
-- Дамп данных таблицы `Manager`
--

INSERT INTO `Manager` (`manager_id`, `manager_name`, `manager_birthday`, `manager_recruitment`, `manager_salary`, `branch_id`, `user_id`) VALUES
(1, 'Новикова Елена', '1972-04-08', '1987-11-02', 56944, 1, 2),
(2, 'Суворов Павел', '1973-12-24', '2003-03-19', 30865, 1, 3),
(3, 'Мишин Максим', '1987-09-15', '2014-05-01', 45908, 1, 4),
(4, 'Некрасов Эраст', '1961-01-07', '2015-04-18', 59371, 1, 5),
(5, 'Лебедева Любовь', '1982-06-30', '1996-12-17', 35321, 1, 6),
(6, 'Миронов Пётр', '1981-08-15', '1985-10-14', 40851, 1, 7),
(7, 'Сидоров Ярослав', '1961-03-07', '1990-03-07', 62204, 1, 8),
(8, 'Комиссаров Станислав', '1958-02-21', '1991-09-22', 32894, 1, 9),
(9, 'Ковалёва Таисия', '1969-05-05', '2005-08-09', 30540, 1, 10),
(10, 'Крюков Анатолий', '1967-01-08', '1992-11-17', 44525, 1, 11),
(11, 'Гришин Эдуард', '1967-03-09', '2007-05-24', 59273, 1, 12),
(12, 'Ефимова Анастасия', '1973-05-27', '2000-03-14', 34391, 1, 13),
(13, 'Мартынов Фёдор', '1957-09-26', '2015-09-16', 47278, 1, 14),
(14, 'Трофимов Вадим', '1965-09-15', '2014-07-27', 37454, 1, 15),
(15, 'Стрелкова Александра', '1962-03-28', '2005-01-08', 66264, 1, 16),
(16, 'Шашков Артём', '1981-04-19', '2007-11-27', 66398, 1, 17),
(17, 'Герасимова Майя', '1984-10-30', '2014-12-13', 39854, 1, 18),
(18, 'Филатова Валерия', '1976-09-27', '1989-09-19', 39213, 1, 19),
(19, 'Мясникова Ксения', '1986-01-20', '1989-09-24', 35449, 1, 20),
(20, 'Третьякова Ярослава', '1982-06-25', '1988-11-30', 62106, 1, 21),
(21, 'Фролов Анатолий', '1972-02-21', '1999-08-07', 38267, 2, 22),
(22, 'Сазонов Фёдор', '1965-03-28', '1999-12-03', 63515, 2, 23),
(23, 'Прохорова Алина', '1955-01-16', '2014-05-30', 55046, 2, 24),
(24, 'Якушев Григорий', '1985-05-08', '2014-07-30', 41085, 2, 25),
(25, 'Агафонова Марина', '1963-03-30', '1998-09-29', 64886, 2, 26),
(26, 'Агафонов Михаил', '1967-06-28', '2001-07-28', 33692, 2, 27),
(27, 'Анисимов Александр', '1981-01-04', '2006-03-02', 68532, 2, 28),
(28, 'Сазонова Галина', '1977-02-10', '1994-08-23', 69307, 2, 29),
(29, 'Суханов Трофим', '1957-12-28', '2014-03-13', 51778, 2, 30),
(30, 'Лебедев Федот', '1974-09-26', '1987-05-13', 40836, 2, 31),
(31, 'Тарасова Фаина', '1956-07-09', '1995-08-05', 57109, 2, 32),
(32, 'Субботин Вадим', '1985-08-09', '1985-07-21', 59059, 2, 33),
(33, 'Турова Марина', '1963-02-26', '1995-06-10', 53258, 2, 34),
(34, 'Соловьёв Роман', '1977-02-25', '2014-03-21', 48801, 2, 35),
(35, 'Семёнов Сергей', '1984-11-06', '2011-07-11', 49186, 2, 36),
(36, 'Артемьев Павел', '1972-02-03', '2004-11-26', 60694, 2, 37),
(37, 'Емельянова София', '1956-12-29', '1990-09-13', 32453, 2, 38),
(38, 'Крылова Василиса', '1988-07-09', '2006-04-02', 52970, 2, 39),
(39, 'Родионов Герасим', '1982-12-14', '1999-11-21', 34595, 2, 40),
(40, 'Кононов Герман', '1956-10-13', '2012-02-26', 60499, 2, 41),
(41, 'Потапова Снежана', '1959-04-23', '1997-03-09', 60310, 3, 42),
(42, 'Абрамов Арсений', '1980-10-04', '2014-09-14', 49691, 3, 43),
(43, 'Шилов Иннокентий', '1972-09-03', '2014-05-25', 50063, 3, 44),
(44, 'Исаев Геннадий', '1964-03-08', '1998-05-14', 52479, 3, 45),
(45, 'Горбачёва Алина', '1964-11-25', '1996-03-19', 64362, 3, 46),
(46, 'Цветков Борис', '1973-03-01', '1994-06-16', 45051, 3, 47),
(47, 'Орлова Фаина', '1970-11-17', '2010-07-09', 37477, 3, 48),
(48, 'Гришин Вениамин', '1985-02-25', '1989-04-01', 58615, 3, 49),
(49, 'Денисов Семён', '1955-03-17', '2000-03-15', 45447, 3, 50),
(50, 'Голубева Любовь', '1981-05-05', '2012-09-16', 57924, 3, 51),
(51, 'Алексеев Егор', '1972-01-14', '2010-10-03', 32181, 3, 52),
(52, 'Самойлова Нина', '1961-10-10', '2014-12-04', 65657, 3, 53),
(53, 'Мясников Семён', '1979-03-12', '2011-02-07', 63928, 3, 54),
(54, 'Бобылёва Нонна', '1981-04-15', '1996-02-15', 53892, 3, 55),
(55, 'Николаева Василиса', '1984-11-20', '1986-02-01', 52587, 3, 56),
(56, 'Одинцова Елизавета', '1965-02-11', '1994-07-13', 68262, 3, 57),
(57, 'Морозов Ефим', '1988-02-24', '2010-07-08', 55682, 3, 58),
(58, 'Молчанова Снежана', '1982-09-12', '1988-11-14', 35063, 3, 59),
(59, 'Медведев Александр', '1962-05-25', '2007-11-13', 60750, 3, 60),
(60, 'Колесников Николай', '1981-11-17', '2005-02-18', 65281, 3, 61),
(61, 'Мельников Ярослав', '1966-08-28', '2000-10-25', 34944, 4, 62),
(62, 'Турова Ярослава', '1978-03-30', '2014-12-12', 54470, 4, 63),
(63, 'Щербакова Ярослава', '1962-09-29', '2001-10-03', 48851, 4, 64),
(64, 'Зайцев Артём', '1959-10-06', '2004-02-12', 41516, 4, 65),
(65, 'Попова Анастасия', '1955-03-10', '1988-12-26', 52118, 4, 66),
(66, 'Афанасьев Тимофей', '1963-06-15', '2014-07-23', 65625, 4, 67),
(67, 'Мухина Раиса', '1976-09-03', '2014-07-20', 47437, 4, 68),
(68, 'Стрелкова Анна', '1965-10-28', '1991-10-18', 62699, 4, 69),
(69, 'Меркушева Галина', '1980-09-18', '1986-10-15', 47349, 4, 70),
(70, 'Зиновьева Анна', '1971-11-27', '2009-04-06', 53459, 4, 71),
(71, 'Ширяев Тимофей', '1971-11-21', '2003-07-27', 48739, 4, 72),
(72, 'Дорофеев Ростислав', '1975-05-30', '1999-04-30', 45492, 4, 73),
(73, 'Степанов Герман', '1956-12-29', '2004-04-21', 67945, 4, 74),
(74, 'Молчанова Мария', '1963-10-08', '2012-02-23', 44289, 4, 75),
(75, 'Белякова София', '1960-03-04', '2014-10-28', 45517, 4, 76),
(76, 'Гаврилов Степан', '1967-12-08', '2002-07-23', 33766, 4, 77),
(77, 'Агафонов Демьян', '1957-05-16', '1987-12-23', 32445, 4, 78),
(78, 'Зайцева Юлия', '1960-04-11', '2012-08-26', 61904, 4, 79),
(79, 'Корнилова Анастасия', '1963-01-23', '2005-07-03', 65464, 4, 80),
(80, 'Муравьёва Ирина', '1956-05-31', '1994-06-12', 30305, 4, 81),
(81, 'Филиппова Вероника', '1989-10-26', '2006-04-08', 58386, 5, 82),
(82, 'Гуляева Оксана', '1978-06-18', '2014-09-16', 33551, 5, 83),
(83, 'Гаврилова Раиса', '1966-08-19', '2007-07-24', 51311, 5, 84),
(84, 'Петухов Владислав', '1983-03-23', '2003-03-29', 62425, 5, 85),
(85, 'Кулагина Галина', '1961-08-25', '1993-12-18', 54740, 5, 86),
(86, 'Гришина Полина', '1970-12-21', '1994-01-21', 50044, 5, 87),
(87, 'Морозова Маргарита', '1960-01-14', '2000-11-10', 32558, 5, 88),
(88, 'Белозёров Алексей', '1970-04-19', '2011-01-13', 49943, 5, 89),
(89, 'Герасимов Макар', '1981-07-10', '1992-02-15', 54456, 5, 90),
(90, 'Осипова Анна', '1981-11-24', '1990-05-27', 46521, 5, 91),
(91, 'Тимофеева Светлана', '1983-04-19', '2014-07-18', 47523, 5, 92),
(92, 'Сазонова Тамара', '1970-06-11', '1992-03-23', 44565, 5, 93),
(93, 'Григорьева Полина', '1971-08-09', '2007-12-21', 48161, 5, 94),
(94, 'Панов Валерий', '1974-09-05', '2003-10-27', 43806, 5, 95),
(95, 'Щукина Марина', '1957-12-01', '1988-08-14', 48876, 5, 96),
(96, 'Вишнякова Жанна', '1969-04-21', '2004-04-03', 53300, 5, 97),
(97, 'Лазарева Татьяна', '1955-11-20', '2006-09-24', 69211, 5, 98),
(98, 'Федотова София', '1988-03-18', '1990-03-24', 59875, 5, 99),
(99, 'Колобова Снежана', '1978-12-03', '1996-08-18', 47775, 5, 100),
(100, 'Куликова София', '1958-06-21', '1987-02-28', 36045, 5, 101),
(101, 'Зайцева Маргарита', '1973-06-26', '1997-12-15', 63513, 6, 102),
(102, 'Савельева Евгения', '1989-05-31', '2002-01-06', 68660, 6, 103),
(103, 'Крылов Николай', '1969-01-17', '1993-03-22', 30725, 6, 104),
(104, 'Архипова Екатерина', '1978-06-30', '1997-09-06', 62213, 6, 105),
(105, 'Архипов Демьян', '1984-07-06', '2014-10-13', 51821, 6, 106),
(106, 'Максимова Ульяна', '1974-04-17', '1983-11-03', 45472, 6, 107),
(107, 'Громов Богдан', '1966-06-19', '1994-01-02', 64191, 6, 108),
(108, 'Никитин Константин', '1967-05-20', '1996-01-07', 48833, 6, 109),
(109, 'Федотов Игнатий', '1988-11-03', '2007-08-06', 58831, 6, 110),
(110, 'Кулагина Галина', '1984-12-18', '2014-06-14', 32835, 6, 111),
(111, 'Ширяев Роман', '1966-09-03', '1998-12-15', 50712, 6, 112),
(112, 'Ермакова Валентина', '1980-11-07', '2007-08-19', 66721, 6, 113),
(113, 'Щукина Василиса', '1974-04-29', '2001-01-07', 35291, 6, 114),
(114, 'Лукина Карина', '1972-06-21', '2011-01-14', 48673, 6, 115),
(115, 'Григорьев Игорь', '1976-07-18', '2013-12-13', 69029, 6, 116),
(116, 'Зиновьев Христофор', '1969-03-19', '2014-05-26', 42831, 6, 117),
(117, 'Аксёнов Олег', '1973-04-30', '2010-02-22', 67835, 6, 118),
(118, 'Чернова Елизавета', '1990-03-04', '1991-12-02', 45807, 6, 119),
(119, 'Зыков Эдуард', '1976-08-16', '2014-08-19', 38513, 6, 120),
(120, 'Медведева Карина', '1955-10-17', '1989-03-22', 32500, 6, 121);

-- --------------------------------------------------------

--
-- Структура таблицы `OrderProduct`
--

CREATE TABLE IF NOT EXISTS `OrderProduct` (
  `orderproduct_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_count` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`orderproduct_id`),
  KEY `orderproduct` (`orderproduct_id`),
  KEY `orderproduct_o` (`order_id`),
  KEY `orderproduct_p` (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=208 ;

--
-- Дамп данных таблицы `OrderProduct`
--

INSERT INTO `OrderProduct` (`orderproduct_id`, `product_count`, `order_id`, `product_id`) VALUES
(1, 2, 1, 99),
(2, 1, 1, 56),
(3, 2, 2, 49),
(4, 2, 2, 62),
(5, 2, 2, 103),
(6, 1, 3, 41),
(7, 2, 4, 80),
(8, 1, 5, 33),
(9, 1, 5, 26),
(10, 2, 5, 77),
(11, 2, 6, 60),
(12, 1, 7, 87),
(13, 2, 8, 42),
(14, 2, 8, 49),
(15, 1, 8, 22),
(16, 2, 9, 30),
(17, 1, 10, 76),
(18, 1, 10, 90),
(19, 1, 11, 111),
(20, 2, 12, 87),
(21, 1, 13, 96),
(22, 1, 14, 92),
(23, 1, 14, 67),
(24, 1, 14, 74),
(25, 2, 15, 83),
(26, 1, 15, 98),
(27, 2, 16, 111),
(28, 2, 16, 60),
(29, 2, 17, 33),
(30, 1, 18, 92),
(31, 2, 18, 73),
(32, 1, 19, 36),
(33, 1, 20, 27),
(34, 2, 20, 7),
(35, 1, 21, 55),
(36, 1, 21, 39),
(37, 1, 22, 12),
(38, 2, 22, 2),
(39, 2, 22, 104),
(40, 1, 23, 75),
(41, 2, 23, 34),
(42, 1, 23, 11),
(43, 1, 24, 79),
(44, 2, 24, 46),
(45, 1, 25, 88),
(46, 1, 25, 79),
(47, 1, 26, 89),
(48, 1, 27, 16),
(49, 1, 28, 110),
(50, 1, 28, 26),
(51, 1, 29, 62),
(52, 2, 30, 102),
(53, 1, 30, 53),
(54, 1, 30, 78),
(55, 2, 31, 70),
(56, 2, 32, 20),
(57, 1, 32, 77),
(58, 1, 32, 11),
(59, 1, 33, 16),
(60, 2, 34, 58),
(61, 1, 34, 15),
(62, 1, 35, 20),
(63, 2, 36, 3),
(64, 2, 37, 7),
(65, 2, 37, 92),
(66, 2, 37, 41),
(67, 1, 38, 27),
(68, 2, 38, 102),
(69, 1, 38, 104),
(70, 1, 39, 43),
(71, 2, 39, 85),
(72, 1, 39, 96),
(73, 2, 40, 30),
(74, 2, 40, 44),
(75, 1, 41, 111),
(76, 1, 42, 52),
(77, 2, 42, 105),
(78, 1, 42, 32),
(79, 2, 43, 85),
(80, 2, 43, 71),
(81, 1, 43, 58),
(82, 1, 44, 18),
(83, 1, 44, 92),
(84, 2, 45, 113),
(85, 2, 45, 54),
(86, 2, 45, 93),
(87, 1, 46, 110),
(88, 1, 47, 32),
(89, 1, 47, 38),
(90, 2, 48, 36),
(91, 1, 48, 16),
(92, 2, 49, 63),
(93, 2, 49, 16),
(94, 2, 49, 69),
(95, 2, 50, 107),
(96, 2, 51, 34),
(97, 2, 51, 19),
(98, 2, 52, 101),
(99, 2, 52, 3),
(100, 2, 52, 114),
(101, 2, 53, 42),
(102, 2, 53, 34),
(103, 1, 53, 50),
(104, 1, 54, 7),
(105, 1, 54, 101),
(106, 1, 54, 109),
(107, 1, 55, 112),
(108, 1, 56, 11),
(109, 2, 56, 13),
(110, 1, 57, 113),
(111, 2, 58, 16),
(112, 2, 59, 96),
(113, 1, 60, 51),
(114, 2, 61, 88),
(115, 1, 61, 2),
(116, 1, 62, 52),
(117, 1, 62, 56),
(118, 1, 62, 108),
(119, 2, 63, 106),
(120, 1, 63, 96),
(121, 2, 64, 95),
(122, 2, 64, 25),
(123, 1, 65, 70),
(124, 2, 65, 97),
(125, 2, 66, 1),
(126, 2, 67, 47),
(127, 2, 67, 25),
(128, 1, 67, 35),
(129, 2, 68, 14),
(130, 2, 68, 35),
(131, 2, 69, 55),
(132, 1, 69, 61),
(133, 2, 69, 103),
(134, 1, 70, 109),
(135, 2, 71, 102),
(136, 2, 72, 101),
(137, 1, 72, 36),
(138, 1, 73, 58),
(139, 2, 74, 8),
(140, 1, 74, 6),
(141, 1, 75, 96),
(142, 1, 75, 4),
(143, 1, 75, 66),
(144, 2, 76, 19),
(145, 1, 76, 23),
(146, 2, 77, 74),
(147, 2, 77, 40),
(148, 2, 77, 67),
(149, 1, 78, 11),
(150, 1, 78, 77),
(151, 1, 79, 34),
(152, 1, 79, 51),
(153, 2, 79, 44),
(154, 1, 80, 52),
(155, 1, 80, 29),
(156, 1, 81, 95),
(157, 2, 82, 82),
(158, 1, 82, 97),
(159, 2, 82, 8),
(160, 1, 83, 70),
(161, 1, 83, 61),
(162, 2, 84, 71),
(163, 1, 84, 6),
(164, 2, 84, 52),
(165, 1, 85, 45),
(166, 1, 85, 24),
(167, 1, 86, 76),
(168, 1, 86, 97),
(169, 2, 86, 22),
(170, 1, 87, 45),
(171, 2, 87, 5),
(172, 1, 87, 1),
(173, 1, 88, 13),
(174, 1, 88, 54),
(175, 2, 88, 84),
(176, 1, 89, 110),
(177, 2, 90, 109),
(178, 2, 90, 60),
(179, 2, 90, 20),
(180, 2, 91, 40),
(181, 2, 91, 18),
(182, 2, 92, 26),
(183, 1, 92, 40),
(184, 1, 93, 104),
(185, 1, 93, 87),
(186, 2, 94, 110),
(187, 1, 94, 34),
(188, 1, 94, 29),
(189, 1, 95, 8),
(190, 1, 96, 78),
(191, 2, 97, 37),
(192, 2, 97, 111),
(193, 2, 97, 4),
(194, 2, 98, 43),
(195, 2, 98, 57),
(196, 2, 99, 49),
(197, 1, 99, 104),
(198, 2, 100, 74),
(199, 2, 100, 57),
(200, 2, 100, 5);

-- --------------------------------------------------------

--
-- Структура таблицы `OrderTable`
--

CREATE TABLE IF NOT EXISTS `OrderTable` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_date` date NOT NULL,
  `order_address` varchar(100) DEFAULT NULL,
  `order_totalcost` float NOT NULL,
  `manager_id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `auto_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `ordertable` (`order_id`),
  KEY `ordertable_m` (`manager_id`),
  KEY `ordertable_c` (`client_id`),
  KEY `ordertable_b` (`branch_id`),
  KEY `ordertable_a` (`auto_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=108 ;

--
-- Дамп данных таблицы `OrderTable`
--

INSERT INTO `OrderTable` (`order_id`, `order_date`, `order_address`, `order_totalcost`, `manager_id`, `client_id`, `branch_id`, `auto_id`) VALUES
(1, '2014-09-07', 'Новосёлки, 3-я улица', 118613, 5, 1, 5, 10),
(2, '2015-04-17', 'Автозаводский 1-й проезд', 165998, 15, 2, 4, 2),
(3, '2015-02-24', 'Крымская набережная', 43736, 11, 3, 6, 3),
(4, '2015-05-06', 'Зачатьевский 1-й переулок', 67800, 20, 4, 2, 3),
(5, '2013-09-26', 'Белореченская улица', 154037, 10, 5, 1, 3),
(6, '2015-08-30', 'Муравская улица', 99966, 15, 6, 1, 6),
(7, '2015-06-29', 'Новый 1-й переулок', 36258, 9, 7, 2, 8),
(8, '2014-08-08', 'Чоботовская улица', 200391, 2, 8, 5, 9),
(9, '2014-02-09', 'Можайский 6-й переулок', 41402, 13, 9, 2, 2),
(10, '2013-12-15', 'Квесисская 2-я улица', 51628, 16, 10, 6, 4),
(11, '2014-09-25', 'Средний Кисловский переулок', 31853, 14, 11, 3, 10),
(12, '2015-11-07', 'Митинский 1-й переулок', 72516, 16, 12, 4, 1),
(13, '2013-01-16', 'Лыковский 1-й проезд', 39957, 8, 13, 6, 10),
(14, '2014-02-14', 'Напрудная 1-я улица', 145043, 4, 14, 4, 2),
(15, '2014-08-28', 'Николая Сироткина, улица', 115636, 1, 15, 5, 3),
(16, '2013-02-18', 'Ивана Сусанина, улица', 163672, 19, 16, 5, 2),
(17, '2014-10-18', 'Николоямская набережная', 96250, 4, 17, 6, 3),
(18, '2013-09-06', 'Большого Круга, аллея', 166356, 12, 18, 6, 4),
(19, '2013-12-01', 'Рижский проезд', 15260, 9, 19, 6, 9),
(20, '2014-04-11', 'Станционная улица', 121090, 16, 20, 4, 3),
(21, '2015-11-08', 'Шарикоподшипниковская улица', 83344, 18, 21, 6, 3),
(22, '2014-07-08', 'Олимпийской Деревни, проезд', 190307, 17, 22, 2, 8),
(23, '2014-03-04', 'Вавилова, улица', 153491, 12, 23, 1, 10),
(24, '2015-08-03', 'Дьяково Городище, 1-я улица', 130195, 19, 24, 4, 1),
(25, '2015-12-08', 'Комсомольская улица (Молжаниновский)', 96928, 18, 25, 5, 7),
(26, '2015-02-01', 'Мельницкий переулок', 39273, 14, 26, 2, 3),
(27, '2015-06-03', 'Новгородская улица', 37779, 12, 27, 6, 4),
(28, '2014-04-13', 'Фрунзенская 1-я улица', 114790, 12, 28, 1, 7),
(29, '2013-01-25', 'Исаковского, улица', 22591, 19, 29, 6, 3),
(30, '2015-07-16', 'Малый Сергиевский переулок', 159336, 3, 30, 5, 4),
(31, '2015-06-28', 'Лениногорская улица', 119966, 13, 31, 6, 4),
(32, '2014-12-12', 'Бажова, улица', 149221, 17, 32, 4, 4),
(33, '2015-02-15', 'Александра Невского, улица', 37779, 17, 33, 4, 3),
(34, '2013-07-09', 'Малая Остроумовская улица', 153837, 4, 34, 5, 8),
(35, '2013-06-12', 'Погодинская улица', 38924, 16, 35, 4, 4),
(36, '2014-10-29', 'Рассветная аллея', 55810, 1, 36, 2, 3),
(37, '2013-02-07', 'Холодильный переулок', 281912, 16, 37, 6, 1),
(38, '2015-11-07', 'Поклонная улица', 139437, 13, 38, 2, 10),
(39, '2015-09-15', 'Курьяновская 1-я улица', 129863, 15, 39, 1, 2),
(40, '2013-12-07', 'Чертольский переулок', 147302, 14, 40, 5, 1),
(41, '2014-11-11', 'Академика Королёва, улица', 31853, 17, 41, 3, 9),
(42, '2015-12-01', 'Большая Черёмушкинская улица', 158277, 14, 42, 2, 1),
(43, '2015-11-11', 'Чистопольская улица', 141963, 3, 43, 1, 4),
(44, '2013-01-21', 'Венёвская улица', 79635, 1, 44, 1, 6),
(45, '2013-12-01', 'Алексея Свиридова, улица', 298978, 9, 45, 4, 7),
(46, '2014-08-07', 'Малая Екатерининская улица', 59158, 13, 46, 3, 2),
(47, '2015-09-06', 'Котельнический 2-й переулок', 78436, 2, 47, 1, 9),
(48, '2014-04-17', 'Хуторской 1-й переулок', 68299, 15, 48, 6, 4),
(49, '2015-10-16', 'Кадомцева проезд', 257734, 13, 49, 3, 8),
(50, '2014-10-02', 'Васильцовский переулок', 72442, 4, 50, 1, 9),
(51, '2013-11-27', 'Бирюлёвская улица', 151034, 6, 51, 1, 7),
(52, '2014-05-28', 'Хуторской 1-й переулок', 199460, 18, 52, 1, 4),
(53, '2015-01-29', 'Судакова, улица', 213872, 16, 53, 4, 8),
(54, '2013-04-04', 'Кленовый бульвар', 150921, 7, 54, 3, 7),
(55, '2014-06-03', 'Внуковская 1-я улица', 40538, 10, 55, 4, 5),
(56, '2015-12-19', 'Ростовская набережная', 119745, 17, 56, 4, 9),
(57, '2015-04-02', 'Карпатская 2-я улица', 40964, 16, 57, 6, 6),
(58, '2015-03-17', 'Бурденко, улица', 75558, 20, 58, 5, 4),
(59, '2013-03-17', 'Госпитальный Вал, улица', 79914, 14, 59, 4, 9),
(60, '2014-06-12', 'Якиманская набережная', 18162, 17, 60, 6, 10),
(61, '2014-02-12', 'Пресненская набережная', 123030, 6, 61, 1, 6),
(62, '2014-12-23', 'Переяславский переулок', 78890, 4, 62, 5, 5),
(63, '2013-05-09', 'Поселковая улица', 77375, 11, 63, 5, 2),
(64, '2014-10-27', 'Коптевский бульвар', 154478, 12, 64, 4, 8),
(65, '2014-07-03', 'Донелайтиса, проезд', 179235, 7, 65, 3, 1),
(66, '2014-06-22', 'Маршала Бабаджаняна, площадь', 77618, 2, 66, 5, 7),
(67, '2013-04-19', 'Промышленная улица', 232798, 1, 67, 1, 4),
(68, '2015-04-14', 'Добролюбова, улица', 144736, 5, 68, 6, 3),
(69, '2013-05-31', 'Ксеньинский переулок', 172910, 8, 69, 5, 2),
(70, '2013-06-28', 'Сыромятнический 4-й переулок', 55352, 5, 70, 2, 9),
(71, '2014-05-19', 'Симферопольский проезд', 81212, 3, 71, 4, 9),
(72, '2014-04-20', 'Сетуньский 4-й проезд', 117294, 20, 72, 4, 7),
(73, '2014-01-21', 'Садовническая улица', 54555, 12, 73, 6, 2),
(74, '2015-11-05', 'Нагатинский 1-й проезд', 112862, 6, 74, 3, 3),
(75, '2013-12-02', 'Лялина площадь', 106629, 12, 75, 6, 3),
(76, '2014-01-31', 'Медведковское шоссе', 143870, 13, 76, 3, 3),
(77, '2013-04-19', 'Кухмистерова, улица', 280634, 18, 77, 1, 10),
(78, '2013-07-11', 'Пантелеевская улица', 71373, 10, 78, 4, 5),
(79, '2014-06-28', 'Малый Харитоньевский переулок', 153441, 20, 79, 2, 2),
(80, '2014-02-12', 'Козлова, улица', 61607, 5, 80, 6, 5),
(81, '2014-01-11', 'Марьиной Рощи, 13-й проезд', 20733, 11, 81, 2, 6),
(82, '2014-07-06', 'Вишневского Академика, площадь', 196756, 20, 82, 2, 10),
(83, '2013-02-03', 'Рязанский проезд', 89937, 16, 83, 6, 6),
(84, '2014-01-06', 'Варварские Ворота, площадь', 142206, 3, 84, 1, 4),
(85, '2014-07-17', 'Дербеневская набережная', 103683, 8, 85, 1, 8),
(86, '2013-12-15', 'Войковский 1-й проезд', 208636, 4, 86, 4, 10),
(87, '2013-02-22', 'Мелитопольский проезд', 157060, 7, 87, 4, 2),
(88, '2014-02-11', 'Никольский переулок', 212012, 20, 88, 4, 2),
(89, '2013-04-05', 'Казанский переулок', 59158, 7, 89, 2, 7),
(90, '2014-01-15', 'Угловой переулок', 288518, 4, 90, 1, 7),
(91, '2015-09-18', 'Курсовой переулок', 149818, 14, 91, 2, 10),
(92, '2015-10-17', 'Генерала Тюленева, улица', 159206, 17, 92, 6, 4),
(93, '2015-08-01', 'Люберецкий 1-й проезд', 62497, 3, 93, 5, 3),
(94, '2015-03-27', 'Осипенко, улица (Южное Бутово)', 187915, 4, 94, 6, 7),
(95, '2014-05-16', 'Водников, улица', 26882, 3, 95, 5, 7),
(96, '2014-08-02', 'Бронницкая улица', 28514, 2, 96, 4, 5),
(97, '2013-12-02', 'Большой Татарский переулок', 231918, 18, 97, 5, 6),
(98, '2015-04-26', 'Щёлковское шоссе', 180638, 20, 98, 4, 10),
(99, '2013-12-24', 'Бухвостова 2-я улица', 59675, 18, 99, 3, 8),
(100, '2015-10-30', 'Дунаевского, улица', 237406, 6, 100, 2, 7);

-- --------------------------------------------------------

--
-- Структура таблицы `Product`
--

CREATE TABLE IF NOT EXISTS `Product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(50) NOT NULL,
  `product_cost` float NOT NULL,
  `product_made` varchar(20) NOT NULL,
  `product_category` varchar(50) NOT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product` (`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=139 ;

--
-- Дамп данных таблицы `Product`
--

INSERT INTO `Product` (`product_id`, `product_name`, `product_cost`, `product_made`, `product_category`) VALUES
(1, 'Acer Aspire E5-511', 38090, 'Вьетнам', 'Ноутбук'),
(2, 'Acer Aspire ES1-512', 48000, 'Вьетнам', 'Ноутбук'),
(3, 'Acer Aspire E5-731G', 27905, 'Китай', 'Ноутбук'),
(4, 'Apple MacBook Pro MGX72RU/A', 45355, 'Вьетнам', 'Ноутбук'),
(5, 'Apple MacBook Pro MGX82RU/A', 31321, 'Китай', 'Ноутбук'),
(6, 'Apple MacBook Pro MGXC2RU/A', 59098, 'Россия', 'Ноутбук'),
(7, 'ASUS G751JM', 44552, 'Китай', 'Ноутбук'),
(8, 'ASUS X553MA', 26882, 'Россия', 'Ноутбук'),
(9, 'ASUS G750JS', 26774, 'Индонезия', 'Ноутбук'),
(10, 'DELL Inspiron 3531', 23012, 'Китай', 'Ноутбук'),
(11, 'DELL Inspiron 3541', 46233, 'Вьетнам', 'Ноутбук'),
(12, 'DELL Inspiron 7347', 41829, 'Индонезия', 'Ноутбук'),
(13, 'Fujitsu LIFEBOOK E544', 36756, 'Китай', 'Ноутбук'),
(14, 'Fujitsu LIFEBOOK E754', 42980, 'Индонезия', 'Ноутбук'),
(15, 'Fujitsu LIFEBOOK E782', 44727, 'Вьетнам', 'Ноутбук'),
(16, 'HP 250 G3', 37779, 'Россия', 'Ноутбук'),
(17, 'HP 255 G3', 24437, 'Китай', 'Ноутбук'),
(18, 'HP ProBook 430 G2', 26967, 'Вьетнам', 'Ноутбук'),
(19, 'Lenovo IdeaPad Z5070', 46138, 'Вьетнам', 'Ноутбук'),
(20, 'Lenovo IdeaPad G5030', 38924, 'Россия', 'Ноутбук'),
(21, 'Lenovo B5070', 23412, 'Тайвань', 'Ноутбук'),
(22, 'MSI GT72', 56507, 'Вьетнам', 'Ноутбук'),
(23, 'MSI CR70', 51594, 'Тайвань', 'Ноутбук'),
(24, 'MSI GT80', 48074, 'Вьетнам', 'Ноутбук'),
(25, 'Samsung ATIV Book 9', 56506, 'Россия', 'Ноутбук'),
(26, 'Sony VAIO SV-T1122E2R', 55632, 'Вьетнам', 'Ноутбук'),
(27, 'Sony VAIO SV-P1321I6R', 31986, 'Россия', 'Ноутбук'),
(28, 'Sony VAIO SV-P1322R4R', 18595, 'Тайвань', 'Ноутбук'),
(29, 'Toshiba Satellite P50T', 40220, 'Вьетнам', 'Ноутбук'),
(30, 'Toshiba Portege Z30', 20701, 'Индонезия', 'Ноутбук'),
(31, 'Huawei Honor 4c', 49691, 'Россия', 'Смартфон'),
(32, 'Apple iPhone 6 16Gb', 54366, 'Тайвань', 'Смартфон'),
(33, 'ASUS Zenfone 2 Lazer ZE500KL 16Gb', 48125, 'Вьетнам', 'Смартфон'),
(34, 'Microsoft Lumia 640 3G Dual Sim', 29379, 'Китай', 'Смартфон'),
(35, 'Huawei Honor 7 16Gb', 29388, 'Китай', 'Смартфон'),
(36, 'Sony Xperia Z3 Compact', 15260, 'Россия', 'Смартфон'),
(37, 'Meizu M2 Note 16Gb', 38751, 'Россия', 'Смартфон'),
(38, 'Sony Xperia Z5 Compact', 24070, 'Россия', 'Смартфон'),
(39, 'Microsoft Lumia 950 Dual Sim', 55556, 'Вьетнам', 'Смартфон'),
(40, 'Microsoft Lumia 550', 47942, 'Россия', 'Смартфон'),
(41, 'Microsoft Lumia 640 LTE Dual Sim', 43736, 'Тайвань', 'Смартфон'),
(42, 'ASUS ZenFone 2 ZE551ML 32Gb Ram 4Gb', 55224, 'Вьетнам', 'Смартфон'),
(43, 'Highscreen Power Five', 42832, 'Россия', 'Смартфон'),
(44, 'LG G4', 52950, 'Индонезия', 'Смартфон'),
(45, 'Meizu M2 mini', 55609, 'Китай', 'Смартфон'),
(46, 'Nokia Lumia 830', 35391, 'Вьетнам', 'Смартфон'),
(47, 'Samsung Galaxy S6 32Gb', 45199, 'Россия', 'Смартфон'),
(48, 'Nokia X2 Dual sim', 56456, 'Индонезия', 'Смартфон'),
(49, 'Microsoft Lumia 435 Dual Sim', 16718, 'Китай', 'Смартфон'),
(50, 'Microsoft Lumia 950', 44666, 'Вьетнам', 'Смартфон'),
(51, 'Apple iPhone 6S 64Gb', 18162, 'Индонезия', 'Смартфон'),
(52, 'Microsoft Lumia 640 XL 3G Dual Sim', 21387, 'Индонезия', 'Смартфон'),
(53, 'ASUS Zenfone 5 16Gb', 49610, 'Китай', 'Смартфон'),
(54, 'Microsoft Lumia 535 Dual', 57484, 'Тайвань', 'Смартфон'),
(55, 'ASUS ZenFone 2 16Gb', 27788, 'Вьетнам', 'Смартфон'),
(56, 'Nokia Lumia 730 Dual sim', 16769, 'Тайвань', 'Смартфон'),
(57, 'ASUS Zenfone 2 Lazer ZE550KL', 47487, 'Тайвань', 'Смартфон'),
(58, 'Highscreen Boost 3', 54555, 'Индонезия', 'Смартфон'),
(59, 'ASUS ZenFone 2 ZE500CL', 59850, 'Китай', 'Смартфон'),
(60, 'Nokia Lumia 735', 49983, 'Китай', 'Смартфон'),
(61, 'Brother 1440', 29954, 'Тайвань', 'Принтер'),
(62, 'Brother MFC8840', 22591, 'Индонезия', 'Принтер'),
(63, 'Brother MFC8840D', 35293, 'Китай', 'Принтер'),
(64, 'Canon 30i', 36825, 'Вьетнам', 'Принтер'),
(65, 'Canon 550i', 31192, 'Китай', 'Принтер'),
(66, 'Canon MP780', 21317, 'Индонезия', 'Принтер'),
(67, 'Canon MP800', 52480, 'Индонезия', 'Принтер'),
(68, 'Canon MP830', 16739, 'Тайвань', 'Принтер'),
(69, 'Canon MultiPass F30 (MFP)', 55795, 'Тайвань', 'Принтер'),
(70, 'Dell 1100', 59983, 'Китай', 'Принтер'),
(71, 'Dell 940', 20167, 'Вьетнам', 'Принтер'),
(72, 'Dell A960', 22395, 'Россия', 'Принтер'),
(73, 'Dell P1500', 56844, 'Индонезия', 'Принтер'),
(74, 'Dell S2500', 39895, 'Вьетнам', 'Принтер'),
(75, 'Epson LQ570', 48500, 'Вьетнам', 'Принтер'),
(76, 'Epson LQ-590', 35996, 'Вьетнам', 'Принтер'),
(77, 'Epson Stylus C20UX', 25140, 'Китай', 'Принтер'),
(78, 'Epson Stylus C60', 28514, 'Тайвань', 'Принтер'),
(79, 'Espon EPL-5800L', 59413, 'Тайвань', 'Принтер'),
(80, 'HP Color LaserJet 2500', 33900, 'Россия', 'Принтер'),
(81, 'HP Color LaserJet CP6015n', 58089, 'Россия', 'Принтер'),
(82, 'HP DeskJet F380', 41683, 'Тайвань', 'Принтер'),
(83, 'HP DeskJet 2050A', 35439, 'Тайвань', 'Принтер'),
(84, 'HP LaserJet 1010', 58886, 'Тайвань', 'Принтер'),
(85, 'HP LaserJet P4515n', 23537, 'Индонезия', 'Принтер'),
(86, 'HP Officejet 3015', 24016, 'Китай', 'Принтер'),
(87, 'HP OfficeJet G85xi', 36258, 'Китай', 'Принтер'),
(88, 'HP Photosmart 1000', 37515, 'Китай', 'Принтер'),
(89, 'HP PhotoSmart P1000', 39273, 'Вьетнам', 'Принтер'),
(90, 'HP PSC 1110', 15632, 'Индонезия', 'Принтер'),
(91, 'HP PSC 1210', 24987, 'Китай', 'Принтер'),
(92, 'HP PSC 1300', 52668, 'Россия', 'Принтер'),
(93, 'HP PSC 7410', 51041, 'Вьетнам', 'Принтер'),
(94, 'HP PSC 750', 54232, 'Тайвань', 'Принтер'),
(95, 'Kyocera 3800', 20733, 'Россия', 'Принтер'),
(96, 'Kyocera FS-1000', 39957, 'Россия', 'Принтер'),
(97, 'Kyocera FS-600', 59626, 'Тайвань', 'Принтер'),
(98, 'Kyocera FS-6700', 44758, 'Вьетнам', 'Принтер'),
(99, 'Kyocera FS-680', 50922, 'Индонезия', 'Принтер'),
(100, 'Kyocera FS-7000', 40155, 'Тайвань', 'Принтер'),
(101, 'Lexmark 7000', 51017, 'Россия', 'Принтер'),
(102, 'Lexmark E232', 40606, 'Вьетнам', 'Принтер'),
(103, 'Lexmark Z53', 43690, 'Индонезия', 'Принтер'),
(104, 'Lexmark Z818', 26239, 'Вьетнам', 'Принтер'),
(105, 'OKIPAGE 8w Lite', 41262, 'Россия', 'Принтер'),
(106, 'Panasonic KX-MB1900', 18709, 'Тайвань', 'Принтер'),
(107, 'Samsung CLP-300', 36221, 'Китай', 'Принтер'),
(108, 'Samsung CLX-2160', 40734, 'Китай', 'Принтер'),
(109, 'Samsung SCX-4500W', 55352, 'Индонезия', 'Принтер'),
(110, 'Samsung SCX-4600', 59158, 'Россия', 'Принтер'),
(111, 'Xerox WorkCentre PE 220', 31853, 'Индонезия', 'Принтер'),
(112, 'Xerox Phaser 3117', 40538, 'Китай', 'Принтер'),
(113, 'Xerox Phaser 6010', 40964, 'Тайвань', 'Принтер'),
(114, 'Xerox WorkCentre 3045B', 20808, 'Вьетнам', 'Принтер');

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_group_permissi_permission_id_84c5c92e_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Ограничения внешнего ключа таблицы `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permissi_content_type_id_2f476e4b_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Ограничения внешнего ключа таблицы `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Ограничения внешнего ключа таблицы `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `auth_user_user_perm_permission_id_1fbb5f2c_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Ограничения внешнего ключа таблицы `Auto`
--
ALTER TABLE `Auto`
  ADD CONSTRAINT `Auto_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `Branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `BranchProduct`
--
ALTER TABLE `BranchProduct`
  ADD CONSTRAINT `BranchProduct_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `Branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `BranchProduct_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `django_admin__content_type_id_c4bce8eb_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Ограничения внешнего ключа таблицы `Driver`
--
ALTER TABLE `Driver`
  ADD CONSTRAINT `Driver_ibfk_1` FOREIGN KEY (`auto_id`) REFERENCES `Auto` (`auto_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Manager`
--
ALTER TABLE `Manager`
  ADD CONSTRAINT `Manager_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `Branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Manager_user_id_2b6e8814_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Ограничения внешнего ключа таблицы `OrderProduct`
--
ALTER TABLE `OrderProduct`
  ADD CONSTRAINT `OrderProduct_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `OrderTable` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `OrderProduct_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `OrderTable`
--
ALTER TABLE `OrderTable`
  ADD CONSTRAINT `OrderTable_auto_id_71532ba6_fk_Auto_auto_id` FOREIGN KEY (`auto_id`) REFERENCES `Auto` (`auto_id`),
  ADD CONSTRAINT `OrderTable_client_id_4e96595a_fk_Client_client_id` FOREIGN KEY (`client_id`) REFERENCES `Client` (`client_id`),
  ADD CONSTRAINT `OrderTable_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `Manager` (`manager_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `OrderTable_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `Branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
