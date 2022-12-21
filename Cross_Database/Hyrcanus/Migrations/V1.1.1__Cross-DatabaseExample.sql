-- USE Hyrcanus  (Flyway does this for you)
/* Script to demonstrate how to deal with mutual database dependencies
on the same server*/
-- create the very simplest of tables

/*--  start of the build script   --*/
-- create the first table
CREATE TABLE dbo.TheFirstTable (TheFirstColumn INT);
GO
-- create the second table
IF (Object_Id ('dbo.TheSecondTable', 'U') IS NOT NULL)
  DROP TABLE dbo.TheSecondTable;
  CREATE TABLE dbo.TheSecondTable
  (TheFirstColumn INT IDENTITY NOT NULL,
   CONSTRAINT pk_TheFirstTable_TheFirstColumn
     PRIMARY KEY CLUSTERED (TheFirstColumn),
   TheSecondColumn VARCHAR(20) NOT NULL);
GO
IF (Object_Id ('dbo.TheFirstView', 'v') IS NOT NULL)
  DROP view  dbo.TheFirstView;
GO
CREATE VIEW dbo.TheFirstView
AS
  SELECT TheFirstColumn, TheSecondColumn FROM Antigonus.dbo.TheThirdTable;
GO
