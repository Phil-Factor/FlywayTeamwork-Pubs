<#
.SYNOPSIS
    Returns all committed and uncommitted changes to Flyway scripts as an
    array of change objects sorted by date that you can then inspect or use 
    for further processing.

.DESCRIPTION
    Scans Git commit history and working directory for any changes to Flyway
    Script scripts.
    Each entry includes Date, Author, Action, File, ScriptName, ScriptType,
    Message, and Commit hash.    The script Parses the Git history of your 
    Script folders, Filters changes by author, Script name, or type,
    Adds uncommitted changes (modified, staged, or untracked), and Returns 
    everything as a pipeline-friendly 
    object list.

.PARAMETER ScriptPaths
    One or more paths (relative to repo root) to search for Script files.

.PARAMETER MaxCommits
    Maximum number of commits to scan (default: 500).

.PARAMETER AuthorRegex
    Optional regex filter for author names.a Regex is used so that a list of 
    names can be specified

.PARAMETER IgnoreCallbackTypes 
   list of any callback types to ignore (eg BeforeInfo)

.PARAMETER ScriptRegex
    Optional regex filter for Script names.

.PARAMETER FileTypeRegex
    regex filter. This defaults to "\.(ps1|bat|cmd|sh|bash|py)(?m:$)".

.PARAMETER RepoLocation
    If specified, the script will temporarily change to this directory (useful if 
    script is run elsewhere).
dir pubs\branches\develop\migrations

.EXAMPLES
    # get the files used in a branch
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
        -ScriptPaths @('Pubs\Branches\Develop\Migrations','resources','scripts') `
        -RepoLocation "$env:FlywayWorkPath"  |Out-GridView
    # get the files used in main
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
        -ScriptPaths @('Pubs\Migrations','resources','scripts') `
        -RepoLocation "$env:FlywayWorkPath"  |Out-GridView
    # must be in appropriate Github repo directory before executing the script 
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
          -ScriptPaths 'sql/callbacks' -IgnoreCallbackTypes 'beforemigrate'
     # Filter by a list of callback types (beforemigrate','afterMigrate)
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
          -IgnoreCallbackTypes ('beforemigrate','afterMigrate')| Format-Table -AutoSize
    # Filter by author (e.g., "alice" case-insensitive)
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
          -AuthorRegex '(?i)phil factor'
    # Filter by callback name (e.g., "afterMigrate")
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
          -CallbackNameRegex 'afterMigrate'
    # Drill down as far back as specified date and format
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1 `
          | Where-Object {$_.Date -gt '2025-01-01'} 
    # Result Table 
     .$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1`
            | Format-Table Date, Author, Action, File, Message -AutoSize
#>

param (
	[Array]$ScriptPaths,
	[int]$MaxCommits = 300,
	[string]$AuthorRegex = "",
    [Array]$IgnoreCallbackTypes=$(),#list of any callback types to ignore
	[string]$ScriptRegex = "", #if you wish to restrict by filename
	[string]$FileTypeRegex = "\.(ps1|bat|cmd|sh|bash|py)(?m:$)",
	[string]$RepoLocation = ""
)

$ScriptPaths= @('Pubs\Migrations','resources','scripts')

# Temporarily move to repo if necessary
if ($RepoLocation)
{
	if ($pwd.path -ne $RepoLocation)
	{
		$originalLocation = $pwd
		Write-verbose "Changed to $RepoLocation"
		cd $RepoLocation
	}
	else { $originalLocation = $null }
}
else { $originalLocation = $null }

# Confirm Git repo presence
if (-not (Test-Path ".git"))
{
	Write-Error "This script must be run inside a Git repository."
	exit 1
}

<# warning. case sensitivity in Git even when git config core.ignorecase true
this corrects case typos #>
$previousScriptPaths = $ScriptPaths

$ScriptPaths = $ScriptPaths | foreach{
	$_ -split '\\|/' | foreach -Begin { $path = '' }{
		$CurrentDir = $_;
		$CaseSensitiveName = dir $path -Directory -Name | where { $_ -like $CurrentDir }
		$path = "$path$CaseSensitiveName\";
	} {
		$Path.TrimEnd('\')
	}
}
if ($previousScriptPaths -cne $ScriptPaths)
{
	write-verbose "changed callback paths from  to $($ScriptPaths -join ',')"
}

# Parse Git log for all the git locations specified, including subdirectories.
$Secondaries=$ScriptPaths| ForEach {
     $base = $_; dir "$RepoLocation\$base" -Directory -Recurse 
     } | foreach { "$base\$($_.name)"}
$gitLog=$ScriptPaths+$Secondaries| foreach {
	Write-verbose "collecting data for   $_ "
	git log -n $MaxCommits --date=short --pretty=format:"__COMMIT__`n%h|%ad|%an|%s" --name-status -- $_
}

$currentCommit = $null
$action = '';
$changes = $gitLog -split "`n" | ForEach-Object {
	$line = $_
	if ($line -like "__COMMIT__*")
	{
		$currentCommit = @{
			Hash = ""
			Date = ""
			Author = ""
			Message = ""
		}
	}
	elseif ($line -match "^([0-9a-f]+)\|([\d\-]+)\|(.+?)\|(.+)$")
	{
		$currentCommit.Hash = $matches[1]
		$currentCommit.Date = $matches[2]
		$currentCommit.Author = $matches[3].Trim()
		$currentCommit.Message = $matches[4].Trim()
	}
	elseif ($line -match "^(?<Action>[ADM])\s+(?<File>.+)$" -and $currentCommit)
	{
		$action =
		switch ($matches['Action'])
		{
			"M"  { "Modified" }
			"A"  { "Added" }
			"D"  { "Deleted" }
			"??" { "Untracked" }
			default { $psitem }
		}
		$file = $matches['File'].Trim()
		$ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($file)
		$ScriptType = $ScriptName -replace '__.+?\z', ''
		
		if ($ScriptName -imatch '(?<CallbackType>\A(after|before)(each|)(clean|info|migrate|baseline|Validate|connect|repair|undo|Repeatable|version)(statement|error|Applied|)(Error|)).{3,}')
		{
			$CallbackType = $matches['CallbackType']
		}
		else
		{
			$CallbackType = 'script'
		}
		$ItIsAFileWeWant = $true #assume that we want it
		# Apply filters
        
		if ($FiletypeRegex -and ($file -notmatch $FiletypeRegex)) { $ItIsAFileWeWant = $false }
        if ($IgnoreCallbackTypes.Count-ne 0) {if ($CallbackType -in $IgnoreCallbackTypes) { $ItIsAFileWeWant = $false }}
		if ($AuthorRegex -and ($currentCommit.Author -notmatch $AuthorRegex)) { $ItIsAFileWeWant = $false }
		if ($ScriptNameRegex -and ($ScriptName -notmatch $ScriptNameRegex)) { $ItIsAFileWeWant = $false }
		if ($ItIsAFileWeWant) #saves huge amount of time in the loop
		{
			[PSCustomObject]@{
				Date = $currentCommit.Date
				Author = $currentCommit.Author
				Action = $action
				File = $file
				ScriptName = $ScriptName
				ScriptType = $CallbackType
				Message = $currentCommit.Message
				Commit = $currentCommit.Hash
			}
		}
	}
}
<# The script outputs all changes (committed + uncommitted)
as objects for use in pipes or formatting. 

The git status check ensures you can now spot callback files 
that were edited but never committed — essential for keeping 
Flyway scripts in sync with Git. #>

# Detect uncommitted (working dir) changes
$rawStatus = git status -z
$entries = $rawStatus -split [char]0;
$uncommitted = $entries | Where-Object { $_ -match "^(..)\s+(.*)$" } | ForEach-Object {
	$status = $matches[1].Trim()
	$file = $matches[2].Trim()
	$uncommittedFile = $_
	if ($uncommittedFile -match "^(..)\s+(.*)$")
	{
		$status = $matches[1].Trim()
		$file = $matches[2].Trim()
		# Skip if not in a  path
		$ThisFileIsRelevant = $false;
		$Scriptpaths | foreach {$linuxpath=$_.replace('\','/')  ; if ($File -like "$linuxpath*") { $ThisFileIsRelevant = $true } }
		$ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($file)
		$ScriptType = $ScriptName -replace '__.+?\z', ''
		if ($ScriptName -imatch '(?<CallbackType>\A(after|before)(each|)(clean|info|migrate|baseline|Validate|Repair|undo|Repeatable|version)(statement|error|Applied|)(Error|)).{3,}')
		{
			$CallbackType = $matches['CallbackType']
		}
		else
		{
			$CallbackType = 'script'
		}
		if ($FiletypeRegex -and ($file -notmatch $FiletypeRegex)) { $ThisFileIsRelevant = $false }
		if ($ScriptNameRegex -and ($ScriptName -notmatch $ScriptNameRegex)) { $ThisFileIsRelevant = $false; }
        if ($IgnoreCallbackTypes.Count-ne 0) {if ($CallbackType -in $IgnoreCallbackTypes) { $ItIsAFileWeWant = $false }}
        # write-verbose "this $file files relevance is $ThisFileIsRelevant "
		if ($ThisFileIsRelevant)
		{
			$simpleStatus = switch ($status)
			{
				"M"  { "Modified" }
				"A"  { "Added" }
				"D"  { "Deleted" }
				"??" { "Untracked" }
				default { $status }
			}

			[PSCustomObject]@{
				Date = (Get-Date -Format "dd-MM-yyyy")
				Author = "*UNCOMMITTED*"
				Action = $simpleStatus
				File = $file
				ScriptName = $ScriptName
				ScriptType = $CallbackType
				Message = "*Uncommitted change*"
				Commit = "*WORKING*"
			}
		}
	}
}

# Merge and sort
$allChanges = $changes + $uncommitted | Sort-Object Date

# Restore original location
if ($originalLocation) { cd $originalLocation }

# Output for further use
$allChanges