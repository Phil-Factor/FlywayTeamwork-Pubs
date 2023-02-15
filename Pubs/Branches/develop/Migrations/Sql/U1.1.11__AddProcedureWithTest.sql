IF Object_Id ('[dbo].[SplitStringToWords]', 'TF') IS NOT NULL
  BEGIN
    PRINT N'Dropping [dbo].[SplitStringToWords]';
    DROP FUNCTION [dbo].[SplitStringToWords];
  END;
PRINT N'Altering extended properties';
GO
