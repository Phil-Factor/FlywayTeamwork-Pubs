/*
    Generated on 05/Jun/2020 14:35 by Redgate SQL Change Automation v3.2.19130.7523
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

GO
PRINT N'Creating types'
GO

GO
CREATE TYPE [dbo].[tid] FROM varchar (6) NOT NULL
GO

GO
CREATE TYPE [dbo].[id] FROM varchar (11) NOT NULL
GO

GO
CREATE TYPE [dbo].[empid] FROM char (9) NOT NULL
GO

GO
PRINT N'Creating [dbo].[employee]'
GO
CREATE TABLE [dbo].[employee]
(
[emp_id] [dbo].[empid] NOT NULL,
[fname] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[minit] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[lname] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[job_id] [smallint] NOT NULL CONSTRAINT [DF__employee__job_id__24927208] DEFAULT ((1)),
[job_lvl] [tinyint] NULL CONSTRAINT [DF__employee__job_lv__267ABA7A] DEFAULT ((10)),
[pub_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__employee__pub_id__276EDEB3] DEFAULT ('9952'),
[hire_date] [datetime] NOT NULL CONSTRAINT [DF__employee__hire_d__29572725] DEFAULT (getdate())
) ON [PRIMARY]
GO

GO
PRINT N'Creating index [employee_ind] on [dbo].[employee]'
GO
CREATE CLUSTERED INDEX [employee_ind] ON [dbo].[employee] ([lname], [fname], [minit]) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [PK_emp_id] on [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [PK_emp_id] PRIMARY KEY NONCLUSTERED  ([emp_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[jobs]'
GO
CREATE TABLE [dbo].[jobs]
(
[job_id] [smallint] NOT NULL IDENTITY(1, 1),
[job_desc] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__jobs__job_desc__1BFD2C07] DEFAULT ('New Position - title not formalized yet'),
[min_lvl] [tinyint] NOT NULL,
[max_lvl] [tinyint] NOT NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [PK__jobs__6E32B6A51A14E395] on [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [PK__jobs__6E32B6A51A14E395] PRIMARY KEY CLUSTERED  ([job_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating trigger [dbo].[employee_insupd] on [dbo].[employee]'
GO

CREATE TRIGGER [dbo].[employee_insupd]
ON [dbo].[employee]
FOR insert, UPDATE
AS
--Get the range of level for this job type from the jobs table.
declare @min_lvl tinyint,
   @max_lvl tinyint,
   @emp_lvl tinyint,
   @job_id smallint
select @min_lvl = min_lvl,
   @max_lvl = max_lvl,
   @emp_lvl = i.job_lvl,
   @job_id = i.job_id
from employee e, jobs j, inserted i
where e.emp_id = i.emp_id AND i.job_id = j.job_id
IF (@job_id = 1) and (@emp_lvl <> 10)
begin
   raiserror ('Job id 1 expects the default level of 10.',16,1)
   ROLLBACK TRANSACTION
end
ELSE
IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
begin
   raiserror ('The level for job_id:%d should be between %d and %d.',
      16, 1, @job_id, @min_lvl, @max_lvl)
   ROLLBACK TRANSACTION
end

GO

GO
PRINT N'Creating [dbo].[stores]'
GO
CREATE TABLE [dbo].[stores]
(
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_name] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[stor_address] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[city] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[zip] [char] (5) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPK_storeid] on [dbo].[stores]'
GO
ALTER TABLE [dbo].[stores] ADD CONSTRAINT [UPK_storeid] PRIMARY KEY CLUSTERED  ([stor_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[discounts]'
GO
CREATE TABLE [dbo].[discounts]
(
[discounttype] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[lowqty] [smallint] NULL,
[highqty] [smallint] NULL,
[discount] [decimal] (4, 2) NOT NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[publishers]'
GO
CREATE TABLE [dbo].[publishers]
(
[pub_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_name] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[city] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[country] [varchar] (30) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF__publisher__count__0519C6AF] DEFAULT ('USA')
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPKCL_pubind] on [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED  ([pub_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[pub_info]'
GO
CREATE TABLE [dbo].[pub_info]
(
[pub_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[logo] [image] NULL,
[pr_info] [text] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPKCL_pubinfo] on [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [UPKCL_pubinfo] PRIMARY KEY CLUSTERED  ([pub_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[titles]'
GO
CREATE TABLE [dbo].[titles]
(
[title_id] [dbo].[tid] NOT NULL,
[title] [varchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[type] [char] (12) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__titles__type__07F6335A] DEFAULT ('UNDECIDED'),
[pub_id] [char] (4) COLLATE Latin1_General_CI_AS NULL,
[price] [money] NULL,
[advance] [money] NULL,
[royalty] [int] NULL,
[ytd_sales] [int] NULL,
[notes] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[pubdate] [datetime] NOT NULL CONSTRAINT [DF__titles__pubdate__09DE7BCC] DEFAULT (getdate())
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPKCL_titleidind] on [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [UPKCL_titleidind] PRIMARY KEY CLUSTERED  ([title_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating index [titleind] on [dbo].[titles]'
GO
CREATE NONCLUSTERED INDEX [titleind] ON [dbo].[titles] ([title]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[roysched]'
GO
CREATE TABLE [dbo].[roysched]
(
[title_id] [dbo].[tid] NOT NULL,
[lorange] [int] NULL,
[hirange] [int] NULL,
[royalty] [int] NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating index [titleidind] on [dbo].[roysched]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched] ([title_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[sales]'
GO
CREATE TABLE [dbo].[sales]
(
[stor_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[ord_num] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[ord_date] [datetime] NOT NULL,
[qty] [smallint] NOT NULL,
[payterms] [varchar] (12) COLLATE Latin1_General_CI_AS NOT NULL,
[title_id] [dbo].[tid] NOT NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPKCL_sales] on [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [UPKCL_sales] PRIMARY KEY CLUSTERED  ([stor_id], [ord_num], [title_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating index [titleidind] on [dbo].[sales]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[sales] ([title_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[authors]'
GO
CREATE TABLE [dbo].[authors]
(
[au_id] [dbo].[id] NOT NULL,
[au_lname] [varchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[au_fname] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[phone] [char] (12) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF__authors__phone__00551192] DEFAULT ('UNKNOWN'),
[address] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[city] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[zip] [char] (5) COLLATE Latin1_General_CI_AS NULL,
[contract] [bit] NOT NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPKCL_auidind] on [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED  ([au_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating index [aunmind] on [dbo].[authors]'
GO
CREATE NONCLUSTERED INDEX [aunmind] ON [dbo].[authors] ([au_lname], [au_fname]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[titleauthor]'
GO
CREATE TABLE [dbo].[titleauthor]
(
[au_id] [dbo].[id] NOT NULL,
[title_id] [dbo].[tid] NOT NULL,
[au_ord] [tinyint] NULL,
[royaltyper] [int] NULL
) ON [PRIMARY]
GO

GO
PRINT N'Creating primary key [UPKCL_taind] on [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [UPKCL_taind] PRIMARY KEY CLUSTERED  ([au_id], [title_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating index [auidind] on [dbo].[titleauthor]'
GO
CREATE NONCLUSTERED INDEX [auidind] ON [dbo].[titleauthor] ([au_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating index [titleidind] on [dbo].[titleauthor]'
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[titleauthor] ([title_id]) ON [PRIMARY]
GO

GO
PRINT N'Creating [dbo].[titleview]'
GO

CREATE VIEW [dbo].[titleview]
AS
select title, au_ord, au_lname, price, ytd_sales, pub_id
from authors, titles, titleauthor
where authors.au_id = titleauthor.au_id
   AND titles.title_id = titleauthor.title_id

GO

GO
PRINT N'Creating [dbo].[byroyalty]'
GO

CREATE PROCEDURE [dbo].[byroyalty] @percentage int
AS
select au_id from titleauthor
where titleauthor.royaltyper = @percentage

GO

GO
PRINT N'Creating [dbo].[reptq1]'
GO

CREATE PROCEDURE [dbo].[reptq1] AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id with rollup
order by pub_id

GO

GO
PRINT N'Creating [dbo].[reptq2]'
GO

CREATE PROCEDURE [dbo].[reptq2] AS
select 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id, type with rollup

GO

GO
PRINT N'Creating [dbo].[reptq3]'
GO

CREATE PROCEDURE [dbo].[reptq3] @lolimit money, @hilimit money,
@type char(12)
AS
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	count(title_id) as cnt
from titles
where price >@lolimit AND price <@hilimit AND type = @type OR type LIKE '%cook%'
group by pub_id, type with rollup

GO

GO
PRINT N'Adding constraints to [dbo].[authors]'
GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__au_id__7F60ED59] CHECK (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO

GO
ALTER TABLE [dbo].[authors] ADD CONSTRAINT [CK__authors__zip__014935CB] CHECK (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO

GO
PRINT N'Adding constraints to [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [CK_emp_id] CHECK (([emp_id] like '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR [emp_id] like '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'))
GO

GO
PRINT N'Adding constraints to [dbo].[jobs]'
GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__min_lvl__1CF15040] CHECK (([min_lvl]>=(10)))
GO

GO
ALTER TABLE [dbo].[jobs] ADD CONSTRAINT [CK__jobs__max_lvl__1DE57479] CHECK (([max_lvl]<=(250)))
GO

GO
PRINT N'Adding constraints to [dbo].[publishers]'
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [CK__publisher__pub_i__0425A276] CHECK (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO

GO
PRINT N'Adding foreign keys to [dbo].[titleauthor]'
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__au_id__0CBAE877] FOREIGN KEY ([au_id]) REFERENCES [dbo].[authors] ([au_id])
GO
ALTER TABLE [dbo].[titleauthor] ADD CONSTRAINT [FK__titleauth__title__0DAF0CB0] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO

GO
PRINT N'Adding foreign keys to [dbo].[discounts]'
GO
ALTER TABLE [dbo].[discounts] ADD CONSTRAINT [FK__discounts__stor___173876EA] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO

GO
PRINT N'Adding foreign keys to [dbo].[employee]'
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__job_id__25869641] FOREIGN KEY ([job_id]) REFERENCES [dbo].[jobs] ([job_id])
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [FK__employee__pub_id__286302EC] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO

GO
PRINT N'Adding foreign keys to [dbo].[pub_info]'
GO
ALTER TABLE [dbo].[pub_info] ADD CONSTRAINT [FK__pub_info__pub_id__20C1E124] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO

GO
PRINT N'Adding foreign keys to [dbo].[titles]'
GO
ALTER TABLE [dbo].[titles] ADD CONSTRAINT [FK__titles__pub_id__08EA5793] FOREIGN KEY ([pub_id]) REFERENCES [dbo].[publishers] ([pub_id])
GO

GO
PRINT N'Adding foreign keys to [dbo].[roysched]'
GO
ALTER TABLE [dbo].[roysched] ADD CONSTRAINT [FK__roysched__title___15502E78] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO

GO
PRINT N'Adding foreign keys to [dbo].[sales]'
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK__sales__stor_id__1273C1CD] FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
GO
ALTER TABLE [dbo].[sales] ADD CONSTRAINT [FK__sales__title_id__1367E606] FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO

GO
PRINT N'Adding version number'
GO
Declare @Version Varchar(20)
Declare @DatabaseInfo nvarchar(3000)
SET @version = N'1.1.1';
SELECT @DatabaseInfo =
  (
  SELECT 'Pubs' AS "Name", @version AS "Version",
    'The Pubs (publishing) Database supports a fictitious publisher.' AS "Description",
    GetDate() AS "Modified", SUser_Name() AS "by"
  FOR JSON PATH
  );

IF NOT EXISTS
  (
  SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
    FROM sys.fn_listextendedproperty(
N'Database_Info', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
)
  )
  EXEC sys.sp_addextendedproperty @name = N'Database_Info',
@value = @DatabaseInfo;
ELSE EXEC sys.sp_updateextendedproperty @name = N'Database_Info',
@value = @DatabaseInfo;
go
PRINT N'Altering permissions on TYPE:: [dbo].[empid]'
GO
GRANT REFERENCES ON TYPE:: [dbo].[empid] TO [public]
GO

GO
PRINT N'Altering permissions on TYPE:: [dbo].[id]'
GO
GRANT REFERENCES ON TYPE:: [dbo].[id] TO [public]
GO

GO
PRINT N'Altering permissions on TYPE:: [dbo].[tid]'
GO
GRANT REFERENCES ON TYPE:: [dbo].[tid] TO [public]
GO

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


