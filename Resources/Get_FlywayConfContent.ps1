<#
	.SYNOPSIS
		Get the configuration values from all the Flyway sources, including any encrypted files
	
	.DESCRIPTION
		This gathers up all of the Flyway configuration values  frtom file or environment variable in order of precendence. It uses the current working folder to get its values
	
	.PARAMETER ListOfSources
		A list of extra resources with config information such as config information passed as parameters.
	
	.EXAMPLE
		PS C:\> Get-FlywayConfContent 
	
#>
function Get-FlywayConfContent
{
	param
	(
		[array]$ListOfSources = @()
	)
	
	$FlywaylinesToParse = @()
	
	if (test-path 'env:FP__ParameterConfigItem__')
	{
		if ("$env:FP__ParameterConfigItem__" -notin $ListOfSources)
		{ $ListOfSources += "$env:FP__ParameterConfigItem__" }
	}
	#We need to add unencrypted file import too 
	#has the placeholder been set to explain that an encrypted file was imported into Flyway?
	#Flyway will do placeholder substitutions 
	if (!([string]::IsNullOrEmpty("$env:FP__dpeci__")))
	{
		$secureString = Import-Clixml "$env:FP__dpeci__"
		$bstrPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
		try
		{
			$originalText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstrPtr)
		}
		finally
		{
			[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrPtr)
			
		}
		$FlywaylinesToParse += $originalText -split "`n"
	}
	if ($ListOfSources.count -gt 0 -and !([string]::IsNullOrEmpty($ListOfSources)))
	{
		$ListOfSources | foreach { $FlywaylinesToParse += Get-content "$_" }
	}
	$FlywaylinesToParse += gci env:FLYWAY* | foreach{ "flyway.$($_.Name.ToLower() -replace 'FLYWAY_', '') = $($_.value)" }
	$FlywaylinesToParse += gci env:FP_* | foreach{ "$($_.Name -replace 'FP__flyway_', '') = $($_.value)" }
	$FlywaylinesToParse += Get-Content "flyway.conf"
	$FlywaylinesToParse += Get-content "$env:userProfile\flyway.conf"
	$FlywayConfContent = @()
	$FlywaylinesToParse |
	where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
	foreach{ $_ -replace '\\', '\\' } |
	ConvertFrom-StringData | foreach {
		if ($FlywayConfContent."$($_.Keys)" -eq $null)
		{ $FlywayConfContent += $_ }
	}
	
	$FlywayConfContent
	
}


$FlywaylinesToParse |
	where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
	foreach{ $_ -replace '\\', '\\' } |
	ConvertFrom-StringData | foreach {
		if ($FlywayConfContent."$($_.Keys)" -eq $null)
		{ $FlywayConfContent += $_ }
	}

@'
# Settings are simple key-value pairs
flyway.key=value
# Single line comment start with a hash

# Long properties can be split over multiple lines by ending each line with a backslash
flyway.locations=filesystem:my/really/long/path/folder1,\
    filesystem:my/really/long/path/folder2,\
    filesystem:my/really/long/path/folder3

# These are some example settings
flyway.url=jdbc:mydb://mydatabaseurl
flyway.schemas=schema1,schema2
flyway.placeholders.keyABC=valueXYZ
'@  -split "`n"| where {
 ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '')
  } | foreach -begin {$Folding=''}{
  if ($_ -match '\\[\\\s]*')
  {$folding="$folding$(($_ -ireplace '\\[\\\s]*','').trim())"}
  else { "$folding$($_.trim())"; $Folding=''}
  }| foreach{ $_ -replace '\\', '\\' } | ConvertFrom-StringData 