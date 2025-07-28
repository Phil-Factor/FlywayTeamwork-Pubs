<#  
  .NOTES
  ===========================================================================
   Created on:     17/09/2024 10:01
   Created by:     Phil Factor
  ===========================================================================
  .DESCRIPTION
This routine will print a colourcoded message to explain what environment is actually being
used. It is used in a callback because only then will the placeholders be visible#>

$Message="Used $env:FP__currentEnvironment__ for $env:FP__projectName__  ($env:FP__projectDescription__)  $env:FP__Branch__ branch "                                                           
If (-Not (Test-path ".\reports" -Pathtype Container))
	{ $null = New-Item -ItemType directory -Path ".\reports" -Force }
	@"
Write-Host "$Message"  -ForegroundColor $env:FP__foregroundColour__ -BackgroundColor $env:FP__backgroundColour__
"@ >".\reports\current.ps1"

<#
'Black','DarkBlue','DarkGreen','DarkCyan','DarkRed',
'DarkMagenta','DarkYellow','Gray','DarkGray','Blue',
'Green','Cyan','Red','Magenta','Yellow','White'
#>