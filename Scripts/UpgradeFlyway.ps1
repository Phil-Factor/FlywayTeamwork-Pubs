<#
.SYNOPSIS
    Downloads the latest version of Flyway and sets the flyway command to execute this version

.DESCRIPTION
    This automates the download of the latest version of flyway 

.EXAMPLE
    (execute as admin)
    $env:FlywayWorkPath\scripts\UpgradeFlyway.ps1
#>

<# Verify Install Directory Exists:
Checks that the base directory for Flyway versions is present. If not, installation cannot proceed.
#>
<# #>
if ([string]::IsNullOrEmpty($ENV:FlywayInstallation))
{
	Write-Warning @"
You must have set an environment variable to the path to the Flyway installation location 
"@ -WarningAction Stop
}
# Check for admin rights
if (-not ([Security.Principal.WindowsPrincipal] `
		[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
		[Security.Principal.WindowsBuiltInRole]::Administrator))
{
	Write-Warning @"
This script must be run as an Administrator.
Right-click the script or PowerShell and choose 'Run as administrator
"@ -WarningAction Stop
}

Write-verbose "Running script with Admin rights. First "
<# we find the top current installed version in the Flyway install
directory (we can have several if we have favourite old versions or
need to run legacy systems with original Flyway version #>
$Installpath = "$ENV:FlywayInstallation\flyway.commandline\tools"
if (!(Test-Path $Installpath -PathType Container))
{ Write-error "Sorry, but the Flyway install directory '$Installpath' does not yet exist" -ErrorAction Stop }
Write-verbose "we have found an installation at $Installpath"
$currentInstalledVersion = dir $Installpath -directory -name | foreach{
	[version]($_ -replace 'flyway-', '')
} | sort -Descending | select -first 1 | foreach{
	$_Oldversion = $_; $_.ToString()
}
if ([string]::IsNullOrEmpty($currentInstalledVersion))
{
	Write-Verbose "The Install directory has no flyway installs yet"
}
else
{
	# Fetch the content of the web page
	Write-Verbose "Your latest installed version of Flyway is $currentInstalledVersion"
    <# Fetch Webpage to Discover Latest Version:
This fetches Flyway's documentation page to scrape the version number from download links. This avoids needing an API call.
 #>
	try
	{
		# Define the URL to fetch and fetch page content
		$url = "https://documentation.red-gate.com/flyway/reference/usage/command-line"
		$response = Invoke-WebRequest -Uri $url -UseBasicParsing
		$content = $response.Content
<#      Extract Version Using Regex:
        A regular expression looks for the zip filename for the Windows x64 installer. 
        If found, the version number is extracted.
        #>		
		# Define the regex pattern to extract the version number
		# This looks for 'flyway-commandline-' followed by a version pattern
		$pattern = 'flyway-commandline-(\d+\.\d+\.\d+)-windows-x64\.zip'
		
		# Perform the regex match
		if ($content -match $pattern)
		{
			# Extract the version number from the match group
			$flywayLatestVersion = $matches[1]
			Write-Output "Flyway Latest Version Number: $flywayLatestVersion"
			$flywayVersion = $flywayLatestVersion
		}
		else
		{
			Write-Output "Version string not found in the webpage content."
		}
		
	}
	catch
	{
		Write-Error "Failed to retrieve or process the webpage. Error: $_"
	}
}
<# Compare Versions:
If the online version is newer than what is installed, proceed to upgrade.#>
if ($currentInstalledVersion -lt [version]$flywayLatestVersion)
{
	Write-verbose "Will download Flyway $flywayLatestVersion to upgrade from Flyway $currentInstalledVersion"
	$Url = "https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/$flywayVersion/flyway-commandline-$flywayVersion-windows-x64.zip"
	$DownloadZipFile = "$env:temp\flyway-$flywayVersion.zip"
	$ExtractPath = "$ENV:FlywayInstallation\flyway.commandline\tools"
	if (Test-Path "$Installpath\flyway-$flywayVersion" -PathType Container)
	{
		Write-Error "Somehow, That version $flywayVersion is already installed"
		Exit 1
	}
	# Ensure that the Flyway extraction directory exists
	if (-Not (Test-Path $ExtractPath -PathType Container))
	{
		# Create the directory if it doesn't exist
		New-Item $ExtractPath -ItemType Directory -Force
		Write-verbose "Folder Path '$ExtractPath' Created successfully"
	}
	if (!(test-path $DownloadZipFile -PathType Leaf))
	{
		Write-Verbose "Downloading Flyway Version: $flywayVersion"
		Invoke-WebRequest -Uri $Url -OutFile $DownloadZipFile -UseBasicParsing
	}
	if (-Not (Test-Path "$DownloadZipFile"))
	{
		Write-Error "Flyway extraction failed."
		Exit 1
	}
	Write-Verbose "Extracting Flyway files to install location"
	Expand-Archive -Path $DownloadZipFile -DestinationPath $ExtractPath -Force -ErrorAction Stop
	Write-Verbose "Tesk complete"
    <# This only seems necessary if you install flyway the way I do (I like to store old versions
    and be able to revert in an emergency) with the rapidity of releases it's convenient #>
	#get the path to the latest version of Flyway
	$Latest = "$ENV:FlywayInstallation\flyway.commandline\tools\flyway-$flywayVersion\flyway.cmd"
	Set-Alias -Name 'Flyway' -Value $Latest -Scope global
    #annoying extra for enterprise users that requires internet access.
	# Flyway auth -IAgreeToTheEula 	
}
else
{
	Write-verbose "You are currently already on the latest version ($currentInstalledVersion)"
}
