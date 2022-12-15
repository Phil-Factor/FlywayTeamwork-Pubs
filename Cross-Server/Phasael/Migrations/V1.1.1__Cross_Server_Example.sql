-- USE Antigonus; --Without Flyway we'd need to  switch to the database
/*--  start of Cleanup script to ensure that we start with an empty database  --*/
IF Object_Id ('dbo.Aristobulus_Hyrcanus_dbo_FirstTable', 'SN') IS NOT NULL
  DROP SYNONYM dbo.Aristobulus_Hyrcanus_dbo_FirstTable;
IF Object_Id ('dbo.Aristobulus_Hyrcanus_dbo_SecondTable', 'SN') IS NOT NULL
  DROP SYNONYM dbo.Aristobulus_Hyrcanus_dbo_SecondTable
/*-- end of Cleanup script   --*/
/*--  start of the build script   --*/
--build script for TheSecondDatabase

GO
CREATE TABLE dbo.ThirdTable
  (TheFirstColumn INT IDENTITY NOT NULL,
   CONSTRAINT pk_TheThirdTable_TheSecondColumn
     PRIMARY KEY CLUSTERED (TheFirstColumn),
   TheSecondColumn Varchar(20) NOT NULL);
GO
IF Object_Id ('tempdb..#dummy') IS NOT NULL SET NOEXEC ON;
CREATE TABLE #dummy (TheFirstColumn INT, TheSecondColumn INT);
GO
SET NOEXEC OFF;
CREATE SYNONYM dbo.Aristobulus_Hyrcanus_dbo_SecondTable
FOR #dummy;
GO
CREATE VIEW dbo.TheSecondView
AS
  SELECT TheSecondColumn FROM dbo.Aristobulus_Hyrcanus_dbo_SecondTable;
GO
DROP SYNONYM dbo.Aristobulus_Hyrcanus_dbo_SecondTable;
CREATE SYNONYM dbo.Aristobulus_Hyrcanus_dbo_SecondTable
FOR Aristobulus.Hyrcanus.dbo.TheSecondTable;
IF Object_Id ('tempdb..#dummy') IS NOT NULL SET NOEXEC ON;
GO
CREATE TABLE #dummy (TheFirstColumn INT, TheSecondColumn INT);
GO
SET NOEXEC OFF;
CREATE SYNONYM dbo.Aristobulus_Hyrcanus_dbo_FirstTable
FOR #dummy;
GO
CREATE VIEW dbo.TheThirdView
AS
  SELECT TheFirstColumn FROM dbo.Aristobulus_Hyrcanus_dbo_FirstTable;
GO
DROP SYNONYM dbo.Aristobulus_Hyrcanus_dbo_FirstTable;
CREATE SYNONYM dbo.Aristobulus_Hyrcanus_dbo_FirstTable
FOR Aristobulus.Hyrcanus.dbo.TheFirstTable;
