<# This callback does all the 'staff-work' for a release. It  allows the user to
opt whether to do anything or everything, or to do just some of the wonderful
things it does.

[flyway.placeholders]
CompareVersions = "Snapshot,Changes,Scripts,Model,Build,Reports"
TeamworkVerbosity="quiet"
 
This is done by two placeholders that will be defined within a TOML file
They appear to the callback as 
$Env:FP__CompareVersions__
$Env:FP__TeamworkVerbosity__

You can have any of the following values- Snapshot,Changes,Scripts,Model,Build,Reports

Snapshot - create a snapshot that will save a snapshot of the database at this version
Changes - Provide a list of changes and what has changed.
Scripts - undo, versioned and baseline script
Model - generate a schema model for this version
Build - Produce a build script
Reports - produce the Flyway Desktop reports of the changes

$Env:FP__CompareVersions__ = 'Build'
$Env:FP__TeamworkVerbosity__ = 'Verbose'
#>
$VerbosePreference = switch ($Env:FP__TeamworkVerbosity__)
{
	'verbose' { 'continue' }
	'continue' { 'continue' }
	default { 'SilentlyContinue' }
}
<# 
This callback demonstrates a way of taking a snapshot, create a model, and generate
all the useful SQL Scripts that you might need for every version. It also provides
the data that tells you what's changed.

This is powershell, but it can be executed as a callback from a Flywway task that
runs from Dos Commandline  or BASH. This makes it prudent to make sure you are using 
the latest flyway. Make sure that the next line has the path to your install directory.
The easiest approach for me is to define my  flyway installation an an environment 
variable 

The opening section of the script determines and uses the latest Flyway installation
and then runs flyway info, captures its JSON output and extracts from it the metadata
needed to run the tasks, such as the current schema version, previous successful version,
schema name, and the description of the latest applied migration.
It then defines paths for storing generated files and ensures all outputs (snapshots,
reports, scripts, models) are versioned.
#>
<# What does the user want?  #>
$WhatWeCanDo = @('Snapshot', 'Changes', 'Scripts', 'Model', 'Build', 'Reports');
$WhatWeDo = @();
if ($Env:FP__CompareVersions__ -ne $null) #if the user has given an opinion
{
	#if there is a definite request
	$WhatWeWantToDo = $Env:FP__CompareVersions__ -split ',' | foreach { $_.Trim() }
	if ('Everything' -in $WhatWeWantToDo) { $WhatWeDo = $whatWeCanDo }
	elseif ('Nothing' -in $WhatWeWantToDo) { $WhatWeDo = $null }
	else
	{
		$WhatWeDo = $WhatWeWantToDo | where { $_ -in ($WhatWeCanDo) }
	}
}
else
{ $WhatWeDo = $WhatWeCanDo }
# you need the current snapshot for the fancy stuff. comparisons are quicker
if ('Snapshot' -notin $WhatWeDo)
{
	# we can't do the extras without the snapshot 
	$WhatWeDo | foreach -begin { $SnapshotNeeded = $false } {
		if ($_ -in @('Changes', 'Scripts', 'Model', 'Build'))
		{
			$SnapshotNeeded = $true
		}
		#Add in the snapshot if needed for something else
	} -end {
		if ($SnapshotNeeded) { [array]$WhatWeDo += 'Snapshot'; }
	}
}

if ('Build' -in $WhatWeDo -and 'Scripts' -notin $WhatWeDo)
     {[array]$WhatWeDo+='Scripts'}
$WeHaveAllRequiredInfo = $false;
$writtenlist=$WhatWeDo | &{ @($Input) -as 'Collections.Stack'}|foreach{
   $i=0;$w='';$J=@(' and ',', ')}{$W=$J[$i]+$_+$W;$i=1}{$w.TrimStart(', ')}

write-verbose "This routine needs to  do $writtenlist"

if ($WhatWeDo -ne $null)
{
    <#-- Preparations to use Flyway --#>
	$FlywayinstallDirectory = "$env:FlywayInstallation\flyway.commandline\tools"
    <# This only seems necessary if you install flyway the way I do (I like to store old versions
    and be able to revert in an emergency) with the rapidity of releases it's convenient #>
	$Latest = (Dir "$FlywayinstallDirectory\flyway-*\flyway.cmd" | ` # lets see them all
		Sort-Object -property creationtime -descending | select -first 1).Fullname
	Set-Alias -Name 'Flyway' -Value $Latest
	Write-verbose 'determining the current and previous database version, and their  descriptions'
    <#-- we use 'info' to fetch the essential details we need for the various operations --#>
	# we establish what the current version of the database is, the name of the migration
	# file that produced it, the previous version and the list of schemas.
	$ContentsOfOutput = (flyway '-outputType=json'  info) # also catches flyway execution errrors
	$WeHaveAllRequiredInfo = $?
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
		write-warning "$($info.error.message)"
		$WeHaveAllRequiredInfo = $false
	}
}
if ($WeHaveAllRequiredInfo) #only if we got the info we need 
{
	#we can now assemble all our essential variables
	$Version = $Info.schemaVersion #get the current version
	$schemas = $Info.schemaName
	# .. and the description of the version
	$description = $Info.migrations | where { $_.rawVersion -eq $version } | foreach { $_.description }
	$CurrentDirectories = @('Scripts', 'Reports', 'Model')
	
	$PresentVersionLocation = "$pwd\versions\current" #the 'current' directory with a copy of the current version
	$CurrentArtefactLocation = "$pwd\Versions\$Version\Reports" #where the reports go
	$CurrentScriptsLocation = "$pwd\Versions\$Version\Scripts" #where the scripts go
	$CurrentModelLocation = "$pwd\Versions\$Version\Model" #where the models go
	$CurrentChangesLocation = "$pwd\Versions\$Version\Changes" #where the change reports go (set to null if not wanted)
	$CurrentBuildLocation = "$pwd\Versions\$Version\Build" #where the Build reports go (set to null if not wanted)
	$OurDirectories = @($CurrentArtefactLocation, $CurrentScriptsLocation, $CurrentModelLocation,
		"$PresentVersionLocation\Scripts", "$PresentVersionLocation\Reports",
		"$PresentVersionLocation\Model")
	
	if ($CurrentChangesLocation -ne $null) { $OurDirectories += $CurrentChangesLocation; $CurrentDirectories += 'Changes' }
	if ($CurrentBuildLocation -ne $null) { $OurDirectories += $CurrentBuildLocation; $CurrentDirectories += 'Build' }
	
	
<#--    Now we create the snapshot      --#>
	if ('Snapshot' -in $WhatWeDo)
	{
		write-verbose "writing snapshot to $CurrentArtefactLocation\Snapshot.json"
		#Create the directory if it doesn't exist.
		$OurDirectories | Foreach {
			if (!(Test-Path -Path $_ -PathType Container))
			{
				$null = md $_ -Force
			}
		}
		# Create the snapshot. We assemble an environment to ensure that one exists
		$current = @(# displayName not allowed!
			"-environments.current.url=$env:FLYWAY_URL"
			"-environments.current.password=$env:FLYWAY_PASSWORD"
			"-environments.current.user=$env:FLYWAY_USER"
			"-environments.current.schemas=$($Info.schemaName)",
			'-environment=current');
		
		flyway snapshot $current  '-snapshot.source=current' `
			   "-snapshot.filename=$CurrentArtefactLocation\Snapshot.json"
		
		#Do we need to do any of this lot?
		@('Changes', 'Scripts', 'Model', 'Build') | foreach -Begin { $DoWe = $False }{
			if ($_ -in $WhatWeDo) { $DoWe = $true }
		}
		
		if ($DoWe)
		{
    <#--    Now we find the previous version and compare with it (or with 'empty'--#>			
			Write-verbose 'Comparing the status with the previous version, if any'
			$WeHaveAComparison = $false;
			$PreviousVersion = $info.migrations |
			where { -not [string]::IsNullOrEmpty($_.rawversion) } |
			where { $_.state -eq 'Success' -and [version]$_.rawVersion -lt [version]$Version } |
			Sort-Object -Descending -Property rawVersion |
			select -First 1 | foreach{ $_.rawversion }
			if ($PreviousVersion -ne $null)
			{
				$PreviousArtefactLocation = "$pwd\Versions\$PreviousVersion\reports"
				# if there was a snapshot for the previous version we compare with that
				# was there a snapshot for the previous version
				
				if (test-path -path "$PreviousArtefactLocation\Snapshot.json" -PathType Leaf)
				{
					Write-Verbose "there is a snapshot at $PreviousArtefactLocation that we can compare with";
					$WeHaveAComparison = $true
				}
                else
                {
                    Write-Verbose "Sadly there isn't a snapshot at $PreviousArtefactLocation that we can compare with"
                }
            }
			if ($WeHaveAComparison){
            	$DiffParams = @(
					"-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json", <#
    The source to use for the diff operation. 'empty', 'schemamodel', 'migrations'
      or the name of an 'environment' #>
					"-diff.target=snapshot:$PreviousArtefactLocation\Snapshot.json",
					'-outputType=json',
					"-diff.artifactFilename=$CurrentArtefactLocation\artifact.diff"
				)
			}
			else #there was no previous version so we compare with 'empty'
			{
				$WeHaveAComparison = $true
				$DiffParams = @(
					"-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json", <#
    The source to use for the diff operation. 'empty', 'schemamodel', 'migrations'
      or the name of an 'environment' #>
					'-diff.target=empty',
					'-outputType=json',
					"-diff.artifactFilename=$CurrentArtefactLocation\artifact.diff"
				)
			}
    <#-- Now we can extract the list of changes from the last version or 'empty --#>
			if ($WeHaveAComparison)
			{
				Write-verbose 'Creating a narrative of differences'
				flyway $DiffParams  diff diffText >"$CurrentArtefactLocation\changes.json"
				# we do a chained command for both the DIFF and difftext, assuming that a report of the 
				# SQL is useful
				$Differences = Type "$CurrentArtefactLocation\changes.json" | convertfrom-JSON
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
				}
				if ('Changes' -in $WhatWeDo)
				{
					Write-verbose 'saving changes in the current version'
					$null = md "$CurrentArtefactLocation" -Force -ErrorAction SilentlyContinue
					$Changes | ConvertTo-Csv > "$CurrentArtefactLocation\changes.csv"
				}
			}#--end the 'if $WeHaveAComparison' 
    <#--    Now we can create the undo and versioned scripts  --#>			
			if ('Scripts' -in $WhatWeDo)
			{
				Write-verbose 'Creating the Undo and Versioned script'
                $GenerateParams = @(
						"-generate.types=$_",
						"-generate.artifactFilename=$CurrentArtefactLocation\artifact.diff"
						"-generate.version=$Version",
						"-generate.description=Generated-$description",
						"-generate.location=$CurrentScriptsLocation",
						'-generate.force=true'
					)
				@('undo', 'versioned') | foreach {
					#'versioned' left out until name correct
					
					# we do a generate. It now overwrites any existing 
					$generationFeedback = (flyway  $GenerateParams generate -outputType=json) #generate the script
					$generationFeedback | convertFrom-JSON | foreach{
						if ($_.error -ne $null) { write-Error $_.error.message }
						if ($_.warnings.count -gt 0) { $_.warnings | foreach{ write-warning $_ } }
					}
				}
    <#--    Now we create the baseline script     --#>
				# now do the baseline script. This requires a Diff with empty, 
				# otherwise it is identical to the versioned file
				Write-verbose 'Creating baseline script'
				flyway diff "-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json" '-diff.target=empty' `
					   generate "-generate.types=baseline" '-generate.description=Generated'`
					   "-generate.location=$CurrentScriptsLocation" "-generate.version=$Version" `
					   "-generate.force=true"  >"$CurrentScriptsLocation\log.txt"
				#Now we just add these files to the current folder so you can quickly see
				# what scripts are in the current directory
			} # finished doing scripts
			    <#--    Now we create the model     --#>
			if ('Model' -in $WhatWeDo)
			{
				
				Write-verbose 'Creating the model'
				#We need to make sure the directory exists
				#and we delete anything in it as we need an empty schema to compare with 
				$null = Remove-Item –path "$CurrentModelLocation\*" –recurse
				# we can now work out what the parameter should be
				$DiffParams = @(
					"-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json"
					'-diff.target=schemaModel'
					"-schemaModelLocation=$CurrentModelLocation"
				)
			}
			if ('Reports' -in $WhatWeDo)
			{
				# we do a chained command for both the DIFF and MODEL
				flyway $Diffparams diff model >"$CurrentModelLocation\log.txt"
				Write-verbose 'Creating the reports'
    <#--    Now we can update the directory with the current model      --#>
				if ($CurrentChangesLocation -ne $null -and $PreviousVersion -ne $null)
				{
					$snapshot_source = "$CurrentArtefactLocation\Snapshot.json"
					$snapshot_target = "$PreviousArtefactLocation\Snapshot.json"
					flyway check -changes "-check.nextSnapshot=$snapshot_source" `
						   "-check.deployedSnapshot=$snapshot_target" `
						   "-reportFilename=`"$CurrentChangesLocation\report.html`"">"$CurrentChangesLocation\report.txt"
				}
				
			} #if we are getting an extra artefact 
			
    <#--    Now we can update the directory with the current model      --#>
			
			del "$PresentVersionLocation" -Recurse -Force
			#now add the directories we want
			$CurrentDirectories | Foreach {
				if (!(test-path -path "$PresentVersionLocation\$($_)" -PathType Container))
				{
					$null = md "$PresentVersionLocation\$($_)"
				}
			}
		}
		if (($CurrentBuildLocation -ne $null) -and ('Build' -in $WhatWeDo))
		{
			Copy-Item -Path "$CurrentscriptsLocation\b*" `
					  -destination "$PresentVersionLocation\Build\build_V$($Version)_$description.sql" -Force
		}
		if ('Scripts' -in $WhatWeDo)
		{
			Copy-Item "$pwd\versions\$Version\scripts\*.sql" `
					  -Destination "$PresentVersionLocation\Scripts" -Force
		}
		Copy-Item "$pwd\versions\$Version\reports\*.*" `
				  -Destination "$PresentVersionLocation\Reports" -Force
		if ('Model' -in $WhatWeDo)
		{
			Copy-Item "$pwd\versions\$Version\Model\*.*" `
					  -Destination "$PresentVersionLocation\Model" -Recurse -Force
		}
	}
}


 
