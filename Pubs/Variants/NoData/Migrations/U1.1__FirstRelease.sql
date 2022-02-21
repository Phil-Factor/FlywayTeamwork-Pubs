-- Disable all constraints for database
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

PRINT(N'Delete rows from [dbo].[titleauthor]')
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '172-32-1176' AND [title_id] = 'PS3333'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '213-46-8915' AND [title_id] = 'BU1032'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '213-46-8915' AND [title_id] = 'BU2075'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '238-95-7766' AND [title_id] = 'PC1035'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '267-41-2394' AND [title_id] = 'BU1111'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '267-41-2394' AND [title_id] = 'TC7777'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '274-80-9391' AND [title_id] = 'BU7832'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '409-56-7008' AND [title_id] = 'BU1032'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '427-17-2319' AND [title_id] = 'PC8888'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '472-27-2349' AND [title_id] = 'TC7777'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '486-29-1786' AND [title_id] = 'PC9999'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '486-29-1786' AND [title_id] = 'PS7777'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '648-92-1872' AND [title_id] = 'TC4203'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '672-71-3249' AND [title_id] = 'TC7777'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '712-45-1867' AND [title_id] = 'MC2222'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '722-51-5454' AND [title_id] = 'MC3021'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '724-80-9391' AND [title_id] = 'BU1111'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '724-80-9391' AND [title_id] = 'PS1372'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '756-30-7391' AND [title_id] = 'PS1372'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '807-91-6654' AND [title_id] = 'TC3218'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '846-92-7186' AND [title_id] = 'PC8888'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '899-46-2035' AND [title_id] = 'MC3021'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '899-46-2035' AND [title_id] = 'PS2091'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '998-72-3567' AND [title_id] = 'PS2091'
DELETE FROM [dbo].[titleauthor] WHERE [au_id] = '998-72-3567' AND [title_id] = 'PS2106'
PRINT(N'Operation applied to 25 rows out of 25')

PRINT(N'Delete rows from [dbo].[sales]')
DELETE FROM [dbo].[sales] WHERE [stor_id] = '6380' AND [ord_num] = '6871' AND [title_id] = 'BU1032'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '6380' AND [ord_num] = '722a' AND [title_id] = 'PS2091'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7066' AND [ord_num] = 'A2976' AND [title_id] = 'PC8888'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7066' AND [ord_num] = 'QA7442.3' AND [title_id] = 'PS2091'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7067' AND [ord_num] = 'D4482' AND [title_id] = 'PS2091'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7067' AND [ord_num] = 'P2121' AND [title_id] = 'TC3218'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7067' AND [ord_num] = 'P2121' AND [title_id] = 'TC4203'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7067' AND [ord_num] = 'P2121' AND [title_id] = 'TC7777'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7131' AND [ord_num] = 'N914008' AND [title_id] = 'PS2091'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7131' AND [ord_num] = 'N914014' AND [title_id] = 'MC3021'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7131' AND [ord_num] = 'P3087a' AND [title_id] = 'PS1372'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7131' AND [ord_num] = 'P3087a' AND [title_id] = 'PS2106'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7131' AND [ord_num] = 'P3087a' AND [title_id] = 'PS3333'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7131' AND [ord_num] = 'P3087a' AND [title_id] = 'PS7777'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7896' AND [ord_num] = 'QQ2299' AND [title_id] = 'BU7832'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7896' AND [ord_num] = 'TQ456' AND [title_id] = 'MC2222'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '7896' AND [ord_num] = 'X999' AND [title_id] = 'BU2075'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '8042' AND [ord_num] = '423LL922' AND [title_id] = 'MC3021'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '8042' AND [ord_num] = '423LL930' AND [title_id] = 'BU1032'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '8042' AND [ord_num] = 'P723' AND [title_id] = 'BU1111'
DELETE FROM [dbo].[sales] WHERE [stor_id] = '8042' AND [ord_num] = 'QA879.1' AND [title_id] = 'PC1035'
PRINT(N'Operation applied to 21 rows out of 21')

PRINT(N'Delete rows from [dbo].[titles]')
DELETE FROM [dbo].[titles] WHERE [title_id] = 'BU1032'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'BU1111'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'BU2075'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'BU7832'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'MC2222'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'MC3021'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'MC3026'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PC1035'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PC8888'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PC9999'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PS1372'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PS2091'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PS2106'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PS3333'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'PS7777'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'TC3218'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'TC4203'
DELETE FROM [dbo].[titles] WHERE [title_id] = 'TC7777'
PRINT(N'Operation applied to 18 rows out of 18')

PRINT(N'Delete rows from [dbo].[pub_info]')
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '0736'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '0877'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '1389'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '1622'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '1756'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '9901'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '9952'
DELETE FROM [dbo].[pub_info] WHERE [pub_id] = '9999'
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Delete rows from [dbo].[employee]')
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'A-C71970F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'AMD15433F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'A-R89858F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'ARD36773F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'CFH28514M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'CGS88322F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'DBT39435M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'DWR65030M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'ENL44273F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'F-C16315M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'GHT50241M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'HAN90777M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'HAS54740M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'H-B39728F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'JYL26161F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'KFJ64308F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'KJJ92907F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'LAL21447M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'L-B31947F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'MAP77183M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'MAS70474F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'MFS52347M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'MGK44605M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'MJP25939M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'M-L67958F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'MMS49649F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'M-P91209M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'M-R38834F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PCM98509F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PDI47470M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PHF38899M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PMA42628M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'POK93028M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PSA89086M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PSP68661F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PTC11962M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'PXH22250M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'RBM23061F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'R-M53550M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'SKO22412M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'TPO55093M'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'VPA30890F'
DELETE FROM [dbo].[employee] WHERE [emp_id] = 'Y-L77953M'
PRINT(N'Operation applied to 43 rows out of 43')

PRINT(N'Delete rows from [dbo].[stores]')
DELETE FROM [dbo].[stores] WHERE [stor_id] = '6380'
DELETE FROM [dbo].[stores] WHERE [stor_id] = '7066'
DELETE FROM [dbo].[stores] WHERE [stor_id] = '7067'
DELETE FROM [dbo].[stores] WHERE [stor_id] = '7131'
DELETE FROM [dbo].[stores] WHERE [stor_id] = '7896'
DELETE FROM [dbo].[stores] WHERE [stor_id] = '8042'
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Delete rows from [dbo].[publishers]')
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '0736'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '0877'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '1389'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '1622'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '1756'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '9901'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '9952'
DELETE FROM [dbo].[publishers] WHERE [pub_id] = '9999'
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Delete rows from [dbo].[jobs]')
DELETE FROM [dbo].[jobs] WHERE [job_id] = 1
DELETE FROM [dbo].[jobs] WHERE [job_id] = 2
DELETE FROM [dbo].[jobs] WHERE [job_id] = 3
DELETE FROM [dbo].[jobs] WHERE [job_id] = 4
DELETE FROM [dbo].[jobs] WHERE [job_id] = 5
DELETE FROM [dbo].[jobs] WHERE [job_id] = 6
DELETE FROM [dbo].[jobs] WHERE [job_id] = 7
DELETE FROM [dbo].[jobs] WHERE [job_id] = 8
DELETE FROM [dbo].[jobs] WHERE [job_id] = 9
DELETE FROM [dbo].[jobs] WHERE [job_id] = 10
DELETE FROM [dbo].[jobs] WHERE [job_id] = 11
DELETE FROM [dbo].[jobs] WHERE [job_id] = 12
DELETE FROM [dbo].[jobs] WHERE [job_id] = 13
DELETE FROM [dbo].[jobs] WHERE [job_id] = 14
PRINT(N'Operation applied to 14 rows out of 14')
DBCC CHECKIDENT ('Jobs', RESEED, 1)

PRINT(N'Delete rows from [dbo].[authors]')
DELETE FROM [dbo].[authors] WHERE [au_id] = '172-32-1176'
DELETE FROM [dbo].[authors] WHERE [au_id] = '213-46-8915'
DELETE FROM [dbo].[authors] WHERE [au_id] = '238-95-7766'
DELETE FROM [dbo].[authors] WHERE [au_id] = '267-41-2394'
DELETE FROM [dbo].[authors] WHERE [au_id] = '274-80-9391'
DELETE FROM [dbo].[authors] WHERE [au_id] = '341-22-1782'
DELETE FROM [dbo].[authors] WHERE [au_id] = '409-56-7008'
DELETE FROM [dbo].[authors] WHERE [au_id] = '427-17-2319'
DELETE FROM [dbo].[authors] WHERE [au_id] = '472-27-2349'
DELETE FROM [dbo].[authors] WHERE [au_id] = '486-29-1786'
DELETE FROM [dbo].[authors] WHERE [au_id] = '527-72-3246'
DELETE FROM [dbo].[authors] WHERE [au_id] = '648-92-1872'
DELETE FROM [dbo].[authors] WHERE [au_id] = '672-71-3249'
DELETE FROM [dbo].[authors] WHERE [au_id] = '712-45-1867'
DELETE FROM [dbo].[authors] WHERE [au_id] = '722-51-5454'
DELETE FROM [dbo].[authors] WHERE [au_id] = '724-08-9931'
DELETE FROM [dbo].[authors] WHERE [au_id] = '724-80-9391'
DELETE FROM [dbo].[authors] WHERE [au_id] = '756-30-7391'
DELETE FROM [dbo].[authors] WHERE [au_id] = '807-91-6654'
DELETE FROM [dbo].[authors] WHERE [au_id] = '846-92-7186'
DELETE FROM [dbo].[authors] WHERE [au_id] = '893-72-1158'
DELETE FROM [dbo].[authors] WHERE [au_id] = '899-46-2035'
DELETE FROM [dbo].[authors] WHERE [au_id] = '998-72-3567'
PRINT(N'Operation applied to 23 rows out of 23')

delete from Discounts
Delete from Roysched

-- Enable all constraints for database
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

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
