SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
PRINT N'Dropping foreign keys from [people].[WordOccurence]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.foreign_keys
     WHERE
     object_id = Object_Id (N'[people].[FKWordOccurenceWord]', 'F')
 AND parent_object_id = Object_Id (N'[people].[WordOccurence]', 'U'))
  ALTER TABLE people.WordOccurence DROP CONSTRAINT FKWordOccurenceWord;
GO
PRINT N'Dropping constraints from [people].[WordOccurence]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[PKWordOcurrence]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[WordOccurence]', 'U'))
  ALTER TABLE people.WordOccurence DROP CONSTRAINT PKWordOcurrence;
GO
PRINT N'Dropping constraints from [people].[Word]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[people].[PKWord]', 'PK')
 AND parent_object_id = Object_Id (N'[people].[Word]', 'U'))
  ALTER TABLE people.Word DROP CONSTRAINT PKWord;
GO
PRINT N'Dropping constraints from [people].[Word]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.columns
     WHERE
     name = N'frequency'
 AND object_id = Object_Id (N'[people].[Word]', 'U')
 AND default_object_id = Object_Id (
                           N'[people].[DF__Word__frequency__56E8E7AB]', 'D'))
  ALTER TABLE people.Word DROP CONSTRAINT DF__Word__frequency__56E8E7AB;
GO
PRINT N'Dropping [dbo].[FindString]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[dbo].[FindString]')
 AND (type = 'IF' OR type = 'FN' OR type = 'TF'))
  DROP FUNCTION dbo.FindString;
GO
PRINT N'Dropping [dbo].[FindWords]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[dbo].[FindWords]')
 AND (type = 'IF' OR type = 'FN' OR type = 'TF'))
  DROP FUNCTION dbo.FindWords;
GO
PRINT N'Dropping [dbo].[SearchNotes]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[dbo].[SearchNotes]')
 AND (type = 'IF' OR type = 'FN' OR type = 'TF'))
  DROP FUNCTION dbo.SearchNotes;
GO
PRINT N'Dropping [dbo].[IterativeWordChop]';
GO
IF EXISTS
  (SELECT 1
     FROM sys.objects
     WHERE
     object_id = Object_Id (N'[dbo].[IterativeWordChop]')
 AND (type = 'IF' OR type = 'FN' OR type = 'TF'))
  DROP FUNCTION dbo.IterativeWordChop;
GO
PRINT N'Dropping [people].[WordOccurence]';
GO
IF Object_Id (N'[people].[WordOccurence]', 'U') IS NOT NULL
  DROP TABLE people.WordOccurence;
GO
PRINT N'Dropping [people].[Word]';
GO
IF Object_Id (N'[people].[Word]', 'U') IS NOT NULL DROP TABLE people.Word;
GO
PRINT N'Altering extended properties';
GO
EXEC sp_updateextendedproperty N'Database_Info',
                               N'[{"Name":"Pubs","Version":"1.1.12","Description":"The Pubs (publishing) Database supports a fictitious publisher.","Modified":"2022-02-04T11:07:40.790","by":"PhilFactor"}]',
                               NULL, NULL, NULL, NULL, NULL, NULL;
GO
