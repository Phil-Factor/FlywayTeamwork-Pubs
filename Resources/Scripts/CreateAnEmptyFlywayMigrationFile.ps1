<#	
	.NOTES
	===========================================================================
	 Created on:   	23/04/2025 10:33
	 Created by:   	Phil Factor
	 Organization: 	MML Systems
	 Filename:     CreateAnEmptyFlywayMigrationFile.ps1
	===========================================================================
	.DESCRIPTION
		This script is designed to create a new migration file from a programmer's editor.
   .EXAMPLE  pwsh -File  "S:\work\Github\FlywayTeamwork\Resources\Scripts\CreateAnEmptyFlywayMigrationFile.ps1"  -Description "AuthorsAndEditions"
             pwsh -File  "S:\work\Github\FlywayTeamwork\Resources\Scripts\CreateAnEmptyFlywayMigrationFile.ps1"  -Description "SQUAREABORT" 

    #>
param (
    $description = 'Mysterious', # Description of the migration or undo
    $type=$null, #undo, baseline
    $location=$null, #if you want to specify where it should go
    $force=$null, #overwrite the existing file?
    $nameonly=$null, #don't create the file
    $ProjectLocation = 'FlywayTeamwork' # Root folder of Flyway projects
)
# we add whatever parameters are wanted and put them in the command line
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
}
catch
{
	Write-error @"
{
  "Error" : "`"$($PSItem.ToString())`""
}
"@ -ErrorAction Stop
}

$currentBranch=switch ( $branch ){  'main' {$project} default { $branch }}
#go to the appropriate directory 
# Change working directory to the project branch directory
cd "$(($pwd -split "$currentBranch")[0])$Currentbranch"
$result= flyway '-outputType=json' 'add' "-description=$description" $TheType $Thelocation $Theforce $Thenameonly;
$ResultObject=($result|convertfrom-json)
#Check for any errors 
if ($ResultObject.error -ne $null)
    {write-error $ResultObject.error -ErrorAction Stop}
else {
    $TheFileWeveCreated=$ResultObject.migrationPath
    #we write the name back to the calling application
    $TheFileWeveCreated=($TheFileWeveCreated -replace 'file:///','') -replace '/./','/'
    write-host $TheFileWeveCreated
    #we can get EditPadPro to open a pane for the new file so you can enter your code.
    EditPadPro8.exe $TheFileWeveCreated
}

