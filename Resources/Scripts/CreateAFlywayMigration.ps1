<#	
	.NOTES
	===========================================================================
	 Created on:   	23/04/2025 10:33
	 Created by:   	Phil Factor
	 Organization: 	MML Systems
	 Filename:     CreateAFlywayMigration.ps1
	===========================================================================
	.DESCRIPTION
		This script is designed to execute Flyway commands efficiently from a programmer's editor.
		It enables seamless project switching and branch navigation while handling database credentials.
		A hierarchical file structure is required for proper execution.
             cd "$env:FlywayWorkPath\Pubs\Branches\develop\migrations\sql"
    .EXAMPLE pwsh -File  "S:\work\Github\FlywayTeamwork\Resources\Scripts\CreateAFlywayMigration.ps1"  -Description "AuthorsAndEditions" -Server "Philf01" -serverType="SQLServer" 
             pwsh -File  "S:\work\Github\FlywayTeamwork\Resources\Scripts\CreateAFlywayMigration.ps1"  -Description "SQUAREABORT" -filename "V1.2__SecondRelease1-1-3to1-1-11"  -Server "Philf01" -serverType="SQLServer" 

    #>
param (
    $description = 'Mysterious', # Description of the migration or undo
    $type=$null, #undo, baseline
    $location=$null, #if you want to specify where
    $force=$null, #overwrite the existing file?
    $nameonly=$null, #don't create the file
    $ServerType = 'SQLServer', # The database type (e.g., SQLServer, PostgreSQL, etc.)
	$Server = '*', # The database server name (wildcard '*' if using a single server)
    $ProjectLocation = 'FlywayTeamwork' # Root folder of Flyway projects
)
    $TheType='';$Thelocation='';$Theforce='';$Thenameonly='';
    if ($type -ne $null) {$TheType="-type `"$type`""};  #undo, baseline
    if ($location-ne $null) {$Thelocation="-location `"$location`""}; #if you want to specify where
    if ($force-ne $null) {$Theforce="-force `"$force`""}; #overwrite the existing file?
    if ($nameonly-ne $null)  {$Thenameonly="-nameonly`"$nameonly`""}; #don't create the file


	if ("$pwd" -notlike "*$ProjectLocation*")
	{ Write-Error "You must be editing within '$ProjectLocation' for this to work, not $($pwd.path)" -ErrorAction Stop;
     $NoReallyStop=$true }

try
{
    # Ensure the working directory is within the defined project space
    #We now need to eork out what branch we are working on 
    $Splitpath=("$pwd" -split "$ProjectLocation\\")
    #this is dependent on our way of doing directories
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

$currentBranch=switch ( $branch ){  'main' {$project} default { $branch }}

#we must make it the working directory - though could set this as a parameter
	#go to the appropriate directory - make it your working directory

# Change working directory to the project branch directory
cd "$(($pwd -split "$currentBranch")[0])$Currentbranch"
$result= flyway $currentCredentialsPath '-outputType=json' 'add' "-description=$description" $TheType $Thelocation $Theforce $Thenameonly;
$ResultObject=($result|convertfrom-json)
if ($ResultObject.error -ne $null)
    {write-error $ResultObject.error -ErrorAction Stop}
else {
    write-host $ResultObject.migrationPath
    EditPadPro8.exe $ResultObject.migrationPath
}

#{
#  "migrationPath" : "file:///S:/work/Github/FlywayTeamwork/Pubs/Branches/develop/./migrations/V1.1.18.sql"
#}
