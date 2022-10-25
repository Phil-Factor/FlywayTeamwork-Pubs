/* these views and functions are idempotent in that you can run the script over
and over again with the same result. This is done so it can be used in a 
flyway callback that does the essentail checks to create the schema if it 
doesn't already exist*/

/* what we used to do before CREATE OR ALTER */
IF (Object_Id ('util.TheFlywayVersion') IS NULL)
  EXEC ('CREATE FUNCTION util.TheFlywayVersion() RETURNS 
	@returntable TABLE (dummy char(1)) AS BEGIN RETURN END');
GO
alter FUNCTION util.TheFlywayVersion (@TheJSONData NVarchar(4000))
/* what we used to do before CREATE OR ALTER */
/**
Summary: >
  This returns a one-row table that tells us what the current
  flyway version is, and what the previous one was.
Author: Philip Hypotenuse Factor
Date: Thursday, 8 September 2022
Examples:
   - SELECT * FROM util.TheFlywayVersion(
       (SELECT [installed_rank] ,[version] ,[type], success 
	    FROM dbo.flyway_schema_history FOR JSON auto))
Returns: >
  Current_Version of database
   Current Type of migration
   Previous Version of database
   Previous Type of migration
   Last Action Type
**/
RETURNS @WhatHappened TABLE
  (Current_Version NVARCHAR(50) NULL,
   Current_Type NVARCHAR(20) NULL,
   Previous_Version NVARCHAR(50) NULL,
   Previous_Type NVARCHAR(20) NULL,
   Last_Action_Type NVARCHAR(20)  NULL)
AS
/*
-- To call this directly from a database, but you might also use SQL
-- executed by Flyway to call it
-- Call the routine by this way
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
	    FROM dbo.flyway_schema_history FOR JSON auto))
	end
*/

  /*define our variables */
  BEGIN



    DECLARE @Latest_Installed_Rank INT, @CurrentVersion NVARCHAR(50),
            @PreviousVersion NVARCHAR(50), @CurrentType NVARCHAR(20),
            @PreviousType NVARCHAR(20), @LastActionType NVARCHAR(20);

	DECLARE @flyway_schema_history TABLE (
	[installed_rank] [int] NOT NULL,
	[version] [nvarchar](50) NULL,
	[type] [nvarchar](20) NOT NULL,
	success bit)
	INSERT INTO @flyway_schema_history ([installed_rank] ,[version] ,[type], success)
		SELECT * FROM OpenJson (@TheJSONData) WITH ([installed_rank] [int],
	[version] [nvarchar](50),
	[type] [nvarchar](20),
	success bit) 


    /* we find out the last action taken, the version number and type*/


    SELECT @Latest_Installed_Rank = installed_rank,
           @CurrentVersion = version, @CurrentType = type,
           @LastActionType = type
      FROM @flyway_schema_history
      WHERE
      installed_rank =
        (SELECT Max (installed_rank) FROM @flyway_schema_history WHERE
         version IS NOT NULL); -- check for result of REPEATABLE 
    /* Now we assume that it was not an undo so we find out the version
number achieved by the last forward migration */
    SELECT @PreviousVersion = version, @PreviousType = type
      FROM @flyway_schema_history
      WHERE installed_rank =
        (SELECT Max (installed_rank)
           FROM flyway_schema_history
           WHERE
           installed_rank < @Latest_Installed_Rank AND type NOT LIKE 'UNDO%');
    /*oh. Complication it was an undo */
    IF (@CurrentType LIKE 'UNDO%')
      BEGIN
        /* in this case the previous version was that of the last forward migration */
        SELECT @PreviousVersion = version
          FROM @flyway_schema_history
          WHERE
          installed_rank =
            (SELECT Max (installed_rank) FROM flyway_schema_history WHERE
             type NOT LIKE 'UNDO%');
        /* in this case the current version is the one before the one in the
	entry that turned out to be an UNDO*/
        SELECT TOP 1 @CurrentVersion = version, @CurrentType = type
          FROM @flyway_schema_history
          WHERE
          Cast('/' + version + '/' AS HIERARCHYID) < 
		      Cast('/' + @CurrentVersion + '/' AS HIERARCHYID)
          ORDER BY installed_rank DESC;
      END;

    INSERT INTO @WhatHappened
      (Current_Version, Current_Type, Previous_Version, Previous_Type,
       Last_Action_Type)
    VALUES
      (@CurrentVersion,  -- Current_Version - nvarchar(50)
       @CurrentType,     -- Current_Type - nvarchar(20)
       @PreviousVersion, -- Previous_Version - nvarchar(50)
       @PreviousType,    -- Previous_Type - nvarchar(20)
       @LastActionType   -- Last_Action_Type - nvarchar(20)
      );
    RETURN;
  END;
GO



/* what we used to do before CREATE OR ALTER */
IF (Object_Id ('util.GetMostFrequentlyExecuted','VIEW') IS NULL)
  EXEC ('CREATE VIEW util.GetMostFrequentlyExecuted
	as 
	Select ''EMPTY'' as empty;')
GO
/**
Summary: >
  This Get most frequently executed queries for this database 
  (Query Execution Counts)
Author: Glen Berry https://glennsqlperformance.com/resources/
Date: Thursday, 8 September 2022
Examples:
   - Select [Short Query Text], [Execution Count] from util.GetMostFrequentlyExecuted
   -   SELECT *  FROM util.GetMostFrequentlyExecuted

**/


ALTER VIEW util.GetMostFrequentlyExecuted
as
SELECT TOP (50) LEFT(t.[text], 100) AS [Short Query Text],
                qs.execution_count AS [Execution Count],
                qs.total_logical_reads AS [Total Logical Reads],
                qs.total_logical_reads / qs.execution_count AS [Avg Logical Reads],
                qs.total_worker_time AS [Total Worker Time],
                qs.total_worker_time / qs.execution_count AS [Avg Worker Time],
                qs.total_elapsed_time AS [Total Elapsed Time],
                qs.total_elapsed_time / qs.execution_count AS [Avg Elapsed Time],
                CASE WHEN CONVERT (nvarchar(MAX), qp.query_plan) LIKE N'%<MissingIndexes>%' THEN
                     1 ELSE 0 END AS [Has Missing Index],
                qs.creation_time AS [Creation Time],
				t.[text] AS [Complete Query Text], 
				qp.query_plan AS [Query Plan]
  FROM
  sys.dm_exec_query_stats AS qs WITH (NOLOCK)
    CROSS APPLY sys.dm_exec_sql_text (plan_handle) AS t
    CROSS APPLY sys.dm_exec_query_plan (plan_handle) AS qp
  WHERE t.dbid = DB_ID ()
  ORDER BY qs.execution_count DESC;

  GO
 

/* what we used to do before CREATE OR ALTER */
IF (Object_Id ('util.LogSpaceUsage','VIEW') IS NULL)
  EXEC ('CREATE VIEW util.LogSpaceUsage
	as 
	Select ''EMPTY'' as empty ;')
GO
/**
Summary: >
  This view gets the Log space usage for current database
  Author: Glen Berry https://glennsqlperformance.com/resources/
Date: Thursday, 8 September 2022
Examples:
   - Select * from util.LogSpaceUsage
   -   SELECT [Database Name], [Recovery Model], [Used Log Space %]
         FROM util.LogSpaceUsage

**/
ALTER VIEW util.LogSpaceUsage
AS
  SELECT Db_Name (lsu.database_id) AS [Database Name],
         db.recovery_model_desc AS [Recovery Model],
         Cast(lsu.total_log_size_in_bytes / 1048576.0 AS DECIMAL(10, 2)) AS [Total Log Space (MB)],
         Cast(lsu.used_log_space_in_bytes / 1048576.0 AS DECIMAL(10, 2)) AS [Used Log Space (MB)],
         Cast(lsu.used_log_space_in_percent AS DECIMAL(10, 2)) AS [Used Log Space %],
         Cast(lsu.log_space_in_bytes_since_last_backup / 1048576.0 AS DECIMAL(10, 2)) 
			AS [Used Log Space Since Last Backup (MB)],
         db.log_reuse_wait_desc
    FROM
    sys.dm_db_log_space_usage AS lsu WITH (NOLOCK)
      INNER JOIN sys.databases AS db WITH (NOLOCK)
        ON lsu.database_id = db.database_id;
GO


/* what we used to do before CREATE OR ALTER */
IF (Object_Id ('util.UserSessions','VIEW') IS NULL)
  EXEC ('CREATE VIEW util.UserSessions
	as 
	Select ''EMPTY'' as empty ;')
GO
/**
Summary: >
  This view finds the users that are connected to the server 
  and says whether they are running anytrhing, and the number of sessions for each user.
  Author: Glen Berry https://glennsqlperformance.com/resources/
Date: Thursday, 8 September 2022
Examples:
   - Select * from util.UserSessions
  

**/
ALTER VIEW util.UserSessions AS 
SELECT login_name ,COUNT(session_id)AS session_count,  
	Min(status) AS User_Status, Sum(CPU_time) AS Total_CPU_Time 
FROM sys.dm_exec_sessions   
GROUP BY login_name;   
GO 

