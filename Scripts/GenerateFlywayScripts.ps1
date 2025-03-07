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
#
$credentialsFile = "SQLServer_$($Branch)_$Server"
$ProjectArtefacts = ".\Versions" # the directory for artefacts
#we specify where in the user area we store connections and credentials
$currentCredentialsPath = "$env:USERPROFILE\$($Project)_$credentilsFile.toml"

#go to the appropriate directory - make it your working directory
cd "$env:FlywayWorkPath\$Project"
$CurrentCredentialsPath = "$env:USERPROFILE\$($Project)_$credentilsFile.toml"
<# $current just contains your 'current' environment. If you call it something different,
you'll need to change it in the subsequent code #> 
$current="-configFiles=$CurrentCredentialsPath"

# we establish what the current version of the database is
$Info =(flyway $current '-outputType=json'  info) | convertFrom-JSON
if ($Info.error -ne $null) # we must check for an error in INFO
{ write-error $Info.error }
$Version = $Info.schemaVersion # get the current version no
#Make sure that all the basic directories are there
If (!(Test-Path -Path "$ProjectArtefacts")) #if there is no versions directory 
{ md "$ProjectArtefacts" } # make sure the versions directory is there 
$ListOfVersions = $Info.migrations.rawversion | where { $_ -ne '' }
$ListOfVersions | foreach {
    # and all the version directories
    If (!(Test-Path -Path "$ProjectArtefacts\$_"))
    { md "$ProjectArtefacts\$_" }
}
# find the path of the snapshot of the previous version in the versions directory
<# (These directories need to be done in order so that there is a previous version
complete with its Snapshot) #>
$description=$Info.migrations|where {$_.rawVersion -eq $version}|foreach {$_.description}
$PreviousVersion = $ListOfVersions | where {
    [version]$_ -lt [version]$Version
} | Sort-Object -Property [version]$_ -Descending | Select -First 1
#Calculate where the scripts for the current version should go
$CurrentArtefactLocation = "$ProjectArtefacts\$Version\Reports" #
$CurrentScriptsLocation = "$ProjectArtefacts\$Version\Scripts"
#...and where the Snapshot for the previous version should be
$PreviousSnapshotLocation = "$ProjectArtefacts\$PreviousVersion\Reports\Snapshot.json"
#make sure an RG Snapshot is there
if (!(test-path -path "$PreviousSnapshotLocation" -PathType Leaf))
{ Write-error "there is no Snapshot in $PreviousSnapshotLocation that we can compare with, sadly" }
flyway snapshot $current  '-snapshot.source=current' `
			   "-snapshot.filename=$CurrentArtefactLocation\Snapshot.json"

    $DiffParams = @(
    "-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json", <#
    The source to use for the diff operation. 'empty', 'schemamodel', 'migrations'
    or the name of an 'environment' #>
    "-diff.target=snapshot:$PreviousSnapshotLocation",
    '-outputType=json',
    "-diff.artifactFilename=$CurrentArtefactLocation\artifact.diff"
    )

flyway $current $Diffparams diff >"$CurrentArtefactLocation\Differences.json"
# this is done because the list of types doesn't work as advertised
@('undo', 'versioned') | foreach {
    #'versioned' left out until name correct
    $GenerateParams = @(
        "-generate.artifactFilename=$CurrentArtefactLocation\artifact.diff"
        "-generate.types=$_",
        "-generate.version=$Version",
        "-generate.description=Generated-$description",
        "-schemaModelLocation=$PreviousModelLocation",
        "-generate.location=$CurrentScriptsLocation",
        '-generate.force=true'
    )
    # we do a generate. It now overwrites any existing 
    flyway $current $GenerateParams generate -outputType=json > GenerateResult.json #generate the script
    Type GenerateResult.json | convertFrom-JSON | foreach{
        if ($_.error -ne $null) { write-Error $_.error.message }
        if ($_.warnings.count -gt 0) { $_.warnings | foreach{ write-warning $_ } }
    }
    #Del GenerateResult.json
}
# now do the baseline script. This requires a Diff with empty, 
# otherwise it is identical to the versioned file
# this works
flyway $current  diff '-diff.source=current'  '-diff.target=empty' `
              generate "-generate.types=baseline" '-generate.description=Generated'`
              "-generate.location=$CurrentScriptsLocation" `
              "-generate.force=true"

Copy-Item "$CurrentScriptsLocation\*.sql" `
          -Destination "$ProjectArtefacts\current\scripts" -Force
 
