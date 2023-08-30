<#
	.SYNOPSIS
		Simulate STDIN of Flyway Config items
	
	.DESCRIPTION
		This creates a hashtable of  config items that can be fed to Flyway as if they were typed-in parameters.
	
	.PARAMETER file
		The file cntaining the information
	
	.EXAMPLE
				PS C:\> Get-Conf -file $Secrets
				PS C:\> Get-Conf -file $null
	            PS C:\> Get-Conf -file ''
#>
function Get-Conf
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[string]$file = ''
	)
	if (!([string]::IsNullOrEmpty($File)))
    {
		get-content $file | foreach	-Begin	{
			$Values = @();
		} -Process {
			$Values += $_.Split("`n") |
			where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
			foreach{ $_ -replace '\Aflyway\.', '-' }
		} -End  { #tell callbacks where this file is
			$Values  += "-placeholders.ParameterConfigItem=$file";
            $Values
            }
    }	

}
