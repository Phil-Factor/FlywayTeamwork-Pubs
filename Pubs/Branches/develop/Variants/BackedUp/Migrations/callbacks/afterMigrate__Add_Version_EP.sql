DECLARE @Version VARCHAR(20); -- the database version after a migration run. 
SELECT @Version=[version] -- we need to find the greatest successful version.
  FROM ${flyway:defaultSchema}.${flyway:table}  -- 
  WHERE installed_rank = (SELECT Max(Installed_Rank) FROM ${flyway:defaultSchema}.${flyway:table}  WHERE success = 1 AND version IS NOT null
);
-- read out the version number of the latest successful migration to cope with UNDOs etc
PRINT N'Recording the database''s version number - '+@version;
DECLARE @Database NVARCHAR(3000);
SELECT @Database = N'${flyway:database}';
-- Now save the version number as a JSON document in the extended properties of the database
-- so that we don't have to query the database and get the actual user who did the migration
DECLARE @DatabaseInfo NVARCHAR(3000) = --the json document
          (
          SELECT @Database AS "Name", @Version AS "Version",
           N'${projectDescription}' AS "Description",
           N'${projectName}' AS "Project",
            GetDate() AS "Modified", SUser_Name() AS "by"
          FOR JSON PATH
          );

IF NOT EXISTS
	(--does it exist
	SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
	FROM sys.fn_listextendedproperty(
      N'Database_Info', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
      )
	)-- create a new extended property
	  EXEC sys.sp_addextendedproperty @name = N'Database_Info',
      @value = @DatabaseInfo;
   ELSE --alter the existing property
      EXEC sys.sp_updateextendedproperty @name = N'Database_Info',
      @value = @DatabaseInfo;

-- This next statement writes to the SQL Server Log so that the event is recorded
-- in the servers log, and if an event is defined, an alert can send a notification
-- and tools such as SQL Monitor can show this deployment.

--Do I, the user, have permission on this securable I want to use?
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    Declare @eventMessage AS nvarchar(2048)
    SET @eventMessage = N'Flyway deployed to ${flyway:database} to version '+
	              @version+' on ${flyway:timestamp} as part of ${projectName}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
