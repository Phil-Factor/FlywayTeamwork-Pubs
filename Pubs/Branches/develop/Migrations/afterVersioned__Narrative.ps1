. '.\preliminary.ps1'

$PostMigrationInvocations = @(
	$GetCurrentVersion, #checks the database and gets the current version number
    #it does this by reading the Flyway schema history table. 
    $SaveDatabaseModelIfNecessary
    #Save the model for this versiopn of the file
)
Process-FlywayTasks $DBDetails $PostMigrationInvocations

