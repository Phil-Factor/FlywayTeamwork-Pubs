<#	
	.NOTES
	===========================================================================
	 Created on:   	19/02/2025 14:47
	 Created by:   	Phil Factor
	 Organization: 	MML 
	===========================================================================
    .DESCRIPTION
		This uses the Flyway check command. It assumes that snapshots have been taken
at the current version when it was first migrated to. It has to determine the current
version and thereby fetch the correct snapshot location (path)
#>
$ErrorActionPreference = 'Stop' #whatever error happens, we dont want to continue
<#
Substitute your own preferred routine to get your credentials such as the resolvers. 
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
#we can now assemble all our essential variables
$Version = $Info.schemaVersion #get the current version
	$CurrentArtefactLocation = "$pwd\Versions\$Version\Reports" #where the reports go
$DriftParams = @(
    "-reportFilename=$CurrentArtefactLocation\DriftCheck$(Get-Date -Format "dd-MM-yy").html"
    "-deployedSnapshot=$CurrentArtefactLocation\Snapshot.json",
    "-environment=current")# .. and the description of the version
flyway $current check -drift  $DriftParams
