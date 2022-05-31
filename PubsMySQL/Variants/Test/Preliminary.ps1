<# Principles:
one 'resource' directory with all the scripting tools we need for the project
each branch needs its own place for reports, source and scripts
Each branch must maintain its own copy of the database to preserve isolation
Each branch 'working directory' should be the same structure.
All data is based on the Current working directory.
Use flyway.conf where possible #>

<# first check that flyway is installed properly #>
$FlywayCommand = (Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand)
{
	write-error "This script requires Flyway to be installed and available on a PATH or via an alias" -ErrorAction Stop
}
<# is it too old? #>
if ($FlywayCommand.CommandType -eq 'Application' -and
	($FlywayCommand.Version -gt [version]'0.0.0.0' -and $FlywayCommand.Version -lt [version]'0.8.1.0'))
{
	write-error "Your Flyway Version is too outdated to work" -ErrorAction Stop
}
<#
pick up any changed locations that the user wants. If nothing exists, then 
create the file with the default settings in place
#>
 If ($WeHaveDirectoryNames=Test-Path -Path "$pwd\DirectoryNames.json" -PathType Leaf)
    {$FileLocations=[IO.File]::ReadAllText("$pwd\DirectoryNames.json")|convertfrom-json}

#we need this resource path to find out our resources 
$ResourcesPath=if($WeHaveDirectoryNames){$FileLocations.ResourcesPath} else {'Resources'}
if ($ResourcesPath -eq $null) {$ResourcesPath='Resources'}
$structure=if($WeHaveDirectoryNames){$FileLocations.structure} else {'classic'}
if ($structure -eq $null) {$structure='classic';$WeNeedToCreateAPreferencesFile=$true;}
#look for the common resources directory for all assets such as modules that are shared
$dir = $pwd.Path; $ii = 10; # $ii merely prevents runaway looping.
$Branch = Split-Path -Path $pwd.Path -leaf;
if ( (dir "$pwd" -Directory|where {$_.Name -eq 'Branches'}) -ne $null)
    {$structure='branch'}
while ($dir -ne '' -and -not (Test-Path "$dir\$ResourcesPath" -PathType Container
	) -and $ii -gt 0)
#look down the directory structure. 

{
	# first see if there is a reference list of directory names
    if (test-path  "$dir\DirectoryNames.json" -PathType Leaf)
        {$ReferenceDirectoryNamesPath="$dir\DirectoryNames.json"}
    $Project = split-path -path $dir -leaf
    if ($Project -eq 'Branches') {$structure='branch'} 
	if (test-path  "$dir\Branches") {$structure='branch'} 
    $dir = Split-Path $Dir;
	$ii = $ii - 1;
}
if ($dir -eq '') { throw "no resources directory found" }
$WeNeedToCreateAPreferencesFile=$false;
#if no directory  names
$WeNeedToCreateAPreferencesFile=$false;
If (!($WeHaveDirectoryNames))
    {
    if ($ReferenceDirectoryNamesPath -ne $null)
        {$FileLocations=[IO.File]::ReadAllText("$ReferenceDirectoryNamesPath")|convertfrom-json;
        Copy-Item -Path $ReferenceDirectoryNamesPath -Destination "$pwd\DirectoryNames.json"
        }
    else
        {
        $WeNeedToCreateAPreferencesFile=$true;
        $FileLocations=@{
            ResourcesPath='Resources';
            sourcePath ='Source';
            ScriptsPath='Scripts';
            DataPath='Data';
            VersionsPath='Versions'
            Reportdirectory='Documents\GitHub\'
            MigrationsPath =(if ($structure -eq 'branch'){'Migrations'} else {'Scripts'});
            Structure=$structure;
            }
        }
    }

#Read in shared resources
if (Test-path "$Dir\$ResourcesPath\Preliminary.ps1" -PathType Leaf)
    {Throw "Expecting resources in $Dir\$ResourcesPath- instead found preliminary.ps1"}
dir "$Dir\$ResourcesPath\*.ps1" | foreach{ . "$($_.FullName)" }
if ((Get-Command "GetorSetPassword" -erroraction silentlycontinue) -eq $null)
    {Throw "The Flyway library wan't read in from $("$Dir\$ResourcesPath")"}

#find any SQL Compare filters
$Filterpath =$null
if (Test-Path "$Dir\$ResourcesPath\*.scpf"  -PathType leaf)
{$Filterpath= dir "$Dir\$ResourcesPath\*.scpf" |select -first 1|foreach{$_.FullName}}

<# We now know the project name ($project) and the name of the branch (Branch), and have installed all the resources

Now we check that the directories and files that we need are there #>
@(@{ path = "$($pwd.Path)"; desc = 'project directory'; type = 'container' },
	# @{ path = "$($pwd.Path)\$MigrationsPath"; desc = 'migration Scripts Location'; type = 'container' },
	@{ path = "$($pwd.Path)\flyway.conf"; desc = 'flyway.conf file'; type = 'leaf' }
) | foreach{
	if (-not (Test-Path $_.path -PathType $_.type))
	{ throw "Sorry, but I couldn't find a $($_.desc) at the $($pwd.Path) location" }
}

# now we get the password if necessary. To do this we need to know the server and userid
# possibly even the database name too
# The config items are case-sensitive camelcase so beware if you aren't used to this


$FlywayConfContent=@()
$FlywayKeys = (Get-Content "flyway.conf")  |
where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
    foreach{$_ -replace '\\','\\'}|
    ConvertFrom-StringData -OutVariable FlywayConfContent|foreach {$_.keys}
Get-content "$env:userProfile\flyway.conf" |where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') }|
foreach{$_ -replace '\\','\\'}|ConvertFrom-StringData|foreach{
    if (!($_.Keys -in $FlywayKeys)) 
        {$FlywayConfContent+=$_}
    }

# use this information for our own local data
if (!([string]::IsNullOrEmpty($FlywayConfContent.'flyway.url')))
{
	$FlywayURLRegex =
	'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w\\\-\.]{1,40})(?<port>:[\d]{1,4}|)(;.*databaseName=|/)(?<database>[\w]{1,20})';
	$FlywaySimplerURLRegex = 'jdbc:(?<RDBMS>[\w]{1,20}):(?<database>[\w:\\/\.]{1,80})';
	#this FLYWAY_URL contains the current database, port and server so
	# it is worth grabbing
	$ConnectionInfo = $FlywayConfContent.'flyway.url' #get the environment variable
	
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
$migrationsPath = split-path -Leaf -path $FlywayConfContent.'flyway.locations'.Replace('filesystem:','').Split(',')[0]
$migrationsLocation = resolve-path $FlywayConfContent.'flyway.locations'.Replace('filesystem:','')

# the SQL files need to have consistent encoding, preferably utf-8 unless you set config 

$DBDetails = @{
    'RDBMS'= $RDBMS; 
	'server' = $server; #The Server name
    'directoryStructure'=$structure;
    'filterpath'=$filterpath
	'database' = $database; #The Database
	'migrationsPath' = $migrationsPath; #where the migration scripts are stored- default to Migrations
	'migrationsLocation' = $migrationsLocation; #where the migration scripts are stored- default to Migrations
	'resourcesPath' = $resourcesPath; #the directory that stores the project-wide resources
	'sourcePath' = $sourcePath; #where the source of any branch version is stored
	'scriptsPath' = $scriptsPath; #where the various scripts of any branch version is stored #>
	'dataPath' = $DataPath; #where the data for any branch version is stored #>
    'versionsPath'=$VersionsPath;
    'reportDirectory'=$Reportdirectory;
    'reportLocation'="$pwd\$($FileLocations.VersionsPath)"; # part of path from user area to project artefacts folder location 
	'Port' = $port
	'uid' = $FlywayConfContent.'flyway.user'; #The User ID. you only need this if there is no domain authentication or secrets store #>
	'pwd' = ''; # The password. This gets filled in
	'version' = ''; # TheCurrent Version. This gets filled in if you request it
    'previous'=''; # The previous Version. This gets filled in if you request it
	'flywayTable' = 'dbo.flyway_schema_history';#this gets filled in later
	'branch' = $branch;
	'schemas' = 'dbo,classic,people';
	'project' = $project; #Just the simple name of the project
	'projectDescription' = $FlywayConfContent.'flyway.placeholders.projectDescription' #A sample project to demonstrate Flyway Teams, using the old Pubs database'
	'projectFolder' = $FlywayConfContent.'flyway.locations'.Replace('filesystem:',''); #parent the scripts directory
	'resources' = "$Dir\$ResourcesPath"
	'feedback' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                          
	'warnings' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                          
	'problems' = @{ }; # Just leave this be. Filled in for your information                                                                                                                                                                                                           
	'writeLocations' = @{ }; # Just leave this be. Filled in for your information
}
if (!($FlywayConfContent.'flyway.user' -in @("''",'',$null))) #if there is a UID then it needs credentials
    {$DBDetails.pwd = "$(GetorSetPassword $FlywayConfContent.'flyway.user' $server $RDBMS)"}

$FlywayConfContent |
foreach{
	$what = $_;
	$variable = $_.Keys;
	$Variable = $variable -ireplace '(flyway\.placeholders\.|flyway\.)(?<variable>.*)', '${variable}'
	$value = $what."$($_.Keys)"
	$dbDetails."$variable" = $value;
}


#now add in any values passed as environment variables
try{
$EnvVars=@{};
@(  'env:FP__*',
    'env:Flyway_*')|
    Get-ChildItem | 
        foreach{$envVars."$($_.Key)" = $_.Value}
$envVars |
 foreach{
	if ($_.name -imatch '(FP__flyway_(?<Variable>[\w]*)__|FP__(?<Variable>[\w]*)__|FLYWAY_(?<Variable>[\w]*))')
	{
		$FlywayName = $matches['Variable'];
		if ($FlywayName -imatch 'PLACEHOLDERS_') { $FlywayName = $FlywayName -replace 'PLACEHOLDERS_' }
		if ($FlywayName -imatch '\w*_\w*' -or $FlywayName -cmatch '(?m:^)[A-Z]')
		{
			$FlywayName = $FlywayName.ToLower().Split() | foreach -Begin { $ii = $false; $res = '' }{
				$res += if ($ii) { (Get-Culture).TextInfo.ToTitleCase($_) }
				else { $_; $ii = $true };
			} -End { $res }
		}
		@{ $FlywayName = $_.Value }
		
	}
} | foreach{ $dbDetails."$($_.Keys)" = $_."$($_.Keys)" }
}
catch
    { 
    write-warning "$($PSItem.Exception.Message) getting environment variables at line $($_.InvocationInfo.ScriptLineNumber)"
    }
$defaultSchema = if ([string]::IsNullOrEmpty($DBDetails.'defaultSchema'))
                     {($DBDetails.schemas -split ','|select -First 1)} 
                     else {"$($DBDetails.'defaultSchema')"}
$defaultTable = if ([string]::IsNullOrEmpty($DBDetails.'table')) {'flyway_schema_history'} else {"$($DBDetails.'table')"}
$DBDetails.'flywayTable'="$($defaultSchema)$(if ($defaultSchema.trim() -in @($null,'')){''}else {'.'})$($defaultTable)"
$env:FLYWAY_PASSWORD=$DBDetails.Pwd
if ($WeNeedToCreateAPreferencesFile)
    {$FileLocations|convertto-json > "$pwd\DirectoryNames.json"}