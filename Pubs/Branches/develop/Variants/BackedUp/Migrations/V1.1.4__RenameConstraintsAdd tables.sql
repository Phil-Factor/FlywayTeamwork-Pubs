
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
PRINT N'Dropping foreign keys from [dbo].[discounts]'
GO
ALTER TABLE [dbo].[discounts] DROP CONSTRAINT [FK__discounts__stor___173876EA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] DROP CONSTRAINT [FK__employee__job_id__25869641]
GO
ALTER TABLE [dbo].[employee] DROP CONSTRAINT [FK__employee__pub_id__286302EC]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] DROP CONSTRAINT [FK__pub_info__pub_id__20C1E124]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [FK__titles__pub_id__08EA5793]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] DROP CONSTRAINT [FK__roysched__title___15502E78]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [FK__titleauth__au_id__0CBAE877]
GO
ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [FK__titleauth__title__0DAF0CB0]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] DROP CONSTRAINT [CK__authors__au_id__7F60ED59]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] DROP CONSTRAINT [CK__authors__zip__014935CB]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] DROP CONSTRAINT [DF__authors__phone__38996AB5]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [CK__jobs__max_lvl__1DE57479]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [CK__jobs__min_lvl__1CF15040]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [DF__jobs__job_desc__1BFD2C07]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [CK__publisher__pub_i__0425A276]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [UPKCL_pubind]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [DF__publisher__count__3D5E1FD2]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] DROP CONSTRAINT [UPKCL_pubinfo]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] DROP CONSTRAINT [DF__employee__job_id__24927208]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] DROP CONSTRAINT [DF__employee__job_lv__267ABA7A]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] DROP CONSTRAINT [DF__employee__pub_id__276EDEB3]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] DROP CONSTRAINT [DF__employee__hire_d__29572725]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [DF__titles__type__403A8C7D]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [DF__titles__pubdate__09DE7BCC]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping trigger [dbo].[employee_insupd] from [dbo].[employee]'
GO
DROP TRIGGER [dbo].[employee_insupd]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating types'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
CREATE TYPE [dbo].[Dollars] FROM numeric (9, 2) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[employee]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[employee] ALTER COLUMN [pub_id] [char] (8) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[publishers]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[publishers] ALTER COLUMN [pub_id] [char] (8) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [UPKCL_pubind] on [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED  ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[pub_info]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[pub_info] ALTER COLUMN [pub_id] [char] (8) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [UPKCL_pubinfo] on [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED  ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[titles]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[titles] ALTER COLUMN [pub_id] [char] (8) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[publications]'
GO
CREATE TABLE [dbo].[publications]
(
[Publication_id] [dbo].[tid] NOT NULL,
[title] [nvarchar] (255) NOT NULL,
[pub_id] [char] (8) NULL,
[notes] [nvarchar] (4000) NULL,
[pubdate] [datetime] NOT NULL CONSTRAINT [pub_NowDefault] DEFAULT (getdate())
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Publication] on [dbo].[publications]'
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [PK_Publication] PRIMARY KEY CLUSTERED  ([Publication_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[editions]'
GO
CREATE TABLE [dbo].[editions]
(
[Edition_id] [int] NOT NULL IDENTITY(1, 1),
[publication_id] [dbo].[tid] NOT NULL,
[Publication_type] [nvarchar] (20) NOT NULL DEFAULT ('book'),
[EditionDate] [datetime2] NOT NULL DEFAULT (getdate())
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_editions] on [dbo].[editions]'
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [PK_editions] PRIMARY KEY CLUSTERED  ([Edition_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[prices]'
GO
CREATE TABLE [dbo].[prices]
(
[Price_id] [int] NOT NULL IDENTITY(1, 1),
[Edition_id] [int] NULL,
[price] [dbo].[Dollars] NULL,
[advance] [dbo].[Dollars] NULL,
[royalty] [int] NULL,
[ytd_sales] [int] NULL,
[PriceStartDate] [datetime2] NOT NULL DEFAULT (getdate()),
[PriceEndDate] [datetime2] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Prices] on [dbo].[prices]'
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED  ([Price_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Refreshing [dbo].[titleview]'
GO
EXEC sp_refreshview N'[dbo].[titleview]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__au_id] CHECK (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__zip] CHECK (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__max_lvl] CHECK (([max_lvl]<=(250)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__min_lvl] CHECK (([min_lvl]>=(10)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [CK__publisher__pub_id] CHECK (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [AssumeUnknown] DEFAULT ('UNKNOWN') FOR [phone]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [AssumeJobIDof1] DEFAULT ((1)) FOR [job_id]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [AssumeJobLevelof10] DEFAULT ((10)) FOR [job_lvl]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [AssumeAPub_IDof9952] DEFAULT ('9952') FOR [pub_id]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [AssumeAewHire] DEFAULT (getdate()) FOR [hire_date]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [AssumeANewPosition] DEFAULT ('New Position - title not formalized yet') FOR [job_desc]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [AssumeItsTheSatates] DEFAULT ('USA') FOR [country]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [AssumeUndecided] DEFAULT ('UNDECIDED') FOR [type]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [AssumeItsPublishedToday] DEFAULT (getdate()) FOR [pubdate]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[discounts]'
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [FK__discounts__store] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[prices]'
GO
ALTER TABLE [dbo].[prices] ADD CONSTRAINT [fk_prices] FOREIGN KEY ([Edition_id]) REFERENCES [dbo].[editions] ([Edition_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[editions]'
GO
ALTER TABLE [dbo].[editions] ADD CONSTRAINT [fk_edition] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[publications] ([Publication_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__job_id] FOREIGN KEY ([job_id]) REFERENCES [dbo].[jobs] ([job_id])
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [FK__pub_info__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[publications]'
GO
ALTER TABLE [dbo].[publications] ADD CONSTRAINT [fkPublishers] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [FK__titles__pub_id] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [FK__roysched__title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__au_id] FOREIGN KEY ([au_id]) REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on TYPE:: [dbo].[empid]'
GO
REVOKE REFERENCES ON TYPE:: [dbo].[empid] TO [public]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on TYPE:: [dbo].[id]'
GO
REVOKE REFERENCES ON TYPE:: [dbo].[id] TO [public]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering permissions on TYPE:: [dbo].[tid]'
GO
REVOKE REFERENCES ON TYPE:: [dbo].[tid] TO [public]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

