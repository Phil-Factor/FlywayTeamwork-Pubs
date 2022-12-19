

/* Script to demonstrate how to deal with mutual database dependencies
on the same server*/
-- create the very simplest of tables
CREATE TABLE dbo.TheFirstTable (TheFirstColumn INT);
GO
-- and a second one with an index
CREATE TABLE dbo.TheSecondTable
  (TheFirstColumn INT IDENTITY NOT NULL,
   CONSTRAINT pk_TheSecondTable_TheFirstColumn
     PRIMARY KEY CLUSTERED (TheFirstColumn),
   TheSecondColumn INT NOT NULL);
GO
--drop the stub if it exists
IF (Object_Id ('dbo.TheThirdTable', 'U') IS NOT NULL)
  DROP TABLE dbo.TheThirdTable;
-- and a third one with an index
CREATE TABLE dbo.TheThirdTable
  (TheFirstColumn INT IDENTITY NOT NULL,
   CONSTRAINT pk_TheThirdTable_TheFirstColumn
     PRIMARY KEY CLUSTERED (TheFirstColumn),
   TheSecondColumn INT NOT NULL);
GO
-- and a view that references hyrcanus
CREATE VIEW dbo.TheSecondView
AS
  SELECT TheSecondColumn FROM Hyrcanus.dbo.TheSecondTable;
GO
-- and a second view, this one referencing a view
CREATE VIEW TheThirdView
AS
  SELECT ThefirstColumn FROM Hyrcanus.dbo.TheFirstView;
GO
