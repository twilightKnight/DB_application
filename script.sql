USE [master]
GO
/****** Object:  Database [storage]    Script Date: 21.02.2022 16:27:59 ******/
CREATE DATABASE [storage]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'storage', FILENAME = N'D:\MS SQL\MSSQL15.SQLEXPRESS01\MSSQL\DATA\storage.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'storage_log', FILENAME = N'D:\MS SQL\MSSQL15.SQLEXPRESS01\MSSQL\DATA\storage_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [storage] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [storage].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [storage] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [storage] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [storage] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [storage] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [storage] SET ARITHABORT OFF 
GO
ALTER DATABASE [storage] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [storage] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [storage] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [storage] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [storage] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [storage] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [storage] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [storage] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [storage] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [storage] SET  ENABLE_BROKER 
GO
ALTER DATABASE [storage] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [storage] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [storage] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [storage] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [storage] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [storage] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [storage] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [storage] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [storage] SET  MULTI_USER 
GO
ALTER DATABASE [storage] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [storage] SET DB_CHAINING OFF 
GO
ALTER DATABASE [storage] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [storage] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [storage] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [storage] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [storage] SET QUERY_STORE = OFF
GO
USE [storage]
GO
/****** Object:  User [user1]    Script Date: 21.02.2022 16:28:00 ******/
CREATE USER [user1] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [testuser]    Script Date: 21.02.2022 16:28:00 ******/
CREATE USER [testuser] FOR LOGIN [testuser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Водители_экспедиторы]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Водители_экспедиторы](
	[id_сотрудника] [int] IDENTITY(1,1) NOT NULL,
	[Фамилия] [varchar](20) NULL,
	[Имя] [varchar](20) NULL,
	[Отчество] [varchar](20) NULL,
	[Номер_телефона] [varchar](20) NULL,
 CONSTRAINT [PK__Employee__285BF3F7B42307EF] PRIMARY KEY CLUSTERED 
(
	[id_сотрудника] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Габариты]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Габариты](
	[id_габарита] [int] IDENTITY(1,1) NOT NULL,
	[Ширина] [int] NULL,
	[Высота] [int] NULL,
	[Длина] [int] NULL,
 CONSTRAINT [PK__Dimentio__354061A758ADB36A] PRIMARY KEY CLUSTERED 
(
	[id_габарита] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Договора]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Договора](
	[id_договора] [int] IDENTITY(1,1) NOT NULL,
	[Название_фирмы] [varchar](20) NULL,
	[Тип_организации] [varchar](20) NULL,
	[Дата_завершения_договора] [date] NULL,
	[Дата_создания_договора] [date] NULL,
 CONSTRAINT [PK__Supplier__BE29EAA7F65FA5ED] PRIMARY KEY CLUSTERED 
(
	[id_договора] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Комплекты]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Комплекты](
	[id_комплекта] [int] IDENTITY(1,1) NOT NULL,
	[id_накладной] [int] NULL,
	[Дата_создания] [date] NULL,
 CONSTRAINT [PK__Kit__547BB9ED72ECBD92] PRIMARY KEY CLUSTERED 
(
	[id_комплекта] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Коробки]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Коробки](
	[id_коробки] [int] IDENTITY(1,1) NOT NULL,
	[id_габаритов] [int] NULL,
	[id_ТТН] [int] NULL,
	[id_места] [int] NULL,
	[id_типа_продукта] [int] NULL,
	[Срок_годности] [date] NULL,
	[Дата_утилизации] [date] NULL,
 CONSTRAINT [PK__Box__29D5A6B167F43A6A] PRIMARY KEY CLUSTERED 
(
	[id_коробки] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Местоположения]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Местоположения](
	[id_места] [int] IDENTITY(1,1) NOT NULL,
	[Стеллаж] [int] NULL,
	[Крыло] [varchar](2) NULL,
	[Полка] [int] NULL,
	[id_габарита] [int] NULL,
	[id_Условия_хранения] [int] NOT NULL,
 CONSTRAINT [PK__Place__04D478F4E03E2D97] PRIMARY KEY CLUSTERED 
(
	[id_места] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Накладные_на_отпуск]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Накладные_на_отпуск](
	[id_накладной] [int] IDENTITY(1,1) NOT NULL,
	[Дата_отгрузки] [date] NULL,
	[id_сотрудника] [int] NULL,
 CONSTRAINT [PK__Limits__CF36A3F626D160FF] PRIMARY KEY CLUSTERED 
(
	[id_накладной] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Типы_продуктов]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Типы_продуктов](
	[id_типа_продукта] [int] IDENTITY(1,1) NOT NULL,
	[id_Условия_хранения] [int] NULL,
	[Название] [varchar](100) NULL,
 CONSTRAINT [PK__Product___4C17E1CD23AEC8D8] PRIMARY KEY CLUSTERED 
(
	[id_типа_продукта] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Товары]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Товары](
	[id_товара] [int] IDENTITY(1,1) NOT NULL,
	[id_комплекта] [int] NULL,
	[id_коробки] [int] NULL,
 CONSTRAINT [PK__Goods__A75ABBB91A2215D7] PRIMARY KEY CLUSTERED 
(
	[id_товара] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ТТН]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ТТН](
	[id_ТТН] [int] IDENTITY(1,1) NOT NULL,
	[Дата_отпуска_ТТН] [date] NULL,
	[id_договора] [int] NULL,
 CONSTRAINT [PK__Waybills__593102C0D5E015FB] PRIMARY KEY CLUSTERED 
(
	[id_ТТН] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Условия_хранения]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Условия_хранения](
	[id_Условия_хранения] [int] IDENTITY(1,1) NOT NULL,
	[Описание] [varchar](100) NULL,
 CONSTRAINT [PK_Условия_хранения] PRIMARY KEY CLUSTERED 
(
	[id_Условия_хранения] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Комплекты]  WITH CHECK ADD  CONSTRAINT [FK__Kit__Id_limit__3E52440B] FOREIGN KEY([id_накладной])
REFERENCES [dbo].[Накладные_на_отпуск] ([id_накладной])
GO
ALTER TABLE [dbo].[Комплекты] CHECK CONSTRAINT [FK__Kit__Id_limit__3E52440B]
GO
ALTER TABLE [dbo].[Коробки]  WITH CHECK ADD  CONSTRAINT [FK__Box__Id_dimentio__37A5467C] FOREIGN KEY([id_габаритов])
REFERENCES [dbo].[Габариты] ([id_габарита])
GO
ALTER TABLE [dbo].[Коробки] CHECK CONSTRAINT [FK__Box__Id_dimentio__37A5467C]
GO
ALTER TABLE [dbo].[Коробки]  WITH CHECK ADD  CONSTRAINT [FK__Box__id_place__3A81B327] FOREIGN KEY([id_места])
REFERENCES [dbo].[Местоположения] ([id_места])
GO
ALTER TABLE [dbo].[Коробки] CHECK CONSTRAINT [FK__Box__id_place__3A81B327]
GO
ALTER TABLE [dbo].[Коробки]  WITH CHECK ADD  CONSTRAINT [FK__Box__Id_product___3B75D760] FOREIGN KEY([id_типа_продукта])
REFERENCES [dbo].[Типы_продуктов] ([id_типа_продукта])
GO
ALTER TABLE [dbo].[Коробки] CHECK CONSTRAINT [FK__Box__Id_product___3B75D760]
GO
ALTER TABLE [dbo].[Коробки]  WITH CHECK ADD  CONSTRAINT [FK__Box__Id_waybill__398D8EEE] FOREIGN KEY([id_ТТН])
REFERENCES [dbo].[ТТН] ([id_ТТН])
GO
ALTER TABLE [dbo].[Коробки] CHECK CONSTRAINT [FK__Box__Id_waybill__398D8EEE]
GO
ALTER TABLE [dbo].[Местоположения]  WITH CHECK ADD  CONSTRAINT [FK__Place__Id_diment__403A8C7D] FOREIGN KEY([id_габарита])
REFERENCES [dbo].[Габариты] ([id_габарита])
GO
ALTER TABLE [dbo].[Местоположения] CHECK CONSTRAINT [FK__Place__Id_diment__403A8C7D]
GO
ALTER TABLE [dbo].[Местоположения]  WITH CHECK ADD  CONSTRAINT [FK_Местоположения_Условия_хранения] FOREIGN KEY([id_Условия_хранения])
REFERENCES [dbo].[Условия_хранения] ([id_Условия_хранения])
GO
ALTER TABLE [dbo].[Местоположения] CHECK CONSTRAINT [FK_Местоположения_Условия_хранения]
GO
ALTER TABLE [dbo].[Накладные_на_отпуск]  WITH CHECK ADD  CONSTRAINT [FK__Limits__Id_emplo__3F466844] FOREIGN KEY([id_сотрудника])
REFERENCES [dbo].[Водители_экспедиторы] ([id_сотрудника])
GO
ALTER TABLE [dbo].[Накладные_на_отпуск] CHECK CONSTRAINT [FK__Limits__Id_emplo__3F466844]
GO
ALTER TABLE [dbo].[Типы_продуктов]  WITH CHECK ADD  CONSTRAINT [FK_Типы_продуктов_Условия_хранения] FOREIGN KEY([id_Условия_хранения])
REFERENCES [dbo].[Условия_хранения] ([id_Условия_хранения])
GO
ALTER TABLE [dbo].[Типы_продуктов] CHECK CONSTRAINT [FK_Типы_продуктов_Условия_хранения]
GO
ALTER TABLE [dbo].[Товары]  WITH CHECK ADD  CONSTRAINT [FK__Goods__Id_box__3D5E1FD2] FOREIGN KEY([id_коробки])
REFERENCES [dbo].[Коробки] ([id_коробки])
GO
ALTER TABLE [dbo].[Товары] CHECK CONSTRAINT [FK__Goods__Id_box__3D5E1FD2]
GO
ALTER TABLE [dbo].[Товары]  WITH CHECK ADD  CONSTRAINT [FK__Goods__Id_kit__3C69FB99] FOREIGN KEY([id_комплекта])
REFERENCES [dbo].[Комплекты] ([id_комплекта])
GO
ALTER TABLE [dbo].[Товары] CHECK CONSTRAINT [FK__Goods__Id_kit__3C69FB99]
GO
ALTER TABLE [dbo].[ТТН]  WITH CHECK ADD  CONSTRAINT [FK__Waybills__Id_sup__412EB0B6] FOREIGN KEY([id_договора])
REFERENCES [dbo].[Договора] ([id_договора])
GO
ALTER TABLE [dbo].[ТТН] CHECK CONSTRAINT [FK__Waybills__Id_sup__412EB0B6]
GO
/****** Object:  StoredProcedure [dbo].[CheckExpired]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[CheckExpired] as
begin
	update Коробки set Дата_утилизации = GETDATE() where Срок_годности < getdate()
end
GO
/****** Object:  StoredProcedure [dbo].[insertProducts]    Script Date: 21.02.2022 16:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[insertProducts] (@amount int, @box_id int)
as
begin
	declare @i int
	set @i = 0
	while @i < @amount
	begin
		insert into dbo.Товары (Id_комплекта, Id_коробки) values (null, @box_id)
		set @i = @i + 1
	end
end
GO
USE [master]
GO
ALTER DATABASE [storage] SET  READ_WRITE 
GO
