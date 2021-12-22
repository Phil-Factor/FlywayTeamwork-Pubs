# run the library script, assuming it is in the project directory containing the script directory
if (Test-Path -path "..\..\common\DatabaseBuildAndMigrateTasks.ps1"-PathType Leaf)
    {
    . "..\..\common\DatabaseBuildAndMigrateTasks.ps1"
    }
else
    {
    . "..\DatabaseBuildAndMigrateTasks.ps1"
    }

#our regex for gathering variables from Flyway's URL
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w\-\.]{1,40})(?<port>:[\d]{1,4}|)(;.+databaseName=|/)(?<database>[\w]{1,20})'

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
	'ProjectFolder' = ''; #where all the migration files are
    'project' = ''; #the name of your project
    'projectDescription'=''; #a brief description of the project
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
$DatabaseDetails.ProjectFolder = $PWD.Path;


<#
this assumes that reports will go in "$($env:USERPROFILE)\Documents\GitHub\$(
		$param1.EscapedProject)\$($param1.Version)\Reports" but will return
        the path in the $DatabaseDetails if you need it. Set it to whatever
        you want
You will also need to set SQLCMD to the correct value. This is set by a string
$SQLCmdAlias in ..\DatabaseBuildAndMigrateTasks.ps1

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
)
Process-FlywayTasks $DatabaseDetails $PostMigrationInvocations

