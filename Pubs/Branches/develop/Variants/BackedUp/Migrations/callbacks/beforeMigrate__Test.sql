
IF (${MaybeBackup})
	BEGIN
	PRINT 'We are doing a Backup of ${flyway:database} because the maybeBackup placeholder is set to ${MaybeBackup} '
    END
ELSE
	BEGIN
	PRINT 'Forget about a backup of ${flyway:database} because the maybeBackup placeholder is set to ${MaybeBackup} '
    END
IF (${MaybeLogging}) 
	BEGIN
 	PRINT 'We are logging this migration of ${flyway:database} because the MaybeLogging placeholder is set to ${MaybeLogging} '
   END
ELSE
	BEGIN
	PRINT 'No logging of this migration run of ${flyway:database} because the MaybeLogging placeholder is set to ${MaybeLogging} '
    END   
IF (${MaybeTest}) 
	BEGIN
	PRINT 'We are gointg to test ${flyway:database} because the MaybeTest placeholder is set to ${MaybeTest} '
    END
else
	BEGIN
	PRINT 'We will forget about testing ${flyway:database} because the MaybeTest placeholder is set to ${MaybeTest} '
    END




