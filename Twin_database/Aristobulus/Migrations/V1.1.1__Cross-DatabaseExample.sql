/*-- start of Cleanup script for TheFirstDatabase  --*/
IF Object_Id('dbo.Phasael_Antigonus_dbo_ThirdTable', 'SN') IS NOT null
drop SYNONYM dbo.Phasael_Antigonus_dbo_ThirdTable
IF Object_Id('dbo.Phasael_Antigonus_dbo_SecondView', 'SN') IS NOT null
drop SYNONYM dbo.Phasael_Antigonus_dbo_SecondView
/*-- end of Cleanup script   --*/
-- USE Hyrcanus  (Flyway does this for you
/*--  start of the build script   --*/
-- create the first table
CREATE TABLE dbo.TheFirstTable (TheFirstColumn INT);
GO
-- create the second table
CREATE TABLE dbo.TheSecondTable
  (
  TheFirstColumn INT IDENTITY NOT NULL,
  CONSTRAINT pk_TheFirstTable_TheFirstColumn PRIMARY KEY CLUSTERED
    (TheFirstColumn),
  TheSecondColumn varchar(20) NOT null
  );
GO
-- build the view 'TheFirstView' in two simple stages
-- firsat a stub. This is the 'stub' that we can use to prevent errors
IF Object_Id('tempdb..#dummy') IS NOT NULL SET NOEXEC ON
CREATE table #dummy
(TheFirstColumn int,TheSecondColumn INT)
GO
SET NOEXEC off
-- now we deal with the objects that have cross-server references
CREATE synonym dbo.Phasael_Antigonus_dbo_ThirdTable FOR #dummy
go
Create VIEW dbo.TheFirstView
AS
SELECT TheSecondColumn FROM dbo.Phasael_Antigonus_dbo_ThirdTable;
GO
-- we can't change a synonym, so we recreate it
drop synonym dbo.Phasael_Antigonus_dbo_ThirdTable
create synonym dbo.Phasael_Antigonus_dbo_ThirdTable 
  FOR Phasael.Antigonus.dbo.ThirdTable
-- end of the build of the view 'TheFirstView'

--build the view ThefourthView 
IF Object_Id('tempdb..#dummy') IS NOT NULL SET NOEXEC ON
CREATE table #dummy
(TheFirstColumn int,TheSecondColumn INT)
GO
SET NOEXEC OFF

CREATE synonym dbo.Phasael_Antigonus_dbo_SecondView FOR #dummy
GO
CREATE VIEW ThefourthView AS
SELECT ThefirstColumn FROM dbo.Phasael_Antigonus_dbo_SecondView;
GO
-- we can't change a synonym, so we recreate it
drop synonym dbo.Phasael_Antigonus_dbo_SecondView
CREATE synonym dbo.Phasael_Antigonus_dbo_SecondView 
  FOR Phasael.Antigonus.dbo.SecondView 
-- end of the build of the view 'TSecondView'
DROP TABLE #dummy
