PRINT N'Dropping foreign keys from [dbo].[editions]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[dbo].[fk_Publication_Type]', 'F')
 AND parent_object_id = Object_Id (N'[dbo].[editions]', 'U'))
  ALTER TABLE [dbo].[editions] DROP CONSTRAINT [fk_Publication_Type];
GO
PRINT N'Dropping constraints from [dbo].[Publication_Types]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[dbo].[PK__Publicat__66D9D2B31F0370F8]', 'PK')
 AND parent_object_id = Object_Id (N'[dbo].[Publication_Types]', 'U'))
  ALTER TABLE [dbo].[Publication_Types]
  DROP CONSTRAINT [PK__Publicat__66D9D2B31F0370F8];
GO
PRINT N'Dropping [dbo].[Publication_Types]';
GO
IF Object_Id (N'[dbo].[Publication_Types]', 'U') IS NOT NULL
  DROP TABLE [dbo].[Publication_Types];
GO
PRINT N'Refreshing [dbo].[titles]';
GO
IF Object_Id (N'[dbo].[titles]', 'V') IS NOT NULL
  EXEC sp_refreshview N'[dbo].[titles]';
GO
PRINT N'Refreshing [dbo].[PublishersByPublicationType]';
GO
IF Object_Id (N'[dbo].[PublishersByPublicationType]', 'V') IS NOT NULL
  EXEC sp_refreshview N'[dbo].[PublishersByPublicationType]';
GO

IF Object_Id (N'[dbo].[TitlesAndEditionsByPublisher]', 'V') IS NOT NULL
  EXEC sp_executesql N'ALTER View [dbo].[TitlesAndEditionsByPublisher] AS Select ''nothing'' as first';
GO

