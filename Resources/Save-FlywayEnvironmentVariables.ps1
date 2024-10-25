<#
	.SYNOPSIS
		Saves Environment variables that are associated with Flyway. 
	
	.DESCRIPTION
		Saves a copy of the current environment variables. These can be saved as a JSON file or as a 
    powershell script that restores them. if $CurrentSettings has a value, the settings are listed
	in a JSON file. If $FlywayEnvs is specified, a powershell script is provided to write the
	settings.
    this routine which needs to be run in a script or callback, finds all the flyway settings made for 
    the connection and saves them in the user area as a JSON file. and/or as a Powershell script
	
	.PARAMETER CurrentSettings
		the name of the json file that is saved to the user area
	
	.PARAMETER FlywayEnvs
		the name of the powershell script which restores the flyway environewmt that is saved to the user area
	
	.EXAMPLE
				PS C:\> Save-FlywayEnvironmentVariables -CurrentSettings 'Value1' -FlywayEnvs 'Value2'
	
	 .NOTE
	    For this to work, you can set up special environment variables to tell the routine where to save the information
	    e.g.
	    $Env:FP__CurrentSettings__='myListOfENVs'
	    $Env:FP__FlywayEnVs__='CreateFlywayENVs'

		then call it with Save-FlywayEnvironmentVariables $Env:FP__CurrentSettings__ $Env:FP__FlywayEnVs__
#>
function Save-FlywayEnvironmentVariables
{
	[CmdletBinding()]
	param
	(
		[string]$CurrentSettings=$null,
		[string]$FlywayEnvs=$null
	)
	
	if ($CurrentSettings -ne $null)
	{
		Get-FlywayConfContent -WeWantConfigInfo $false|ConvertTo-json > "$env:USERPROFILE\$CurrentSettings.ps1"
	}
	
	if ($FlywayEnvs -ne $null)
	{
		# if either of these variables have a value
		
		# get all the Flyway variable and placeholder values held in the session environment
		('env:FLYWAY_*', 'env:FP__*') | foreach{ gci $_ } | sort-object name | foreach-object -Begin {
			$TheList = @{ };
		} -Process {
			#take each relevant environment variable and strip out the actual name
			$TheList[$_.Name] = $_.Value;
		}
		-end {
			($TheList.Keys | foreach{ "`$Env:$($_)='$($TheList[$_])';" }
			)>"$env:USERPROFILE\$FlywayEnvs.ps1"
		}
	}
}

