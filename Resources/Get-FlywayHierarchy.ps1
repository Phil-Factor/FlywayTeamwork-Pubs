<#
	.SYNOPSIS
		Reveals a flyway hierarchy
	
	.DESCRIPTION
		This is a simple routine for seeing what is in a Flyway branch hierarchy, using the convention of naming.
		Returns the map as an object
	
	.PARAMETER $Directory
		the path to the directory that represents the flyway project on a network location
#>
function Get-FlywayHierarchy
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Directory,
		[string]$Relationship
	)
	
	if ($Directory -is 'string')
	{ $Branch = $directory -Split '[\\/]' | select -Last 1 }
	else { $Branch = $directory.name }
	$TheBranch = @{ $Relationship = $branch }
	$TheVariants = dir "$directory\variants\*" -Directory -ErrorAction Ignore | foreach{ Get-FlywayHierarchy $_ 'variant' }
	$TheBranches = dir "$directory\branches\*" -Directory -ErrorAction Ignore | foreach{ Get-FlywayHierarchy $_ 'branch' }
	if ($TheBranches -ne $null) { $TheBranch.Branches = $TheBranches }
	if ($TheVariants -ne $null) { $TheBranch.Variants = $TheVariants }
	$TheBranch
}

