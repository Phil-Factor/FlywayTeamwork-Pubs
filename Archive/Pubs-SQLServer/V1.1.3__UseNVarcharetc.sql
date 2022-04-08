/* change to NVARCHARs, and named constraints */ 
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
PRINT N'Dropping foreign keys from [dbo].[sales]'
SELECT * FROM sys.objects WHERE name LIKE 'FK__sales%'
GO
ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK__sales__stor_id__1273C1CD]
GO
ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK__sales__title_id__1367E606]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] DROP CONSTRAINT [UPKCL_sales]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] DROP CONSTRAINT [DF__authors__phone__00551192]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [DF__publisher__count__0519C6AF]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] DROP CONSTRAINT [DF__titles__type__07F6335A]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [aunmind] from [dbo].[authors]'
GO
DROP INDEX [aunmind] ON [dbo].[authors]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [titleind] from [dbo].[titles]'
GO
DROP INDEX [titleind] ON [dbo].[titles]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [employee_ind] from [dbo].[employee]'
GO
DROP INDEX [employee_ind] ON [dbo].[employee]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[stores]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[stores] ALTER COLUMN [stor_name] [nvarchar] (80) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[stores] ALTER COLUMN [stor_address] [nvarchar] (80) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[stores] ALTER COLUMN [city] [nvarchar] (40) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[discounts]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[discounts] ADD
[Discount_id] [int] NOT NULL IDENTITY(1, 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[discounts] ALTER COLUMN [discounttype] [nvarchar] (80) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__discount__63D7679C0CEEA6FF] on [dbo].[discounts]'
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT PK_Discounts PRIMARY KEY CLUSTERED  ([Discount_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[employee]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[employee] ALTER COLUMN [fname] [nvarchar] (40) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[employee] ALTER COLUMN [lname] [nvarchar] (60) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [employee_ind] on [dbo].[employee]'
GO
CREATE CLUSTERED INDEX [employee_ind] ON [dbo].[employee] ([lname], [fname], [minit])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[publishers]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[publishers] ALTER COLUMN [pub_name] [nvarchar] (100) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[publishers] ALTER COLUMN [city] [nvarchar] (100) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[publishers] ALTER COLUMN [country] [nvarchar] (80) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[pub_info]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[pub_info] ALTER COLUMN [logo] [varbinary] (max) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[pub_info] ALTER COLUMN [pr_info] [nvarchar] (max) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[titles]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[titles] ALTER COLUMN [title] [nvarchar] (255) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[titles] ALTER COLUMN [type] [nvarchar] (80) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[titles] ALTER COLUMN [notes] [nvarchar] (4000) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [titleind] on [dbo].[titles]'
GO
CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles] ([title])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[roysched]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[roysched] ADD
[roysched_id] [int] NOT NULL IDENTITY(1, 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__roysched__87691CF8BD660B81] on [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT PK_Roysched PRIMARY KEY CLUSTERED  ([roysched_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[sales]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[sales] ALTER COLUMN [ord_num] [nvarchar] (40) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[sales] ALTER COLUMN [payterms] [nvarchar] (40) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [UPKCL_sales] on [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED  ([stor_id], [ord_num], [title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[authors]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[authors] ALTER COLUMN [au_lname] [nvarchar] (80) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[authors] ALTER COLUMN [au_fname] [nvarchar] (80) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[authors] ALTER COLUMN [phone] [nvarchar] (40) NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[authors] ALTER COLUMN [address] [nvarchar] (80) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[authors] ALTER COLUMN [city] [nvarchar] (40) NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [aunmind] on [dbo].[authors]'
GO
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors] ([au_lname], [au_fname])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[titleview]'
GO

ALTER VIEW [dbo].[titleview]
AS
SELECT title, au_ord, au_lname, price, ytd_sales, pub_id
  FROM authors, titles, titleauthor
  WHERE authors.au_id = titleauthor.au_id
    AND titles.title_id = titleauthor.title_id;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[byroyalty]'
GO

ALTER PROCEDURE [dbo].[byroyalty] @percentage INT
AS
SELECT au_id FROM titleauthor WHERE titleauthor.royaltyper = @percentage;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[reptq1]'
GO

ALTER PROCEDURE [dbo].[reptq1]
AS
SELECT CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  Avg(price) AS avg_price
  FROM titles
  WHERE price IS NOT NULL
  GROUP BY pub_id WITH ROLLUP
  ORDER BY pub_id;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[reptq2]'
GO

ALTER PROCEDURE [dbo].[reptq2]
AS
SELECT CASE WHEN Grouping(type) = 1 THEN 'ALL' ELSE type END AS type,
  CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  Avg(ytd_sales) AS avg_ytd_sales
  FROM titles
  WHERE pub_id IS NOT NULL
  GROUP BY pub_id, type WITH ROLLUP;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[reptq3]'
GO

ALTER PROCEDURE [dbo].[reptq3] @lolimit MONEY, @hilimit MONEY, @type CHAR(12)
AS
SELECT CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  CASE WHEN Grouping(type) = 1 THEN 'ALL' ELSE type END AS type,
  Count(title_id) AS cnt
  FROM titles
  WHERE price > @lolimit
    AND price < @hilimit
    AND type = @type
     OR type LIKE '%cook%'
  GROUP BY pub_id, type WITH ROLLUP;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [DF__authors__phone__38996AB5] DEFAULT ('UNKNOWN') FOR [phone]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [DF__publisher__count__3D5E1FD2] DEFAULT ('USA') FOR [country]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [DF__titles__type__403A8C7D] DEFAULT ('UNDECIDED') FOR [type]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[sales]'
GO
PRINT N'Adding foreign keys to [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Stores] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK_Sales_Title] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering trigger [dbo].[employee_insupd] on [dbo].[employee]'
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
  FROM employee e, jobs j, inserted i
  WHERE e.emp_id = i.emp_id AND i.job_id = j.job_id;
IF (@job_id = 1) AND (@emp_lvl <> 10)
  BEGIN
    RAISERROR('Job id 1 expects the default level of 10.', 16, 1);
    ROLLBACK TRANSACTION;
  END;
ELSE IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
       BEGIN
         RAISERROR(
                    'The level for job_id:%d should be between %d and %d.',
                    16,
                    1,
                    @job_id,
                    @min_lvl,
                    @max_lvl
                  );
         ROLLBACK TRANSACTION;
       END;

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) 
begin
PRINT 'The database update succeeded'
end
ELSE BEGIN
  PRINT 'The database update failed'
END
GO