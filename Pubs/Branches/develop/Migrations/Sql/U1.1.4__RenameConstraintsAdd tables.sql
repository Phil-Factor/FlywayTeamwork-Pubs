SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
PRINT N'Dropping foreign keys from [dbo].[discounts]';
GO
IF Object_Id ('[FK__discounts__store]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[discounts] DROP CONSTRAINT [FK__discounts__store];
GO
PRINT N'Dropping foreign keys from [dbo].[prices]';
GO
IF Object_Id ('[fk_prices]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[prices] DROP CONSTRAINT [fk_prices];
GO
PRINT N'Dropping foreign keys from [dbo].[editions]';
GO
IF Object_Id ('[fk_edition]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[editions] DROP CONSTRAINT [fk_edition];
GO
PRINT N'Dropping foreign keys from [dbo].[employee]';
GO
IF Object_Id ('[FK__employee__pub_id]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [FK__employee__pub_id];
GO
IF Object_Id ('[FK__employee__job_id]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [FK__employee__job_id];
GO
PRINT N'Dropping foreign keys from [dbo].[pub_info]';
GO
IF Object_Id ('[FK__pub_info__pub_id]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[pub_info] DROP CONSTRAINT [FK__pub_info__pub_id];
GO
PRINT N'Dropping foreign keys from [dbo].[publications]';
GO
IF Object_Id ('[fkPublishers]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[publications] DROP CONSTRAINT [fkPublishers];
GO
PRINT N'Dropping foreign keys from [dbo].[titles]';
GO
IF Object_Id ('[FK__titles__pub_id]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [FK__titles__pub_id];
GO
PRINT N'Dropping foreign keys from [dbo].[roysched]';
GO
IF Object_Id ('[FK__roysched__title]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[roysched] DROP CONSTRAINT [FK__roysched__title];
GO
PRINT N'Dropping foreign keys from [dbo].[titleauthor]';
GO
IF Object_Id ('[FK__titleauth__au_id]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [FK__titleauth__au_id];
GO
IF Object_Id ('[FK__titleauth__title]', 'F') IS NOT NULL
  ALTER TABLE [dbo].[titleauthor] DROP CONSTRAINT [FK__titleauth__title];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[CK__authors__au_id]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [CK__authors__au_id];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[CK__authors__zip]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [CK__authors__zip];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[CK__jobs__max_lvl]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [CK__jobs__max_lvl];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[CK__jobs__min_lvl]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [CK__jobs__min_lvl];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[CK__publisher__pub_id]', 'C') IS NOT NULL
  ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [CK__publisher__pub_id];
GO
PRINT N'Dropping constraints from [dbo].[editions]';
GO
IF Object_Id ('[PK_editions]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[editions] DROP CONSTRAINT [PK_editions];
GO
PRINT N'Dropping constraints from [dbo].[prices]';
GO
IF Object_Id ('[PK_Prices]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[prices] DROP CONSTRAINT [PK_Prices];
GO
PRINT N'Dropping constraints from [dbo].[pub_info]';
GO
IF Object_Id ('[UPKCL_pubinfo]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[pub_info] DROP CONSTRAINT [UPKCL_pubinfo];
GO
PRINT N'Dropping constraints from [dbo].[publications]';
GO
IF Object_Id ('[PK_Publication]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[publications] DROP CONSTRAINT [PK_Publication];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[UPKCL_pubind]', 'PK') IS NOT NULL
  ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [UPKCL_pubind];
GO
PRINT N'Dropping constraints from [dbo].[authors]';
GO
IF Object_Id ('[AssumeUnknown]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[authors] DROP CONSTRAINT [AssumeUnknown];
GO
PRINT N'Dropping constraints from [dbo].[editions]';
GO
IF Object_Id ('[DF__editions__Public__648DC6E3]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[editions]
  DROP CONSTRAINT [DF__editions__Public__648DC6E3];
GO
PRINT N'Dropping constraints from [dbo].[editions]';
GO
IF Object_Id ('[DF__editions__Editio__6581EB1C]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[editions]
  DROP CONSTRAINT [DF__editions__Editio__6581EB1C];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[AssumeJobIDof1]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [AssumeJobIDof1];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[AssumeJobLevelof10]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [AssumeJobLevelof10];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[AssumeAPub_IDof9952]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [AssumeAPub_IDof9952];
GO
PRINT N'Dropping constraints from [dbo].[employee]';
GO
IF Object_Id ('[AssumeAewHire]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[employee] DROP CONSTRAINT [AssumeAewHire];
GO
PRINT N'Dropping constraints from [dbo].[jobs]';
GO
IF Object_Id ('[AssumeANewPosition]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[jobs] DROP CONSTRAINT [AssumeANewPosition];
GO
PRINT N'Dropping constraints from [dbo].[prices]';
GO
IF Object_Id ('[DF__prices__PriceSta__685E57C7]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[prices] DROP CONSTRAINT [DF__prices__PriceSta__685E57C7];
GO
PRINT N'Dropping constraints from [dbo].[publications]';
GO
IF Object_Id ('[pub_NowDefault]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[publications] DROP CONSTRAINT [pub_NowDefault];
GO
PRINT N'Dropping constraints from [dbo].[publishers]';
GO
IF Object_Id ('[AssumeItsTheSatates]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[publishers] DROP CONSTRAINT [AssumeItsTheSatates];
GO
PRINT N'Dropping constraints from [dbo].[titles]';
GO
IF Object_Id ('[AssumeUndecided]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [AssumeUndecided];
GO
PRINT N'Dropping constraints from [dbo].[titles]';
GO
IF Object_Id ('[AssumeItsPublishedToday]', 'D') IS NOT NULL
  ALTER TABLE [dbo].[titles] DROP CONSTRAINT [AssumeItsPublishedToday];
GO
PRINT N'Unbinding types from columns';
GO
IF Col_Length ('[dbo].[prices]', 'price') IS NOT NULL
  ALTER TABLE [dbo].[prices] ALTER COLUMN [price] NUMERIC(9, 2) NULL;
GO
IF Col_Length ('[dbo].[prices]', 'advance') IS NOT NULL
  ALTER TABLE [dbo].[prices] ALTER COLUMN [advance] NUMERIC(9, 2) NULL;
GO
PRINT N'Dropping [dbo].[publications]';
GO
IF Object_Id ('[dbo].[publications]', 'U') IS NOT NULL
  DROP TABLE [dbo].[publications];
GO
PRINT N'Dropping [dbo].[prices]';
GO
IF Object_Id ('[dbo].[prices]', 'U') IS NOT NULL DROP TABLE [dbo].[prices];
GO
PRINT N'Dropping [dbo].[editions]';
GO
IF Object_Id ('[dbo].[editions]', 'U') IS NOT NULL
  DROP TABLE [dbo].[editions];
GO
PRINT N'Dropping types';
GO
IF EXISTS
  (SELECT 1 FROM sys.types WHERE name LIKE 'Dollars' AND is_user_defined = 1)
  DROP TYPE [dbo].[Dollars];
GO
PRINT N'Altering [dbo].[employee]';
GO
ALTER TABLE [dbo].[employee]
ALTER COLUMN [pub_id] [CHAR](4) COLLATE Latin1_General_CI_AS NOT NULL;
GO
PRINT N'Adding constraints to [dbo].[employee]';
GO
IF Object_Id ('[DF__employee__job_id__24927208]', 'D') IS NULL
  ALTER TABLE [dbo].[employee]
  ADD CONSTRAINT [DF__employee__job_id__24927208]
      DEFAULT ((1)) FOR [job_id];
GO
IF Object_Id ('[DF__employee__job_lv__267ABA7A]', 'D') IS NULL
  ALTER TABLE [dbo].[employee]
  ADD CONSTRAINT [DF__employee__job_lv__267ABA7A]
      DEFAULT ((10)) FOR [job_lvl];
GO
IF Object_Id ('[DF__employee__pub_id__276EDEB3]', 'D') IS NULL
  ALTER TABLE [dbo].[employee]
  ADD CONSTRAINT [DF__employee__pub_id__276EDEB3]
      DEFAULT ('9952') FOR [pub_id];
GO
IF Object_Id ('[DF__employee__hire_d__29572725]', 'D') IS NULL
  ALTER TABLE [dbo].[employee]
  ADD CONSTRAINT [DF__employee__hire_d__29572725]
      DEFAULT (GetDate ()) FOR [hire_date];
GO
PRINT N'Altering [dbo].[publishers]';
GO
IF Col_Length ('[dbo].[publishers]', 'pub_id') IS NOT NULL
  ALTER TABLE [dbo].[publishers]
  ALTER COLUMN [pub_id] [CHAR](4) COLLATE Latin1_General_CI_AS NOT NULL;
GO
PRINT N'Adding constraints to [dbo].[publishers]';
GO
IF Object_Id ('[DF__publisher__count__3D5E1FD2]', 'D') IS NULL
  ALTER TABLE [dbo].[publishers]
  ADD CONSTRAINT [DF__publisher__count__3D5E1FD2]
      DEFAULT ('USA') FOR [country];
GO
PRINT N'Creating primary key [UPKCL_pubind] on [dbo].[publishers]';
GO
ALTER TABLE [dbo].[publishers]
ADD CONSTRAINT [UPKCL_pubind]
  PRIMARY KEY CLUSTERED ([pub_id]);
GO
PRINT N'Altering [dbo].[titles]';
GO
IF Col_Length ('[dbo].[titles]', 'pub_id') IS NOT NULL
  ALTER TABLE [dbo].[titles]
  ALTER COLUMN [pub_id] [CHAR](4) COLLATE Latin1_General_CI_AS NULL;
GO
PRINT N'Adding constraints to [dbo].[titles]';
GO
IF Object_Id ('[DF__titles__type__403A8C7D]', 'D') IS NULL
  ALTER TABLE [dbo].[titles]
  ADD CONSTRAINT [DF__titles__type__403A8C7D]
      DEFAULT ('UNDECIDED') FOR [type];
GO
IF Object_Id ('[DF__titles__pubdate__09DE7BCC]', 'D') IS NULL
  ALTER TABLE [dbo].[titles]
  ADD CONSTRAINT [DF__titles__pubdate__09DE7BCC]
      DEFAULT (GetDate ()) FOR [pubdate];
GO
PRINT N'Creating trigger [dbo].[employee_insupd] on [dbo].[employee]';
GO
IF Object_Id ('[dbo].[employee_insupd]', 'TR') IS NULL
  EXEC ('CREATE TRIGGER [dbo].[employee_insupd] ON [dbo].[employee]
FOR INSERT, UPDATE AS BEGIN SET NOCOUNT ON end');
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
PRINT N'Altering [dbo].[pub_info]';
GO
IF Col_Length ('[dbo].[pub_info]', 'pub_id') IS NOT NULL
  ALTER TABLE [dbo].[pub_info]
  ALTER COLUMN [pub_id] [CHAR](4) COLLATE Latin1_General_CI_AS NOT NULL;
GO
PRINT N'Creating primary key [UPKCL_pubinfo] on [dbo].[pub_info]';
GO
IF Object_Id ('UPKCL_pubinfo', 'pk') IS NULL
  ALTER TABLE [dbo].[pub_info]
  ADD CONSTRAINT [UPKCL_pubinfo]
    PRIMARY KEY CLUSTERED ([pub_id]);
GO
PRINT N'Refreshing [dbo].[titleview]';
GO
IF Object_Id ('[dbo].[titleview]', 'V') IS NOT NULL
  EXEC sp_refreshview N'[dbo].[titleview]';
GO
PRINT N'Adding constraints to [dbo].[authors]';
GO
IF Object_Id ('[CK__authors__au_id__7F60ED59]', 'C') IS NULL
  ALTER TABLE [dbo].[authors]
  ADD CONSTRAINT [CK__authors__au_id__7F60ED59] CHECK (([au_id] LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'));
GO
IF Object_Id ('[CK__authors__zip__014935CB]', 'C') IS NULL
  ALTER TABLE [dbo].[authors]
  ADD CONSTRAINT [CK__authors__zip__014935CB] CHECK (([zip] LIKE '[0-9][0-9][0-9][0-9][0-9]'));
GO
PRINT N'Adding constraints to [dbo].[jobs]';
GO
IF Object_Id ('[CK__jobs__max_lvl__1DE57479]', 'C') IS NULL
  ALTER TABLE [dbo].[jobs]
  ADD CONSTRAINT [CK__jobs__max_lvl__1DE57479] CHECK (([max_lvl] <= (250)));
GO
IF Object_Id ('[CK__jobs__min_lvl__1CF15040]', 'C') IS NULL
  ALTER TABLE [dbo].[jobs]
  ADD CONSTRAINT [CK__jobs__min_lvl__1CF15040] CHECK (([min_lvl] >= (10)));
GO
PRINT N'Adding constraints to [dbo].[publishers]';
GO
IF Object_Id ('[CK__publisher__pub_i__0425A276]', 'C') IS NULL
  ALTER TABLE [dbo].[publishers]
  ADD CONSTRAINT [CK__publisher__pub_i__0425A276] CHECK (([pub_id] = '1756'
                                                       OR [pub_id] = '1622'
                                                       OR [pub_id] = '0877'
                                                       OR [pub_id] = '0736'
                                                       OR [pub_id] = '1389'
                                                       OR [pub_id] LIKE '99[0-9][0-9]'));
GO
PRINT N'Adding foreign keys to [dbo].[discounts]';
GO
IF Object_Id ('[dbo].[discounts]', 'F') IS NULL
  ALTER TABLE [dbo].[discounts]
  ADD CONSTRAINT [FK__discounts__stor___173876EA]
      FOREIGN KEY ([stor_id])
      REFERENCES [dbo].[stores] ([stor_id]);
GO
PRINT N'Adding foreign keys to [dbo].[employee]';
GO
IF Object_Id ('FK__employee__pub_id__286302EC', 'F') IS NULL
  ALTER TABLE [dbo].[employee]
  ADD CONSTRAINT [FK__employee__pub_id__286302EC]
      FOREIGN KEY ([pub_id])
      REFERENCES [dbo].[publishers] ([pub_id]);
GO
IF Object_Id ('FK__employee__job_id__25869641', 'F') IS NULL
  ALTER TABLE [dbo].[employee]
  ADD CONSTRAINT [FK__employee__job_id__25869641]
      FOREIGN KEY ([job_id])
      REFERENCES [dbo].[jobs] ([job_id]);
GO
PRINT N'Adding foreign keys to [dbo].[pub_info]';
GO
IF Object_Id ('FK__pub_info__pub_id__20C1E124', 'F') IS NULL
  ALTER TABLE [dbo].[pub_info]
  ADD CONSTRAINT [FK__pub_info__pub_id__20C1E124]
      FOREIGN KEY ([pub_id])
      REFERENCES [dbo].[publishers] ([pub_id]);
GO
PRINT N'Adding foreign keys to [dbo].[titles]';
GO
IF Object_Id ('FK__titles__pub_id__08EA5793', 'F') IS NULL
  ALTER TABLE [dbo].[titles]
  ADD CONSTRAINT [FK__titles__pub_id__08EA5793]
      FOREIGN KEY ([pub_id])
      REFERENCES [dbo].[publishers] ([pub_id]);
GO
PRINT N'Adding foreign keys to [dbo].[roysched]';
GO
IF Object_Id ('FK__roysched__title___15502E78', 'F') IS NULL
  ALTER TABLE [dbo].[roysched]
  ADD CONSTRAINT [FK__roysched__title___15502E78]
      FOREIGN KEY ([title_id])
      REFERENCES [dbo].[titles] ([title_id]);
GO
PRINT N'Adding foreign keys to [dbo].[titleauthor]';
GO
IF Object_Id ('FK__titleauth__au_id__0CBAE877', 'F') IS NULL
  ALTER TABLE [dbo].[titleauthor]
  ADD CONSTRAINT [FK__titleauth__au_id__0CBAE877]
      FOREIGN KEY ([au_id])
      REFERENCES [dbo].[authors] ([au_id]);
GO
IF Object_Id ('FK__titleauth__title__0DAF0CB0', 'F') IS NULL
  ALTER TABLE [dbo].[titleauthor]
  ADD CONSTRAINT [FK__titleauth__title__0DAF0CB0]
      FOREIGN KEY ([title_id])
      REFERENCES [dbo].[titles] ([title_id]);
GO
PRINT N'Adding constraints to [dbo].[authors]';
GO
IF Object_Id ('[DF__authors__phone__38996AB5]', 'D') IS NULL
  ALTER TABLE [dbo].[authors]
  ADD CONSTRAINT [DF__authors__phone__38996AB5]
      DEFAULT ('UNKNOWN') FOR [phone];
GO
PRINT N'Adding constraints to [dbo].[jobs]';
GO
IF Object_Id ('[DF__jobs__job_desc__1BFD2C07]', 'D') IS NULL
  ALTER TABLE [dbo].[jobs]
  ADD CONSTRAINT [DF__jobs__job_desc__1BFD2C07]
      DEFAULT ('New Position - title not formalized yet') FOR [job_desc];
GO
PRINT N'Altering extended properties';
GO

PRINT N'Altering permissions on TYPE:: [dbo].[empid]';
GO
IF EXISTS
  (SELECT 1 FROM sys.types WHERE name LIKE 'empid' AND is_user_defined = 1)
  GRANT REFERENCES ON TYPE::[dbo].[empid] TO [public];
GO
PRINT N'Altering permissions on TYPE:: [dbo].[id]';
GO
IF EXISTS
  (SELECT 1 FROM sys.types WHERE name LIKE 'id' AND is_user_defined = 1)
  GRANT REFERENCES ON TYPE::[dbo].[id] TO [public];
GO
PRINT N'Altering permissions on TYPE:: [dbo].[tid]';
GO
IF EXISTS
  (SELECT 1 FROM sys.types WHERE name LIKE 'tid' AND is_user_defined = 1)
  GRANT REFERENCES ON TYPE::[dbo].[tid] TO [public];
GO

