﻿<#
.SYNOPSIS
    Returns all committed and uncommitted changes to Flyway callback scripts as an array of change objects sorted by date.

.DESCRIPTION
    Scans Git commit history and working directory for any changes to Flyway callback scripts.
    Each entry includes Date, Author, Action (A/M/D), File, CallbackName, CallbackType, Message, and Commit hash.
    The script Parses the Git history of your callback folders, Filters changes by author, callback name, or type,
    Adds uncommitted changes (modified, staged, or untracked), and Returns everything as a pipeline-friendly 
    object list.

.PARAMETER CallbackPaths
    One or more paths (relative to repo root) to search for callback files.

.PARAMETER MaxCommits
    Maximum number of commits to scan (default: 500).

.PARAMETER AuthorRegex
    Optional regex filter for author names.a Regex is used so that a list of names can be specified

.PARAMETER CallbackNameRegex
    Optional regex filter for callback names.

.PARAMETER CallbackTypeRegex
    Optional regex filter for callback type (e.g. before, after).

.PARAMETER RepoLocation
    If specified, the script will temporarily change to this directory (useful if script is run elsewhere).
dir pubs\branches\develop\migrations
.EXAMPLE
    # get the files used in a branch
    .\scripts\Get-FlywayScriptAndCallbackChanges.ps1 -CallbackPaths 'Pubs\Branches\Develop\Migrations' -RepoLocation "$env:FlywayWorkPath"
    # must be in appropriate Github repo directory before executing the script 
    .\Get-FlywayScriptAndCallbackChanges.ps1 -CallbackPaths 'sql/callbacks' -CallbackTypeRegex '^before'
    # Filter by callback type (before*)
        .\scripts\Get-FlywayScriptAndCallbackChanges.ps1 -CallbackTypeRegex '^before'
    # Filter by a list of callback types (before, beforeEach, after, afterEach)
        .\scripts\Get-FlywayScriptAndCallbackChanges.ps1 -CallbackTypeRegex '^(before|after)'| Format-Table -AutoSize
    # Filter by author (e.g., “alice” case-insensitive)
        .\scripts\Get-FlywayScriptAndCallbackChanges.ps1 -AuthorRegex '(?i)phil factor'
    # Filter by callback name (e.g., “afterMigrate”)
        .\scripts\Get-FlywayScriptAndCallbackChanges.ps1 -CallbackNameRegex 'afterMigrate'
    # Drill down as far back as specified date and format
        .\scripts\Get-FlywayScriptAndCallbackChanges.ps1 | Where-Object {$_.Date -gt '2025-01-01'} 
    # Result Table 
        .\scripts\Get-FlywayScriptAndCallbackChanges.ps1  | Format-Table Date, Author, Action, File, Message -AutoSize
cd pubs
."$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1" -CallbackTypeRegex '^before' -RepoLocation "$env:FlywayWorkPath"
cd "$env:FlywayWorkPath"
#>

param (
    [Array]$CallbackPaths = "Pubs\Branches\develop\Migrations",
    [int]$MaxCommits = 300,
    [string]$AuthorRegex = "",
    [string]$CallbackNameRegex = "",
    [string]$CallbackTypeRegex = "",
    [string]$RepoLocation = ""
)

# Temporarily move to repo if necessary
if ($RepoLocation) {
     Write-verbose "Maybe need to change location"
    if ($pwd.path -ne $RepoLocation) {
        $originalLocation = $pwd
         Write-verbose "Changed to $RepoLocation"
        cd $RepoLocation
    }
    else {$originalLocation=$null}
}
else {$originalLocation=$null}

# Confirm Git repo presence
if (-not (Test-Path ".git")) {
    Write-Error "This script must be run inside a Git repository."
    exit 1
}

<# warning. case sensitivity in Git even when git config core.ignorecase true
this corrects case typos #>
$previousCallbackPaths=$CallbackPaths 
$CallbackPaths=$CallbackPaths-split '\\|/'|foreach -Begin{$path=''}{
    $CurrentDir=$_;
    $CaseSensitiveName=dir $path -Directory -Name |where {$_ -like $CurrentDir}
    $path="$path$CaseSensitiveName\";
    } {$Path.TrimEnd('\')} 

if ($previousCallbackPaths-cne $CallbackPaths) {
    write-verbose "changed callback paths to $CallbackPaths"}

# Parse Git log for all the git locations specified, including subdirectories.
$gitLog = $CallbackPaths  | ForEach-Object {$base=$_; dir $_ -Directory -Recurse} |foreach {
    "$base\$($_.name)"} -end {$base}|foreach {
    git log -n $MaxCommits --date=short --pretty=format:"__COMMIT__`n%h|%ad|%an|%s" --name-status -- $_
}

$currentCommit = $null
$changes = $gitLog -split "`n" | ForEach-Object {
    $line = $_
    if ($line -like "__COMMIT__*") {
        $currentCommit = @{
            Hash = ""
            Date = ""
            Author = ""
            Message = ""
        }
    }
    elseif ($line -match "^([0-9a-f]+)\|([\d\-]+)\|(.+?)\|(.+)$") {
        $currentCommit.Hash = $matches[1]
        $currentCommit.Date = $matches[2]
        $currentCommit.Author = $matches[3].Trim()
        $currentCommit.Message = $matches[4].Trim()
    }
    elseif ($line -match "^([ADM])\s+(.+)$" -and $currentCommit) {
        $file = $matches[2].Trim()
        $callbackName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $callbackType = $callbackName -replace '__.+?\z', ''

        # Apply filters
        if ($AuthorRegex -and ($currentCommit.Author -notmatch $AuthorRegex)) { return }
        if ($CallbackNameRegex -and ($callbackName -notmatch $CallbackNameRegex)) { return }
        if ($CallbackTypeRegex -and ($callbackType -notmatch $CallbackTypeRegex)) { return }

        [PSCustomObject]@{
            Date         = $currentCommit.Date
            Author       = $currentCommit.Author
            Action       = $matches[1]
            File         = $file
            CallbackName = $callbackName
            CallbackType = $callbackType
            Message      = $currentCommit.Message
            Commit       = $currentCommit.Hash
        }
    }
}
<# The script outputs all changes (committed + uncommitted)
as objects for use in pipes or formatting. 

The git status check ensures you can now spot callback files 
that were edited but never committed — essential for keeping 
Flyway scripts in sync with Git. #>

# Detect uncommitted (working dir) changes
$uncommitted = git status --porcelain | ForEach-Object {
    #$uncommittedFile='?? Pubs/Migrations/afterInfo__uncomitted.ps1'
    $uncommittedFile=$_
    if ($uncommittedFile -match "^(..)\s+(.*)$") {
        $status = $matches[1].Trim()
        $file = $matches[2].Trim()
# Skip if not in a callback path
        if (-not ( $CallbackPaths|foreach {($CallbackPaths -split '\\')-join '/'
        } | Where-Object {$file -like "$_/*" })) { return }

        $callbackName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $callbackType = $callbackName -replace '__.+?\z', ''

        if ($CallbackNameRegex -and ($callbackName -notmatch $CallbackNameRegex)) { return }
        if ($CallbackTypeRegex -and ($callbackType -notmatch $CallbackTypeRegex)) { return }

        [PSCustomObject]@{
            Date         = (Get-Date -Format "dd-MM-yyyy")
            Author       = "*UNCOMMITTED*"
            Action       = $status
            File         = $file
            CallbackName = $callbackName
            CallbackType = $callbackType
            Message      = "*Uncommitted change*"
            Commit       = "*WORKING*"
        }
    }
}

# Merge and sort
$allChanges = $changes + $uncommitted | Sort-Object Date

# Restore original location
if ($originalLocation) { cd $originalLocation }

# Output for further use
$allChanges
