# run the library script, assuming it is in the project directory containing the script directory
if (Test-Path -path "..\..\common\DatabaseBuildAndMigrateTasks.ps1"-PathType Leaf)
    {
    . "..\..\common\DatabaseBuildAndMigrateTasks.ps1"
    }
else
    {
    . "..\DatabaseBuildAndMigrateTasks.ps1"
    }
<#To set off any task, all you need is a PowerShell script that is created in such a way that it can be executed by Flyway when it finishes a migration run. Although you can choose any of the significant points in any Flyway action, there are only one or two of these callback points that are useful to us.  This can be a problem if you have several chores that need to be done in the same callback or you have a stack of scripts all on the same callback, each having to gather up and process parameters, or pass parameters such as the current version from one to another. 

 The most useful data passed to this script by Flyway is the URL that you used to call Flyway. This is likely to tell you the server, port, database and the type of database (RDBMS). We can use the URL. If we just want to make JDBC calls. We can't and don't. Instead we extract the connection details and use these. 

This is just to pull in the SCA cmdlets required to execute new-DatabaseReleaseArtifact #>
write-verbose "Importing SCA"
Import-Module SqlChangeAutomation
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w\-\.]{1,40})(?<port>:[\d]{1,4}|)(;.+databaseName=|/)(?<database>[\w]{1,20})'
#the FLYWAY_URL contains the current database, port and server so it is worth grabbing
$ConnectionInfo = $env:FLYWAY_URL #get the environment variable
if ($ConnectionInfo -eq $null) #OMG... it isn't there for some reason
{ Write-error 'missing value for flyway url' }
<# a reference to this Hashtable is passed to each process (it is a scriptBlock) so as to make debugging easy. We'll be a bit cagey about adding key-value pairs as it can trigger the generation of a copy which can cause bewilderment and problems- values don't get passed back. 

Don't fill anything in here!!! The script does that for you#>
$DatabaseDetails = @{
	'RDBMS' = ''; # necessary for systems with several RDBMS on the same server
	'server' = ''; #the name of your server
	'database' = ''; #the name of the database
	'version' = ''; #the version
	'ProjectFolder' = ''; #where all the migration files are
	'project' = ''; #the name of your project
	'projectDescription' = ''; #a brief description of the project
	'flywayTable' = ''; #The name and schema of the flyway Table
	'uid' = ''; #optional if you are using windows authewntication
	'pwd' = ''; #only if you use a uid. Leave blank. we fill it in for you
	'locations' = @{ }; # for reporting file locations used
	'problems' = @{ }; # for reporting any big problems
	'warnings' = @{ } # for reporting any issues
} # for reporting any warnings
write-verbose "Getting values from JDBC connection info"
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
$DatabaseDetails.ProjectFolder = split-path "$($PWD.Path)" -Parent;
if ($env:FP__flyway_defaultSchema__ -ne $null -and $env:FP__flyway_table__ -ne $null)
{ $DatabaseDetails.flywayTable = "$($env:FP__flyway_defaultSchema__).$($env:FP__flyway_table__)" }
else
{ $DatabaseDetails.flywayTable = 'dbo.flyway_schema_history' };

<# Now we need to get the credentials, and the current version of the flyway database#>
$PostMigrationInvocations = @(
	$FetchAnyRequiredPasswords, #checks the hash table to see if there is a username without a password.
	#if so, it fetches the password from store or asks you for the password if it is a new connection
	$GetCurrentVersion) #checks the database and gets the current version number
#it does this by reading the Flyway schema history table. 
write-verbose "Finding version number"
Process-FlywayTasks $DatabaseDetails $PostMigrationInvocations
# the version and password is now in the $DatabaseDetails array4
write-verbose "preparing SCA call"
$EscapedProject = ($DatabaseDetails.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'

$CurrentPathToWorkingFiles = "$($env:USERPROFILE)\$ReportLocation$($EscapedProject)\$($DatabaseDetails.Version)";

$SourceConnectionString = "Server=$($matches['server']);Database=$($matches['database']);User Id=$($env:FLYWAY_USER);Password=$($DatabaseDetails.pwd);Persist Security Info=False"
write-verbose "Creating directories if necessary"
<# If the scripts directory isn't there ... #>
if (-not (Test-Path "$CurrentPathToWorkingFiles\scripts" -PathType Container))
{<# ..then create the scripts directory #>
	$null = New-Item -ItemType Directory -Path "$CurrentPathToWorkingFiles\scripts" -Force
}
<# If the source directory isn't there ... #>
if (-not (Test-Path "$CurrentPathToWorkingFiles\source" -PathType Container))
{<# ..then create the source directory #>
	$null = New-Item -ItemType Directory -Path "$CurrentPathToWorkingFiles\source" -Force
}
if (-not (Test-Path "$CurrentPathToWorkingFiles\source\*" -PathType Leaf))
{
	#only do this once ... 
	# create a release artefact and fill the source directory 
	write-verbose "creating the release artefact"
	$iReleaseArtifact = new-DatabaseReleaseArtifact -Source $SourceConnectionString -Target "$CurrentPathToWorkingFiles\source" 
    # it will fill the blank source directory
	#export a build script
	write-verbose "Creating build script"
	$iReleaseArtifact.UpdateSQL> "$CurrentPathToWorkingFiles\Scripts\V$($DatabaseDetails.Version)__Build.SQL"
	#export a detailed report of code issues
	write-verbose "Creating detailed code report"
    if (-not (Test-Path "$CurrentPathToWorkingFiles\Reports" -PathType Container))
        {<# ..then create the scripts directory #>
	$null = New-Item -ItemType Directory -Path "$CurrentPathToWorkingFiles\Reports" -Force
    }
	$iReleaseArtifact.CodeAnalysisResult.Issues>"$CurrentPathToWorkingFiles\Reports\DetailCodeIssues.txt"
	#export a summary report of code issues
	write-verbose "Creating summary code report"
	$iReleaseArtifact.CodeAnalysisResult.issues | sort-Object  @{ expression = { $_.CodeAnalysisSelection.LineStart } } |
	select CodeAnalysisSelection, IssueCodeName, ShortDescription >"$CurrentPathToWorkingFiles\Reports\SummaryCodeIssues.txt"
	#export a release artifact that can be used to compare release objects
	write-verbose "Saving release artefact"
	$iReleaseArtifact | Export-DatabaseReleaseArtifact -path "$CurrentPathToWorkingFiles\Artifact"
	#add to reports what is in the version, including objects and code issues
    Copy-Item -Path "$CurrentPathToWorkingFiles\Artifact\Reports\*" -Destination "$CurrentPathToWorkingFiles\reports" -force
    Copy-Item -Path "$CurrentPathToWorkingFiles\Artifact\States\Source\*" -Destination "$CurrentPathToWorkingFiles\source" -recurse -force
    Remove-Item -Path "$CurrentPathToWorkingFiles\Artifact" -Force -Recurse   
}