USE [master]
GO
/****** Object:  Database [MegaMinds]    Script Date: 3/6/2023 8:08:48 AM ******/
CREATE DATABASE [MegaMinds]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MegaMinds', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MegaMinds.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MegaMinds_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\MegaMinds_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MegaMinds] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MegaMinds].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MegaMinds] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MegaMinds] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MegaMinds] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MegaMinds] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MegaMinds] SET ARITHABORT OFF 
GO
ALTER DATABASE [MegaMinds] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MegaMinds] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MegaMinds] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MegaMinds] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MegaMinds] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MegaMinds] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MegaMinds] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MegaMinds] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MegaMinds] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MegaMinds] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MegaMinds] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MegaMinds] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MegaMinds] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MegaMinds] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MegaMinds] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MegaMinds] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MegaMinds] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MegaMinds] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MegaMinds] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MegaMinds] SET  MULTI_USER 
GO
ALTER DATABASE [MegaMinds] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MegaMinds] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MegaMinds] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MegaMinds] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [MegaMinds]
GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUser]
	@Id int 
AS
BEGIN
	UPDATE tblUserRegistration set IsDeleted=1 where Id=@Id
	
	IF (@@ERROR != 0)    
		BEGIN    
		select 0 as status,'something went wrong'  as Message 
		END    
	ELSE    
		BEGIN    
		select 1 as status,'Record deleted successfully' as Message 
		END

END


GO
/****** Object:  StoredProcedure [dbo].[GetCity]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCity]
	@StateId int 
AS
BEGIN
	SELECT Id
			,[City Name] as CityName
	 FROM tblcity
	 where [State Id]=ISNULL(@StateId,[State Id])
END


GO
/****** Object:  StoredProcedure [dbo].[GetState]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetState]
	@StateId int 
AS
BEGIN
	SELECT Id
			,[State Name] as StateName
	 FROM tblState
	 where [Id]=ISNULL(@StateId,[Id])
END


GO
/****** Object:  StoredProcedure [dbo].[GETUSERDEATILS]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GETUSERDEATILS]
	@Id int 
AS
BEGIN
	SELECT Id
			,Name
			,Email
			,Address
			,Phone
			,StateId
			,CityId
	 FROM tblUserRegistration	
	 WHERE Isdeleted=0
	 AND Id=ISNULL(@Id,Id)
END


GO
/****** Object:  StoredProcedure [dbo].[UserDataInsertUpdate]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    
 PROCEDURE [dbo].[UserDataInsertUpdate] (    
  @Id			INT
 ,@Name			VARCHAR(50)  
 ,@Email		VARCHAR(50)
 ,@Address		VARCHAR(50)
 ,@Phone		VARCHAR(20)
 ,@CityId		int
 ,@StateId		int
 ,@ReturnValue	INT OUT    
 )    
AS    

IF (@Id = 0) -- New Item                    
BEGIN       
		INSERT INTO [dbo].[tblUserRegistration]
			   ([Name]
			   ,[Email]
			   ,[Phone]
			   ,[Address]
			   ,[StateId]
			   ,[CityId]
			   ,[IsDeleted]
			   ,[CreatedDate]
			   )
		 VALUES
			   (@Name
			   ,@Email
			   ,@Phone
			   ,@Address
			   ,@StateId
			   ,@CityId
			   ,0
			   ,GETDATE())
	 SET @ReturnValue =SCOPE_IDENTITY()    
END    
ELSE    --UPDATE RECORD
BEGIN    
	
		UPDATE [dbo].[tblUserRegistration]
		   SET [Name] = @Name
			  ,[Email] = @Email
			  ,[Phone] = @Phone
			  ,[Address] = @Address
			  ,[StateId] =@StateId
			  ,[CityId] = @CityId
			  ,[LastModifiedDate] = GETDATE()
		 WHERE Id=@Id
		SET @ReturnValue =@Id   
END    
    
  IF (@@ERROR != 0)    
BEGIN    
	RETURN - 1    
END    
ELSE    
BEGIN    
	RETURN @ReturnValue  
END

GO
/****** Object:  Table [dbo].[tblCity]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[State Id] [int] NULL,
	[City Name] [varchar](50) NULL,
 CONSTRAINT [PK_tblCity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblState]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblState](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[State Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblState] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserRegistration]    Script Date: 3/6/2023 8:08:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserRegistration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Phone] [varchar](20) NULL,
	[Address] [varchar](100) NULL,
	[StateId] [int] NOT NULL,
	[CityId] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_tblUserRegistration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tblCity] ON 

INSERT [dbo].[tblCity] ([Id], [State Id], [City Name]) VALUES (1, 1, N'Surat')
INSERT [dbo].[tblCity] ([Id], [State Id], [City Name]) VALUES (2, 1, N'Bardoli')
INSERT [dbo].[tblCity] ([Id], [State Id], [City Name]) VALUES (3, 1, N'Baroda')
INSERT [dbo].[tblCity] ([Id], [State Id], [City Name]) VALUES (4, 2, N'Mumbai')
INSERT [dbo].[tblCity] ([Id], [State Id], [City Name]) VALUES (5, 2, N'Pune')
SET IDENTITY_INSERT [dbo].[tblCity] OFF
SET IDENTITY_INSERT [dbo].[tblState] ON 

INSERT [dbo].[tblState] ([Id], [State Name]) VALUES (1, N'Gujarat')
INSERT [dbo].[tblState] ([Id], [State Name]) VALUES (2, N'Maharashtra')
SET IDENTITY_INSERT [dbo].[tblState] OFF
SET IDENTITY_INSERT [dbo].[tblUserRegistration] ON 

INSERT [dbo].[tblUserRegistration] ([Id], [Name], [Email], [Phone], [Address], [StateId], [CityId], [IsDeleted], [CreatedDate], [LastModifiedDate]) VALUES (1, N'maulika', N'vasami192@gmail.com', N'9327238844', N'224,yogi chowk', 1, 1, 0, CAST(N'2023-03-05 19:51:34.290' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblUserRegistration] OFF
USE [master]
GO
ALTER DATABASE [MegaMinds] SET  READ_WRITE 
GO
