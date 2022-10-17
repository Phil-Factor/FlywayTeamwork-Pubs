
/* what we used to do before CREATE OR ALTER */
IF (Object_Id ('util.TablesByRowcount','VIEW') IS NULL)
  EXEC ('CREATE VIEW util.TablesByRowcount
	as 
	Select ''EMPTY'' as empty ;');
GO
/**
Summary: >
  This view Gets Table names, row counts, and compression status 
  for clustered index or heap .
  Author: Glen Berry https://glennsqlperformance.com/resources/
Date: Thursday, 8 September 2022
Examples:
   - Select * from util.UserSessions
  

**/
alter VIEW util.TablesByRowcount AS 
-- Get Table names, row counts, and compression status for clustered index or heap  (Query 69) (Table Sizes)
SELECT TOP 100 PERCENT Schema_Name(o.Schema_ID) AS [Schema Name], OBJECT_NAME(p.object_id) AS [ObjectName], 
SUM(p.Rows) AS [RowCount], p.data_compression_desc AS [Compression Type]
FROM sys.partitions AS p WITH (NOLOCK)
INNER JOIN sys.Tables AS o WITH (NOLOCK)
ON p.object_id = o.object_id
WHERE index_id < 2 --ignore the partitions from the non-clustered index if any
GROUP BY  SCHEMA_NAME(o.Schema_ID), p.object_id, data_compression_desc
ORDER BY SUM(p.Rows) DESC;
GO

IF (Char(36)+'{flyway:defaultSchema}.'+Char(36)+'{flyway:table}' <> '${flyway:defaultSchema}.${flyway:table}') 
	begin
	PRINT 'Executing this with flyway'
	EXEC ('
	SELECT * FROM util.TheFlywayVersion(
       (SELECT [installed_rank] ,[version] ,[type], success 
	    FROM  ${flyway:defaultSchema}.${flyway:table}  FOR JSON auto))')
	end
ELSE 
	begin
	PRINT 'Not executing this with flyway'
	SELECT * FROM util.TheFlywayVersion(
       (SELECT [installed_rank] ,[version] ,[type], success 
	    FROM util.flyway_schema_history FOR JSON auto))
	end
