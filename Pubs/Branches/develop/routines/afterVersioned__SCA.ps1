. '.\preliminary.ps1'

<#To set off any task, all you need is a PowerShell script that is created in such a way that it can be
executed by Flyway when it finishes a migration run. Although you can choose any of the significant points
in any Flyway action, there are only one or two of these callback points that are useful to us.  
This can be a problem if you have several chores that need to be done in the same callback or you have a
stack of scripts all on the same callback, each having to gather up and process parameters, or pass 
parameters such as the current version from one to another. 

A callback script can't be debugged as easily as an ordinary script. In this design, the actual callback 
just executes a list of tasks in order, and you simply add a task to the list after you've debugged 
and tested it & placed in the DatabaseBuildAndMigrateTasks.ps1 file.
with just one callback script

Each task is passed a standard 'parameters' object. This keeps the 'complexity beast' snarling in its lair.
The parameter object is passed by reference so each task can add value to the data in the object, 
such as passwords, version number, errors, warnings and log entries. 

All parameters are passed by Flyway. It does so by environment variables that are visible to the script.
You can access these directly, and this is probably best for tasks that require special information
passed by custom placeholders, such as the version of the RDBMS, or the current variant of the version 
you're building


The ". '.\preliminary.ps1" line that this callback starts with creates a DBDetails array.
You can dump this array for debugging so that it is displayed by Flyway

$DBDetails|convertTo-json

these routines return the path they write to 
in the $DBDetails if you need it.
You will also need to set SQLCMD to the correct value. This is set by a string
$SQLCmdAlias in ..\DatabaseBuildAndMigrateTasks.ps1

below are the tasks you want to execute. Some, like the on getting credentials, are essential befor you
execute others
in order to execute tasks, you just load them up in the order you want. It is like loading a 
revolver. 
#>
<# Now we need to get the credentials, and the current version of the flyway database#>
$PostMigrationInvocations = @(
	$GetCurrentVersion) #checks the database and gets the current version number
#it does this by reading the Flyway schema history table. 
write-verbose "Finding version number"
Process-FlywayTasks $DBDetails $PostMigrationInvocations
# the version and password is now in the $DBDetails array4
write-verbose "preparing SCA call"
if (!([string]::IsNullOrEmpty($ReportDirectory)))
{
	$EscapedProject = ($DBDetails.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'
	$CurrentPathToWorkingFiles = "$($env:USERPROFILE)\$ReportDirectory$($EscapedProject)\$($DBDetails.Version)";
}
else
{ $CurrentPathToWorkingFiles = "$ReportLocation\$($DBDetails.Version)" }

$SourceConnectionString = "Server=$($dbDetails.server);Database=$($dbDetails.database);User Id=$($dbDetails.uid);Password=$($DBDetails.pwd);Persist Security Info=False"
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


 
if (-not (Test-Path "$CurrentPathToWorkingFiles\Scripts\V$($DbDetails.Version)__Build.SQL" -PathType Leaf))
{
	#export a build script
	write-verbose "Creating build script"
    if ($iReleaseArtifact -eq $null)
    {
        write-verbose "creating the release artefact"
	    $iReleaseArtifact = new-DatabaseReleaseArtifact -Source $SourceConnectionString -Target "$CurrentPathToWorkingFiles\source"
    }
	$iReleaseArtifact.UpdateSQL> "$CurrentPathToWorkingFiles\Scripts\V$($DbDetails.Version)__Build.SQL"
	#export a detailed report of code issues
}

if (-not (Test-Path "$CurrentPathToWorkingFiles\Reports\DetailCodeIssues.txt" -PathType Leaf))
{
	write-verbose "Creating detailed code report"
	if (-not (Test-Path "$CurrentPathToWorkingFiles\Reports" -PathType Container))
	{<# ..then create the scripts directory #>
		$null = New-Item -ItemType Directory -Path "$CurrentPathToWorkingFiles\Reports" -Force
	}
    if ($iReleaseArtifact -eq $null)
        {
        write-verbose "creating the release artefact"
	    $iReleaseArtifact = new-DatabaseReleaseArtifact -Source $SourceConnectionString -Target "$CurrentPathToWorkingFiles\source"
        }
	$iReleaseArtifact.CodeAnalysisResult.Issues>"$CurrentPathToWorkingFiles\Reports\DetailCodeIssues.txt"
	#export a summary report of code issues
}

if (-not (Test-Path "$CurrentPathToWorkingFiles\Reports\SummaryCodeIssues.txt" -PathType Leaf))
{
	write-verbose "Creating summary code report"
   if ($iReleaseArtifact -eq $null)
        {
        write-verbose "creating the release artefact"
	    $iReleaseArtifact = new-DatabaseReleaseArtifact -Source $SourceConnectionString -Target "$CurrentPathToWorkingFiles\source"
        }
	$iReleaseArtifact.CodeAnalysisResult.issues | sort-Object  @{ expression = { $_.CodeAnalysisSelection.LineStart } } |
	select CodeAnalysisSelection, IssueCodeName, ShortDescription >"$CurrentPathToWorkingFiles\Reports\SummaryCodeIssues.txt"
	#export a release artifact that can be used to compare release objects
}
if (-not (Test-Path "$CurrentPathToWorkingFiles\reports\codeAnalysis.xml" -PathType leaf))
{
	write-verbose "Saving release artefact"
   if ($iReleaseArtifact -eq $null)
        {
        write-verbose "creating the release artefact"
	    $iReleaseArtifact = new-DatabaseReleaseArtifact -Source $SourceConnectionString -Target "$CurrentPathToWorkingFiles\source"
        }
	$iReleaseArtifact | Export-DatabaseReleaseArtifact -path "$CurrentPathToWorkingFiles\Artifact"
	#add to reports what is in the version, including objects and code issues
	Copy-Item -Path "$CurrentPathToWorkingFiles\Artifact\Reports\*" -Destination "$CurrentPathToWorkingFiles\reports" -force
	Copy-Item -Path "$CurrentPathToWorkingFiles\Artifact\States\Source\*" -Destination "$CurrentPathToWorkingFiles\source" -recurse -force
	Remove-Item -Path "$CurrentPathToWorkingFiles\Artifact" -Force -Recurse
}


