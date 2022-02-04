<#
	.SYNOPSIS
		Join all migration files in version order
	
	.DESCRIPTION
		Take a migration directory and concatenate (join) all the migration files together
		in the correct order into one script which is saved to the destination
	
	.PARAMETER TheDirectory
		the directory, flyway location, with the files in it.
	
	.PARAMETER DestinationFile
		The name of the file to containTheMigration
	
	.PARAMETER StartVersion
		the earliest version to include
	
	.PARAMETER EndVersion
		The final version of the migration to include
	
	.EXAMPLE
		Concatenate-Migrations "$pwd\$($dbDetails.migrationsPath)" `
		"$pwd\$($dbDetails.ScriptsPath)\V1.12__SecondRelease1-1-3to1-1-11.sql" `
		'1.1.3' '1.1.11'
	
	.NOTES
		Should I add a Allowlist or Blocklist? Should one concatenate undoS?
#>
function Concatenate-Migrations
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[String]$TheDirectory,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[string]$DestinationFile,
		[Parameter(Position = 3)]
		[version]$StartVersion = [version]'0.0.0',
		[Parameter(Position = 4)]
		[version]$EndVersion = [version]'32000.0.0' #latest version to do, leave to do all
	)
	
	$FileContents = [string]'';
	$FileContents += Dir "$TheDirectory\V*.sql" |
	foreach{
		[pscustomobject]@{
			'file' = $_.Name;
			'version' = [version]($_.Name -ireplace '(?m:^)V(?<Version>.*)__.*', '${Version}')
		}
	} |
	where { (!($_.version -lt $StartVersion) -and !($_.version -gt $EndVersion)) } |
	Sort-Object -Property @{ Expression = "version"; Descending = $false } |
	foreach{
		Write-Verbose "processing $($_.file)"
		[IO.File]::ReadAllText("$TheDirectory\$($_.file)")
	}
	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' #Flyway likes this
	$FileContents> $DestinationFile
}
