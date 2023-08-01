<#
	.SYNOPSIS
		Simulate STDIN of Flyway Config items
	
	.DESCRIPTION
		This creates a hashtable of  config items that can be fed to Flyway as if they were typed-in parameters.
	
	.PARAMETER file
		The file cntaining the information
	
	.EXAMPLE
				PS C:\> Get-Conf MyFile
	
#>
function Get-Conf
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[string]$file
	)
	{
		type $file | foreach
		-Begin
		{
			$Values = @();
		} 
		-Process {
			$Values += $_.Split("`n") |
			where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
			foreach{ $_ -replace '\Aflyway\.', '-' }
		}
		-End {
			$Values }
	}
}
