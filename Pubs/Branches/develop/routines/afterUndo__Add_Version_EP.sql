DECLARE @Version VARCHAR(20); -- the database version after a migration run. 
SELECT @Version=[version] --we need to find the greatest successful version.
  FROM ${flyway:defaultSchema}.flyway_schema_History -- 
  WHERE installed_rank = (SELECT Max(Installed_Rank) FROM ${flyway:defaultSchema}.flyway_schema_History WHERE success = 1);
PRINT N'Recording the database''s version number - '+@version;
DECLARE @Database NVARCHAR(3000);
SELECT @Database = N'${flyway:database}';
DECLARE @DatabaseInfo NVARCHAR(3000) =
          (
          SELECT @Database AS "Name", @Version AS "Version",
           N'${projectDescription}' AS "Description",
           N'${projectName}' AS "Project",
            GetDate() AS "Modified", SUser_Name() AS "by"
          FOR JSON PATH
          );

IF NOT EXISTS
	(
	SELECT fn_listextendedproperty.name, fn_listextendedproperty.value
	FROM sys.fn_listextendedproperty(
      N'Database_Info', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
      )
	)
	  EXEC sys.sp_addextendedproperty @name = N'Database_Info',
      @value = @DatabaseInfo;
   ELSE 
      EXEC sys.sp_updateextendedproperty @name = N'Database_Info',
      @value = @DatabaseInfo;

-- This next statement writes to the SQL Server Log so that the event is recorded
-- in the servers log, and if an event is defined, an alert can send a notification
-- and tools such as SQL Monitor can show this deployment.

--Do I, the user, have permission on this securable I want to use?
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    Declare @eventMessage AS nvarchar(2048)
    SET @eventMessage = N'Flyway deployed to ${flyway:database} to version '+@version+' on ${flyway:timestamp} as part of ${projectName}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
