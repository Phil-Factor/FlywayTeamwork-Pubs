# load the script preliminary script 
if ($Env:FlywayWorkPath -eq $null) {
  write-warning 'this script needs the environment variable FlywayWorkPath to be set' -WarningAction Stop}
. "$Env:FlywayWorkPath\Scripts\preliminary.ps1"

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
    $SaveDatabaseModelIfNecessary, #writes out the database model
	$CreateBuildScriptIfNecessary, #writes out a build script if there isn't one for this version. This
	$CreateScriptFoldersIfNecessary, #writes out a source folder with an object level script if absent.
    $CreateVersionNarrativeIfNecessary,# create a version narrative 
    $WriteOutERDiagramCode# and a PUML database diagram
    
    #This writes out a model of the version for purposes of comparison, narrative and checking. 
            )
Process-FlywayTasks $DBDetails $PostMigrationTasks

