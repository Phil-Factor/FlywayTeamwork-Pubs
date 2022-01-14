SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
PRINT N'Dropping extended properties';
GO
IF EXISTS
  (SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
     FROM
     sys.fn_listextendedproperty (
       N'MS_Description',
       'SCHEMA',
       N'dbo',
       'TABLE',
       N'discounts',
       'COLUMN',
       N'Discount_id') )
  EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE',
                               N'roysched', 'COLUMN', N'roysched_id';
IF EXISTS
  (SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
     FROM
     sys.fn_listextendedproperty (
       N'MS_Description',
       'SCHEMA',
       N'dbo',
       'TABLE',
       N'roysched',
       'COLUMN',
       N'roysched_id') )
  EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'dbo', 'TABLE',
                               N'roysched', 'COLUMN', N'roysched_id';

GO
PRINT N'Dropping foreign keys from [dbo].[sales]';
GO
IF Object_Id ('[FK_Sales_Stores]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK_Sales_Stores];
GO
IF Object_Id ('[FK_Sales_Title]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK_Sales_Title];
GO
PRINT N'Dropping constraints from [dbo].[discounts]';
GO

IF Object_Id ('PK_discounts') IS NOT NULL
  ALTER TABLE [dbo].[discounts] DROP CONSTRAINT [PK_discounts];
GO

PRINT N'Dropping constraints from [dbo].[roysched]';
GO
IF Object_Id ('[PK_roysched]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[roysched] DROP CONSTRAINT [PK_roysched];
GO
PRINT N'Dropping constraints from [dbo].[sales]';
GO
IF Object_Id ('[UPKCL_sales]') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [UPKCL_sales];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[DF__authors__phone__38996AB5]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [DF__authors__phone__38996AB5];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[DF__publisher__count__3D5E1FD2]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  DROP CONSTRAINT [DF__publisher__count__3D5E1FD2];
GO
PRINT N'Dropping constraints from [dbo].[titles]';
GO
IF Object_Id ('[DF__titles__type__403A8C7D]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [DF__titles__type__403A8C7D];
GO
PRINT N'Dropping index [aunmind] from [dbo].[authors]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[authors]') AND name = 'aunmind')
  DROP INDEX [aunmind] ON [dbo].[authors];
GO
PRINT N'Dropping index [titleind] from [dbo].[titles]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[titles]') AND name = 'titleind')
  DROP INDEX [titleind] ON [dbo].[titles];
GO
PRINT N'Dropping index [employee_ind] from [dbo].[employee]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[employee]') AND name = 'employee_ind')
  DROP INDEX [employee_ind] ON [dbo].[employee];
GO
PRINT N'Altering [dbo].[authors]';
GO
IF Col_Length ('[dbo].[authors]', 'au_lname') IS NOT NULL
  ALTER TABLE [dbo].[authors]
  ALTER COLUMN [au_lname] [VARCHAR](40) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[authors]', 'au_fname') IS NOT NULL
  ALTER TABLE [dbo].[authors]
  ALTER COLUMN [au_fname] [VARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[authors]', 'phone') IS NOT NULL
  ALTER TABLE [dbo].[authors]
  ALTER COLUMN [phone] [CHAR](12) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[authors]', 'address') IS NOT NULL
  ALTER TABLE [dbo].[authors]
  ALTER COLUMN [address] [VARCHAR](40) COLLATE Latin1_General_CI_AS NULL;
GO
IF Col_Length ('[dbo].[authors]', 'city') IS NOT NULL
  ALTER TABLE [dbo].[authors]
  ALTER COLUMN [city] [VARCHAR](20) COLLATE Latin1_General_CI_AS NULL;
GO
PRINT N'Adding constraints to [dbo].[authors]';
GO
IF Object_Id ('[DF__authors__phone__00551192]', 'D') IS NULL
  ALTER TABLE [dbo].[authors]
  ADD CONSTRAINT [DF__authors__phone__00551192]
      DEFAULT ('UNKNOWN') FOR [phone];
GO
PRINT N'Creating index [aunmind] on [dbo].[authors]';
GO
IF NOT EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[authors]') AND name = 'aunmind')
  CREATE NONCLUSTERED INDEX [aunmind]
    ON [dbo].[authors] ([au_lname], [au_fname]);
GO
PRINT N'Altering [dbo].[employee]';
GO
IF Col_Length ('[dbo].[employee]', 'fname') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  ALTER COLUMN [fname] [VARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[employee]', 'lname') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  ALTER COLUMN [lname] [VARCHAR](30) COLLATE Latin1_General_CI_AS NOT NULL;
GO
PRINT N'Creating index [employee_ind] on [dbo].[employee]';
GO
IF NOT EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[employee]') AND name = 'employee_ind')
  CREATE CLUSTERED INDEX [employee_ind]
    ON [dbo].[employee] ([lname], [fname], [minit]);
GO
PRINT N'Altering [dbo].[publishers]';
GO
IF Col_Length ('[dbo].[publishers]', 'pub_name') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  ALTER COLUMN [pub_name] [VARCHAR](40) COLLATE Latin1_General_CI_AS NULL;
GO
IF Col_Length ('[dbo].[publishers]', 'city') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  ALTER COLUMN [city] [VARCHAR](20) COLLATE Latin1_General_CI_AS NULL;
GO
IF Col_Length ('[dbo].[publishers]', 'country') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  ALTER COLUMN [country] [VARCHAR](30) COLLATE Latin1_General_CI_AS NULL;
GO
PRINT N'Adding constraints to [dbo].publishers]';
GO
IF Object_Id ('[DF__publisher__count__0519C6AF]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  ADD CONSTRAINT [DF__publisher__count__0519C6AF]
      DEFAULT ('USA') FOR [country];
GO
PRINT N'Altering [dbo].[titles]';
GO
IF Col_Length ('[dbo].[titles]', 'title') IS NOT NULL
  ALTER TABLE [dbo].[titles]
  ALTER COLUMN [title] [VARCHAR](80) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[titles]', 'type') IS NOT NULL
  ALTER TABLE [dbo].[titles]
  ALTER COLUMN [type] [CHAR](12) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[titles]', 'notes') IS NOT NULL
  ALTER TABLE [dbo].[titles]
  ALTER COLUMN [notes] [VARCHAR](200) COLLATE Latin1_General_CI_AS NULL;
GO
PRINT N'Adding constraints to [dbo].[titles]';
GO
IF Object_Id ('[DF__titles__type__07F6335A]', 'D') IS NULL
  ALTER TABLE [dbo].[titles]
  ADD CONSTRAINT [DF__titles__type__07F6335A]
      DEFAULT ('UNDECIDED') FOR [type];
GO
PRINT N'Creating index [titleind] on [dbo].[titles]';
GO
IF NOT EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[titles]') AND name = 'titleind')
  CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles] ([title]);
GO
PRINT N'Altering [dbo].[stores]';
GO
IF Col_Length ('[dbo].[stores]', 'stor_name') IS NOT NULL
  ALTER TABLE [dbo].[stores]
  ALTER COLUMN [stor_name] [VARCHAR](40) COLLATE Latin1_General_CI_AS NULL;
GO
IF Col_Length ('[dbo].[stores]', 'stor_address') IS NOT NULL
  ALTER TABLE [dbo].[stores]
  ALTER COLUMN [stor_address] [VARCHAR](40) COLLATE Latin1_General_CI_AS NULL;
GO
IF Col_Length ('[dbo].[stores]', 'city') IS NOT NULL
  ALTER TABLE [dbo].[stores]
  ALTER COLUMN [city] [VARCHAR](20) COLLATE Latin1_General_CI_AS NULL;
GO
PRINT N'Altering [dbo].[discounts]';
GO
ALTER TABLE [dbo].[discounts] DROP COLUMN [Discount_id];
GO
IF Col_Length ('[dbo].[discounts]', 'discounttype') IS NOT NULL
  ALTER TABLE [dbo].[discounts]
  ALTER COLUMN [discounttype] [VARCHAR](40) COLLATE Latin1_General_CI_AS NOT NULL;
GO
PRINT N'Altering [dbo].[pub_info]';
GO
IF Col_Length ('[dbo].[pub_info]', 'logo') IS NOT NULL
  ALTER TABLE [dbo].[pub_info] ALTER COLUMN [logo] [IMAGE] NULL;
GO
IF Col_Length ('[dbo].[pub_info]', 'pr_info') IS NOT NULL
  ALTER TABLE [dbo].[pub_info]
  ALTER COLUMN [pr_info] [TEXT] COLLATE Latin1_General_CI_AS NULL;
GO
PRINT N'Altering [dbo].[roysched]';
GO

IF ColumnProperty (Object_Id ('[dbo].[roysched]', 'U'), --the table
                   '[roysched_id]',                     --the column name
                   'Columnid') > 0
  ALTER TABLE [dbo].[roysched] DROP COLUMN [roysched_id];
GO
PRINT N'Altering [dbo].[sales]';
GO
IF Col_Length ('[dbo].[sales]', 'ord_num') IS NOT NULL
  ALTER TABLE [dbo].[sales]
  ALTER COLUMN [ord_num] [VARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL;
GO
IF Col_Length ('[dbo].[sales]', 'payterms') IS NOT NULL
  ALTER TABLE [dbo].[sales]
  ALTER COLUMN [payterms] [VARCHAR](12) COLLATE Latin1_General_CI_AS NOT NULL;
GO
PRINT N'Creating primary key [UPKCL_sales] on [dbo].[sales]';
GO
IF ObjectPropertyEx (Object_Id ('[dbo].[sales]', 'U'), 'TableHasPrimaryKey') = 0
  ALTER TABLE [dbo].[sales]
  ADD CONSTRAINT [UPKCL_sales]
    PRIMARY KEY CLUSTERED ([stor_id], [ord_num], [title_id]);
GO
PRINT N'Altering [dbo].[byroyalty]';
GO
IF Object_Id ('[dbo].[byroyalty]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[byroyalty]  AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE [dbo].[byroyalty] @percentage INT
AS
  SELECT au_id FROM titleauthor WHERE titleauthor.royaltyper = @percentage;
GO
PRINT N'Altering [dbo].[reptq1]';
GO
IF Object_Id ('[dbo].[reptq1]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[reptq1]  AS BEGIN SET NOCOUNT ON; END');
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
IF Object_Id ('[dbo].[reptq1]', 'P') IS NULL
  EXEC ('CREATE PROCEDURE [dbo].[reptq2]  AS BEGIN SET NOCOUNT ON; END');
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
  EXEC ('CREATE PROCEDURE [dbo].[reptq1]  AS BEGIN SET NOCOUNT ON; END');
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
PRINT N'Altering [dbo].[titleview]';
GO
IF Object_Id ('[dbo].[titleview]', 'V') IS NULL
  EXEC ('CREATE VIEW [dbo].[titleview]  AS BEGIN Select 1 END');
GO
ALTER VIEW [dbo].[titleview]
AS
  SELECT title, au_ord, au_lname, price, ytd_sales, pub_id
    FROM
    authors, titles, titleauthor
    WHERE
    authors.au_id = titleauthor.au_id
AND titles.title_id = titleauthor.title_id;
GO
PRINT N'Adding foreign keys to [dbo].[sales]';
GO
IF Object_Id ('[FK__sales__title_id__1367E606]', 'F') IS NULL
  ALTER TABLE [dbo].[sales]
  ADD CONSTRAINT [FK__sales__title_id__1367E606]
      FOREIGN KEY ([title_id])
      REFERENCES [dbo].[titles] ([title_id]);
GO

IF Object_Id ('[dbo].[employee_insupd]', 'TR') IS NULL
  EXEC ('ALTER CREATE  [dbo].[employee_insupd]  on on [dbo].[employee] AS  Select 1');
GO

PRINT N'Altering trigger [dbo].[employee_insupd] on [dbo].[employee]';
GO
ALTER TRIGGER [dbo].[employee_insupd]
ON [dbo].[employee]
FOR INSERT, UPDATE
AS
--Get the range of level for this job type from the jobs table.
DECLARE @min_lvl TINYINT, @max_lvl TINYINT, @emp_lvl TINYINT,
        @job_id SMALLINT;
SELECT @min_lvl = min_lvl, @max_lvl = max_lvl, @emp_lvl = i.job_lvl,
       @job_id = i.job_id
  FROM
  employee e, jobs j, inserted i
  WHERE
  e.emp_id = i.emp_id AND i.job_id = j.job_id;
IF (@job_id = 1) AND (@emp_lvl <> 10)
  BEGIN
    RAISERROR ('Job id 1 expects the default level of 10.', 16, 1);
    ROLLBACK TRANSACTION;
  END;
ELSE IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
       BEGIN
         RAISERROR (
           'The level for job_id:%d should be between %d and %d.',
           16,
           1,
           @job_id,
           @min_lvl,
           @max_lvl);
         ROLLBACK TRANSACTION;
       END;
GO
IF Object_Id ('[FK__sales__stor_id__1273C1CD]', 'F') IS NULL
  ALTER TABLE [dbo].[sales]
  ADD CONSTRAINT [FK__sales__stor_id__1273C1CD]
      FOREIGN KEY ([stor_id])
      REFERENCES [dbo].[stores] ([stor_id]);
GO
IF Object_Id ('DF__publisher__count__3D5E1FD2', 'D') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  DROP CONSTRAINT [DF__publisher__count__3D5E1FD2];
IF Object_Id ('[DF__publisher__count__0519C6AF', 'D') IS NULL
  ALTER TABLE [dbo].[publishers]
  ADD CONSTRAINT [DF__publisher__count__0519C6AF]
      DEFAULT ('USA') FOR [country];
IF Col_Length ('[dbo].[roysched]', 'Roysched_id') IS NOT NULL
  ALTER TABLE [dbo].[roysched] DROP COLUMN roysched_id;