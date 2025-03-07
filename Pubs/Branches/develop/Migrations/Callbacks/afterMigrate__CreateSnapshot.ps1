<#
This callback must never be used in an afterEachxxxx callback, just AfterMigrate or AfterVersioned 
callback. It assumes that, if you want to define where the snapshot is placed, you have defined a
 placehoder for snapshotDirectoryName, the directory where snapshots are stored. Otherwise it calls 
 it 'snapshots' 
 teamworkVerbosity="Continue" will give you verbose explanations, otherwise it is quiet if all goes well
[flyway.placeholders]
teamworkVerbosity="Continue"
SnapshotDirectoryName="VersionSnapshots"
...

#>

$SnapshotDirectoryName = Switch ($Env:FP__snapshotDirectoryName__)
{
	$null { "Snapshots" }
	Default { $Env:FP__SnapshotDirectoryName__ }
}

# in a callback, this will always be present but....
$SnapshotDirectory = switch ($Env:FP__flyway_workingDirectory__)
{
	$null { "$pwd\$SnapshotDirectoryName" }
	default { "$Env:FP__flyway_workingDirectory__\$SnapshotDirectoryName" }
}

$VerbosePreference = switch ($Env:FP__TeamworkVerbosity__)
{
	'verbose' { 'continue' }
	'continue' { 'continue' }
	default { 'SilentlyContinue' }
}



<#-- Preparations to use Flyway --
The opening section of the script determines and uses the latest Flyway installation
and then runs flyway info, captures its JSON output and extracts from it the metadata
needed to run the tasks, such as the current schema version, previous successful version,
schema name, and the description of the latest applied migration.
#>

$FlywayinstallDirectory = "$env:FlywayInstallation\flyway.commandline\tools"
    <# This only seems necessary if you install flyway the way I do (I like to store old versions
    and be able to revert in an emergency) with the rapidity of releases it's convenient #>
if ((get-command 'Flyway' -CommandType All -ErrorAction Ignore) -eq $null)
{
	$Latest = (Dir "$FlywayinstallDirectory\flyway-*\flyway.cmd" | ` # lets see them all
		Sort-Object -property creationtime -descending | select -first 1).Fullname
	Set-Alias -Name 'Flyway' -Value $Latest -Scope global
}
$CouldGetVersionNo = $false;
Write-verbose 'determining the current database version, and their  descriptions'
<#-- we use 'info' to fetch the essential details we need for the various operations --#>
# we establish what the current version of the database is, the name of the migration
# file that prtoduced it, the previous version and the list of schemas.
$ContentsOfOutput = (flyway '-outputType=json'  info) # also catches flyway execution errrors
if ($LastExitCode -eq 0)
{
	try #we need to catch all the errors even if info can't execute 
	{
		# catch non-json output
		$Info = $ContentsOfOutput | convertFrom-JSON
	}
	catch
	{
		write-Error "$ContentsOfOutput"
	}
	if ($info.error -ne $null)
	{
		write-error "$($info.error.message)"
	}
	else { $CouldGetVersionNo = $true }
	if ($CouldGetVersionNo)
	{
		$Version = $info.schemaVersion
		$Migration = $info.migrations | where { $_.category -eq 'Versioned' -and $_.rawversion -eq $Version }
		$DestinationFile = "$SnapshotDirectory\Snapshot_V$($version)__$($Migration.description).json"
<# we now have the confirmation of the version and description #>		
Write-verbose "creating snapshot of the database at version $version "
		
		If (-Not (Test-path $SnapshotDirectory -Pathtype Container))
		{ New-Item -ItemType directory -Path $SnapshotDirectory -Force }
		if (-Not (Test-path $DestinationFile -Pathtype Leaf)) #check to see if it exists already
		{ #in some circumstances, such as after an undo, you would  
			write-verbose "writing snapshot to $DestinationFile"
			# Create the snapshot. We assemble an environment to ensure that one exists
			$current = @(# displayName not allowed!
				"-environments.current.url=$env:FLYWAY_URL"
				"-environments.current.password=$env:FLYWAY_PASSWORD"
				"-environments.current.user=$env:FLYWAY_USER"
				"-environments.current.schemas=$($Info.schemaName)",
				'-environment=current');
			flyway snapshot $current  '-snapshot.source=current' `
				   "-snapshot.filename=$DestinationFile"
		}
		else #we don't over-write an existing snapshot
		{
			write-verbose "snapshot for V$version at $DestinationFile already exists"
		}
	}
}