<#
	.SYNOPSIS
		Updates Flyway's existing entry in the path ENV variable to the latest version
	
	.DESCRIPTION
		This little utility is to update an installation done originally with Chocolatey
	
	.PARAMETER FlywayinstallDirectory
		The directory where Flyway is installed, where there are subdirectories with each 
		installed versiuon
	
	.EXAMPLE
				PS C:\> Update-FlywayCliPath -FlywayinstallDirectory `
											 "$env:FlywayInstallation\flyway.commandline\tools"
	
	.NOTES
		Additional information about the function.
#>
function Update-FlywayCliPath
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$FlywayinstallDirectory
	)
	
	   <# This only seems necessary if you install flyway the way I do (I like to store old versions
    and be able to revert in an emergency) with the rapidity of releases it's convenient #>
	{
		$Latest = (Dir "$FlywayinstallDirectory\flyway-*\flyway.cmd" | ` # lets see them all
			Sort-Object -property creationtime -descending | select -first 1).Fullname
		Set-Alias -Name 'Flyway' -Value $Latest -Scope global
		
		$Updated = ((get-ChildItem Env:\Path | Select-Object -ExpandProperty value) -split ';' | foreach{
				$_ -creplace '(?<FlywayPath>.+\\flyway-).+', ('${FlywayPath}' + $latest)
			}) -join ';'
		[Environment]::SetEnvironmentVariable('PATH', $Updated, 'user')
	}
	
}
