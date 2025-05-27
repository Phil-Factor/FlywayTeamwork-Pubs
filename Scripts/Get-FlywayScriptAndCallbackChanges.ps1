<#
.SYNOPSIS
    Returns all committed and uncommitted changes to Flyway callback scripts.

.DESCRIPTION
    Parses git log and status for Flyway callback folders, applying filters by author, callback name, and type.

.PARAMETER CallbackPaths
    One or more paths to search for callback files.

.PARAMETER MaxCommits
    Max number of commits to scan (default: 300).

.PARAMETER AuthorRegex
    Optional regex filter for author names.

.PARAMETER CallbackNameRegex
    Optional regex filter for callback names.

.PARAMETER CallbackTypeRegex
    Optional regex filter for callback type.

.PARAMETER RepoLocation
    Optional location of git repo if run from elsewhere.
#>

param (
    [Array]$CallbackPaths = @("migrations"),
    [int]$MaxCommits = 300,
    [string]$AuthorRegex = "",
    [string]$CallbackNameRegex = "",
    [string]$CallbackTypeRegex = "",
    [string]$RepoLocation = ""
)

function Get-GitHistoryChanges {
    param (
        [string[]]$Paths,
        [int]$Limit,
        [string]$AuthorFilter,
        [string]$NameFilter,
        [string]$TypeFilter
    )
    Write-Verbose "Retrieving committed git changes for paths: $($Paths -join ', ')"
    $allChanges = @()
    foreach ($path in $Paths) {
        Write-Verbose "Scanning path: $path"
        $gitLog = git log -n $Limit --date=short --pretty=format:"__COMMIT__`n%h|%ad|%an|%s" --name-status -- "$path"

        $currentCommit = $null
        foreach ($line in $gitLog -split "`n") {
            if ($line -like "__COMMIT__*") {
                $currentCommit = @{
                    Hash = ""
                    Date = ""
                    Author = ""
                    Message = ""
                }
            } elseif ($line -match "^([0-9a-f]+)\|([\d\-]+)\|(.+?)\|(.+)$") {
                $currentCommit.Hash = $matches[1]
                $currentCommit.Date = $matches[2]
                $currentCommit.Author = $matches[3].Trim()
                $currentCommit.Message = $matches[4].Trim()
            } elseif ($line -match "^([ADM])\s+(.+)$" -and $currentCommit) {
                $file = $matches[2].Trim()
                $callbackName = [System.IO.Path]::GetFileNameWithoutExtension($file)
                $callbackType = $callbackName -replace '__.+?\z', ''

                if ($AuthorFilter -and ($currentCommit.Author -notmatch $AuthorFilter)) { continue }
                if ($NameFilter -and ($callbackName -notmatch $NameFilter)) { continue }
                if ($TypeFilter -and ($callbackType -notmatch $TypeFilter)) { continue }

                $allChanges += [PSCustomObject]@{
                    Date         = [datetime]$currentCommit.Date
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
    }
    return $allChanges
}

function Get-UncommittedChanges {
    param (
        [string[]]$Paths,
        [string]$NameFilter,
        [string]$TypeFilter
    )
    Write-Verbose "Scanning for uncommitted changes"
    $results = @()
    $normalizedPaths = $Paths | ForEach-Object { ($_ -replace '\\', '/') }

    $rawStatus = git status -z
$entries = $rawStatus -split "`0"

for ($i = 0; $i -lt $entries.Count - 1; $i++) {
    $entry = $entries[$i]

    if ($entry -match "^(..)(.+)$") {
        $status = $matches[1].Trim()
        $file = $matches[2].Trim()

        if (-not ($normalizedPaths | Where-Object { $file -replace '\\', '/' -like "$_/*" })) { continue }

        $callbackName = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $callbackType = $callbackName -replace '__.+?\z', ''

        if ($NameFilter -and ($callbackName -notmatch $NameFilter)) { continue }
        if ($TypeFilter -and ($callbackType -notmatch $TypeFilter)) { continue }

        $results += [PSCustomObject]@{
            Date         = Get-Date
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
return $results

}

if ($RepoLocation) {
    Write-Verbose "Using repo location override: $RepoLocation"
    Push-Location $RepoLocation
} else {
    Write-Verbose "Using current directory as repo location"
}

try {
    if (-not (Test-Path ".git")) {
        throw "This script must be run inside a Git repository."
    }

    $committedChanges   = Get-GitHistoryChanges -Paths $CallbackPaths -Limit $MaxCommits `
                                                -AuthorFilter $AuthorRegex `
                                                -NameFilter $CallbackNameRegex `
                                                -TypeFilter $CallbackTypeRegex

    $uncommittedChanges = Get-UncommittedChanges -Paths $CallbackPaths `
                                                 -NameFilter $CallbackNameRegex `
                                                 -TypeFilter $CallbackTypeRegex

    $allChanges = @() + $committedChanges + $uncommittedChanges | Sort-Object Date
    $allChanges
}
finally {
    if ($RepoLocation) {
        Write-Verbose "Reverting to original directory"
        Pop-Location
    }
}
