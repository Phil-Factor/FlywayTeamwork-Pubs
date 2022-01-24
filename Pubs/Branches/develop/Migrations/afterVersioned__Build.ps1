. '.\preliminary.ps1'

<#To set off any task, all you need is a PowerShell script that is created in such a way that it can be
executed by Flyway when it finishes a migration run. Although you can choose any of the significant points
in any Flyway action, there are only one or two of these callback points that are useful to us.  
This can be a problem if you have several chores that need to be done in the same callback or you have a
stack of scripts all on the same callback, each having to gather up and process parameters, or pass 
parameters such as the current version from one to another. 

A callback script can’t be debugged as easily as an ordinary script. In this design, the actual callback 
just executes a list of tasks in order, and you simply add a task to the list after you’ve debugged 
and tested it & placed in the DatabaseBuildAndMigrateTasks.ps1 file.
with just one callback script

Each task is passed a standard ‘parameters’ object. This keeps the ‘complexity beast’ snarling in its lair.
The parameter object is passed by reference so each task can add value to the data in the object, 
such as passwords, version number, errors, warnings and log entries. 

All parameters are passed by Flyway. It does so by environment variables that are visible to the script.
You can access these directly, and this is probably best for tasks that require special information
passed by custom placeholders, such as the version of the RDBMS, or the current variant of the version 
you're building


The ". '.\preliminary.ps1" line that this callback startes withcreates a DBDetails array.
You can dump this array for debugging so that it is displayed by Flyway

$DBDetails|convertTo-json

these routines return the path they write to 
in the $DatabaseDetails if you need it.
You will also need to set SQLCMD to the correct value. This is set by a string
$SQLCmdAlias in ..\DatabaseBuildAndMigrateTasks.ps1

below are the tasks you want to execute. Some, like the on getting credentials, are essential befor you
execute others
in order to execute tasks, you just load them up in the order you want. It is like loading a 
revolver. 
#>
$PostMigrationTasks = @(
	$GetCurrentVersion, #checks the database and gets the current version number
    #it does this by reading the Flyway schema history table. 
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
	$CheckCodeInMigrationFiles, #does a code analysis of the code in the migration script
    #This uses SQL Codeguard to do this
	$IsDatabaseIdenticalToSource, # uses SQL Compare to check that a version of a database is correct
    #this makes sure that the target is at the version you think it is.
    $SaveDatabaseModelIfNecessary #writes out the database model
    #This writes out a model of the version for purposes of comparison, narrative and checking. 
    $CreateUndoScriptIfNecessary # uses SQL Compare
    #Creates a first-cut UNDo script. This is an idempotentic script that undoes to the previous version 
    $GeneratePUMLforGanttChart
    # This script creates a PUML file for a Gantt chart at the current version of the 
    #database. This can be read into any editor that takes PlantUML files to give a Gantt
    #chart 
            )
Process-FlywayTasks $DBDetails $PostMigrationTasks
