<# Principles:
one 'resource' directory with all the scripting tools we need for the project
each branch needs its own place for reports, source and scripts
Each branch must maintain its own copy of the database to preserve isolation
Each branch 'working directory' should be the same structure.
All data is based on the Current working directory.
Use flyway.conf where possible 
#>
$structure='branch'; #we use branching by default
$FileLocations=@{}; #these can be specified in a JSON file
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
These are the defaults that you can over-ride #>
$FileLocations=[pscustomObject]@{}
If ($WeHaveDirectoryNames=Test-Path -Path "$pwd\DirectoryNames.json" -PathType Leaf)
    {$FileLocationsJson=[IO.File]::ReadAllText("$pwd\DirectoryNames.json");
     $FileLocations=($FileLocationsJson|convertfrom-json);
    }
#we have defaults just in case
if ($FileLocations.Structure -eq $null) {$MaybeOldType=$True} else {$MaybeOldType=$False}
$Additions=(@'
{
    "sourcePath":  "Source",
    "Reportdirectory":  "Documents\\GitHub\\",
    "resourcesPath":  "resources",
    "scriptsPath":  "Scripts",
    "migrationsPath":  "Migrations",
    "DataPath":  "Data",
    "VersionsPath":  "Versions",
    "BranchesPath":"Branches",
    "TestsPath":"Tests",
    "VariantsPath":"Variants",
    "Structure":"Branch"
}
'@|convertFrom-json).psobject.properties |where {$FileLocations."$($_.Name)"-eq $null}|
   foreach {Add-Member -InputObject $FileLocations  -MemberType NoteProperty -Name $_.Name -Value $_.Value}
#use default values if nothing else specified
$ResourcesPath=$FileLocations.resourcesPath
# we need this resource path to find out our resources 
# while we're at it, we get the tests path 
$TestsPath=( $FileLocations.TestsPath,'Tests' -ne $null)[0]
$TestsLocations=@();

if ($MaybeOldType) {$structure='classic';}
#look for the common resources directory for all assets such as modules that are shared
$dir = $pwd.Path; $ii = 10; # $ii merely prevents runaway looping.
$Branch = Split-Path -Path $pwd.Path -leaf;
if ($MaybeOldType -and (dir "$pwd" -Directory|where {$_.Name -eq 'Branches'}) -ne $null)
    {$FileLocations.structure='Branch'}
while ($dir -ne '' -and -not (Test-Path "$dir\$ResourcesPath" -PathType Container
	) -and $ii -gt 0)
#look down the directory structure. 
{
	# first see if there is a reference list of directory names
    if (test-path  "$dir\DirectoryNames.json" -PathType Leaf)
        {$ReferenceDirectoryNamesPath="$dir\DirectoryNames.json"}
    if ((test-path  "$dir\$TestsPath" -PathType Container))
        {$TestsLocations+="$dir\$TestsPath"}
    $Project = split-path -path $dir -leaf
    if ($MaybeOldType -and $Project -eq 'Branches') {$FileLocations.structure='branch'} 
	if ($MaybeOldType -and (test-path  "$dir\Branches")) {$FileLocations.structure='branch'} 
    $dir = Split-Path $Dir;
	$ii = $ii - 1;
}
if ($dir -eq '') { throw "no resources directory found" }
#if no test directory 
if ($TestsLocations.count -eq 0)
    {
    $TestsLocations+="$dir\$Project\$TestsPath";
    $null=New-Item -ItemType Directory -Path "$TestsLocations" -Force 
    }

$VersionsPath= $FileLocations.VersionsPath
$VariantsPath= $FileLocations.VariantsPath
$scriptsPath= $FileLocations.ScriptsPath
$testsPath= $FileLocations.TestsPath
$sourcePath= $FileLocations.SourcePath
$dataPath= $FileLocations.SourcePath
$Reportdirectory=$FileLocations.Reportdirectory

#Read in shared resources (don't execute preliminary. It ends badly.
dir "$Dir\$ResourcesPath\*.ps1" | where {$_.name -ne 'Preliminary.ps1'}| 
         foreach{write-verbose $_.FullName;  . "$($_.FullName)" }
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
<# we no have to check whether the user has changed to a different setting for the database
connections #>

if (Test-Path "RunMe.bat" -PathType leaf)# we may be in a different branch 
    {$setting = [IO.File]::ReadAllText("$pwd\RunMe.bat") #what is there?
    $currentEnvValue=$env:FLYWAY_CONFIG_FILES; # Save the current setting
    #now get the actual filename in the path from the batch file
    $Conffilename = $setting -ireplace 'set\s+?FLYWAY_CONFIG_FILES\s*?=\s*?%userprofile%(\\|/)(?<value>\w{2,}.conf)', '${value}'
    if (Test-Path "$env:userProfile\$Conffilename" -PathType leaf) #does it exist
    #it it our settings?
        {
        $regex='((?<rdbms>\w+)_(?<project>\w+)_(?<branch>\w+).conf|(?<project>\w+)_(?<branch>\w+).conf)'
        #now we see if there is a change
        if ($currentEnvValue -notlike "*$Conffilename*")
            {#Hmm. We need to set the value to get the config
            #it is not there already so we need to delete any current setting
             [Environment]::SetEnvironmentVariable("FLYWAY_CONFIG_FILES", $null)
            #take the offending key/value pair out
            [array]$NewValue = ($currentEnvValue -split ',' | 
                where { (!([string]::IsNullOrEmpty($_))) -and (!($_ -match $regex))}) 
            $NewValue+="$env:userProfile\$Conffilename";
            $TheListOfLocations=$NewValue -join ','
            $env:FLYWAY_CONFIG_FILES=$TheListOfLocations #put the env back with the correct value
            }
        }
    else
        {
        write-warning "location .conf file '$env:userProfile\$Conffilename' in 'RunMe.bat' doesnt exist"
        }
    }


# is there an extra config file then add it to the list in the enviromnent var
if (Test-Path 'flywayTeamworks.conf' -PathType Leaf)
    {if ($env:FLYWAY_CONFIG_FILES -eq $null)
        {$env:FLYWAY_CONFIG_FILES='flywayTeamworks.conf' }#the only one in the list
        else
        {# don't add it in more than once
        if ($env:FLYWAY_CONFIG_FILES -notlike '*flywayTeamworks.conf*')
            {$env:FLYWAY_CONFIG_FILES=$env:FLYWAY_CONFIG_FILES+',flywayTeamworks.conf'}; 
        }
    }
else #make sure that the env reflects the removal of the file
    {if ($env:FLYWAY_CONFIG_FILES -like '*flywayTeamworks.conf*')
        {$env:FLYWAY_CONFIG_FILES= ($env:FLYWAY_CONFIG_FILES -split ','| 
           where {$_ -ne 'flywayTeamworks.conf' }) -join ',' }
    }
         

<# now we read in the contents of every config files we can get hold of reading them 
in order of precedence and only adding a value if there is none there already.#>
$FlywayConfContent=@{}
#we read them in precendence order. 
#is there a list of extra config files specified 
if (!([string]::IsNullOrEmpty($env:FLYWAY_CONFIG_FILES)))
      {$FlywayConfContent=$env:FLYWAY_CONFIG_FILES -split ',' | where {-not [string]::IsNullOrEmpty($_)}| foreach {
            Get-content "$_" |where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') }|
            foreach{$_ -replace '\\','\\'}|ConvertFrom-StringData
            }        
      }
 @("flyway.conf", "$env:userProfile\flyway.conf")| Foreach {  
    Get-Content "$($_)"  |
   where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
    foreach{$_ -replace '\\','\\'}|
    ConvertFrom-StringData | foreach {
        $Theitem=$_;
       if ($FlywayConfContent."$($Theitem.Keys)" -eq $null) 
        { $FlywayConfContent+=$_}
        }
    }
# use this information for our own local data
$RDBMS =''; $port =''; $database =''; $server =''; 
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

$Wallet=$FlywayConfContent.'flyway.oracle.walletLocation'; #extract this so we can use it for oracle
$Service=$FlywayConfContent.'flyway.placeholders.service'; #extract this placeholder so we can use it for oracle
$migrationsLocation = $FlywayConfContent.'flyway.locations' -split ','|where {$_ -like 'filesystem:*'}|foreach {
    $reference=$_.Replace('filesystem:','')
    if (!([System.IO.Path]::IsPathRooted($reference)))
         {
         $migrationsPath=split-path -Parent $reference #-leafbase;
         }
     $reference
     }
# the directory of the first one
$common=0;
$Thepassword=$FlywayConfContent.'flyway.Password';
# the SQL files need to have consistent encoding, preferably utf-8 unless you set config 
$DBDetails = @{
    'RDBMS'= $RDBMS; 
	'server' = $server; #The Server name
    'directoryStructure'=$structure;
    'filterpath'=$filterpath;
    'variant'='default';
	'database' = $database; #The Database
    'wallet'=$Wallet; #oracle only
    'service'=$Service; #oracle only
	'migrationsPath' = $migrationsPath; #where the migration scripts are stored- default to Migrations
	'migrationsLocation' = $migrationsLocation; #where the migration scripts are stored- default to Migrations
    'TestsLocations'=$TestsLocations;#where the tests are held
	'resourcesPath' = $ResourcesPath; #the directory that stores the project-wide resources
	'sourcePath' = $sourcePath; #where the source of any branch version is stored
	'scriptsPath' = $scriptsPath; #where the various scripts of any branch version is stored #>
	'dataPath' = $DataPath; #where the data for any branch version is stored #>
    'testsPath' =$testsPath;
    'versionsPath'=$VersionsPath;
    'variantsPath'=$VariantsPath;
    'reportDirectory'=$Reportdirectory;
    'reportLocation'="$pwd\$($FileLocations.VersionsPath)"; # part of path from user area to project artefacts folder location 
	'Port' = $port
	'uid' = $FlywayConfContent.'flyway.user'; #The User ID. you only need this if there is no domain authentication or secrets store #>
	'pwd' = $Thepassword; # The password. This gets filled in
	'version' = ''; # TheCurrent Version. This gets filled in if you request it
    'previous'=''; # The previous Version. This gets filled in if you request it
	'flywayTable' = 'dbo.flyway_schema_history';#this gets filled in later
	'branch' = $branch;
	'schemas' = '';
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
    {
    if ($Server -ne ''-and $RDBMS -ne '' -and [string]::IsNullOrEmpty($DBDetails.pwd) )
        {$DBDetails.pwd = "$(GetorSetPassword $FlywayConfContent.'flyway.user' $server $RDBMS)"}
    }

$FlywayConfContent.GetEnumerator()| foreach{
        $what=$_
	    $ThisKey = $what.name;
	    $ThisValue = $what.value;
	    $Variable =  $ThisKey -ireplace '(flyway\.placeholders\.|flyway\.)(?<variable>.*)', '${variable}'
	    $dbDetails."$variable" = $ThisValue;
    }

if (($pwd.Path|split-path -Parent|split-path -leaf) -eq 'variants')
    {$DBDetails.variant=$pwd.Path|split-path -Leaf}

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
$defaultSchema = if ([string]::IsNullOrEmpty($DBDetails.'defaultSchema')) #they haven't specified one
                     {($DBDetails.schemas -split ','|select -First 1)} #get the first in the list
                     else {"$($DBDetails.'defaultSchema')"}
$defaultTable = if ([string]::IsNullOrEmpty($DBDetails.'table')) {'flyway_schema_history'} else {"$($DBDetails.'table')"}
$DBDetails.'flywayTable'="$($defaultSchema)$(if ($defaultSchema.trim() -in @($null,'')){''}else {'.'})`"$($defaultTable)`""
$DBDetails.'DefaultSchema'=$defaultSchema
$DBDetails.'flywayTableName'=$defaultTable
#add the password as an environment variable
$env:FLYWAY_PASSWORD=$DBDetails.Pwd 
#if we added defaults to the naming preferences we write them back so the user can change them
$OldFileLocations=($FileLocationsJson|convertfrom-json)
if ($OldFileLocations -ne $null -and $FileLocations -ne $null)
    {
if ((Diff-Objects $FileLocations $OldFileLocations | where {$_.Match -ne '=='}).count -gt 0)
    {$FileLocations|convertto-json > "$pwd\DirectoryNames.json"}
    }
elseif ($FileLocations -ne $null)
    {
    $FileLocations|convertto-json > "$pwd\DirectoryNames.json"
    }
@('schemas','url')|foreach {
if ([string]::IsNullOrEmpty($DBDetails.$_))
    {Write-Warning "No flyway $($_) defined yet"}
    }

