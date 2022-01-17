. '.\preliminary.ps1'


<#
        If a routine writes a report or script, it  will return
        the path in the $DbDetails if you need it. Set it to whatever
        you want
You will also need to set SQLCMD to the correct value. This is set by a string
$SQLCmdAlias in DatabaseBuildAndMigrateTasks.ps1 in 'resources'

in order to execute tasks, you just load them up in the order you want. It is like loading a 
revolver. 
#>
$PostMigrationInvocations = @(
	$FetchAnyRequiredPasswords, #checks the hash table to see if there is a username without a password.
    #if so, it fetches the password from store or asks you for the password if it is a new connection
	$GetCurrentVersion, #checks the database and gets the current version number
    #it does this by reading the Flyway schema history table. 
	$ExecuteTableDocumentationReport, #you'll need SQL Doc to do this. I'd like to do a generic version,
    #sparser but cross-database in nature with just the salient generic features.
	$CreateBuildScriptIfNecessary, #writes out a build script if there isn't one for this version. This
    #uses SQL Compare
	$CreateScriptFoldersIfNecessary, #writes out a source folder with an object level script if absent.
    #this uses SQL Compare
	$ExecuteTableSmellReport, #checks for table-smells
    #This is an example of generating a SQL-based report
	$ExecuteTableDocumentationReport, #publishes table docuentation as a json file that allows you to
    #fill in missing documentation. 
	$CheckCodeInDatabase, #does a code analysis of the code in the live database in its current version
    #This uses SQL Codeguard to do this
	$CheckCodeInMigrationFiles #does a code analysis of the code in the migration script
	$IsDatabaseIdenticalToSource # uses SQL Compare to check that a version of a database is correct
    $SaveDatabaseModelIfNecessary,
    #Save the model for this versiopn of the file
    $ExecuteTableSmellReport,
    <# creates a json report of the documentation of every table and its
    columns. If you add or change tables, this can be subsequently used to update the 
    AfterMigrate callback script for the documentation. #>
    $FormatTheBasicFlywayParameters,
    <# uses SQL Compare to check that a version of a database is correct and hasn't been
    changed. To do this, the $CreateScriptFoldersIfNecessary task must have been run
    first. #>
    $CreateUndoScriptIfNecessary,
    <# This script creates a PUML file for a Gantt chart at the current version of the 
    database. This can be read into any editor that takes PlantUML files to give a Gantt
    chart #>
    $GeneratePUMLforGanttChart
)
Process-FlywayTasks $DbDetails $PostMigrationInvocations

