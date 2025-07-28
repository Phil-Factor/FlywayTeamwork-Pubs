#$Env:FP__projectDirectory__="S:\work\Github\FlywayTeamwork\Pubs"
param ($ListOfExtraSources= @()# these should be absoluter paths
) 
#these are extra configuration files, usually decrypted en-route and  read in as parameters.
<#
 Principles:
  one 'resource' directory with all the scripting tools we need for the project
  each branch needs its own place for reports, source and scripts
Each branch must maintain its own copy of the database to preserve isolation
Each branch 'working directory' should be the same structure.
All data is based on the Current working directory.
Use flyway.conf where possible #>
#were parameters read from a file? If so, we need to read that file
#gci env:F* | sort-object name
<# first check that flyway is installed properly #>
$FlywayCommand = (Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand)
{
	write-error "This script requires Flyway to be installed and available on a PATH or via an alias" -ErrorAction Stop
}
if ($FlywayCommand.CommandType -eq 'Application' -and
	($FlywayCommand.Version -gt [version]'0.0.0.0' -and $FlywayCommand.Version -lt [version]'0.8.1.0'))
{
	write-error "Your Flyway Version is too outdated to work" -ErrorAction Stop
}

# is the placehoder set for the project directory?
$TheWorkingDirectory= $Env:FP__projectDirectory__;
 #Oops! has Flyway set a placeholder for the working directory ?
if ([string]::IsNullOrEmpty($TheWorkingDirectory)) {$TheWorkingDirectory= $Env:FP__flyway_workingDirectory__} 
# ah well, we assume it is the current directory
if ([string]::IsNullOrEmpty($TheWorkingDirectory)) {$TheWorkingDirectory=$pwd.Path}
Write-verbose "We have found '$TheWorkingDirectory'"
$dir=[System.IO.DirectoryInfo]$TheWorkingDirectory
# $dir.FullName
<#
pick up any changed locations that the user wants. 
If nothing exists, then create the file with the default settings in place
#>
 If (!(Test-Path -Path "$TheWorkingDirectory\DirectoryNames.json" -PathType Leaf))
    {@{
	'migrationsPath' = 'Unknown'; 
        #where the migration scripts are stored-branch structure default to Migrations
	'resourcesPath' = 'resources'; #the directory that stores the project-wide resources
	'sourcePath' = 'Source'; #where the source of any branch version is stored
	'scriptsPath' = 'Scripts'; #where the various scripts of any branch version is stored #>
	'DataPath' = 'Data'; #where the data for any branch version is stored #>
	'VersionsPath' = 'Versions'; #where data for all the versions is stored #>
    'Reportdirectory'='Documents\GitHub\'<# path to the directory where data about migration is stored #>
    } |convertto-json > "$TheWorkingDirectory\DirectoryNames.json"
    }

$FileLocations=[IO.File]::ReadAllText("$TheWorkingDirectory\DirectoryNames.json")|convertfrom-json

$ResourcesPath= if ([string]::IsNullOrEmpty($FileLocations.ResourcePath)) 
        {'resources'} else {"$($FileLocations.ResourcesPath)"}
$sourcePath= if ([string]::IsNullOrEmpty($FileLocations.SourcePath))
        {'source'} else {"$($FileLocations.sourcePath)"}
$ScriptsPath= if ([string]::IsNullOrEmpty($FileLocations.ScriptsPath)) 
        {'scripts'} else {"$($FileLocations.ScriptsPath)"}
$dataPath= if ([string]::IsNullOrEmpty($FileLocations.DataPath)) 
        {'data'} else {"$($FileLocations.DataPath)"}
#$ReportLocation is used for the  classic version
$VersionsPath= if ([string]::IsNullOrEmpty($FileLocations.VersionsPath)) 
        {'Versions'} else {"$($FileLocations.VersionsPath)"}
$Reportdirectory= if ([string]::IsNullOrEmpty($FileLocations.Reportdirectory)) 
        {'Documents\GitHub\'} else {"$($FileLocations.Reportdirectory)"}
#$ReportLocation is used for the branch version
$ReportLocation="$TheWorkingDirectory\$VersionsPath"# part of path from user area to project artefacts folder location 
$TestsLocations=@();
#look for the common resources directory for all assets such as modules that are shared

$ii = 10; # $ii merely prevents runaway looping.
if (test-path   "..\$ResourcesPath")
    {$Branch ='main'}
else
    {$Branch = Split-Path -Path $dir.Fullname -leaf;}
$structure='classic' #by default 
if ( (dir "$TheWorkingDirectory" -Directory|where {$_.Name -eq 'Branches'}) -ne $null)
    {$structure='branch'}
while ($dir -ne '' -and -not (Test-Path "$dir\$ResourcesPath" -PathType Container
	) -and $ii -gt 0)
{
	$Project = split-path -path $dir -leaf
    if (test-path "$dir\tests" -PathType Container){$TestsLocations+="$dir\tests"}
    if ($Project -eq 'Branches') {$structure='branch'} 
	$dir = Split-Path $Dir;
	$ii = $ii - 1;
}
$MigrationsPath= if ($FileLocations.MigrationsPath -ieq 'Unknown') 
        {if ($structure -eq 'branch'){'Migrations'} else {'Scripts'}}
         else {"$($FileLocations.MigrationsPath)"}

if ($FileLocations.MigrationsPath -ieq 'Unknown') 
    {$FileLocations.MigrationsPath=$MigrationsPath;
    $FileLocations|convertto-json > "$TheWorkingDirectory\DirectoryNames.json"
    }

if ($dir -eq '') { throw "no resources directory found" }
#Read in shared resources
dir "$Dir\$ResourcesPath\*.ps1" | foreach{. "$($_.FullName)" }
if ((Get-Command "GetorSetPassword" -erroraction silentlycontinue) -eq $null)
    {Throw "The Flyway library wan't read in from $("$Dir\$ResourcesPath")"}

#find any SQL Compare filters
$Filterpath =$null
if (Test-Path "$Dir\$ResourcesPath\*.scpf"  -PathType leaf)
{$Filterpath= dir "$Dir\$ResourcesPath\*.scpf" |select -first 1|foreach{$_.FullName}}
# Get any Flyway configuration ore environments in .Conf or .toml files
$FlywayConfContent=Get-FlywayConfContent($ListOfExtraSources);

# use this information for our own local data
if (!([string]::IsNullOrEmpty($FlywayConfContent.'url')))
{
	$FlywayURLRegex ='jdbc:(?<RDBMS>[\w]{1,20}):(//(?<server>[\w\\\-\.]{1,40})(?<port>:[\d]{1,4}|)|thin:@)((;.*databaseName=|/)(?<database>[\w]{1,20}))?'
	$FlywaySimplerURLRegex = 'jdbc:(?<RDBMS>[\w]{1,20}):(?<database>[\w:\\/\.]{1,80})';
	#this FLYWAY_URL contains the current database, port and server so
	# it is worth grabbing
	$ConnectionInfo = $FlywayConfContent.'url' #get the environment variable
	
	if ($ConnectionInfo -imatch $FlywayURLRegex) #This copes with having no port.
	{
		#we can extract all the info we need
		$RDBMS = $matches['RDBMS'];
		$port = $matches['port'];
		$database = $matches['database'];
		$server = $matches['server'];
	}
	elseif ($ConnectionInfo -imatch $FlywaySimplerURLRegex)
	{
		#no server or port
		$RDBMS = $matches['RDBMS'];
		$database = $matches['database'];
		$server = 'LocalHost';
	}
	else #whatever your default
	{
		$RDBMS = 'sqlserver';
		$server = 'LocalHost';
	}
}

# the SQL files need to have consistent encoding, preferably utf-8 unless you set config 

$DBDetails = @{
    'RDBMS'= $RDBMS; 
	'server' = $server; #The Server name
    'directoryStructure'=$structure;
    'filterpath'=$filterpath
	'database' = $database; #The Database
	'migrationsPath' = $migrationsPath; #where the migration scripts are stored- default to Migrations
	'resourcesPath' = $resourcesPath; #the directory that stores the project-wide resources
	'sourcePath' = $sourcePath; #where the source of any branch version is stored
	'scriptsPath' = $scriptsPath; #where the various scripts of any branch version is stored #>
	'dataPath' = $DataPath; #where the data for any branch version is stored #>
    'versionsPath'=$VersionsPath;
    'defaultSchema'='';
    'flywayTableName'='';
    'reportDirectory'=$Reportdirectory;
    'reportLocation'=$ReportLocation; # part of path from user area to project artefacts folder location 
	'Port' = $port
	'uid' = $FlywayConfContent.'user'; #The User ID. you only need this if there is no domain authentication or secrets store #>
	'pwd' = ''; # The password. This gets filled in if you request it
	'version' = ''; # TheCurrent Version. This gets filled in if you request it
    'previous'=''; # The previous Version. This gets filled in if you request it
	'flywayTable' = 'dbo.flyway_schema_history';#this gets filled in later
	'branch' = $branch;
    'variant'= 'default'
	'schemas' = 'dbo,classic,people';
	'project' = $project; #Just the simple name of the project
	'projectDescription' = $FlywayConfContent.placeholders.ProjectDescription #A sample project to demonstrate Flyway Teams, using the old Pubs database'
	'projectFolder' = switch ( $FlywayConfContent.'locations' ){  $null {'./migrations' } default { $psItem.Replace('filesystem:','') }}; #parent the scripts directory
	'resources' = "$Dir\$ResourcesPath"
    'testsLocations'= ($testsLocations -join ',') ;
	'feedback' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                          
	'warnings' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                          
	'problems' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                           
	'writeLocations' = @{ }; # Just leave this be. Filled in for your information
}

if (!($FlywayConfContent.user -in @("''",'',$null)) -and $FlywayConfContent.password -in @("''",'',$null) ) #if there is a UID then it needs credentials
    {$DBDetails.pwd = "$(GetorSetPassword $FlywayConfContent.user $server $RDBMS)"}
    else
    {$DBDetails.pwd = $FlywayConfContent.password}

# We now add all the values we've gotten from the environment variables and 
# configuration files

#Add in the placeholder key/values if they don't already exist
if ($FlywayConfContent.placeholders -ne $null)
    {$FlywayConfContent.placeholders.Keys | foreach{
    if ([string]::IsNullOrEmpty($DBDetails[$_])) {
    $DBDetails[$_]=$FlywayConfContent.placeholders[$_]}
        }
    }
#Add in the key/values if they don't already exist
$FlywayConfContent.Keys | where {$_ -ne 'Placeholders'}|foreach{
    if ([string]::IsNullOrEmpty($DBDetails[$_])) {
    $DBDetails[$_]=$FlywayConfContent[$_]}
        }
@(@('user','uid'),@('password','pwd'))|foreach{
    if ($dbDetails[$_[0]] -ne $dbDetails[$_[1]]) {$dbDetails[$_[1]]=$dbDetails[$_[0]]}
}
    
$defaultSchema = if ([string]::IsNullOrEmpty($DBDetails.'defaultSchema'))
                     {($DBDetails.schemas -split ','|select -First 1)} 
                     else {"$($DBDetails.'defaultSchema')"}
$defaultTable = if ([string]::IsNullOrEmpty($DBDetails.'table')) {'flyway_schema_history'} else {"$($DBDetails.'table')"}
$DBDetails.'flywayTableName'=$defaultTable;
$DBDetails.'defaultSchema'=$defaultSchema;
$DBDetails.'flywayTable'="$($defaultSchema)$(if ($defaultSchema.trim() -in @($null,'')){''}else {'.'})$($defaultTable)"
