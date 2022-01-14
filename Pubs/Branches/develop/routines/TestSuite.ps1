. '.\preliminary.ps1'



$PostMigrationInvocations = @(
	$GetCurrentVersion, #checks the database and gets the current version number
    #it does this by reading the Flyway schema history table. 
    $SaveDatabaseModelIfNecessary,
    #Save the model for this versiopn of the file
    $CreateBuildScriptIfNecessary,
    #checks the code in the database for any issues, using SQL Code Guard to do all the work
    $CheckCodeInDatabase, 
    <#checks to see if a Source folder already exists for this version of the
    database and, if not, it will create one and fill it with subdirectories for each
    type of object #>
    $CreateScriptFoldersIfNecessary,
    <#checks the code in the migration files for any issues, using SQL Code Guard  #>
    $CheckCodeInMigrationFiles,
    <#executes SQL that produces a report in XML or JSON from the databasethat alerts 
    you to tables that may have issues #>
    $ExecuteTableSmellReport,
    <# creates a json report of the documentation of every table and its
    columns. If you add or change tables, this can be subsequently used to update the 
    AfterMigrate callback script for the documentation. #>
    $ExecuteTableDocumentationReport,
    <# provides the flyway parameters. This is here because it is useful for the 
    community flyway when you wish to do further Flyway actions after doing any
    scripting and code checks. #>
    $FormatTheBasicFlywayParameters,
    <# uses SQL Compare to check that a version of a database is correct and hasn't been
    changed. To do this, the $CreateScriptFoldersIfNecessary task must have been run
    first. #>
    $IsDatabaseIdenticalToSource,
    <# this creates a first-cut UNDO script for the metadata (not the data) which can
    be adjusted and modified quickly to produce an UNDO Script. It does this by using
    SQL Compare to generate a  idepotentic script comparing the database with the 
    contents of the previous version.#>
    $CreateUndoScriptIfNecessary,
    <# This script creates a PUML file for a Gantt chart at the current version of the 
    database. This can be read into any editor that takes PlantUML files to give a Gantt
    chart #>
    $GeneratePUMLforGanttChart
)
Process-FlywayTasks $DBDetails $PostMigrationInvocations


