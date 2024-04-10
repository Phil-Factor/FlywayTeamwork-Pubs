function Import-PSONObject
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Filename,
		[Parameter(Mandatory = $false)]
		[System.Collections.IEnumerable]$AllowedCommands=$null,
		[System.Collections.IEnumerable]$AllowedVariables=$null
	)
	
	$content = Get-Content -Path $Filename -Raw -ErrorAction Stop
	$scriptBlock = [scriptblock]::Create($content)
	$scriptBlock.CheckRestrictedLanguage($allowedCommands, $allowedVariables, $true)
	(& $scriptBlock)
}
