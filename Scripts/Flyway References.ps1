 <#
 <#
    .SYNOPSIS
        Returns a report of all scripts used by a Flyway project and indicates whether they are
        not source-controlled within the project, whether they are source controlled but with
        uncommitted changes, or Whether the file is clean (no pending changes. As Flyway and 
        Git are both quite slow, this routine can take a while
	
	.DESCRIPTION
        This demonstrates a way of using Git and Flyway to determine what scripts are actually
        being referenced by the Flyway project, whatever the status of the migration. It then
        checks in your git repository to see whether the files are there, and if so, whether 
        the committs are up-to-date. It returns a list of the files, with an indented list of
        commits, if there are any. 

	.PARAMETER $TheProjectLocation
        The location where you need to run INFO for your project

    .PARAMETER $PathToSecretsFile
        The full path and filename of your TOML file that provides the Flyway credentials

    .PARAMETER $MigrationLocation
        The full path and filename of your TOML file that provides the Flyway credentials

    .PARAMETER $JSONReport
        The full path and filename of your TOML file that provides the Flyway credentials
        
    .usage
         ."$env:FlywayWorkPath\scripts\Flyway References.ps1" `
            -TheProjectLocation "$env:FlywayWorkPath\Pubs\branches\develop" `
            -PathToSecretsFile "$env:userProfile\Pubs_SQLServer_develop_Philf01.toml" `
            -MigrationLocationList @('Pubs\Branches\Develop\Migrations') `
            -JSONOutput $true

#>

    

param (
    [string]$TheProjectLocation, #e.g. "$env:FlywayWorkPath\<database>\branches\develop"
    [string]$PathToSecretsFile,  #To run Flyway info e.g. $env:userProfile\<database>_SQLServer_develop_<server>1.toml"
    [array]$MigrationLocationList, #@('<database>\Branches\Develop\Migrations')
    [bool]$JSONReport = $false
)
     
# Start by collecting the paths of all the top-level scripts
cd  $TheProjectLocation #make the project your working directory 
#get all the script files within the configuration 
$currentCredentialsPath = "-configFiles=$PathToSecretsFile"
try {
 $ErrorActionPreference = "Stop"  # Force non-terminating errors to be terminating

    $TheReport = flyway $currentCredentialsPath info -X
    if ($LASTEXITCODE -ne 0) {
        throw "Flyway exited with code $LASTEXITCODE"
    }
    }
catch{
    Write-error "could not proceed, in directory '$PWD', using credentials at $currentCredentialsPath" -ErrorAction Stop
    }

#We can now use the output of Flyway's info command to get the list of files that the config provides
$VisibleScripts = ."$env:FlywayWorkPath\scripts\GetFlywayFilesAndTypes.ps1" $TheReport
<# Now we have a complete list of every script  referenced in a migration run, with
 paths to the project resources such as migrations and callbacks. we filter these 
 into a list of paths of the file types that might have references ro other files
 we can make sure that they are all in GitHub, and committed. with this list we can the 
 find all the inline references to script files within the script files
 within the project 
#>
$visited = @{ } # we must start with a NULL list of files we've visited - or files we don't want visited.
#we need a function to do this as it is recursive so we grab the current version of the file it is in
."$env:FlywayWorkPath\scripts\Resolve-ScriptReferences.ps1" #get the latest version of the cmdlet
#now execute the script to resolve the script references 
Resolve-ScriptReferences -ScriptPath $VisibleScripts -Visited $visited
# The list of files visited is in our 'visited' list
$ScriptFilesUsedByFlyway = $visited.GetEnumerator() | select -ExpandProperty name
<# Now we have a complete list of every script  referenced in a migration run we can make sure that 
they are all in GitHub, and committed #>
$GitReportOfProjectFiles = ."$env:FlywayWorkPath\scripts\Get-FlywayScriptAndCallbackChanges.ps1" `
-CallbackPaths $MigrationLocationList  -RepoLocation "$env:FlywayWorkPath" | sort-object commit, File -Unique

<# Now do a report that tells us which files need to be committed etc.  #>
$ScriptFilesUsedByFlyway | foreach {
	$b = ($_ -replace '\\', '/').TrimStart('.');
    Write-verbose "Comparing '*$b'  "
	$Actions = $GitReportOfProjectFiles | where { $_.file -like "*$b" }
    Write-verbose "found $($Actions.count) entries"
    if ($JSONOutput)
        {Add-Member -InputObject $_ -NotePropertyName 'GithubEntries' -NotePropertyValue $Actions}
    else
        {
	    if ($Actions.Count -eq 0) {write-host "File $($_) is not Source-controlled within the project" }
	    elseif ($Actions.Count -eq 1) {write-host  "File $($($Actions[0].File)) -  $($Actions[0].message) at  $($Actions[0].Date)" }
	    else {write-host  "File $($Actions[0].File) - $(($Actions | foreach{ "`n    $($_.message) at  $($_.Date)" }) -join ",")" }
         }
}
if ($JSONOutput) { $ScriptFilesUsedByFlyway | convertTo-json}
