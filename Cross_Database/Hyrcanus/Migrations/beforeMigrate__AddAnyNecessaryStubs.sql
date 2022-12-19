/*-- start of build script for TheFirstDatabase  --*/
--build script for TheSecondDatabase
USE Antigonus
-- create Antigonus.dbo.ThirdTable
IF (Object_Id('dbo.TheThirdTable') IS NULL) 
	BEGIN
    CREATE TABLE dbo.TheThirdTable 
  (
  TheFirstColumn INT IDENTITY NOT NULL,
  TheSecondColumn int NOT null
  )
	exec sp_addextendedproperty  
     @name = N'DeleteMe' 
    ,@value = N'Temporary stub' 
    ,@level0type = N'Schema', @level0name = 'dbo' 
    ,@level1type = N'Table',  @level1name = 'TheThirdTable'
	end
GO
USE Hyrcanus; 
IF (Object_Id('dbo.TheSecondTable') IS NULL) 
	BEGIN
    CREATE TABLE dbo.TheSecondTable
  (
  TheFirstColumn INT IDENTITY NOT NULL,
  TheSecondColumn int NOT NULL
  )
	EXEC sp_addextendedproperty  
     @name = N'DeleteMe' 
    ,@value = N'Temporary stub' 
    ,@level0type = N'Schema', @level0name = 'dbo' 
    ,@level1type = N'Table',  @level1name = 'TheSecondTable' 	

	end
GO
--views can't be created in other databases 
IF (Object_Id('dbo.TheFirstView') IS NULL)  
	BEGIN --CREATE VIEW must be first in the batch. one can use the NOEXEC trick
	PRINT 'creating stub for dbo.TheFirstView on Hyrcanus'
	EXECUTE ('CREATE VIEW dbo.TheFirstView
AS SELECT 1 as TheFirstcolumn,''dummyColumn'' as TheSecondcolumn') 
	exec sp_addextendedproperty  
     @name = N'DeleteMe' 
    ,@value = N'Temporary stub' 
    ,@level0type = N'Schema', @level0name = 'dbo' 
    ,@level1type = N'View',  @level1name = 'TheFirstView' 	
	END
