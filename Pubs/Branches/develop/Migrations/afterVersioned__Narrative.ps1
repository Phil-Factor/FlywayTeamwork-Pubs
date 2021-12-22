# run the library script, assuming it is in the project directory containing the script directory
if (Test-Path -path "..\..\common\DatabaseBuildAndMigrateTasks.ps1"-PathType Leaf)
    {
    . "..\..\common\DatabaseBuildAndMigrateTasks.ps1"
    }
else
    {
    . "..\DatabaseBuildAndMigrateTasks.ps1"
    }
# Before running this, you will need to have TheGloopDatabaseModel.sql in the same directory as 
# DatabaseBuildAndMigrateTasks.ps1

#this FLYWAY_URL contains the current database, port and server so
# it is worth grabbing
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
	'ProjectFolder' = Split-Path $PWD -Parent; #where all the migration files are
    'project' = $env:FP__projectName__; #the name of your project
    'schemas'=$env:FP__schemas__ # only needed if you are calling flyway
    'historyTable'="$($env:FP__flyway_defaultSchema__).$($env_FP__flyway_filename__ )";
    'projectDescription'=$env:FP__projectDescription__; #a brief description of the project
	'uid' = $env:FLYWAY_USER; #optional if you are using windows authewntication
	'pwd' = ''; #only if you use a uid. Leave blank. we fill it in for you
	'locations' = @{ }; # for reporting file locations used
	'problems' = @{ }; # for reporting any big problems
	'warnings' = @{ } # for reporting any issues
} # for reporting any warnings
#our regex for gathering variables from Flyway's URL
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w\-\.]{1,40})(?<port>:[\d]{1,4}|)(;.*databaseName=|/)(?<database>[\w]{1,20})'
$FlywayURLTruncationRegex ='jdbc:.{1,30}://.{1,30}(;|/)'
#this FLYWAY_URL contains the current database, port and server so
# it is worth grabbing
$ConnectionInfo = $env:FLYWAY_URL #get the environment variable
if ($ConnectionInfo -eq $null) #OMG... it isn't there for some reason
{  $internalLog+='missing value for flyway url'; $WeCanContinue=$false; }

$uid = $env:FLYWAY_USER;
$ProjectFolder = $PWD.Path;

if ($ConnectionInfo -imatch $FlywayURLRegex) #This copes with having no port.
{#we can extract all the info we need
	$DatabaseDetails.RDBMS = $matches['RDBMS'];
	$DatabaseDetails.server = $matches['server'];
	$DatabaseDetails.port = $matches['port'];
	$DatabaseDetails.database = $matches['database']
}
elseif ($ConnectionInfo -imatch 'jdbc:(?<RDBMS>[\w]{1,20}):(?<database>[\w:\\]{1,80})')
{#no server or port
	$DatabaseDetails.RDBMS = $matches['RDBMS'];
	$DatabaseDetails.server = 'LocalHost';
	$DatabaseDetails.port = 'default';
	$DatabaseDetails.database = $matches['database']
}
else
 {
	$DatabaseDetails.RDBMS = 'sqlserver';
	$DatabaseDetails.server = 'LocalHost';
	$DatabaseDetails.port = 'default';
	$DatabaseDetails.database = $env:FP__flyway_database__;
	$internalLog+='unmatched connection info'
 }

<#
this assumes that reports will go in "$($env:USERPROFILE)\Documents\GitHub\$(
$param1.EscapedProject)\$($param1.Version)\Reports" but will return
the path in the $DatabaseDetails if you need it. Set it to whatever
you want in ..\DatabaseBuildAndMigrateTasks.ps1

You will also need to set SQLCMD to the correct value. This is set by a string
$SQLCmdAlias in ..\DatabaseBuildAndMigrateTasks.ps1

in order to execute tasks, you just load them up in the order you want. It is like loading a 
revolver. 
#>
if ($InternalLog) {if ($InternalLog.count -gt 0) {$InternalLog|foreach{write-warning "$_"}}}

$PostMigrationInvocations = @(
	$FetchAnyRequiredPasswords, #checks the hash table to see if there is a username without a password.
    #if so, it fetches the password from store or asks you for the password if it is a new connection
	$GetCurrentVersion, #checks the database and gets the current version number
    #it does this by reading the Flyway schema history table. 
    $SaveDatabaseModelIfNecessary
    #Save the model for this versiopn of the file
)
Process-FlywayTasks $DatabaseDetails $PostMigrationInvocations

