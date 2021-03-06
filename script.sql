USE [master]
GO
/****** Object:  Database [QuanLyQuanCafe]    Script Date: 10/12/2018 2:27:29 PM ******/
CREATE DATABASE [QuanLyQuanCafe]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanLyQuanCafe', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QuanLyQuanCafe.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QuanLyQuanCafe_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QuanLyQuanCafe_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QuanLyQuanCafe] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyQuanCafe].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyQuanCafe] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyQuanCafe] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyQuanCafe] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QuanLyQuanCafe] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyQuanCafe] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyQuanCafe] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLyQuanCafe] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QuanLyQuanCafe]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountByUserNameAndPassword]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountByUserNameAndPassword]
@username NVARCHAR(100),
@password NVARCHAR(1000)
AS
BEGIN
	SELECT username, fullname, password, type FROM dbo.Accounts WHERE @username = username AND @password = password
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetTableList]
AS SELECT id, name, status FROM dbo.TableFoods

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBillInfo]
@idBill INT, @idFood INT, @count INT
AS
BEGIN
	DECLARE @foodCount INT = 0

	SELECT @foodCount = b.count
	FROM dbo.BillInfos AS b
	WHERE b.idBills = @idBill AND b.idFoods = @idFood

	DECLARE @newFoodCount INT = @count + @foodCount

	IF (@foodCount > 0)
		IF (@newFoodCount > 0)
			UPDATE dbo.BillInfos SET count = @newFoodCount WHERE idFoods = @idFood
		ELSE 
			DELETE dbo.BillInfos WHERE idBills = @idBill AND idFoods = @idFood
	ELSE
		IF (@newFoodCount > 0)
			INSERT INTO dbo.BillInfos
					( idBills, idFoods, count )
			VALUES  ( @idBill, -- idBills - int
					  @idFood, -- idFoods - int
					  @newFoodCount  -- count - int
					  )
END

GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[USP_Login]
@username nvarchar(100),
@password nvarchar(1000)
AS
BEGIN
	SELECT username, password, fullname, type FROM dbo.Accounts WHERE @username = username AND @password = password
END

GO
/****** Object:  StoredProcedure [dbo].[USP_StatisticsList]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_StatisticsList]
@dateCheckIn date, @dateCheckOut date
AS
BEGIN 
	SELECT s.name, s.dateCheckIn, s.dateCheckOut, s.discount, s.totalPrice
	FROM dbo.Statistic AS s
	WHERE s.dateCheckIn >= @dateCheckIn AND s.dateCheckOut <= @dateCheckOut
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SwapTable]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SwapTable]
@idBills1 INT, @idBills2 INT
AS
BEGIN
	DECLARE @countRecordInBillInfo1 INT = 0
	DECLARE @countRecordInBillInfo2 INT = 0
	DECLARE @statusExist NVARCHAR(100) = N'Có người'
	DECLARE @statusNotExist NVARCHAR(100) = N'Trống'

	SELECT @countRecordInBillInfo1 = COUNT(idBills) FROM dbo.BillInfos WHERE idBills = @idBills1
	SELECT @countRecordInBillInfo2 = COUNT(idBills) FROM dbo.BillInfos WHERE idBills = @idBills2
	
	IF (@countRecordInBillInfo1 != 0 AND @countRecordInBillInfo2 != 0)
		BEGIN
			SELECT idBills, idFoods, count INTO dbo.Temp FROM dbo.BillInfos WHERE idBills = @idBills1
			DELETE dbo.BillInfos WHERE idBills = @idBills1
			
			UPDATE dbo.Temp SET idBills = @idBills2 WHERE idBills = @idBills1
			UPDATE dbo.BillInfos SET idBills = @idBills1 WHERE idBills = @idBills2

			INSERT INTO dbo.BillInfos
			        ( idBills, idFoods, count )
			SELECT idBills, idFoods, count FROM dbo.Temp WHERE idBills = @idBills2

			DROP TABLE dbo.Temp
        END

	IF (@countRecordInBillInfo1 != 0 AND @countRecordInBillInfo2 = 0)
		BEGIN
			SELECT idBills, idFoods, count INTO dbo.Temp FROM dbo.BillInfos WHERE idBills = @idBills1
			DELETE dbo.BillInfos WHERE idBills = @idBills1
			
			UPDATE dbo.Temp SET idBills = @idBills2 WHERE idBills = @idBills1
			UPDATE dbo.BillInfos SET idBills = @idBills1 WHERE idBills = @idBills2

			UPDATE dbo.TableFoods SET status = @statusExist WHERE id = @idBills1

			INSERT INTO dbo.BillInfos
			        ( idBills, idFoods, count )
			SELECT idBills, idFoods, count FROM dbo.Temp WHERE idBills = @idBills2
			DROP TABLE dbo.Temp

			UPDATE dbo.TableFoods SET status = @statusNotExist WHERE id = @idBills2
        END

	 IF (@countRecordInBillInfo1 = 0 AND @countRecordInBillInfo2 != 0)
		BEGIN
			SELECT idBills, idFoods, count INTO dbo.Temp FROM dbo.BillInfos WHERE idBills = @idBills1
			DELETE dbo.BillInfos WHERE idBills = @idBills1
			
			UPDATE dbo.Temp SET idBills = @idBills2 WHERE idBills = @idBills1
			UPDATE dbo.BillInfos SET idBills = @idBills1 WHERE idBills = @idBills2

			UPDATE dbo.TableFoods SET status = @statusNotExist WHERE id = @idBills2

			INSERT INTO dbo.BillInfos
			        ( idBills, idFoods, count )
			SELECT idBills, idFoods, count FROM dbo.Temp WHERE idBills = @idBills2

			
			UPDATE dbo.TableFoods SET status = @statusExist	WHERE id = @idBills1
			DROP TABLE dbo.Temp
        END
END

GO
/****** Object:  UserDefinedFunction [dbo].[fuConvertToUnsign1]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) 
RETURNS NVARCHAR(4000)
AS BEGIN IF @strInput IS NULL 
RETURN @strInput 
	IF @strInput = '' 
RETURN @strInput 
DECLARE @RT NVARCHAR(4000) 
DECLARE @SIGN_CHARS NCHAR(136) 
DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END

GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[username] [nvarchar](100) NOT NULL,
	[fullname] [nvarchar](100) NOT NULL,
	[password] [nvarchar](1000) NOT NULL,
	[type] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BillInfos]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBills] [int] NULL,
	[idFoods] [int] NULL,
	[count] [int] NULL,
 CONSTRAINT [PK__BillInfo__3213E83FEF627741] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bills]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bills](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dateCheckIn] [date] NOT NULL,
	[dateCheckOut] [date] NULL,
	[idTableFoods] [int] NOT NULL,
	[status] [int] NOT NULL,
	[discount] [int] NULL,
	[totalPrice] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[id] [nvarchar](100) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK__FoodCate__3213E83F8FACD11F] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Foods]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Foods](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[idFoodCategory] [nvarchar](100) NOT NULL,
	[price] [float] NOT NULL,
 CONSTRAINT [PK__Foods__3213E83F3B662C43] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Statistic]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistic](
	[name] [nvarchar](100) NOT NULL,
	[dateCheckIn] [date] NULL,
	[dateCheckOut] [date] NULL,
	[discount] [int] NULL,
	[totalPrice] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TableFoods]    Script Date: 10/12/2018 2:27:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFoods](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NULL,
	[status] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Accounts] ([username], [fullname], [password], [type]) VALUES (N'nhatminh', N'Nhật Minh', N'1', 2)
INSERT [dbo].[Accounts] ([username], [fullname], [password], [type]) VALUES (N'trangle', N'Lê Thị Thùy Trang', N'1', 1)
SET IDENTITY_INSERT [dbo].[Bills] ON 

INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (1, CAST(0x0D3F0B00 AS Date), CAST(0x0D3F0B00 AS Date), 1, 1, 0, 91000)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (2, CAST(0x093F0B00 AS Date), NULL, 2, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (3, CAST(0x0B3F0B00 AS Date), CAST(0x0B3F0B00 AS Date), 3, 1, 0, 51000)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (4, CAST(0x093F0B00 AS Date), NULL, 4, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (5, CAST(0x093F0B00 AS Date), NULL, 5, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (6, CAST(0x093F0B00 AS Date), NULL, 6, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (7, CAST(0x093F0B00 AS Date), NULL, 7, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (8, CAST(0x093F0B00 AS Date), NULL, 8, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (9, CAST(0x0D3F0B00 AS Date), CAST(0x0D3F0B00 AS Date), 9, 1, 0, 35000)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (10, CAST(0x093F0B00 AS Date), NULL, 10, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (11, CAST(0x093F0B00 AS Date), NULL, 11, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (12, CAST(0x093F0B00 AS Date), NULL, 12, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (13, CAST(0x093F0B00 AS Date), NULL, 13, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (14, CAST(0x093F0B00 AS Date), NULL, 14, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (15, CAST(0x093F0B00 AS Date), NULL, 15, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (16, CAST(0x093F0B00 AS Date), NULL, 16, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (17, CAST(0x093F0B00 AS Date), NULL, 17, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (18, CAST(0x093F0B00 AS Date), NULL, 18, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (19, CAST(0x093F0B00 AS Date), NULL, 19, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (20, CAST(0x093F0B00 AS Date), NULL, 20, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (21, CAST(0x093F0B00 AS Date), NULL, 21, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (22, CAST(0x093F0B00 AS Date), NULL, 22, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (23, CAST(0x093F0B00 AS Date), NULL, 23, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (24, CAST(0x093F0B00 AS Date), NULL, 24, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (25, CAST(0x093F0B00 AS Date), NULL, 25, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (26, CAST(0x093F0B00 AS Date), NULL, 26, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (27, CAST(0x093F0B00 AS Date), NULL, 27, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (28, CAST(0x093F0B00 AS Date), NULL, 28, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (29, CAST(0x093F0B00 AS Date), NULL, 29, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (30, CAST(0x093F0B00 AS Date), NULL, 30, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (31, CAST(0x093F0B00 AS Date), NULL, 31, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (32, CAST(0x093F0B00 AS Date), NULL, 32, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (33, CAST(0x093F0B00 AS Date), NULL, 33, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (34, CAST(0x093F0B00 AS Date), NULL, 34, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (35, CAST(0x093F0B00 AS Date), NULL, 35, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (36, CAST(0x093F0B00 AS Date), NULL, 36, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (37, CAST(0x093F0B00 AS Date), NULL, 37, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (38, CAST(0x093F0B00 AS Date), NULL, 38, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (39, CAST(0x093F0B00 AS Date), NULL, 39, 0, 0, NULL)
INSERT [dbo].[Bills] ([id], [dateCheckIn], [dateCheckOut], [idTableFoods], [status], [discount], [totalPrice]) VALUES (40, CAST(0x093F0B00 AS Date), NULL, 40, 0, 0, NULL)
SET IDENTITY_INSERT [dbo].[Bills] OFF
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (N'B', N'Bánh')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (N'D', N'Đông lạnh')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (N'N', N'Nước giải khát')
SET IDENTITY_INSERT [dbo].[Foods] ON 

INSERT [dbo].[Foods] ([id], [name], [idFoodCategory], [price]) VALUES (1, N'Cocacola', N'N', 10000)
INSERT [dbo].[Foods] ([id], [name], [idFoodCategory], [price]) VALUES (2, N'Pepsi', N'N', 10000)
INSERT [dbo].[Foods] ([id], [name], [idFoodCategory], [price]) VALUES (6, N'Trà xanh không độ Vị Chanh', N'N', 12000)
INSERT [dbo].[Foods] ([id], [name], [idFoodCategory], [price]) VALUES (7, N'Sửa chua', N'D', 3000)
INSERT [dbo].[Foods] ([id], [name], [idFoodCategory], [price]) VALUES (8, N'Oishi', N'B', 6000)
SET IDENTITY_INSERT [dbo].[Foods] OFF
INSERT [dbo].[Statistic] ([name], [dateCheckIn], [dateCheckOut], [discount], [totalPrice]) VALUES (N'Bàn 01', CAST(0x0B3F0B00 AS Date), CAST(0x0B3F0B00 AS Date), 15, 17000)
INSERT [dbo].[Statistic] ([name], [dateCheckIn], [dateCheckOut], [discount], [totalPrice]) VALUES (N'Bàn 01', CAST(0x0B3F0B00 AS Date), CAST(0x0B3F0B00 AS Date), 0, 28000)
INSERT [dbo].[Statistic] ([name], [dateCheckIn], [dateCheckOut], [discount], [totalPrice]) VALUES (N'Bàn 03', CAST(0x0B3F0B00 AS Date), CAST(0x0B3F0B00 AS Date), 0, 51000)
INSERT [dbo].[Statistic] ([name], [dateCheckIn], [dateCheckOut], [discount], [totalPrice]) VALUES (N'Bàn 09', CAST(0x0D3F0B00 AS Date), CAST(0x0D3F0B00 AS Date), 0, 35000)
INSERT [dbo].[Statistic] ([name], [dateCheckIn], [dateCheckOut], [discount], [totalPrice]) VALUES (N'Bàn 01', CAST(0x0D3F0B00 AS Date), CAST(0x0D3F0B00 AS Date), 0, 91000)
INSERT [dbo].[Statistic] ([name], [dateCheckIn], [dateCheckOut], [discount], [totalPrice]) VALUES (N'Bàn 01', CAST(0x0B3F0B00 AS Date), CAST(0x0B3F0B00 AS Date), 15, 102000)
SET IDENTITY_INSERT [dbo].[TableFoods] ON 

INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (1, N'Bàn 01', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (2, N'Bàn 02', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (3, N'Bàn 03', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (4, N'Bàn 04', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (5, N'Bàn 05', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (6, N'Bàn 06', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (7, N'Bàn 07', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (8, N'Bàn 08', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (9, N'Bàn 09', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (10, N'Bàn 10', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (11, N'Bàn 11', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (12, N'Bàn 12', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (13, N'Bàn 13', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (14, N'Bàn 14', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (15, N'Bàn 15', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (16, N'Bàn 16', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (17, N'Bàn 17', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (18, N'Bàn 18', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (19, N'Bàn 19', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (20, N'Bàn 20', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (21, N'Bàn 21', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (22, N'Bàn 22', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (23, N'Bàn 23', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (24, N'Bàn 24', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (25, N'Bàn 25', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (26, N'Bàn 26', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (27, N'Bàn 27', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (28, N'Bàn 28', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (29, N'Bàn 29', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (30, N'Bàn 30', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (31, N'Bàn 31', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (32, N'Bàn 32', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (33, N'Bàn 33', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (34, N'Bàn 34', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (35, N'Bàn 35', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (36, N'Bàn 36', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (37, N'Bàn 37', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (38, N'Bàn 38', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (39, N'Bàn 39', N'Trống')
INSERT [dbo].[TableFoods] ([id], [name], [status]) VALUES (40, N'Bàn 40', N'Trống')
SET IDENTITY_INSERT [dbo].[TableFoods] OFF
ALTER TABLE [dbo].[Accounts] ADD  DEFAULT (N'Trang Lê') FOR [fullname]
GO
ALTER TABLE [dbo].[Accounts] ADD  DEFAULT ((0)) FOR [type]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT (getdate()) FOR [dateCheckIn]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  CONSTRAINT [DF__FoodCatego__name__625A9A57]  DEFAULT (N'Chưa đặt tên') FOR [name]
GO
ALTER TABLE [dbo].[Foods] ADD  CONSTRAINT [DF__Foods__name__65370702]  DEFAULT (N'Chưa đặt tên') FOR [name]
GO
ALTER TABLE [dbo].[Foods] ADD  CONSTRAINT [DF__Foods__price__662B2B3B]  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[TableFoods] ADD  DEFAULT (N'Bàn chưa có tên') FOR [name]
GO
ALTER TABLE [dbo].[TableFoods] ADD  DEFAULT (N'Trống') FOR [status]
GO
ALTER TABLE [dbo].[BillInfos]  WITH CHECK ADD  CONSTRAINT [FK_BillInfos_Bills] FOREIGN KEY([idBills])
REFERENCES [dbo].[Bills] ([id])
GO
ALTER TABLE [dbo].[BillInfos] CHECK CONSTRAINT [FK_BillInfos_Bills]
GO
ALTER TABLE [dbo].[BillInfos]  WITH CHECK ADD  CONSTRAINT [FK_BillInfos_Foods] FOREIGN KEY([idFoods])
REFERENCES [dbo].[Foods] ([id])
GO
ALTER TABLE [dbo].[BillInfos] CHECK CONSTRAINT [FK_BillInfos_Foods]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_TableFoods] FOREIGN KEY([idTableFoods])
REFERENCES [dbo].[TableFoods] ([id])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_TableFoods]
GO
ALTER TABLE [dbo].[Foods]  WITH CHECK ADD  CONSTRAINT [FK__Foods__price__671F4F74] FOREIGN KEY([idFoodCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
ALTER TABLE [dbo].[Foods] CHECK CONSTRAINT [FK__Foods__price__671F4F74]
GO
USE [master]
GO
ALTER DATABASE [QuanLyQuanCafe] SET  READ_WRITE 
GO
