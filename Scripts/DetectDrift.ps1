<#	
	.NOTES
	===========================================================================
	 Created on:   	18/02/2025 14:47
	 Created by:   	Phil Factor
	 Organization: 	MML 
	===========================================================================
#>
$ErrorActionPreference = 'Stop' #whatever error happens, we dont want to continue
<#
The objective here is to allow you to run this without altering your existing project
TOML file and to avoid real connection information getting beyond your user area
I have, for every database type, project, branch, and server, a file with connection
information in it that can be used. It uses the 'current' environment.  
The Filenames go Project_RDBMS_Branch_Server such as ...
C:\Users\Phil\Pubs_SQLServer_Main_Philf01.toml

typical contents are ....

flyway.environment = "current"
[environments.current]
url = "jdbc:<My Connection information>;"
user = "PhilipFactor"
password = "DeadSecret"

You will want to use your environments and resolvers in flyway.user.toml to do this 
so you just need to end up with a string array called $current with your credentials
#>


$Project = 'Pubs' # for working directory and the name of the credentials file
$Branch = 'Main' # the branch. We use this just for suitable login credentials 
$Server = 'Philf01'
$RDBMS = 'SQLServer'
#
$credentialsFile = "$RDBMS_$($Branch)_$Server"
$ProjectArtefacts = ".\Versions" # the directory for artefacts
#we specify where in the user area we store connections and credentials
$currentCredentialsPath = "$env:USERPROFILE\$($Project)_$credentilsFile.toml"
#go to the appropriate directory - make it your working directory
cd "$env:FlywayWorkPath\$Project"
$CurrentCredentialsPath = "$env:USERPROFILE\$($Project)_$credentilsFile.toml"
<# $current just contains your 'current' environment. If you call it something different,
you'll need to change it in the subsequent code #>
$current = "-configFiles=$CurrentCredentialsPath"
# we establish what the current version of the database is
$Info = (flyway $current '-outputType=json'  info) | convertFrom-JSON
if ($Info.error -ne $null) # we must check for an error in INFO
{ write-error $Info.error }
$Version = $Info.schemaVersion # get the current version no
$CurrentArtefactLocation = "$ProjectArtefacts\$Version\Reports" 
$CurrentReportLocation = "$ProjectArtefacts\$Version\Reports\Drift$(Get-Date -Format "dd-MM-yy")" 
#
if (!(test-path -path "$CurrentArtefactLocation\Snapshot.json" -PathType Leaf))
{ Write-error "there is no Snapshot in $CurrentArtefactLocation for this version of the database, sadly" }
$DiffParams = @(
	"-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json", <#
    The source to use for the diff operation. 'empty', 'schemamodel', 'migrations'
    or the name of an 'environment' #>
	"-diff.target=current",
	'-outputType=json',
	"-diff.artifactFilename=$CurrentReportLocation\artifact.diff"
)
#create the directory if necessary
if (!(test-path -path "$CurrentReportLocation" -PathType Container)) {
    $null= md $CurrentReportLocation
    }
#put the report in it
flyway $current $DiffParams  diff diffText >"$CurrentReportLocation\changes.json"
# we do a chained command for both the DIFF and difftext, assuming that a report of the 
# SQL is useful
$Differences = Type "$CurrentReportLocation\changes.json" | convertfrom-JSON
if ($Differences.error -ne $null) { Write-error "$($Differences.error.message)" }
$Changes = $Differences.individualResults[0].differences | foreach {
	$To = ($_.to.schema + '.' + $_.to.name).TrimStart('.');
	$From = ($_.from.schema + '.' + $_.from.name).TrimStart('.');
	if ($to -eq '') { $Whatever = $From }
	else { $Whatever = $to }
	if ($whatever -ne $from) { $IfDifferent = $From }
	else { $IfDifferent = $null }
	[pscustomObject]@{
		'name' = $whatever;
		'type' = $_.ObjectType; 'Difference' = $_.differenceType + 'ed';
		'to' = $IfDifferent
	}
if ($Changes -ne $null){$Changes | ConvertTo-Csv > "$CurrentReportLocation\changes.csv"}
else {Write-Host "no changes were found in $Project $Branch $Version"}
}

