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


The ". '.\preliminary.ps1" line that this callback startes with creates a DBDetails array.
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

Set-Alias SQLite  'C:\ProgramData\chocolatey\lib\SQLite\tools\sqlite-tools-win32-x86-3360000\sqlite3.exe' -Scope local

#test this alias

if (!(test-path  ((Get-alias -Name SQLite).definition) -PathType Leaf))
{ write-error 'The alias for SQLite is not set correctly yet' }

#get a JSON report of the history. We only want the record for the current version
try
{
	$report = Flyway info "-password=$($dbDetails.pwd)"  -outputType=json | convertFrom-json
	if ($report.error -ne $null) #if an error was reported by Flyway
	{
		#if an error (usually bad parameters) error out.
		$report.error | foreach { write-error  "$($_.errorCode): $($_.message)" }
	}
	if ($report.allSchemasEmpty) #if it is an empty database
	{ write-warning "all schemas of $database are empty. No version has been created here" }
}
catch
{
	$report.error = "We got an uncaught error from Flyway $($_.ScriptStackTrace)"
}

#looking good, so first get the paramaters that are not specific to the version
$RecordOfCurrentVersion = [pscustomobject]@{
	# get the global variables
	'Database' = $report.database;
	'Server' = $dbDetails.server;
	'RDBMS' = $dbDetails.RDBMS;
	'Schema names' = $report.schemaName;
	'Flyway Version' = $report.flywayVersion;
}
 # now add all the values from the record for the current version
$Report.migrations |
where { $_.version -eq $Report.schemaVersion } | select -Last 1 | foreach{
	$rec = $_; #remember this for gettinmg it's value
	$rec | gm -MemberType NoteProperty
} | foreach{
	# do each key/value pair in turn
	$RecordOfCurrentVersion |
	Add-Member -MemberType NoteProperty -Name $_.Name -Value $Rec.($_.Name)
}
if ($RecordOfCurrentVersion.state -ne 'Success')
{ write-error "Have you given the correct project folder?" }
#now all we have to do is to write it into the database if the record
#does not already exist
#in this case, we have only one record but we'll use a pipeline
#just for convenience.
$RecordOfCurrentVersion | foreach{
	sqlite "$($dbDetails.Resources)\flyway$($dbDetails.Project)$($dbDetails.branch)History.db" @"
CREATE TABLE IF NOT EXISTS 
Versions(
    Database Varchar(80),
    Server Varchar(80),
    RDBMS  Varchar(20),
    Schema_names Varchar(200),
    Flyway_Version Varchar(20),
    category Varchar(80),
    description Varchar(80),
    executionTime int,
    filepath  Varchar(200),
    installedBy Varchar(80),
    installedOn Varchar(25),
    installedOnUTC Varchar(25),
    state Varchar(80),
    type Varchar(10),
    undoable Varchar(5),
    version Varchar(80),
    PRIMARY KEY (Database, Server, RDBMS, Version))
;
INSERT INTO Versions( Database, Server, RDBMS, Schema_names,
Flyway_Version, category, description, executionTime,
filepath, installedBy, installedOn, installedOnUTC,
state, type, undoable, version) 
SELECT '$($_.Database)', '$($_.Server)', '$($_.RDBMS)', 
  '$($_.'Schema names')', '$($_.'Flyway Version')', '$($_.category)',
  '$($_.description)', '$($_.executionTime)', '$($_.filepath)',
  '$($_.installedBy)', '$($_.installedOn)', '$($_.installedOnUTC)',
  '$($_.state)', '$($_.type)', '$($_.undoable)', '$($_.version)'
WHERE NOT EXISTS(SELECT 1 FROM Versions
        WHERE Database='$($_.Database)' AND Server= '$($_.Server)' 
        AND RDBMS= '$($_.RDBMS)' AND version = '$($_.Version)'); 
"@  .exit
}
