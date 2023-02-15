SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
PRINT N'Dropping extended properties';
GO
IF EXISTS (SELECT 1 FROM sys.extended_properties WHERE name LIKE N'Database_Info')
	EXEC sp_dropextendedproperty N'Database_Info', NULL, NULL, NULL, NULL, NULL, NULL;
GO
PRINT N'Dropping foreign keys from [dbo].[titleauthor]';
GO
IF Object_Id ('[FK__titleauth__au_id__0CBAE877]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor]
  DROP CONSTRAINT [FK__titleauth__au_id__0CBAE877];
GO
IF Object_Id ('[FK__titleauth__title__0DAF0CB0]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor]
  DROP CONSTRAINT [FK__titleauth__title__0DAF0CB0];
GO
PRINT N'Dropping foreign keys from [dbo].[discounts]';
GO
IF Object_Id ('[FK__discounts__stor___173876EA]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[discounts]
  DROP CONSTRAINT [FK__discounts__stor___173876EA];
GO
PRINT N'Dropping foreign keys from [dbo].[employee]';
GO
IF Object_Id ('[FK__employee__job_id__25869641]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  DROP CONSTRAINT [FK__employee__job_id__25869641];
GO

IF Object_Id ('[FK__employee__pub_id__286302EC]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[employee]
    DROP CONSTRAINT [FK__employee__pub_id__286302EC];
GO
PRINT N'Dropping foreign keys from [dbo].[pub_info]';
GO
if Object_Id ('[FK__pub_info__pub_id__20C1E124]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[pub_info]
    DROP CONSTRAINT [FK__pub_info__pub_id__20C1E124];
GO
PRINT N'Dropping foreign keys from [dbo].[titles]';
GO
if Object_Id ('[FK__titles__pub_id__08EA5793]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [FK__titles__pub_id__08EA5793];
GO
PRINT N'Dropping foreign keys from [dbo].[roysched]';
GO
IF Object_Id ('[FK__roysched__title___15502E78]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[roysched]
  DROP CONSTRAINT [FK__roysched__title___15502E78];
GO
PRINT N'Dropping foreign keys from [dbo].[sales]';
GO
IF Object_Id ('[FK__sales__stor_id__1273C1CD]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK__sales__stor_id__1273C1CD];
GO
IF Object_Id ('[FK__sales__title_id__1367E606]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [FK__sales__title_id__1367E606];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO


IF Object_Id ('[CK__authors__au_id__7F60ED59]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [CK__authors__au_id__7F60ED59];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[CK__authors__zip__014935CB]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [CK__authors__zip__014935CB];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[CK_emp_id]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [CK_emp_id];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[CK__jobs__min_lvl__1CF15040]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [CK__jobs__min_lvl__1CF15040];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[CK__jobs__max_lvl__1DE57479]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [CK__jobs__max_lvl__1DE57479];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[CK__publisher__pub_i__0425A276]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  DROP CONSTRAINT [CK__publisher__pub_i__0425A276];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[UPKCL_auidind]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [UPKCL_auidind];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[PK_emp_id]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [PK_emp_id];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[PK__jobs__6E32B6A51A14E395]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [PK__jobs__6E32B6A51A14E395];
GO
PRINT N'Dropping constraints from [dbo].[pub_info]';
GO
IF Object_Id ('[UPKCL_pubinfo]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[pub_info] DROP CONSTRAINT [UPKCL_pubinfo];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[UPKCL_pubind]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [UPKCL_pubind];
GO
PRINT N'Dropping constraints from [dbo].[sales]';
GO
IF Object_Id ('[UPKCL_sales]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[sales] DROP CONSTRAINT [UPKCL_sales];
GO
PRINT N'Dropping constraints from [dbo].[stores]';
GO
IF Object_Id ('[UPK_storeid]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[stores] DROP CONSTRAINT [UPK_storeid];
GO
PRINT N'Dropping constraints from [dbo].[titleauthor]';
GO
IF Object_Id ('[UPKCL_taind]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [UPKCL_taind];
GO
PRINT N'Dropping constraints from [dbo].[titles]';
GO
IF Object_Id ('[UPKCL_titleidind]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [UPKCL_titleidind];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[DF__authors__phone__00551192]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [DF__authors__phone__00551192];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[DF__employee__job_id__24927208]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  DROP CONSTRAINT [DF__employee__job_id__24927208];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[DF__employee__job_lv__267ABA7A]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  DROP CONSTRAINT [DF__employee__job_lv__267ABA7A];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[DF__employee__pub_id__276EDEB3]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  DROP CONSTRAINT [DF__employee__pub_id__276EDEB3];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[DF__employee__hire_d__29572725]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[employee]
  DROP CONSTRAINT [DF__employee__hire_d__29572725];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[DF__jobs__job_desc__1BFD2C07]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [DF__jobs__job_desc__1BFD2C07];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[DF__publisher__count__0519C6AF]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  DROP CONSTRAINT [DF__publisher__count__0519C6AF];
GO
PRINT N'Dropping constraints from [dbo].[titles]';
GO
IF Object_Id ('[DF__titles__type__07F6335A]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [DF__titles__type__07F6335A];
GO
PRINT N'Dropping constraints from [dbo].[titles]';
GO
IF Object_Id ('[DF__titles__pubdate__09DE7BCC]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [DF__titles__pubdate__09DE7BCC];
GO
PRINT N'Dropping index [aunmind] from [dbo].[authors]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[authors]')
 AND name = 'aunmindTagName_index')
  DROP INDEX [aunmind] ON [dbo].[authors];
GO
PRINT N'Dropping index [titleidind] from [dbo].[roysched]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[roysched]')
 AND name = 'titleidindTagName_index')
  DROP INDEX [titleidind] ON [dbo].[roysched];
GO
PRINT N'Dropping index [titleidind] from [dbo].[sales]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[sales]')
 AND name = 'titleidindTagName_index')
  DROP INDEX [titleidind] ON [dbo].[sales];
GO
PRINT N'Dropping index [auidind] from [dbo].[titleauthor]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[titleauthor]')
 AND name = 'auidindTagName_index')
  DROP INDEX [auidind] ON [dbo].[titleauthor];
GO
PRINT N'Dropping index [titleidind] from [dbo].[titleauthor]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[titleauthor]')
 AND name = 'titleidindTagName_index')
  DROP INDEX [titleidind] ON [dbo].[titleauthor];
GO
PRINT N'Dropping index [titleind] from [dbo].[titles]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[titles]')
 AND name = 'titleindTagName_index')
  DROP INDEX [titleind] ON [dbo].[titles];
GO
PRINT N'Dropping index [employee_ind] from [dbo].[employee]';
GO
IF EXISTS
  (SELECT *
     FROM sys.indexes
     WHERE
     object_id = Object_Id ('[dbo].[employee]')
 AND name = 'employee_indTagName_index')
  DROP INDEX [employee_ind] ON [dbo].[employee];
GO
PRINT N'Dropping trigger [dbo].[employee_insupd] from [dbo].[employee]';
GO
IF Object_Id('[dbo].[employee_insupd]','TR') IS NOT NULL DROP TRIGGER [dbo].[employee_insupd];
GO
PRINT N'Unbinding types from columns';

GO
IF Col_Length ('[dbo].[authors]', '[au_id]') IS NOT NULL
  ALTER TABLE [dbo].[authors] ALTER COLUMN [au_id] VARCHAR(11);
IF Col_Length ('[dbo].[employee]', '[emp_id]') IS NOT NULL
  ALTER TABLE [dbo].[employee] ALTER COLUMN [emp_id] CHAR(9);
IF Col_Length ('[dbo].[roysched]', '[title_id]') IS NOT NULL
  ALTER TABLE [dbo].[roysched] ALTER COLUMN [title_id] VARCHAR(6);
IF Col_Length ('[dbo].[sales]', '[title_id]') IS NOT  NULL
  ALTER TABLE [dbo].[sales] ALTER COLUMN [title_id] VARCHAR(6);
IF Col_Length ('[dbo].[titleauthor]', '[au_id]') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor] ALTER COLUMN [au_id] VARCHAR(11);
IF Col_Length ('[dbo].[titleauthor]', '[title_id]') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor] ALTER COLUMN [title_id] VARCHAR(6);
IF Col_Length ('[dbo].[titles]', '[title_id]') IS  NOT NULL
  ALTER TABLE [dbo].[titles] ALTER COLUMN [title_id] VARCHAR(6);
PRINT N'Dropping [dbo].[titleview]';
GO
IF Object_Id ('[dbo].[titleview]', 'V') IS NOT NULL
  DROP VIEW [dbo].[titleview];
GO
PRINT N'Dropping [dbo].[reptq3]';
GO
IF Object_Id ('[dbo].[reptq3]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[reptq3];
GO
PRINT N'Dropping [dbo].[reptq2]';
GO
IF Object_Id ('[dbo].[reptq2]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[reptq2];
GO
PRINT N'Dropping [dbo].[reptq1]';
GO
IF Object_Id ('[dbo].[reptq1]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[reptq1];
GO
PRINT N'Dropping [dbo].[byroyalty]';
GO
IF Object_Id ('[dbo].[byroyalty]', 'P') IS NOT NULL
  DROP PROCEDURE [dbo].[byroyalty];
GO
PRINT N'Dropping [dbo].[titleauthor]';
GO
IF Object_Id ('[dbo].[titleauthor]', 'U') IS NOT NULL
  DROP TABLE [dbo].[titleauthor];
GO
PRINT N'Dropping [dbo].[sales]';
GO
IF Object_Id ('[dbo].[sales]', 'U') IS NOT NULL DROP TABLE [dbo].[sales];
GO
PRINT N'Dropping [dbo].[roysched]';
GO
IF Object_Id ('[dbo].[roysched]', 'U') IS NOT NULL
  DROP TABLE [dbo].[roysched];
GO
PRINT N'Dropping [dbo].[pub_info]';
GO
IF Object_Id ('[dbo].[pub_info]', 'U') IS NOT NULL
  DROP TABLE [dbo].[pub_info];
GO
PRINT N'Dropping [dbo].[discounts]';
GO
IF Object_Id ('[dbo].[discounts]', 'U') IS NOT NULL
  DROP TABLE [dbo].[discounts];
GO
PRINT N'Dropping [dbo].[stores]';
GO
IF Object_Id ('[dbo].[stores]', 'U') IS NOT NULL DROP TABLE [dbo].[stores];
GO
PRINT N'Dropping [dbo].[titles]';
GO
IF Object_Id ('[dbo].[titles]', 'U') IS NOT NULL DROP TABLE [dbo].[titles];
GO
PRINT N'Dropping [dbo].[publishers]';
GO
IF Object_Id ('[dbo].[publishers]', 'U') IS NOT NULL
  DROP TABLE [dbo].[publishers];
GO
PRINT N'Dropping [dbo].[jobs]';
GO
IF Object_Id ('[dbo].[jobs]', 'U') IS NOT NULL DROP TABLE [dbo].[jobs];
GO
PRINT N'Dropping [dbo].[employee]';
GO
IF Object_Id ('[dbo].[employee]', 'U') IS NOT NULL
  DROP TABLE [dbo].[employee];
GO
PRINT N'Dropping [dbo].[authors]';
GO
IF Object_Id ('[dbo].[authors]', 'U') IS NOT NULL DROP TABLE [dbo].[authors];
GO
PRINT N'Dropping types';
GO
IF EXISTS (SELECT 1 FROM sys.types WHERE name LIKE 'empid')
  DROP TYPE [dbo].[empid];
GO
IF EXISTS (SELECT 1 FROM sys.types WHERE name LIKE 'id')
  DROP TYPE [dbo].[id];
GO
IF EXISTS (SELECT 1 FROM sys.types WHERE name LIKE 'tid')
  DROP TYPE [dbo].[tid];
GO
PRINT N'Dropping schemas';
GO
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name LIKE 'Classic')
  DROP SCHEMA [Classic];
GO
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name LIKE 'People')
  DROP SCHEMA [people];
GO
SELECT object_Schema_name(object_id)+'.'+Object_Name(object_id), Replace(Lower(type_desc),'_',' ') AS [objects Left]
FROM sys.objects WHERE is_ms_shipped=0