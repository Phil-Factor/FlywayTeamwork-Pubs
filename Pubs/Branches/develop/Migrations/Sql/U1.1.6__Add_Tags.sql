SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
PRINT N'Dropping foreign keys from [dbo].[TagTitle]';
GO
IF Object_Id ('[fkTagname]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[TagTitle] DROP CONSTRAINT [fkTagname];
GO
IF Object_Id ('[FKTitle_id]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[TagTitle] DROP CONSTRAINT [FKTitle_id];
GO
PRINT N'Dropping foreign keys from [dbo].[roysched]';
GO
IF Object_Id ('[FK__roysched__title]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[roysched] DROP CONSTRAINT [FK__roysched__title];
GO
PRINT N'Dropping foreign keys from [dbo].[sales]';
GO
IF Object_Id ('[FK_Sales_Title]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK_Sales_Title];
GO
PRINT N'Dropping foreign keys from [dbo].[titleauthor]';
GO
IF Object_Id ('[FK__titleauth__title]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [FK__titleauth__title];
GO
PRINT N'Dropping constraints from [dbo].[TagName]';
GO
IF Object_Id ('[TagnameSurrogate]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[TagName] DROP CONSTRAINT [TagnameSurrogate];
GO
PRINT N'Dropping constraints from [dbo].[TagName]';
GO
IF Object_Id ('[Uniquetag]', 'UQ') IS NOT NULL
  ALTER TABLE [dbo].[TagName] DROP CONSTRAINT [Uniquetag];
GO
PRINT N'Dropping constraints from [dbo].[TagTitle]';
GO
IF Object_Id ('[PK_TagNameTitle]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[TagTitle] DROP CONSTRAINT [PK_TagNameTitle];
GO
PRINT N'Dropping constraints from [dbo].[TagTitle]';
GO
IF Object_Id ('[NotPrimary]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[TagTitle] DROP CONSTRAINT [NotPrimary];
GO
PRINT N'Dropping [dbo].[TitlesAndEditionsByPublisher]';
GO
IF Object_Id ('[dbo].[TitlesAndEditionsByPublisher]', 'V') IS NOT NULL
  DROP VIEW [dbo].[TitlesAndEditionsByPublisher];
GO
PRINT N'Dropping [dbo].[PublishersByPublicationType]';
GO
IF Object_Id ('[dbo].[PublishersByPublicationType]', 'V') IS NOT NULL
  DROP VIEW [dbo].[PublishersByPublicationType];
GO
PRINT N'Dropping [dbo].[titles]';
IF Object_Id ('[dbo].[titles]', 'V') IS NOT NULL
  SELECT title_id, title, type, pub_id, price, advance, royalty, ytd_sales,
         notes, pubdate
    INTO #TempTitles
    FROM dbo.titles;
GO

ALTER TABLE dbo.editions NOCHECK CONSTRAINT ALL
ALTER TABLE dbo.prices NOCHECK CONSTRAINT ALL
ALTER TABLE dbo.publications NOCHECK CONSTRAINT ALL

IF Object_Id ('dbo.publications', 'U') IS NOT NULL
	BEGIN
	ALTER TABLE dbo.publications NOCHECK CONSTRAINT ALL
	DELETE FROM dbo.publications;
	ALTER TABLE dbo.publications WITH CHECK CHECK CONSTRAINT ALL
	end

IF Object_Id ('dbo.editions', 'U') IS NOT NULL 
	BEGIN
	ALTER TABLE dbo.editions NOCHECK CONSTRAINT ALL
	DELETE FROM dbo.editions;
	ALTER TABLE dbo.editions WITH CHECK CHECK CONSTRAINT ALL
	end

IF Object_Id ('dbo.prices', 'U') IS NOT NULL
	BEGIN
	ALTER TABLE dbo.prices NOCHECK CONSTRAINT ALL
	DELETE FROM dbo.prices;
	ALTER TABLE dbo.prices WITH CHECK CHECK CONSTRAINT ALL
	end

IF Object_Id ('[dbo].[titles]', 'V') IS NOT NULL DROP VIEW [dbo].[titles];
GO
PRINT N'Dropping [dbo].[TagName]';
IF Object_Id ('[dbo].[TagName]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[TagName];
GO
PRINT N'Dropping [dbo].[TagTitle]';
GO
IF Object_Id ('[dbo].[TagTitle]', 'U') IS NOT NULL
  DROP TABLE [dbo].[TagTitle];
GO
PRINT N'Creating [dbo].[titles]';
GO
IF Object_Id ('[dbo].[titles]', 'U') IS NULL
  BEGIN
    CREATE TABLE [dbo].[titles]
      ([title_id] [dbo].[tid] NOT NULL,
       [title] [NVARCHAR](255) COLLATE Latin1_General_CI_AS NOT NULL,
       [type] [NVARCHAR](80) COLLATE Latin1_General_CI_AS NOT NULL
         CONSTRAINT [AssumeUndecided]
           DEFAULT ('UNDECIDED'),
       [pub_id] [CHAR](8) COLLATE Latin1_General_CI_AS NULL,
       [price] [MONEY] NULL,
       [advance] [MONEY] NULL,
       [royalty] [INT] NULL,
       [ytd_sales] [INT] NULL,
       [notes] [NVARCHAR](4000) COLLATE Latin1_General_CI_AS NULL,
       [pubdate] [DATETIME] NOT NULL
         CONSTRAINT [AssumeItsPublishedToday]
           DEFAULT (GetDate ()));
    INSERT INTO dbo.titles
      (title_id, title, type, pub_id, price, advance, royalty, ytd_sales,
       notes, pubdate)
      SELECT title_id, title, type, pub_id, price, advance, royalty,
             ytd_sales, notes, pubdate
        FROM #TempTitles;
  END;
GO
PRINT N'Creating primary key [UPKCL_titleidind] on [dbo].[titles]';
GO
ALTER TABLE [dbo].[titles]
ADD CONSTRAINT [UPKCL_titleidind]
  PRIMARY KEY CLUSTERED ([title_id]);
GO
PRINT N'Creating index [titleind] on [dbo].[titles]';
GO
IF (Object_Id ('[dbo].[titles]', 'U') IS NOT NULL
     AND IndexProperty (
           Object_Id ('[dbo].[titles]', 'U'), 'titleind', '[title]') IS NULL)
  CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles] ([title]);
GO
PRINT N'Altering [dbo].[byroyalty]';
GO
IF Object_Id ('[dbo].[byroyalty]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[byroyalty] AS SET NOCOUNT on');
GO
ALTER PROCEDURE [dbo].[byroyalty] @percentage INT
AS
  SELECT au_id FROM titleauthor WHERE titleauthor.royaltyper = @percentage;
GO
PRINT N'Altering [dbo].[reptq1]';
GO
IF Object_Id ('[dbo].[reptq1]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[reptq1] AS SET NOCOUNT on');
GO
ALTER PROCEDURE [dbo].[reptq1]
AS
  SELECT CASE WHEN Grouping (pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
         Avg (price) AS avg_price
    FROM titles
    WHERE price IS NOT NULL
    GROUP BY pub_id WITH ROLLUP
    ORDER BY pub_id;
GO
PRINT N'Altering [dbo].[reptq2]';
GO
IF Object_Id ('[dbo].[reptq2]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[reptq2] AS SET NOCOUNT on');
GO
ALTER PROCEDURE [dbo].[reptq2]
AS
  SELECT CASE WHEN Grouping (type) = 1 THEN 'ALL' ELSE type END AS type,
         CASE WHEN Grouping (pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
         Avg (ytd_sales) AS avg_ytd_sales
    FROM titles
    WHERE pub_id IS NOT NULL
    GROUP BY
    pub_id, type WITH ROLLUP;
GO
PRINT N'Altering [dbo].[reptq3]';
GO
IF Object_Id ('[dbo].[reptq3]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[reptq3] AS SET NOCOUNT on');
GO
ALTER PROCEDURE [dbo].[reptq3]
  @lolimit MONEY, @hilimit MONEY, @type CHAR(12)
AS
  SELECT CASE WHEN Grouping (pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
         CASE WHEN Grouping (type) = 1 THEN 'ALL' ELSE type END AS type,
         Count (title_id) AS cnt
    FROM titles
    WHERE
    price > @lolimit
AND price < @hilimit
AND type = @type
 OR type LIKE '%cook%'
    GROUP BY
    pub_id, type WITH ROLLUP;
GO
PRINT N'Refreshing [dbo].[titleview]';
GO
IF Object_Id ('dbo.titleview', 'V') IS NOT NULL
  EXEC sp_refreshview N'[dbo].[titleview]';
GO
PRINT N'Adding foreign keys to [dbo].[roysched]';
GO

IF Object_Id ('[dbo].[roysched]', 'U') IS NOT NULL
AND NOT EXISTS
  (SELECT *
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[dbo].[roysched]')
 AND parent_object_id = Object_Id (N'[dbo].[roysched] '))
  ALTER TABLE [dbo].[roysched]
  ADD CONSTRAINT [FK__roysched__title]
      FOREIGN KEY ([title_id])
      REFERENCES [dbo].[titles] ([title_id]);
GO
PRINT N'Adding foreign keys to [dbo].[sales]';
GO
IF Object_Id ('[dbo].[sales]', 'U') IS NOT NULL
AND NOT EXISTS
  (SELECT *
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id ('[FK_Sales_Title]')
 AND parent_object_id = Object_Id (N'[dbo].[sales]'))
  ALTER TABLE [dbo].[sales]
  ADD CONSTRAINT [FK_Sales_Title]
      FOREIGN KEY ([title_id])
      REFERENCES [dbo].[titles] ([title_id]);
GO
PRINT N'Adding foreign keys to [dbo].[titleauthor]';
GO
IF Object_Id ('[dbo].[titleauthor]', 'U') IS NOT NULL
AND NOT EXISTS
  (SELECT *
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id ('[FK__titleauth__title]')
 AND parent_object_id = Object_Id (N'[dbo].[titleauthor]'))
  ALTER TABLE [dbo].[titleauthor]
  ADD CONSTRAINT [FK__titleauth__title]
      FOREIGN KEY ([title_id])
      REFERENCES [dbo].[titles] ([title_id]);
GO
PRINT N'Adding foreign keys to [dbo].[titles]';
GO
IF Object_Id ('[dbo].[titles]', 'U') IS NOT NULL
AND NOT EXISTS
  (SELECT *
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id ('FK__titles__pub_id')
 AND parent_object_id = Object_Id (N'[dbo].[titles]'))
  ALTER TABLE [dbo].[titles]
  ADD CONSTRAINT [FK__titles__pub_id]
      FOREIGN KEY ([pub_id])
      REFERENCES [dbo].[publishers] ([pub_id]);
GO
