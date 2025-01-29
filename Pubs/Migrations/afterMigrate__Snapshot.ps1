<# This callback demonstrates a way of taking a snapshot, create a model, and generate
all the useful SQL Scripts that you might need for every version. It also provides
the data that tells you what's changed.

  This is powershell, but it can be executed as a callback from a Flywway task that
  runs from Dos Commandline  or BASH. This makes it prudent to make sure you are using 
  the latest flyway. Make sure that the next line has the path to your install directory.
  The easiest approach for me is to define my  flyway installation an an environment 
  variable #>
$FlywayinstallDirectory = "$env:FlywayInstallation\flyway.commandline\tools"

<# This seems necessary if you install flyway the way I do (I like to store old versions
and be able to revert in an emergency) with the rapidity of releases it's convenient #>
$Latest = (Dir "$FlywayinstallDirectory\flyway-*\flyway.cmd" | ` # lets see them all
	Sort-Object -property creationtime -descending | select -first 1).Fullname
Set-Alias -Name 'Flyway' -Value $Latest

<#-- we use 'info' to fetch the essential details we need for the various operations --#>

# we establish what the current version of the database is, the name of the migration
# file that prtoduced it, the previous version and the list of schemas.
$ContentsOfOutput = (flyway  '-outputType=json'  info)# also catches flyway execution errrors
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
if ($WeHaveAllRequiredInfo) #only if we got the info we need 
{ #we can now assemble all our essential variables
	$Version = $Info.schemaVersion #get the current version
    $schemas=$Info.schemaName
	# .. and the description of the version
	$description = $Info.migrations | where { $_.rawVersion -eq $version } | foreach { $_.description }
	
	$CurrentArtefactLocation = "$pwd\Versions\$Version\Reports" #where the reports go
	$CurrentScriptsLocation = "$pwd\Versions\$Version\Scripts"  #where the scripts go
	$CurrentModelLocation = "$pwd\Versions\$Version\Model"      #where the models go
    $PresentVersionLocation = "$pwd\versions\current"           #the 'current' directory with a copy of the currentversion

<#--    Now we create the snapshot      --#>
	#Create the directory if it doesn't exist.
    ($CurrentArtefactLocation, $CurrentScriptsLocation, $CurrentModelLocation,
    "$PresentVersionLocation\Scripts","$PresentVersionLocation\Reports",
    "$PresentVersionLocation\Model")| Foreach {
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

<#--    Now we find the previous version and compare with it (or with 'empty'--#>	
	$WeHaveAComparison = $false;
	$PreviousVersion = $info.migrations | 
       where { -not [string]::IsNullOrEmpty($_.rawversion) } |
	   where { $_.state -eq 'Success' -and [version]$_.rawVersion -lt [version]$Version } |
	   Sort-Object -Descending -Property rawVersion |
       select -First 1 | foreach{ $_.rawversion }
	if ($PreviousVersion -ne $null)
	{
		$PreviousArtefactLocation = "Versions\$PreviousVersion\reports"
		# if there was a snapshot for the previous version we compare with that
		# was there a snapshot for the previous version
		
		if (!(test-path -path "$PreviousArtefactLocation" -PathType Leaf))
		{
			Write-Host "there is a snapshot at $PreviousArtefactLocation that we can compare with";
			$WeHaveAComparison = $true
		}
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
		$null = md "$CurrentArtefactLocation\reports" -Force
		$Changes | ConvertTo-Csv > "$CurrentArtefactLocation\changes.csv"
	}
<#--    Now we can create the undo and versioned sctrips  --#>	
	@('undo', 'versioned') | foreach {
		#'versioned' left out until name correct
		$GenerateParams = @(
			"-generate.types=$_",
			"-generate.artifactFilename=$CurrentArtefactLocation\artifact.diff"
			"-generate.version=$Version",
			"-generate.description=Generated-$description",
			"-generate.location=$CurrentScriptsLocation",
			'-generate.force=true'
		)
		# we do a generate. It now overwrites any existing 
		$generationFeedback=(flyway  $GenerateParams generate -outputType=json) #generate the script
		$generationFeedback | convertFrom-JSON | foreach{
			if ($_.error -ne $null) { write-Error $_.error.message }
			if ($_.warnings.count -gt 0) { $_.warnings | foreach{ write-warning $_ } }
		}
	}
<#--    Now we create the baseline script     --#>
	# now do the baseline script. This requires a Diff with empty, 
	# otherwise it is identical to the versioned file
	flyway diff "-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json" '-diff.target=empty' `
		   generate "-generate.types=baseline" '-generate.description=Generated'`
		   "-generate.location=$CurrentScriptsLocation" "-generate.version=$Version" `
		   "-generate.force=true"  >"$CurrentScriptsLocation\log.txt"
	#Now we just add these files to the current folder so you can quickly see
	# what scripts are in the current directory
	
<#--    Now we create the model     --#>
	
	#We need to make sure the directory exists
	#and we delete anything in it as we need an empty schema to compare with 
	$null=Remove-Item –path "$CurrentModelLocation\*" –recurse
	# we can now work out what the parameter should be
	$DiffParams = @(
		"-diff.source=snapshot:$CurrentArtefactLocation\Snapshot.json"
		'-diff.target=schemaModel'
		"-schemaModelLocation=$CurrentModelLocation"
	)
	# we do a chained command for both the DIFF and MODEL
	flyway $Diffparams diff model >"$CurrentModelLocation\log.txt"
<#--    Now we can update the directory with the current model      --#>	
    del "$PresentVersionLocation" -Recurse -Force 
    @('Scripts','Reports','Model')|Foreach {
        if (!(test-path -path "$PresentVersionLocation\$($_)" -PathType Container))
            {
            $null=md "$PresentVersionLocation\$($_)"
            }
        }
	Copy-Item "$pwd\versions\$Version\scripts\*.sql" `
			  -Destination "$PresentVersionLocation\Scripts" -Force
	Copy-Item "$pwd\versions\$Version\reports\*.*" `
			  -Destination "$PresentVersionLocation\Reports" -Force
	Copy-Item "$pwd\versions\$Version\Model\*.*" `
			  -Destination "$PresentVersionLocation\Model" -Recurse -Force
} 
#--end the 'if $WeHaveAComparison' 

