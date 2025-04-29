<#	
	.NOTES
	===========================================================================
	 Created on:   	25/03/2025 10:33
	 Created by:   	Phil Factor
	 Organization: 	MML Systems
	 Filename:     DoACommand.ps1
	===========================================================================
	.DESCRIPTION
		This script is designed to execute Flyway commands efficiently from a programmer's editor.
		It enables seamless project switching and branch navigation while handling database credentials.
		A hierarchical file structure is required for proper execution.


    .EXAMPLE pwsh -File  "S:\work\Github\FlywayTeamwork\Resources\DoACommand.ps1" -ServerType "SqlServer"  -Server "Philf01" 
             pwsh -File  "S:\work\Github\FlywayTeamwork\Resources\DoACommand.ps1" -ServerType "SqlServer"  -Server "Philf01" -Command "clean"
#>
param (
	$command = 'info', # The Flyway command(s) to execute (default: 'info')
    $parameters = '', # Additional parameters for Flyway (only '-target' supported so far)
	$filename = $null, # Filename of the current migration script (used for version extraction)
    $ServerType = 'SQLServer', # The database type (e.g., SQLServer, PostgreSQL, etc.)
	$Server = '*', # The database server name (wildcard '*' if using a single server)
    $ProjectLocation = 'FlywayTeamwork' # Root folder of Flyway projects
)

try
{
    # Ensure the working directory is within the defined project space
	if ("$pwd" -notlike "*$ProjectLocation*")
	{ Write-Error "You must be editing within '$ProjectLocation' for this to work, not $path" -ErrorAction Stop }
    $Splitpath=("$pwd" -split "$ProjectLocation\\")
	$ProjectAndBranch = $Splitpath[1] -split '\\branches\\'
    $PathToFlyway=$Splitpath[0]; 
	$project = ($ProjectAndBranch[0] -split '\\')[0]
	$branch = switch ($ProjectAndBranch.count)
	{
		1 { 'main' } # Default branch if none specified
		default
		{
			($ProjectAndBranch[$psitem - 1] -split '\\')[0]
		}
	}
	
   # Define the location in the user area of database connection credentials
	$SecretsFile = "$env:USERPROFILE\$($Project)_$($ServerType)_$($Branch)_$Server.toml"
    #we look to see if there is anything suitable
    # if we have an ambiguous reference
 	$SecretFilesSpecified = dir $SecretsFile
   # Extract version number from filename if provided (for migrations)
    if ($filename -ne $null) 
        {#match undo or Version files to establish the version number
        $Version=(([regex]'(V|U)(?<Version>.{2,30})__').matches($filename).Groups|
           where {$_.Name -eq 'Version'}).Value
        if ($version -eq $null)
	    {  Write-Error "I can't find a version number in the filename '$filename'" -ErrorAction Stop 
        }
    }
    # Validate that exactly one secrets file is found
	if ($SecretFilesSpecified.count -gt 1)
	{ write-error "we need more details of the secrets file than $SecretsFile'" -ErrorAction Stop }
    # if we have no references at all
	if ($SecretFilesSpecified.count -eq 0)
	{ Write-Error "You must have a 'secrets' .toml file at $SecretsFile, for this to work" -ErrorAction Stop }
    #we create a Flyway parameter that asks Flyway to read in the parameter
	$currentCredentialsPath = "-configFiles=$($SecretFilesSpecified[0])"
}
catch
{
	Write-Output @"
{
  "Error" : "`"$($PSItem.ToString())`""
}
"@ -ErrorAction Stop
}
#any parameters could need values
# Parse additional parameters, supporting only '-target' so far
$parameterArray=$parameters-split ','
$parameterList=$parameterArray|foreach{if ($_ -eq '-target') {"$_=`"$version`""}else {$_}}

# we run the command(s) specified. The main branch is called after the name of the project
# Identify the appropriate branch (default to 'main' project name if needed)
$currentBranch=switch ( $branch ){  'main' {$project} default { $branch }}
#we must make it the working directory - though could set this as a parameter
	#go to the appropriate directory - make it your working directory

# Change working directory to the project branch directory
cd "$(($pwd -split "$currentBranch")[0])$branch"
#if we have more than one command we need to pass them as an array.
$commands= $command.Trim() -split  ' '
#and now we can now execute Flyway in the appropriate place
write-verbose "Flyway $currentCredentialsPath '-outputType=json'  $commands  $parameterList"
flyway $currentCredentialsPath '-outputType=json'  $commands  $parameterList

