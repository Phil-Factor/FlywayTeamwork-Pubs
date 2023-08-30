
function Get-GPGconf <# creates an array of parameters for Flyway
from a file that is formatted as a fleyway.conf file. #>
{
	[CmdletBinding()]
	[OutputType([array])]
	param
	(
		[Parameter(Mandatory = $true,
		ValueFromPipeline = $true)]
		[string]$List
	)
	
	$list -csplit ',' | foreach `
	-Begin { $Values = @(); } `
	{
		$Values += (gpg -d -q  $_).Split("`n") |
		
		where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
		foreach{ $_ -replace '\Aflyway\.', '-' }
	} `
	-End { $Values }
}
