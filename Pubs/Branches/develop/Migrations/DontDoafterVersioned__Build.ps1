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


run the library script, assuming it is in the project directory containing the script directory #>
# run the library script, assuming it is in the project directory containing the script directory
if (Test-Path -path "..\..\common\DatabaseBuildAndMigrateTasks.ps1"-PathType Leaf)
    {
    . "..\..\common\DatabaseBuildAndMigrateTasks.ps1"
    }
else
    {
    . "..\DatabaseBuildAndMigrateTasks.ps1"
    }

<# The most useful data passed to this script by Flyway is the URL that you used to call Flyway. This
is likely to tell you the server, port, database and the type of database (RDBMS). We can use the URL
if we just want to make JDBC calls. We can't and don't. Instead we extract the connection details
and use these. #>
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w\-\.]{1,40})(?<port>:[\d]{1,4}|)(;.+databaseName=|/)(?<database>[\w]{1,20})'

#this FLYWAY_URL contains the current database, port and server so it is worth grabbing
$ConnectionInfo = $env:FLYWAY_URL #get the environment variable
if ($ConnectionInfo -eq $null) #OMG... it isn't there for some reason
{ Write-error 'missing value for flyway url' }
<# a reference to this Hashtable is passed to each process (it is a scriptBlock)
so as to make debugging easy. We'll be a bit cagey about adding key-value pairs
as it can trigger the generation of a copy which can cause bewilderment and 
problems- values don't get passed back. 
Don't fill anything in here!!! The script does that for you#>
$DatabaseDetails = @{
    'RDBMS'=''; # necessary for systems with several RDBMS on the same server
	'server' = ''; #the name of your server
	'database' = ''; #the name of the database
	'version' = ''; #the version
	'ProjectFolder' = ''; #where all the migration files are
    'project' = ''; #the name of your project
    'projectDescription'=''; #a brief description of the project
    'flywayTable'='';#The name and schema of the flyway Table
	'uid' = ''; #optional if you are using windows authewntication
	'pwd' = ''; #only if you use a uid. Leave blank. we fill it in for you
	'locations' = @{ }; # for reporting file locations used
	'problems' = @{ }; # for reporting any big problems
	'warnings' = @{ } # for reporting any issues
} # for reporting any warnings

if ($ConnectionInfo -imatch $FlywayURLRegex)
{
	$DatabaseDetails.RDBMS = $matches['RDBMS'];
	$DatabaseDetails.server = $matches['server'];
	$DatabaseDetails.port = $matches['port'];
	$DatabaseDetails.database = $matches['database']
}
else
{ write-error "failed to obtain the value of the RDBMS, server, Port or database from the FLYWAY_URL" }

$DatabaseDetails.uid = $env:FLYWAY_USER;
$DatabaseDetails.Project = $env:FP__projectName__;
$DatabaseDetails.ProjectDescription = $env:FP__projectDescription__;
$DatabaseDetails.ProjectFolder = split-path $PWD.Path -Parent;
if ($env:FP__flyway_defaultSchema__ -ne $null -and $env:FP__flyway_table__ -ne $null)
    {$DatabaseDetails.flywayTable="$($env:FP__flyway_defaultSchema__).$($env:FP__flyway_table__)"}
    else
    {$DatabaseDetails.flywayTable='dbo.flyway_schema_history'};
<#
You can dump this array for debugging so that it is displayed by Flyway

$DatabaseDetails|convertTo-json

these routines write to  reports  in "$($env:USERPROFILE)\Documents\GitHub\$(
		$param1.EscapedProject)\$($param1.Version)\Reports" and will return
        the path in the $DatabaseDetails if you need it. Set it to whatever
        you want in the file DatabaseBuildAndMigrateTasks.ps1
You will also need to set SQLCMD to the correct value. This is set by a string
$SQLCmdAlias in ..\DatabaseBuildAndMigrateTasks.ps1

below are the tasks you want to execute. Some, like the on getting credentials, are essential befor you
execute others
in order to execute tasks, you just load them up in the order you want. It is like loading a 
revolver. 
#>
$PostMigrationTasks = @(
	$FetchAnyRequiredPasswords, #checks the hash table to see if there is a username without a password.
    #if so, it fetches the password from store or asks you for the password if it is a new connection
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
    )
Process-FlywayTasks $DatabaseDetails $PostMigrationTasks
