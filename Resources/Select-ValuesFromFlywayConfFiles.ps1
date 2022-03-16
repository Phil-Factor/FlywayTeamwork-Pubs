<#
	.SYNOPSIS
		Show all the values in  flyway.conf files in a hierarchy
	
	.DESCRIPTION
		create a hastable of all the config files and their values, from which you can, if necessary select particular values
	
	.PARAMETER Directory
		the directory in which you start your search
	
	.PARAMETER Relationship
		the relationship within the hierarchy, leave blank for the first one
	
	.EXAMPLE
		$TheFlywaySettings = Select-ValuesFromFlywayConfFiles '<pathTo>\FlywayTeamwork\Pubs'

		$TheFlywaySettings | foreach{ $TheBranch = $_.Branch; $_.Contents } |
		   where { $_.keys[0] -eq 'flyway.url' } | foreach{ @{ $TheBranch = $_.Values[0] } }
	
#>
function Select-ValuesFromFlywayConfFiles
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Directory,
		[Parameter(Mandatory = $false)]
		[string]$Relationship = ''
	)
	
	if ($Directory -is 'string')
	{ $Branch = $directory -Split '[\\/]' | select -Last 1 }
	else { $Branch = $directory.name }
	if (Test-Path -path "$directory\Flyway.conf" -PathType Leaf)
	{
		@{
			'Branch' = "$Relationship/$branch"; 'Contents' = (Get-Content "$directory\Flyway.conf") |
			where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
			ConvertFrom-StringData
		}
	}
	if (Test-Path "$directory\variants" -PathType Container)
	{
		dir "$directory\variants\*" -Directory |
		foreach{ Select-ValuesFromFlywayConfFiles $_ "$Relationship/$branch" }
	}
	if (Test-Path "$directory\branches" -PathType Container)
	{
		dir "$directory\branches\*" -Directory |
		foreach{ Select-ValuesFromFlywayConfFiles $_ "$Relationship/$branch" }
	}
	
}



