<#

These are a collection of script blocks that are designed to run with Flyway
- either in the community edition or with Teams. They allow you to maintain
backups or scripts for each version and make a Flyway a full participant
in any source control system in use, even to the point of providing an 
object-level source to allow the eveolution of individual tables to be tracked

A simple database that is really nothing more than a grown-up spreadsheet will 
not need any of this fancy stuff. It becomes increasingly important as the
database grows into a team effort. The facilities cover automatic code reviews,
source control, and change tracking. It provides build scripts that are, I
believe, essential to successful branching and merging, and for databases such
as MySQL that do not roll-back DDL changes in failed transactions. Some of 
these utilities are there primarily to show how to run exteranal programs,
or to save the results of a SQL Call as a JSON file or other result. I have 
examples of SQL Code executed from a variable containing a query,  and from 
a file. 

They share a common data object as a parameter. The parameter looks somewhat 
like this but the routines don't all require them. They y check to see whether
you've provided what is needed... It
is actually a hashTable passed by reference. 
Few of theseparameters  are needed for any one task, and some
such as version and password are filled in as the hashtable is accessed.

$DatabaseDetails = @{
    'RDBMS'=''; # necessary for systems with several RDBMS on the same server
	'server' = ''; #the name of your server
    'schemas'='' # only needed if you are calling flyway
	'database' = ''; #the name of the database
	'version' = ''; #the version
	'ProjectFolder' = ''; #where all the  files are. The script files are usually in a \scripts subdirectory
    'project' = ''; #the name of your project
    'projectDescription'=''; #a brief description of the project
	'uid' = ''; #optional if you are using windows authewntication
	'pwd' = ''; #only if you use a uid. Leave blank. we fill it in for you
	'WriteLocations' = @{ }; # for reporting file WriteLocations used
	'problems' = @{ }; # for reporting any big problems
	'warnings' = @{ } # for reporting any issues
} # for reporting any warnings

These Scriptblocks can be batched up into an array
and processed one by one. Some of them are utility chores such as extracting
passwords from a relatively safe place, or fetching prepared parameters. There
is one that merely formats the data. They are able to write errors or status
to the data object. The hashtable is passed by reference. One has to be cautious
with this because alterations to the hashtable can result in powerShell holding
a copy instead. 

As well as being run in a series, they can be used individually. If one of them
needs maintenance, it is very easy to pull it apart and run it interactively.

The reason for using this design was to make it easy to choose what gets run 
and in what order. 

$DatabaseDetails = 
    @{
    'RDBMS'=''; #jdbc name. Only necessary for systems with several RDBMS on the same server
    'ProjectFolder' = 'MyPathToTheFlywayFolder\PubsFlywaySecondMigration';
    'ProjectDescription'='However you describe your project';
    'schemas'='dbo' # only needed if you are calling flyway
	'pwd' = ''; #Always leave blank
	'uid' = 'MyUserName'; #leave blank unless you use credentials
	'Database' = 'MyDatabase'; # fill this in please
	'server' = 'MyServer'; # We need to know the server!
	'port' = $null; #Not normally needed with SQL Server. add if required
	#set to $null or leave it out if you want to let jdbc detect it 
	'project' = $MyProject; # the name of the project-needed for saving files
	'version' = ''; # current version of database - 
	# leave blank unless you know
	'WriteLocations' = @{ }; # for reporting file WriteLocations used
	'problems' = @{ }; # for reporting any big problems
	'warnings' = @{ } # for reporting any issues
     }

 
$CheckCodeInDatabase 
This scriptblock checks the code in the database for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the current database, not the scripts

$CheckCodeInMigrationFiles
This scriptblock checks the code in the migration files for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the scripts not the current database.

$CreateScriptFoldersIfNecessary:
this task checks to see if a Source folder already exists for this version of the
database and, if not, it will create one and fill it with subdirectories for each
type of object. A tables folder will, for example, have a file for every table each
containing a build script to create that object. When this exists, it allows SQL Compare
to do comparisons and check that a version has not drifted. It saves the Source folder
as a subfolder for the supplied version, so it needs $GetCurrentVersion to have been
run beforehand in the chain of tasks.

$CreateBuildScriptIfNecessary: 
produces a build script from the database, using SQL Compare. It saves the build script
in the Scripts folder, as a subfolder for the supplied version, so it needs
$GetCurrentVersion to have been run beforehand in the chain of tasks.

$ExecuteTableSmellReport
This scriptblock executes SQL that produces a report in XML or JSON from the database
that alerts you to tables that may have issues

$ExecuteTableDocumentationReport
 This places in a report a json report of the documentation of every table and its
columns. If you add or change tables, this can be subsequently used to update the 
AfterMigrate callback script
for the documentation. 

$FetchOrSaveDetailsOfParameterSet
This checks over the scriptblock 
and project. it allows you to save and load the shared parameters for all these 
scriptblocks under a name you give it. you'd choose a different name for each
database within a project, but make them unique across projects. If the parameters
have the name defined but vital stuff missing, it fills in from the last remembered 
version. If it has the name and the vital stuff then it assumes that you want to 
save it. If no name then it ignores.

$FetchAnyRequiredPasswords 
This checks the hash table to see if there is a username without a password. 
If so, the task asks for it in a query window and stores it, encrypted, in 
the user area it. If the user already has the password stored for this username
and database, it uses it.

$ExecuteTableSmellReport
This scriptblock executes SQL that produces a report in XML or JSON from the database

$FormatTheBasicFlywayParameters
This provides the flyway parameters. This is here because it is useful for the 
community flyway when you wish to do further Flyway actions after doing any
scripting and code checks.

$GetCurrentVersion 
This contacts the database and determines its current version by interrogating
the flyway_schema_history data table in the database. It merely finds the highest
version number recorded as being successfully used. If it is an empty database,
or there is just no Flyway data, then it returns a version of 0.0.0.

$IsDatabaseIdenticalToSource: 
This uses SQL Compare to check that a version of a database is correct and hasn't been
changed. To do this, the $CreateScriptFoldersIfNecessary task must have been run
first. It compares the database to the associated source folder, for that version,
and returns, in the hash table, the comparison equal to true if it was the same,
or false if there has been drift, with a list of objects that have changed. If
the comparison returns $null, then it means there has been an error. To access
the right source folder for this database version, it needs $GetCurrentVersion
to have been run beforehand in the chain of tasks

$SaveDatabaseModelIfNecessary
This writes a JSON model of the database to a file that can be used subsequently
to check for database version-drift or to create a narrative of changes for the
flyway project between versions.

$BulkCopyIn
This script performs a bulk copy operation to get data into a database. It
can only do this if the data is in a suitable directory. At the moment it assumes
that you are using a DATA directory at the same level as the scripts directory. 
BCP must have been previously installed in the path 
Unlike many other tasks, you are unlikely to want to do this more than once for any
database.If you did, you'd need to clear out the existing data first! It is intended
for static scripts AKA baseline migrations.

$BulkCopyout
This script performs a bulk copy operation to get data out of a database, and
into a suitable directory. At the moment it assumes that you wish to use a 
DATA directory at the same level as the scripts directory. 
BCP must have been previously installed in the path.

$CreateUndoScriptIfNecessary
this creates a first-cut UNDO script for the metadata (not the data) which can
be adjusted and modified quickly to produce an UNDO Script. It does this by using
SQL Compare to generate a  idepotentic script comparing the database with the 
contents of the previous version.

$GeneratePUMLforGanttChart
This script creates a PUML file for a Gantt chart at the current version of the database. This can be
read into any editor that takes PlantUML files to give a Gantt chart

$CreatePossibleMigrationScript
This creates a forward migration that scripts out all the changes made to the database since the current
migration
#>


 #>
#we always use SQLCMD to access SQL Server
$SQLCmdAlias = "$($env:ProgramFiles)\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\sqlcmd.exe"
#We use SQL Code Guard just for code analysis.
$CodeGuardAlias= "${env:ProgramFiles(x86)}\SQLCodeGuard\SqlCodeGuard30.Cmd.exe"
# We use SQL Compare to compare build script with database
# and for generating scripts.
$SQLCompareAlias= "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 13\sqlcompare.exe"
$PGDumpAlias= "$($env:LOCALAPPDATA)\Programs\pgAdmin 4\v5\runtime\pg_dump.exe"
$psqlAlias= "$($env:LOCALAPPDATA)\Programs\pgAdmin 4\v5\runtime\psql.exe"
$sqliteAlias='C:\ProgramData\chocolatey\lib\SQLite\tools\sqlite-tools-win32-x86-3360000\sqlite3.exe'



#where we want to store reports, the sub directories from the user area.

Set-Alias SQLCmd   $SQLCmdAlias  -Scope local
Set-Alias psql $psqlAlias -Scope local
Set-Alias sqlite $sqliteAlias -Scope local

$GetdataFromSqlite = { <# a Scriptblock way of accessing SQLite via a CLI to get JSON-based  results 
without having to explicitly open a connection. it will take either SQL files or queries.  #>
	Param (
		$Theargs,
		#this is the same ubiquitous hashtable 
		$query,
		#a query. If a file, put the path in the $fileBasedQuery parameter
		$fileBasedQuery = $null) # $GetdataFromSqlite: (Don't delete this)
	
	$problems = @()
	if ($TheArgs.Database -in @($null, '')) # do we have the necessary values
    { $problems += "Can't do this: no value for the database" }
	
	if ($problems.Count -eq 0)
	{
		$TempInputFile = "$($env:Temp)\TempInput$(Get-Random -Minimum 1 -Maximum 900).sql"
		if ($FileBasedQuery -ne $null) #if we've been passed a file ....
		{ $TempInputFile = $FileBasedQuery }
		else
		{ [System.IO.File]::WriteAllLines($TempInputFile, $query); }
		
		$params = @(
			'.bail on',
			'.mode json',
			'.headers off',
			#".output $($TempOutputFile -replace '\\','/')",
			".read $($TempInputFile -replace '\\', '/')",
			'.quit')
		try
		{
			$result = sqlite "$($param1.database)" @Params
		}
		catch
		{ $problems += "SQL called to SQLite  failed because $($_)" }
        if ($?) { $result }
        else {$problems +='The SQL Call to SQLite failed'}
		if ($FileBasedQuery -eq $null) { Remove-Item $TempInputFile }
	}
if ($problems.Count -gt 0) { $Param1.Problems.'GetdataFromSqlite' = $problems }
}

#This is a utility scriptblock used by the task scriptblocks
$GetdataFromSQLCMD = {<# a Scriptblock way of accessing SQL Server via a CLI to get JSON results without having to 
explicitly open a connection. it will take SQL files and queries. It will also deal with simple SQL queries if you
set 'simpleText' to true #>
	Param ($Theargs, #this is the same ubiquitous hashtable 
		$query, #either a query that returns JSON, or a simple expression
        $fileBasedQuery=$null, #if you specify input from a file
        $simpleText=$false)  # $GetdataFromSQLCMD: (Don't delete this)
    if ([string]::IsNullOrEmpty($TheArgs.server) -or [string]::IsNullOrEmpty($TheArgs.database))
    {"[{`"Error`":`"Cannot continue because name of either server ('$($TheArgs.server)') or database ('$($TheArgs.database)') is not provided `"}]"}
    else
    {
	    $TempOutputFile = "$($env:Temp)\TempOutput$(Get-Random -Minimum 1 -Maximum 900).json"
        if (!($simpleText))
            {
	    $FullQuery = "Set nocount on; Declare @Json nvarchar(max) 
        Select @Json=($query) Select @JSON"
            }
        else
            {$FullQuery=$query};
	    if ($FileBasedQuery-ne $null) #if we've been passed a file ....
            {$TempInputFile=$FileBasedQuery}
        else
            {$TempInputFile = "$($env:Temp)\TempInput.sql"}
        #If we can't pass a query string directly, or we have a file ...
        if ($FullQuery -like '*"*' -or ($FileBasedQuery-ne $null))
	    { #Then we can't pass a query as a string. It must be passed as a file
		    #Deal with query strings 
            if ($FileBasedQuery -eq $null) {$FullQuery>$TempInputFile;}
		    if ($TheArgs.uid -ne $null) #if we need to use credentials
		    {
			    sqlcmd -S $TheArgs.server -d $TheArgs.database `
				       -i $TempInputFile -U $TheArgs.Uid -P $TheArgs.pwd `
				       -o "$TempOutputFile" -u -y0
		    }
		    else #we are using integrated security
		    {
			    sqlcmd -S $TheArgs.server -d $TheArgs.database `
				       -i $TempInputFile -E -o "$TempOutputFile" -u -y0
		    }
            #if it is just for storing a query
		    if ($FileBasedQuery-eq $null) {Remove-Item $TempInputFile}
	    }
	
	    else #we can pass a query as a string
	    {
		    if ($TheArgs.uid -ne $null) #if we need to use credentials
		    {
			    sqlcmd -S $TheArgs.server -d $TheArgs.database `
				       -Q "`"$FullQuery`"" -U $TheArgs.uid -P $TheArgs.pwd `
				       -o `"$TempOutputFile`" -u -y0
		    }
		    else #we are using integrated security
		    {
			    sqlcmd -S $TheArgs.server -d $TheArgs.database `
				       -Q "`"$FullQuery`"" -o `"$TempOutputFile`" -u -y0
		    }
	    }
	    If (Test-Path -Path $TempOutputFile)
	    { #make it easier for the caller to read the error
		    $response = [IO.File]::ReadAllText($TempOutputFile);
		    Remove-Item $TempOutputFile
		    if ($response -like 'Msg*')
		    { "[{`"Error`":`"$($TheArgs.database) says $Response'`"}]" }
		    elseif ($response -like 'SqlCmd*')
		    { "[{`"Error`":`"SQLCMD says $Response'`"}]" }
		    elseif ($response -like 'NULL*')
		    { '' }
		    else
		    { $response }
	    }
    }
}

$GetdataFromPsql = {<# a Scriptblock way of accessing PosgreSQL via a CLI to get JSON-based  results without having to 
explicitly open a connection. it will take either SQL files or queries.  #>
	Param (
        $Theargs, #this is the same ubiquitous hashtable 
		$query, #a query. If a file, put the path in the $fileBasedQuery parameter
        $fileBasedQuery=$null)  # $GetdataFromPsql: (Don't delete this)
 
    $problems=@()
    @('server', 'database', 'port','user','pwd') |
	        foreach{ if ($TheArgs.$_ -in @($null,'')) { $problems += "Can't do this: no value for '$($_)'" } }
    
    if ($problems.Count -eq 0)
    {
	    $TempOutputFile = "$($env:Temp)\TempOutput$(Get-Random -Minimum 1 -Maximum 900).csv"
        $TempInputFile = "$($env:Temp)\TempInput.sql"
        if ($FileBasedQuery-ne $null) #if we've been passed a file ....
            {$TempInputFile=$FileBasedQuery}
        else
            {[System.IO.File]::WriteAllLines($TempInputFile, $query);}
       Try
        {
        $Params=@(
        "--dbname=$($TheArgs.database)",
        "--host=$($TheArgs.server)",
        "--username=$($TheArgs.user)",
        "--password=$($TheArgs.pwd)",
        "--port=$($TheArgs.Port -replace '[^\d]','')",
        "--file=$TempInputFile",
        "--no-password",
        "--csv")
        $env:PGPASSWORD="$($TheArgs.pwd)"
        $result=psql @params
        }
        catch
        {$Param1.Problems.'GetdataFromPsql' += "$psql query failed because $($_)"}
       if ($?)
        {$result|convertFrom-csv|convertto-json}
    }
    else{$Param1.Problems.'GetdataFromPsql'+=$problems}
}


<# This scriptblock allows you to save and load the shared parameters for all these 
scriptblocks under a name you give it. you'd choose a different name for each database
within a project, but make them unique across projects 
If the parameters have the name defined but vital stuff missing, it fills 
in from the last remembered version. If it has the name and the vital stuff then it assumes
you want to save it. If no name then it ignores. 
#>
$FetchOrSaveDetailsOfParameterSet = {
	Param ($param1) # $FetchOrSaveDetailsOfParameterSet: (Don't delete this)
	$Param1.'Problems' = @{ };
	$Param1.'Warnings' = @{ };
	$Param1.'WriteLocations' = @{ };
	$problems = @();
	if ($Param1.name -ne $null -and $Param1.project -ne $null)
	{
		# define where we store our secret project details
		$StoredParameters = "$($env:USERPROFILE)\Documents\Deploy\$(($param1.Project).Split([IO.Path]::GetInvalidFileNameChars()) -join '_')";
		$ParametersFilename = 'AllParameters.json';
		$TheLocation = "$StoredParameters\$($Param1.Name)-$ParametersFilename"
	}
	$VariablesWeWant = @(
			'server', 'uid', 'port', 'project', 'database', 'projectFolder', 'projectDescription'
		);	
	if ($Param1.name -ne $null -and $Param1.project -ne $null -and $Param1.Server -eq $null -and $Param1.Database -eq $null)
	{
		# we don't want to keep passwords unencrypted and we don't want any of the transitory
		# variables that provide state (warnings, error, version number and so on)
		# If the directory doesn't exist then create it
		if (!(test-path -Path $StoredParameters -PathType Container))
		{ $null = New-Item -Path $StoredParameters -ItemType "directory" -Force }
		#if the file already exists then read it in.
		
		if (test-path $TheLocation -PathType leaf)
		{
			# so we read in all the details
			try
			{
				$JSONcontents = Get-Content -Path $TheLocation -Raw
				$TheActualParameters = $JSONcontents | ConvertFrom-json
			}
			catch
			{
				$Problems += "Cannot read file $TheLocation because it has unescaped content"
			}
			if ($problems.count -eq 0)
			{
				$TheActualParameters.psobject.properties |
				Foreach { if ($_.Name -in $VariablesWeWant) { $param1[$_.Name] = $_.Value } }
				write-verbose "fetched details from $TheLocation"
				$VariablesWeWant | where { $_ -notin @('port', 'ProjectFolder', 'projectDescription') } |
				foreach {
					if ($param1.$_ -eq $null) { $Problems += "missing a value for $($_)" }
				}
			}
		}
		else
		{
			$Problems += "Could not find project file $TheLocation"
		}
	}
	#if the user wants to save or resave they'll the name AND include both the the server and database
	elseif ($Param1.Name -ne $null -and $Param1.Server -ne $null -and $Param1.Database -ne $null)
	{
		$RememberedHashTable = @{ }
		$VariablesWeWant | foreach{ $RememberedHashTable.$_ = $param1.$_ }
		$RememberedHashTable | ConvertTo-json |
		out-file -FilePath $TheLocation -Force
		"Saved details to $TheLocation"
	}
	if ($Param1.'Checked' -eq $null) { $Param1.'Checked' = $false; }
	# has it been checked against a source directory?
	@('server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	if ($TheLocation -ne $null)
	{ $Param1.WriteLocations.'FetchOrSaveDetailsOfParameterSet' = $TheLocation; }
	if ($problems.Count -gt 0)
	{ $Param1.Problems.'FetchOrSaveDetailsOfParameterSet' += $problems; }
}

<# now we format the Flyway parameters #>
<# Sometimes we need to run Flyway, and the easiest approach is to create a hashtable
of the information Flyway needs. It is different to the one we use for each of these
scriptblocks  #>

$FormatTheBasicFlywayParameters = {
	Param ($param1) # $FormatTheBasicFlywayParameters (Don't delete this)
	$problems = @();
	@('server', 'database', 'projectFolder') |
	   foreach{ if ($param1.$_ -in @($null,'')) { $problems += "no value for '$($_)'" } }
	$migrationsPath= if ([string]::IsNullOrEmpty($param1.migrationsPath)) {'\scripts'} else {"\$($param1.migrationsPath)"}
    if ([string]::IsNullOrEmpty($param1.Reportdirectory)){$migrationsPath=''};# compatibility problem
	$MaybePort = "$(if ([string]::IsNullOrEmpty($param1.port)) { '' }
		else { ":$($param1.port)" })"
	if (!([string]::IsNullOrEmpty($param1.uid)))
	{
		if ($param1.pwd -eq $null) { $problems += "no password provided for $($($param1.uid))" }
		$FlyWayArgs =
		@("-url=jdbc:sqlserver://$($param1.Server)$maybePort;databaseName=$($param1.Database)",
			"-WriteLocations=filesystem:$($param1.ProjectFolder)$migrationsPath", <# the migration folder #>
			"-user=$($param1.uid)",
			"-password=$($param1.pwd)")
	}
	else <# we need to use an integrated security flag in the connection string #>
	{
		$FlyWayArgs =
		@("-url=jdbc:sqlserver://$($param1.Server)$maybePort;databaseName=$(
				$param1.Database
			);integratedSecurity=true",
			"-WriteLocations=filesystem:$($param1.ProjectFolder)")<# the migration folder #>
	}
	
	$FlyWayArgs += <# the project variables that we reference with placeholders #>
	@("-placeholders.projectDescription=$($param1.ProjectDescription)",
		"-placeholders.projectName=$($param1.Project)",
		"-community") <# Change this if using teams!! #>
	$Param1.FlywayArgs = $FlyWayArgs
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'FormatTheBasicFlywayParameters' += $problems;
	}
}



<# This scriptblock looks to see if we have the passwords stored for this userid, Database and RDBMS
if not we ask for it and store it encrypted in the user area
 #>
$FetchAnyRequiredPasswords = {
	Param ($param1) # $FetchAnyRequiredPasswords (Don't delete this)
	$problems = @()
	try
	{
       @('server') |
		foreach{ if ($param1.$_ -in @($null, '')) { $problems += "no value for '$($_)'" } }
		# some values, especially server names, have to be escaped when used in file paths.
		if ($problems.Count -eq 0)
		{
			$escapedServer = ($Param1.server.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'
			# now we get the password if necessary
			
			if (!([string]::IsNullOrEmpty($param1.uid))) #then it is using SQL Server Credentials
			{
				# we see if we've got these stored already. If specifying RDBMS, then use that.
				if ([string]::IsNullOrEmpty($param1.RDBMS))
				{ $SqlEncryptedPasswordFile = "$env:USERPROFILE\$($param1.uid)-$($escapedServer).xml" }
				else
				{ $SqlEncryptedPasswordFile = "$env:USERPROFILE\$($param1.uid)-$($escapedServer)-$($RDBMS).xml" }
				# test to see if we know about the password in a secure string stored in the user area
				if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
				{
					#has already got this set for this login so fetch it
					$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
				}
				else #then we have to ask the user for it (once only)
				{
					# hasn't got this set for this login
					$SqlCredentials = get-credential -Credential $param1.uid
					# Save in the user area 
					$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
				}
				
			$param1.Uid = $SqlCredentials.UserName;
			$param1.Pwd = $SqlCredentials.GetNetworkCredential().password
			}
        }
	}
	catch
	{
		$Param1.Problems.'FetchAnyRequiredPasswords' +=
             "$($PSItem.Exception.Message) at line $($_.InvocationInfo.ScriptLineNumber)"
	}
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'FetchAnyRequiredPasswords' += $problems;
	}
    if (!([string]::IsNullOrEmpty($param1.uid)) -and [string]::IsNullOrEmpty($param1.Pwd))
         {Write-warning "returned no password"}
}

<#This scriptblock checks the code in the database for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the current database, not the scripts
 #>
$CheckCodeInDatabase = {
	Param ($param1) # $CheckCodeInDatabase - (Don't delete this)
	#you must set this value correctly before starting.
	Set-Alias CodeGuard $CodeGuardAlias -Scope local
    try
    {
	$Problems = @(); #our local problem counter
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }
	#check that all the values we need are in the hashtable
	@('server', 'Database', 'version', 'Project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	#now we create the parameters for CodeGuard.
    $escapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports"} 
        else {"$ReportLocation\$($param1.Version)\Reports"} #else the simple version
	if ($MyDatabasePath -like '*\\*'){ } { $Problems += "created an illegal path '$MyDatabasePath'" }
    $Arguments = @{
		server = $($param1.server) #The server name to connect
		Database = $($param1.database) #The database name to analyze
		outfile = "$MyDatabasePath\codeAnalysis.xml" <#
        The file name in which to store the analysis xml report#>
		#exclude='BP007;DEP004;ST001' 
		#A semicolon separated list of rule codes to exclude
		include = 'all' #A semicolon separated list of rule codes to include
	}

	#add the arguments for credentials where necessary
	if (!([string]::IsNullOrEmpty($param1.uid)))
	{
		$Arguments += @{
			User = $($param1.uid)
			Password = $($param1.pwd)
		}
	}
	# we need to make sure tha path is there
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	<# we only do the analysis if it hasn't already been done for this version,
    and we've hit no problems #>
    if (($problems.Count -eq 0) -and (-not (
				Test-Path -PathType leaf  "$MyDatabasePath\codeAnalysis.xml")))
	{
		$result = codeguard @Arguments; #execute the command-line Codeguard.
		if ($? -or $LASTEXITCODE -eq 1)
		{
			"Written Code analysis for $($param1.Project) $($param1.Version
			) to $MyDatabasePath\codeAnalysis.xml"
		}
		else
		{
			<#report a problem and send back the args for diagnosis 
            (hint, only for script development) #>
			$CLIArgs = '';
			$CLIArgs += $Arguments |
			foreach{ "$($_.Name)=$($_.Value)" }
			$problems += "CodeGuard responded '$result' with error code $LASTEXITCODE when used with parameters $CLIArgs."
		}
		#$Problems += $result | where { $_ -like '*error*' }
	}
}
	catch
	{
		$Param1.Problems.'CheckCodeInDatabase' +=
             "$($PSItem.Exception.Message) at line $($_.InvocationInfo.ScriptLineNumber)"
	}

	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInDatabase! ";
		$Param1.Problems.'CheckCodeInDatabase' += $problems;
	}
	else
    {$Param1.WriteLocations.'CheckCodeInDatabase' = "$MyDatabasePath\codeAnalysis.xml";}
}


<#This scriptblock checks the code in the migration files for any issues,
using SQL Code Guard to do all the work. This runs SQL Codeguard 
and saves the report in a subdirectory the version directory of your 
project artefacts. It also reports back in the $DatabaseDetails
Hashtable. It checks the scripts not the current database.
$OurDetails=@{
  'project'='MyProjectName';
  '
  'warnings'=@{};'problems'=@{};}
$CheckCodeInMigrationFiles.Invoke($OurDetails)

 $Details=@{
'Project'='publications';                                                                                                                                                                                                          
'Warnings'=@{};                                                                                                                                                                                                            
'Problems'=@{};                                                                                                                                                                                                            
'projectFolder'='YourPathTo\PubsAndFlyway\PubsFlywaySecondMigration'                                                                                                                                                        
}
$param1=$dbDetails
$CheckCodeInMigrationFiles.Invoke($Details) #>

$CheckCodeInMigrationFiles = {
	Param ($param1) # $CheckCodeInMigrationFiles - (Don't delete this)
	#you must set this value correctly before starting.
	Set-Alias CodeGuard $CodeGuardAlias -Scope local
	$Problems = @(); #our local problem counter
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name codeguard).definition) -PathType Leaf))
	{ $Problems += 'The alias for Codeguard is not set correctly yet' }
	#check that all the values we need are in the hashtable
	@('ProjectFolder') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
    $escapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'

	#$migrationsPath= if ([string]::IsNullOrEmpty($param1.migrationsPath)) {'\scripts'} else {"\$($param1.migrationsPath)"}
	#if ([string]::IsNullOrEmpty($param1.Reportdirectory)){$migrationsPath=''};# compatibility problem

    dir "$($param1.projectFolder)\V*.sql" | foreach{
		$Thepath = $_.FullName;
		$TheFile = $_.Name
		$Theversion = ($_.Name -replace 'V(?<Version>[.\d]+).+', '${Version}')
        if ([version]$Theversion -le [version]$Param1.version)
            {
		    #now we create the parameters for CodeGuard.
		    $MyVersionReportPath = 
              if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
                {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports"} 
              else {"$ReportLocation\$($param1.Version)\Reports"} #else the simple version
		    $Arguments = @{
			    source = $ThePath
			    outfile = "$MyVersionReportPath\FilecodeAnalysis.xml" <#
                The file name in which to store the analysis xml report#>
			    #exclude='BP007;DEP004;ST001' 
			    #A semicolon separated list of rule codes to exclude
			    include = 'all' #A semicolon separated list of rule codes to include
		    }
		    # we need to make sure tha path is there
		    if (-not (Test-Path -PathType Container $MyVersionReportPath))
		    {
			    # does the path to the reports directory exist?
			    # not there, so we create the directory 
			    $null = New-Item -ItemType Directory -Force $MyVersionReportPath;
		    }
	        <# we only do the analysis if it hasn't already been done for this version,
            and we've hit no problems #>
		    if (($problems.Count -eq 0) -and (-not (
					    Test-Path -PathType leaf  "$MyVersionReportPath\FilecodeAnalysis.xml")))
		    {
			    $result = codeguard @Arguments; #execute the command-line Codeguard.
			    if ($? -or $LASTEXITCODE -eq 1)
			    {
				    Write-Verbose  "Written file Code analysis for $TheFile for $($param1.Project) project) to $MyVersionReportPath\FilecodeAnalysis.xml"
			    }
			    else
			    {
			        <#report a problem and send back the args for diagnosis 
                    (hint, only for script development) #>
				    $CLIArgs = '';
				    $CLIArgs += $Arguments.GetEnumerator() |
				    foreach{ "$($_.Name)=$($_.Value)" }
				    $problems += "CodeGuard responded '$result' with error code $LASTEXITCODE when used with parameters $CLIArgs."
			    }
			    #$Problems += $result | where { $_ -like '*error*' }
		    }
        }
	}
	if ($problems.Count -gt 0)
	{
		Write-warning "Problem '$problems' with CheckCodeInMigrationFiles! ";
		$Param1.Problems.'CheckCodeInMigrationFiles' += $problems;
	}
    else
    {$Param1.WriteLocations.'CheckCodeInMigrationFiles' = "$MyVersionReportPath\FilecodeAnalysis.xml"; }
		
}



<#This scriptblock gets the current version of a flyway_schema_history data from the 
table in the database. if there is no Flyway Data, then it returns a version of 0.0.0
 #>
$GetCurrentVersion = {
	Param ($param1) # $GetCurrentVersion parameter is a hashtable 
	$problems = @();
	$doit = $true;
	@('server', 'database') | foreach{
		if ($param1.$_ -in @($null, ''))
		{
			$Problems += "no value for '$($_)'";
			$DoIt = $False;
		}
	}
	$flywayTable = $Param1.flywayTable
	if ($flywayTable -eq $null)
	{ $flywayTable = 'dbo.flyway_schema_history' }
	$Version = 'unknown'
	if ($param1.RDBMS -eq 'sqlserver')
	{
		# Do it the SQL Server way.
		$AllVersions = $GetdataFromSQLCMD.Invoke(
			$param1, "SELECT DISTINCT version
      FROM $flywayTable
      WHERE version IS NOT NULL
    FOR JSON AUTO") |
		convertfrom-json
		$LastAction = $GetdataFromSQLCMD.Invoke(
			$param1, "SELECT version, type
      FROM $flywayTable
      WHERE
      installed_rank =
        (SELECT Max (installed_rank) FROM $flywayTable
           WHERE success = 1)
    FOR JSON AUTO") |
		convertfrom-json
	} ##
	elseif ($param1.RDBMS -eq 'postgresql')
	{
		# Do it the PostgreSQL way
		$AllVersions = $GetdataFrompsql.Invoke(
			$param1, "SELECT DISTINCT version
      FROM $($param1.flywayTable)
      WHERE version IS NOT NULL
    ") | convertfrom-json
		$LastAction = $GetdataFrompsql.Invoke(
			$param1, "SELECT version, type
      FROM $flywayTable
      WHERE
      installed_rank =
        (SELECT Max (installed_rank) FROM $flywayTable
           WHERE success = true)
    ") | convertfrom-json
	}
    elseif ($param1.RDBMS -eq 'sqlite')
	{
		# Do it the SQLite way
		$AllVersions = $GetdataFromsqlite.Invoke(
			$param1, "SELECT DISTINCT version
      FROM $($param1.flywayTable)
      WHERE version IS NOT NULL
    ") | convertfrom-json
		$LastAction = $GetdataFromSqlite.Invoke(
			$param1, "SELECT version, type
      FROM $($param1.flywayTable)
      WHERE
      installed_rank =
        (SELECT Max (installed_rank) FROM $($param1.flywayTable)
           WHERE success = 1)
    ") | convertfrom-json
	}
	else { $problems += "$($param1.RDBMS) is not supported yet. " }
	if ($AllVersions.error -ne $null) { $problems += $AllVersions.error }
	if ($LastAction.error -ne $null) { $problems += $LastAction.error }
	if ($AllVersions -eq $null) { $problems += 'No response for version list' }
	if ($LastAction -eq $null) { $problems += 'no response for last migration' }
	if ($problems.count -eq 0)
	{
		if ($LastAction.type -like 'UNDO*')
		{
			$OrderedVersions = $AllVersions | %{
				new-object System.Version ($_.version)
			} |
			sort | % -Begin { $ii = 1 }{
				[pscustomobject]@{ 'Order' = $ii++; 'version' = $_.ToString() }
			};
			$VersionOrder = $OrderedVersions |
			where{ $_.version -eq $Lastaction.version } | Select Order -First 1;
			$Version = ($OrderedVersions |
				where{ $_.Order -eq $VersionOrder.Order - 1 } |
				Select version -First 1).version;
		}
		else
		{
			$Version = $LastAction.version;
		}
	}
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'GetCurrentVersion' += $problems;
		$version = '0.0.0'
	}
    $Param1.feedback.'GetCurrentVersion'="current version is $version"
	$param1.Version = $version
}



<# This uses SQL Compare to check that a version of a database is correct and hasn't been changed.
It returns comparison equal to true if it was the same or false if there has been drift, 
with a list of objects that have changed. if the comparison returns $null, then it means there 
has been an error #>

$IsDatabaseIdenticalToSource = {
	Param ($param1) # $IsDatabaseIdenticalToSource (Don't delete this)
	$problems = @();
	$warnings = @();
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $problems += "no value for '$($_)'" } }
	<#if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	if ($param1.Version -eq '0.0.0') { $identical = $null; $warnings += "Cannot compare an empty database" }
	$GoodVersion = try { $null = [Version]$param1.Version; $true }
	catch { $false }
	if (-not ($goodVersion))
	{ $problems += "Bad version number '$($param1.Version)'" }
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
    $escapedProject=($Param1.Project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	if ($problems.Count -eq 0)
	{
		
        $SourcePath= if ([string]::IsNullOrEmpty($param1.SourcePath)) {'Source'} else {"$($param1.SourcePath)"}
        #the database scripts path would be up to you to define, of course
		$MyDatabasePath =
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\$sourcePath"} 
        else {"$ReportLocation\$($param1.Version)\$sourcePath"} #else the simple version
		$CLIArgs = @(# we create an array in order to splat the parameters. With many command-line apps you
			# can use a hash-table 
			"/Scripts1:$MyDatabasePath",
			"/server2:$($param1.server)",
			"/database2:$($param1.database)",
			"/Assertidentical",
			"/force",
            "/exclude:table:$($param1.flywayTable)",
			'/exclude:ExtendedProperty', #trivial
			"/LogLevel:Warning"
		)
        if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
		{
			$CLIArgs += @(
				"/username2:$($param1.uid)",
				"/Password2:$($param1.pwd)"
			)
		}
	}
    $MyVersionReportPath = 
              if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
                {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports"} 
              else {"$ReportLocation\$($param1.Version)\Reports"} #else the simple version
	if ($problems.Count -eq 0)
	{
		if (Test-Path -PathType Container $MyDatabasePath) #if it does already exist
		{
			Sqlcompare @CLIArgs >"$MyVersionReportPath\VersionComparison.txt"#simply check that the two are identical
			if ($LASTEXITCODE -eq 0) { $identical = $true; "Database Identical to source" }
			elseif ($LASTEXITCODE -eq 79) { $identical = $False; "Database Different to source" }
			else
			{
				#report a problem and send back the args for diagnosis (hint, only for script development)
				$Arguments = ''; $identical = $null;
				$Arguments += $CLIArgs | foreach{ $_ }
				$problems += "That Went Badly (code $LASTEXITCODE) with paramaters $Arguments."
			}
		}
		else
		{
			$identical = $null;
			$Warnings = "source folder '$MyDatabasePath' did not exist so can't check"
		}
		
	}
	$param1.Checked = $identical
	if ($problems.Count -gt 0)
	{ $Param1.Problems.'IsDatabaseIdenticalToSource' += $problems; }
	else
	{
		$Param1.WriteLocations.'IsDatabaseIdenticalToSource' = "$MyVersionReportPath\VersionComparison.txt";
	}
	if ($warnings.Count -gt 0)
	{ $Param1.Warnings.'IsDatabaseIdenticalToSource' += $Warnings; }
}

<#this routine checks to see if a script folder already exists for this version
of the database and, if not, it will create one and fill it with subdirectories
for each type of object. A tables folder will, for example, have a file for every table
each containing a  build script to create that object.
When this exists, it allows SQL Compare to do comparisons and check that a version has not
drifted.#>

$CreateScriptFoldersIfNecessary = {
	Param ($param1) # $CreateScriptFoldersIfNecessary 
	$Problem = @(); #We check that it contains the keys for the values that we need 
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -eq $null) { $problems += "no key for the '$($_)'" } }
	<#if ($param1.Escapedserver -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
    $EscapedProject=($Param1.Project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$SourcePath= if ([string]::IsNullOrEmpty($param1.SourcePath)) {'Source'} else {"$($param1.SourcePath)"}
    $MyDatabasePath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\$sourcePath"} 
        else {"$ReportLocation\$($param1.Version)\$sourcePath"} #else the simple version
    $MyCurrentPath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\current\$sourcePath"} 
        else {"$ReportLocation\current\$sourcePath"} #else the simple version
	$CLIArgs = @(
		"/server1:$($param1.server)",
		"/database1:$($param1.database)",
		"/Makescripts:$($MyDatabasePath)", #special command to make a scripts directory
		"/force",
		"/LogLevel:Warning"
	)
	
	if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
	{
		$CLIArgs += @(
			"/username1:$($param1.uid)",
			"/Password1:$($param1.pwd)"
		)
	}
	if ($problems.Count -eq 0 -and (!(Test-Path -PathType Container $MyDatabasePath))) #if it doesn't already erxist
	{
		Sqlcompare @CLIArgs #write an object-level  script folder that represents the vesion of the database
		if ($?) { "Written script folder for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
		else
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $CLIArgs | foreach{ $_ }
			$problems += "SQL Compare responded with error code $LASTEXITCODE when used with paramaters $Arguments."
		}
		if ($problems.count -gt 0)
		{ $param1.Problems += @{ 'Name' = 'CreateScriptFoldersIfNecessary'; Issues = $problems } }
    	else
	    {
	    $Param1.WriteLocations.'CreateScriptFoldersIfNecessary' = "$MyDatabasePath";
        copy-item -path "$MyDatabasePath\*"  -recurse -destination $MyCurrentPath # copy over the current model
        @{'version'=$Param1.version;'Author'=$Param1.InstalledBy;'Branch'=$param1.branch}|
            convertTo-json >"$(split-path -path $MyCurrentPath -parent)\Version.json"
	    }
	}
	else { "This version is already scripted in $MyDatabasePath " }
}

<# $param1=$dbDetails
a script block that produces a build script from a database, using SQL Compare, pg_dump or whatever. #>

$CreateBuildScriptIfNecessary = {
	Param ($param1) # $CreateBuildScriptIfNecessary (Don't delete this) 
	$problems = @();
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null, '')) { $Problems += "no value for '$($_)'" } }

	#the database scripts path would be up to you to define, of course
	$EscapedProject = ($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'
	$scriptsPath = if ([string]::IsNullOrEmpty($param1.scriptsPath)) { 'scripts' }
	else { "$($param1.scriptsPath)" }
	$MyDatabasePath =
	if ($param1.directoryStructure -in ('classic', $null)) #If the $ReportDirectory has a value
	{ "$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\$scriptsPath" }
	else { "$ReportLocation\$($param1.Version)\$scriptsPath" } #else the simple version
	
	if (-not (Test-Path -PathType Leaf "$MyDatabasePath\V$($param1.Version)__Build.sql"))
	{
		if (-not (Test-Path -PathType Container $MyDatabasePath))
		{
			# is the path to the scripts directory
			# not there, so we create the directory 
			$null = New-Item -ItemType Directory -Force $MyDatabasePath;
		}
		switch ($param1.RDBMS)
		{
			'sqlserver' #using SQL Server
			{
            	#the alias must be set to the path of your installed version of SQL Compare
				Set-Alias SQLCompare $SQLCompareAlias -Scope Script;
				if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
				{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
				$CLIArgs = @(# we create an array in order to splat the parameters. With many command-line apps you
					# can use a hash-table 
					"/server1:$($param1.server)",
					"/database1:$($param1.database)",
					"/exclude:table:$($param1.flywayTable)",
					"/empty2",
					"/force", # 
					"/options:NoTransactions,NoErrorHandling", # so that we can use the script with Flyway more easily
					"/LogLevel:Warning",
					"/ScriptFile:$MyDatabasePath\V$($param1.Version)__Build.sql"
				)
				
				if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
				{
					$CLIArgs += @(
						"/username1:$($param1.uid)",
						"/Password1:$($param1.pwd)"
					)
				}
				
				# if it is done already, then why bother? (delete it if you need a re-run for some reason 	
				Sqlcompare @CLIArgs #run SQL Compare with splatted arguments
				if ($?) { $Param1.WriteLocations.'CreateBuildScriptIfNecessary'="Written build script for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
				else # if no errors then simple message, otherwise....
				{
					#report a problem and send back the args for diagnosis (hint, only for script development)
					$Arguments = '';
					$Arguments += $CLIArgs | foreach{ $_ }
					$Problems += "SQLCompare Went badly. (code $LASTEXITCODE) with paramaters $Arguments."
				}
				break;
			}
			'postgresql' #using SPostgreSQL
			{
            	#the alias must be set to the path of your installed version of Spg_dump
			    Set-Alias pg_dump   $PGDumpAlias -Scope Script;
			    if (!(test-path  ((Get-alias -Name pg_dump).definition) -PathType Leaf))
			    { $Problems += 'The alias for pg_dump is not set correctly yet' }
                $env:PGPASSWORD="$($param1.pwd)"
                $Params=@(
                    "--dbname=$($param1.database)",
                    "--host=$($param1.server)",
                    "--username=$($param1.user)",
                    "--port=$($param1.Port -replace '[^\d]','')",
                    "--file=$MyDatabasePath\V$($param1.Version)__Build.sql",
                    '--encoding=UTF8',
                    '--schema-only')
                 pg_dump @Params 
				if ($?) 
                { $Param1.feedback.'CreateBuildScriptIfNecessary'="Written PG build script for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
				else # if no errors then simple message, otherwise....
				{
					$Problems += "pg_dump Went badly. (code $LASTEXITCODE)"
				}
				break;
			}
            'sqlite' #using SQLite
            {
         		$params = @(
			        '.bail on',
                    '.schema',
			        '.quit')
		        try
		        {
			        sqlite "$($param1.database)" @Params > "$MyDatabasePath\V$($param1.Version)__Build.sql"
		        }		
                catch
		        { $problems += "SQL called to SQLite  failed because $($_)"
                }           
                if ($?)
                { $Param1.feedback.'CreateBuildScriptIfNecessary'="Written SQLite build script for $($param1.Project)" }
                else
                {$problems += "SQLite couldn't create the build script for $($param1.Version) $($param1.RDBMS)"}
            }
            default
                {
                $problems += "cannot do a build script for $($param1.Version) $($param1.RDBMS) "
                }
		}
		if ($problems.count -gt 0)
		{ $Param1.Problems.'CreateBuildScriptIfNecessary' += $problems; }
		else
		{
			$Param1.WriteLocations.'CreateBuildScriptIfNecessary' = "$MyDatabasePath\V$($param1.Version)__Build.sql";
		}
	}
	
	else {$Param1.feedback.'CreateBuildScriptIfNecessary'="This version '$($param1.Version)' already has a build script at $MyDatabasePath " }
	
}


<#This scriptblock executes SQL that produces a report in XML or JSON from the database
#>

$ExecuteTableSmellReport = {
	Param ($param1) # $ExecuteTableSmellReport - parameter is a hashtable 
	$problems = @()
	@('server', 'database', 'version', 'project') | foreach{
		if ($param1.$_ -eq $null)
		{ write-error "no value for '$($_)'" }
	}
	<#if ($param1.EscapedProject -eq $null) #check that escapedValues are in place
	{
		$EscapedValues = $param1.GetEnumerator() |
		where { $_.Name -in ('server', 'Database', 'Project') } | foreach{
			@{ "Escaped$($_.Name)" = ($_.Value.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') }
		}
		$EscapedValues | foreach{ $param1 += $_ }
	}#>
    $EscapedProject=($Param1.Project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports"} 
        else {"$ReportLocation\$($param1.Version)\Reports"} #else the simple version
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	$MyOutputReport = "$MyDatabasePath\TableIssues.JSON"
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCmd   $SQLCmdAlias  -Scope local
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCMD is not set correctly yet' }
	$query = @'
SET NOCOUNT ON
/**
summary:   >
 This query finds the following table smells
 1/ is a Wide table (set this to what you consider to be wide)
 2/ is a Heap
 3/ is an undocumented table
 4/ Has no Primary Key
 5/ Has ANSI NULLs set to OFF
 6/ Has no index at all
 7/ No candidate key (unique constraint on column(s))
 8/ Has disabled Index(es)
 9/ has leftover fake index(es)
10/ has a column collation different from the database
11/ Has a surprisingly low Fill-Factor
12/ Has disabled constraint(s)'
13/ Has untrusted constraint(s)'
14/ Has a disabled Foreign Key'
15/ Has untrusted FK'
16/ Has unrelated to any other table'
17/ Has a deprecated LOB datatype
18/ Has unintelligible column names'
19/ Has a foreign key that has no index'
20/ Has a GUID in a clustered Index
21/ Has non-compliant column names'
22/ Has a trigger that has'nt got NOCOUNT ON'
23/ Is not referenced by any procedure, view or function'
24/ Has  a disabled trigger' 
25/ Can't be indexed'
Revisions:
 - Author: Phil Factor
   Version: 1.1
   Modifications:
	-  added tests as suggested by comments to blog
   Date: 30 Mar 2016
 - Author: Phil Factor
   Version: 1.2
   Modifications:
	-  tidying, added five more smells
   Date: 10 July 2020
 - Author: Phil Factor
   Version: 1.3
   Modifications:
	-  re-engineered it for JSON output
   Date: 26 March 2021
 
 returns:   >
 single result of table name, and list of problems        
**/
declare  @TableSmells table (object_id INT, problem VARCHAR(200)) 
INSERT INTO @TableSmells (object_id, problem)
 SELECT object_id, 'wide (more than 15 columns)' AS Problem
          FROM sys.tables /* see whether the table has more than 15 columns */
          WHERE max_column_id_used > 15
        UNION ALL
        SELECT DISTINCT sys.tables.object_id, 'heap'
          FROM sys.indexes /* see whether the table is a heap */
            INNER JOIN sys.tables
              ON sys.tables.object_id = sys.indexes.object_id
          WHERE sys.indexes.type = 0
        UNION ALL
        SELECT s.object_id, 'Undocumented table'
          FROM sys.tables AS s /* it has no extended properties */
            LEFT OUTER JOIN sys.extended_properties AS ep
              ON s.object_id = ep.major_id AND minor_id = 0
          WHERE ep.value IS NULL
        UNION ALL
        SELECT sys.tables.object_id, 'No primary key'
          FROM sys.tables /* see whether the table has a primary key */
          WHERE ObjectProperty(object_id, 'TableHasPrimaryKey') = 0
        UNION ALL
        SELECT sys.tables.object_id, 'has ANSI NULLs set to OFF'
          FROM sys.tables /* see whether the table has ansii NULLs off*/
          WHERE ObjectPropertyEx(object_id, 'IsAnsiNullsOn') = 0
       UNION ALL
        SELECT sys.tables.object_id, 'No index at all'
          FROM sys.tables /* see whether the table has any index */
          WHERE ObjectProperty(object_id, 'TableHasIndex') = 0
        UNION ALL
        SELECT sys.tables.object_id, 'No candidate key'
          FROM sys.tables /* if no unique constraint then it isn't relational */
          WHERE ObjectProperty(object_id, 'TableHasUniqueCnst') = 0
            AND ObjectProperty(object_id, 'TableHasPrimaryKey') = 0
        UNION ALL
        SELECT DISTINCT object_id, 'disabled Index(es)'
          FROM sys.indexes /* don't leave these lying around */
          WHERE is_disabled = 1
        UNION ALL
        SELECT DISTINCT object_id, 'leftover fake index(es)'
          FROM sys.indexes /* don't leave these lying around */
          WHERE is_hypothetical = 1
        UNION ALL
        SELECT c.object_id,
          'has a column ''' + c.name + ''' that has a collation '''
          + collation_name + ''' different from the database'
          FROM sys.columns AS c
          WHERE Coalesce(collation_name, '') 
		  <> DatabasePropertyEx(Db_Id(), 'Collation')
        UNION ALL
        SELECT DISTINCT object_id, 'surprisingly low Fill-Factor'
          FROM sys.indexes /* a fill factor of less than 80 raises eyebrows */
          WHERE fill_factor <> 0
            AND fill_factor < 80
            AND is_disabled = 0
            AND is_hypothetical = 0
        UNION ALL
        SELECT DISTINCT parent_object_id, 'disabled constraint(s)'
          FROM sys.check_constraints /* hmm. i wonder why */
          WHERE is_disabled = 1
        UNION ALL
        SELECT DISTINCT parent_object_id, 'untrusted constraint(s)'
          FROM sys.check_constraints /* ETL gone bad? */
          WHERE is_not_trusted = 1
        UNION ALL
        SELECT DISTINCT parent_object_id, 'disabled FK'
          FROM sys.foreign_keys /* build script gone bad? */
          WHERE is_disabled = 1
        UNION ALL
        SELECT DISTINCT parent_object_id, 'untrusted FK'
          FROM sys.foreign_keys /* Why do you have untrusted FKs?       
      Constraint was enabled without checking existing rows;
      therefore, the constraint may not hold for all rows. */
          WHERE is_not_trusted = 1
        UNION ALL
        SELECT object_id, 'unrelated to any other table'
          FROM sys.tables /* found a simpler way! */
          WHERE ObjectPropertyEx(object_id, 'TableHasForeignKey') = 0
            AND ObjectPropertyEx(object_id, 'TableHasForeignRef') = 0
        UNION ALL
        SELECT object_id, 'deprecated LOB datatype'
          FROM sys.tables /* found a simpler way! */
          WHERE ObjectPropertyEx(object_id, 'TableHasTextImage') = 1 
       UNION ALL
        SELECT DISTINCT object_id, 'unintelligible column names'
          FROM sys.columns /* column names with no letters in them */
          WHERE name COLLATE Latin1_General_CI_AI NOT LIKE '%[A-Z]%' COLLATE Latin1_General_CI_AI
        UNION ALL
        SELECT keys.parent_object_id,
          'foreign key ' + keys.name + ' that has no supporting index'
          FROM sys.foreign_keys AS keys
            INNER JOIN sys.foreign_key_columns AS TheColumns
              ON keys.object_id = constraint_object_id
            LEFT OUTER JOIN sys.index_columns AS ic
              ON ic.object_id = TheColumns.parent_object_id
             AND ic.column_id = TheColumns.parent_column_id
             AND TheColumns.constraint_column_id = ic.key_ordinal
          WHERE ic.object_id IS NULL
        UNION ALL
        SELECT Ic.object_id, Col_Name(Ic.object_id, Ic.column_id)
          + ' is a GUID in a clustered index' /* GUID in a clustered IX */
          FROM sys.index_columns AS Ic
			INNER JOIN sys.tables AS tables
			ON tables.object_id = Ic.object_id
            INNER JOIN sys.columns AS c
              ON c.object_id = Ic.object_id AND c.column_id = Ic.column_id
            INNER JOIN sys.types AS t
              ON t.system_type_id = c.system_type_id
            INNER JOIN sys.indexes AS i
              ON i.object_id = Ic.object_id AND i.index_id = Ic.index_id
          WHERE t.name = 'uniqueidentifier'
            AND i.type_desc = 'CLUSTERED'
        UNION ALL
        SELECT DISTINCT object_id, 'non-compliant column names'
          FROM sys.columns /* column names that need delimiters*/
          WHERE name COLLATE Latin1_General_CI_AI LIKE '%[^_@$#A-Z0-9]%' COLLATE Latin1_General_CI_AI
        UNION ALL /* Triggers lacking `SET NOCOUNT ON`, which can cause unexpected results WHEN USING OUTPUT */
        SELECT ta.object_id,
          'This table''s trigger, ' + Object_Name(tr.object_id)
          + ', has''nt got NOCOUNT ON'
          FROM sys.tables AS ta /* see whether the table has any index */
            INNER JOIN sys.triggers AS tr
              ON tr.parent_id = ta.object_id
            INNER JOIN sys.sql_modules AS mo
              ON tr.object_id = mo.object_id
          WHERE definition NOT LIKE '%set nocount on%'
        UNION ALL /* table not referenced by any routine */
        SELECT sys.tables.object_id,
          'not referenced by procedure, view or function'
          FROM sys.tables /* found a simpler way! */
            LEFT OUTER JOIN sys.sql_expression_dependencies
              ON referenced_id = sys.tables.object_id
          WHERE referenced_id IS NULL
        UNION ALL
        SELECT DISTINCT parent_id, 'has a disabled trigger'
          FROM sys.triggers
          WHERE is_disabled = 1 AND parent_id > 0
        UNION ALL
        SELECT sys.tables.object_id, 'can''t be indexed'
          FROM sys.tables /* see whether the table has a primary key */
          WHERE ObjectProperty(object_id, 'IsIndexable') = 0
DECLARE @json NVARCHAR(MAX)
SELECT @json = (SELECT TableName, problem from
	(SELECT DISTINCT  Object_Schema_Name(Object_ID) + '.' + Object_Name(Object_ID) AS TableName,object_id, Count(*) AS smells
FROM @TableSmells GROUP BY Object_ID)f(TableName,Object_id, Smells)
INNER JOIN @TableSmells AS problems ON f.object_id=problems.object_id
ORDER BY smells desc
FOR JSON AUTO)
SELECT @Json
'@
	
	if (!([string]::IsNullOrEmpty($param1.uid)) -and ([string]::IsNullOrEmpty($param1.pwd)))
	{ $problems += 'No password is specified' }
	If (!(Test-Path -PathType Leaf  $MyOutputReport) -and ($problems.Count -eq 0))
	{
		if (!([string]::IsNullOrEmpty($param1.uid)))
		{
			$MyJSON = sqlcmd -S "$($param1.server)" -d "$($param1.database)" `
							 -Q `"$query`" -U $($param1.uid) -P $($param1.pwd) -o $MyOutputReport -u -y0
			$arguments = "$($param1.server) -d $($param1.database) -U $($param1.uid) -P $($param1.pwd) -o $MyOutputReport"
		}
		else
		{
			$MyJSON = sqlcmd -S "$($param1.server)" -d "$($param1.database)" -Q `"$query`" -E -o $MyOutputReport -u -y0
			$arguments = "$($param1.server) -d $($param1.database) -o $MyOutputReport"
		}
		if (!($?))
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Problems += "sqlcmd failed with code $LASTEXITCODE, $Myversions, with parameters $arguments"
		}
		$possibleError = Get-Content -Path $MyOutputReport -raw
		if ($PossibleError -like '*Sqlcmd: Error*')
		{
			$Problems += $possibleError;
			Remove-Item $MyOutputReport;
		}
		
	}
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'ExecuteTableSmellReport' += $problems;
	}
	else
	{
		$Param1.WriteLocations.'ExecuteTableSmellReport' = $MyOutputReport;
	}
}

<# This places in a report a json report of the documentation of every table and its
columns. If you add or change tables, this can be subsequently used to update the 
AfterMigrate callback script
for the documentation */#>

$ExecuteTableDocumentationReport = {
	Param ($param1) # $ExecuteTableDocumentationReport  - parameter is a hashtable


	$problems = @()
	@('server', 'database', 'version', 'project') | foreach{
		if ($param1.$_ -eq $null)
		{ $Problems= "no value for '$($_)'" }
	}
	$escapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports"} 
        else {"$ReportLocation\$($param1.Version)\Reports"} #else the simple version
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $MyDatabasePath;
	}
	$MyOutputReport = "$MyDatabasePath\TableDocumentation.JSON"
    
	#the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCmd   $SQLCMDAlias -Scope local
	#is that alias correct?
	if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCMD is not set correctly yet' }
#The JSON Query must have 'SET NOCOUNT ON' and assign the result to 'NVARCHAR MAX' which you select from.

@'
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
DECLARE  @Json NVARCHAR(MAX)
DECLARE @TheSQExpression NVARCHAR(MAX)
DECLARE @TheErrorNumber INT
SELECT @TheErrorNumber=0
 BEGIN TRY
      EXECUTE sp_executesql  @stmt = N'Declare @null nvarchar(100)
	  SELECT @null=String_Agg(text,'','') FROM (VALUES (''testing''),(''testing''),(''one''),(''Two''),(''three''))f(Text)'
    END TRY
    BEGIN CATCH
       SELECT @TheErrorNumber=Error_Number() 
    END CATCH;
/*On Transact SQL language the Msg 195 Level 15 - 'Is not a recognized built-in function name'
 means that the function name is misspelled, not supported  or does not exist. */
IF @TheErrorNumber = 0 
SELECT @TheSQExpression=N'Select @TheJson=(SELECT Object_Schema_Name(TABLES.object_id) + ''.'' + TABLES.name AS TableObjectName,
     Lower(Replace(type_desc,''_'','' '')) AS [Type], --the type of table source
     Coalesce(Convert(NVARCHAR(3800), ep.value), '''') AS "Description",
      (SELECT Json_Query(''{''+String_Agg(''"''+String_Escape(TheColumns.name,N''json'')
            +''":''+''"''+Coalesce(String_Escape(Convert(NVARCHAR(3800),epcolumn.value),N''json''),'''')+''"'', '','')
            WITHIN GROUP ( ORDER BY TheColumns.column_id ASC )  +''}'') Columns
        FROM sys.columns AS TheColumns
         LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
          ON epcolumn.major_id = TABLES.object_id
         AND epcolumn.minor_id = TheColumns.column_id
		 AND epcolumn.class=1
         AND epcolumn.name = ''MS_Description'' --you may choose a different name
        WHERE TheColumns.object_id = TABLES.object_id)
     AS TheColumns
      FROM sys.objects tables
        LEFT OUTER JOIN sys.extended_properties ep
          ON ep.major_id = TABLES.object_id
         AND ep.minor_id = 0
         AND ep.name = ''MS_Description''
      WHERE type IN (''IF'',''FT'',''TF'',''U'',''V'')
FOR JSON auto)'
ELSE
SELECT @TheSQExpression=N'Select @TheJson=(SELECT Object_Schema_Name(TABLES.object_id) + ''.'' + TABLES.name AS TableObjectName,
     Lower(Replace(type_desc,''_'','' '')) AS [Type], --the type of table source
     Coalesce(Convert(NVARCHAR(3800), ep.value), '''') AS "Description",	
	
	(SELECT	Json_Query(''{''+Stuff((SELECT '', ''+''"''+String_Escape(TheColumns.name,N''json'')
            +''":''+''"''+Coalesce(String_Escape(Convert(NVARCHAR(3800),epcolumn.value),N''json''),'''')+''"''
		FROM sys.columns TheColumns
         LEFT OUTER JOIN sys.extended_properties epcolumn --get any description
          ON epcolumn.major_id = Tables.object_id
         AND epcolumn.minor_id = TheColumns.column_id
		 AND epcolumn.class=1
         AND epcolumn.name = ''MS_Description'' --you may choose a different name
        WHERE TheColumns.object_id = Tables.object_id
		ORDER BY TheColumns.column_id
		 FOR XML PATH(''''), TYPE).value(''.'', ''nvarchar(max)''),1,2,'''')  +''}'' )) TheColumns
      FROM sys.objects tables
        LEFT OUTER JOIN sys.extended_properties ep
          ON ep.major_id = TABLES.object_id
         AND ep.minor_id = 0
         AND ep.name = ''MS_Description''
      WHERE type IN (''IF'',''FT'',''TF'',''U'',''V'')
FOR JSON AUTO)'

EXECUTE sp_EXECUTESQL @TheSQExpression,N'@TheJSON nvarchar(max) output',@TheJSON=@Json OUTPUT
SELECT @JSON
'@ > "$($env:Temp)\Temp.SQL"
	if (!([string]::IsNullOrEmpty($param1.uid)) -and ([string]::IsNullOrEmpty($param1.pwd)))
	{ $problems += 'No password is specified' }
	If (!(Test-Path -PathType Leaf  $MyOutputReport) -and ($problems.Count -eq 0)) # do the report once only
	{
        if ($Param1.uid -ne $null) #if we need to use credentials
        {
	         sqlcmd -S "$($param1.server)" -d "$($param1.database)" `
					         -i "$($env:Temp)\Temp.SQL" -U $($param1.uid) -P $($param1.pwd) `
					         -o $MyOutputReport -u -y0
        }
        else #we are using integrated security
        {
	         sqlcmd -S "$($param1.server)" -d "$($param1.database)" `
					         -i "$($env:Temp)\Temp.SQL" -E -o $MyOutputReport -u -y0
        }
        if (!($?)) #sqlcmd error
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Problems += "sqlcmd failed with code $LASTEXITCODE, $Myversions, with parameters $arguments"
		}
		$possibleError = Get-Content -Path $MyOutputReport -raw
		if ($PossibleError -like '*Sqlcmd: Error*')
		{
			$Problems += $possibleError;
			Remove-Item $MyOutputReport;
		}
 	     Remove-Item "$($env:Temp)\Temp.SQL";
    }
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'ExecuteTableDocumentationReport' += $problems;
	}
	else
	{
		$Param1.WriteLocations.'ExecuteTableDocumentationReport' = $MyOutputReport;
	}
}



<#This writes a JSON model of the database to a file that can be used subsequently
to check for database version-drift or to create a narrative of changes for the
flyway project between versions. */#>
$SaveDatabaseModelIfNecessary = {
	Param ($param1) # $SaveDatabaseModelIfNecessary - dont delete this
	$problems = @() #none yet!
	#check that you have the  entries that we need in the parameter table.
	@('server', 'database', 'version', 'project', 'ProjectFolder') | foreach{
		if ([string]::IsNullOrEmpty($param1.$_))
		{ $Problems += "no value for '$($_)'" }
	}
	try
	{
		if (!([string]::IsNullOrEmpty($param1.resources)))
		{ $routine = "$($param1.resources)\TheGloopDatabaseModel.sql" }
		elseif (!([string]::IsNullOrEmpty($param1.ProjectFolder)))
		{ $routine = "$($param1.ProjectFolder)\TheGloopDatabaseModel.sql" }
		else
		{ $routine = "$pwd\TheGloopDatabaseModel.sql" }
		$escapedProject = ($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'
		$MyDatabasePath =
		if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
		{ "$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports" }
		else { "$ReportLocation\$($param1.Version)\Reports" } #else the simple version
		$MyOutputReport = "$MyDatabasePath\DatabaseModel.JSON"
		if (!(Test-Path -PathType Leaf $MyOutputReport))
		{
			if (Test-Path -PathType Leaf $MyDatabasePath)
			{
				# does the path to the reports directory exist as a file for some reason?
				# there, so we delete it 
				remove-Item $MyDatabasePath;
			}
			if (-not (Test-Path -PathType Container $MyDatabasePath))
			{
				# does the path to the reports directory exist?
				# not there, so we create the directory 
				$null = New-Item -ItemType Directory -Force $MyDatabasePath;
			}
			#the alias must be set to the path of your installed version of SQLcmd
			Set-Alias SQLCmd   $SQLCMDAlias -Scope local
			#is that alias correct?
			if (!(test-path  ((Get-alias -Name SQLCmd).definition) -PathType Leaf))
			{ $Problems += 'The alias for SQLCMD is not set correctly yet' }
			#The JSON Query must have 'SET NOCOUNT ON' and assign the result to 'NVARCHAR MAX' which you select from.
			if (!([string]::IsNullOrEmpty($param1.uid)) -and ([string]::IsNullOrEmpty($param1.pwd)))
			{ $problems += 'No password is specified' }
			If (!(Test-Path -PathType Leaf  $MyOutputReport) -and ($problems.Count -eq 0)) # do the report once only
			{
				#make sure that the SQL File is there
				if (!(test-path  $routine -PathType Leaf))
				{ $Problems += "$Routine needs to be installed in the project'" }
				else
				{
					try
					{
						$JSONMetadata = $GetdataFromSQLCMD.Invoke(
							$param1, $null, $routine) | convertfrom-json
					}
					catch
					{
						write-error "the SQL came up with an error $DatabaseModel"
					}
					
					if ($JSONMetadata.error -ne $null) { $problems += $JSONMetadata.error }
					else
					{
						$dlm0 = ''; #the first level delimiter
						$PSSourceCode = $JSONMetadata |
						foreach{
							$dlm1 = ''; #the second level delimiter
							"$dlm0`"$($_.Schema -replace '"', '`"')`"= @{"
							$_.types |
							foreach{
								$dlm2 = ''; #the third leveldelimiter
								"    $dlm1`"$($_.type -replace '"', '`"')`"= @{"
								$_.names |
								foreach{
									$dlm3 = ''; #the fourth-level delimiter
									if ($_.attributes -eq $null -or ($_.attributes[0].attr[0].name -eq $null))
									{ "      $dlm2`"$($_.Name -replace '"', '`"')`"= '' " }
									else
									{
										"      $dlm2`"$($_.Name -replace '"', '`"')`"= @{"
										$_.attributes | #where {$_.attr[0].name -ne $null}|
										foreach{
											$dlm4 = ''; #the fifth-level delimiter
											"        $dlm3`"$($_.TheType -replace '"', '`"')`"= @("
											$_.attr | #where {$_.name -ne $null}|
											foreach{
												"        $dlm4`"$($_.name -replace '"', '`"')`"";
												$dlm4 = ','
											}
											"        )"
											$dlm3 = ';'
										}
										"      }"
									}
									$dlm2 = ';'
								}
								"    }"
								$dlm1 = ';'
							}
							"  }"
							$dlm0 = ';'
						}
						try
						{
							$DataObject = Invoke-Expression  "@{$PSSourceCode}"
							$dataObject | convertTo-json -depth 10 >$MyOutputReport
						}
						catch
						{
							$PSSourceCode >$MyOutputReport
							$Param1.Problems.'SaveDatabaseModelIfNecessary' += "could not convert the json object"
						}
					}
					if ($problems.Count -eq 0) { $Param1.WriteLocations.'SaveDatabaseModelIfNecessary' = $MyOutputReport; }
				}
			}
		}
	}
	catch
	{
		$Param1.Problems.'SavedDatabaseModelIfNecessary' += "$($PSItem.Exception.Message)"
	}
	
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'SaveDatabaseModelIfNecessary' += $problems;
	}
}

<# this creates a first-cut UNDO script for the metadata (not the data) which can
be adjusted and modified quickly to produce an UNDO Script. It does this by using
SQL Compare to generate a  idepotentic script comparing the database with the 
contents of the previous version.#>
$CreateUndoScriptIfNecessary = {
	Param ($param1) # $CreateUndoScriptIfNecessary (Don't delete this) 
	$problems = @(); # well, not yet
    $WeCanDoIt=$true; #assume that we can generate a script ....so far!
    #check that we have values for the necessary details
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	# the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
    $scriptsPath= if ([string]::IsNullOrEmpty($param1.scriptsPath)) {'scripts'} else {"$($param1.scriptsPath)"}
    $sourcePath= if ([string]::IsNullOrEmpty($param1.sourcePath)) {'Source'} else {"$($param1.SourcePath)"}
    $EscapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
   #What was the previous version?
   $flywayTable=$Param1.flywayTable
   if ($flywayTable -eq $null)
        {$flywayTable='dbo.flyway_schema_history'}
	$AllVersions = $GetdataFromSQLCMD.Invoke(
		$param1, "SELECT DISTINCT version
  FROM $flywayTable
  WHERE version IS NOT NULL
FOR JSON AUTO") | convertfrom-json
    $PreviousVersion = $AllVersions| %{
				new-object System.Version ($_.version)
			} | where {$_ -lt [version]$Param1.version}| sort -Descending|select -first 1
    if ($PreviousVersion -eq $null) {
        "no previous version to undo to"; 
        $null=New-Item -ItemType Directory -Force "$env:Temp\DummySource"
        $PreviousDatabasePath="$env:Temp\DummySource";
        $PreviousVersion=[version]'0.0.0';
        }
    else
        {
        $PreviousDatabasePath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($PreviousVersion)\$sourcePath"} 
        else {"$ReportLocation\$($PreviousVersion)\$sourcePath"} #else the simple version

        If (!(Test-Path -path $PreviousDatabasePath -PathType Container)) 
            {$WeCanDoIt=$False} #Because no previous source
        } 
    $CurrentUndoPath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\$scriptsPath"} 
        else {"$ReportLocation\$($param1.Version)\$scriptsPath"} #else the simple version
    if (Test-Path -Path "$CurrentUndoPath\U$($Param1.Version)__Undo.sql" -PathType Leaf )
        {$WeCanDoIt=$False} #Because it has already been done             
    If ($WeCanDoIt)
	    {
        $CLIArgs = @(# we create an array in order to splat the parameters. With many command-line apps you
		    # can use a hash-table 
            "/Scripts1:$PreviousDatabasePath"
		    "/server2:$($param1.server)",
            '/include:identical',#a migration may just be data, no metadata.
		    "/database2:$($param1.database)",
		    "/exclude:table:$($param1.flywayTable)",
		    "/force", # 
		    "/options:NoErrorHandling,IgnoreQuotedIdentifiersAndAnsiNullSettings,NoTransactions,DoNotOutputCommentHeader,ThrowOnFileParseFailed,ForceColumnOrder,IgnoreNoCheckAndWithNoCheck,IgnoreSquareBrackets,IgnoreWhiteSpace,ObjectExistenceChecks,IgnoreSystemNamedConstraintNames,IgnoreTSQLT,NoDeploymentLogging", 
# so that we can use the script with Flyway more easily
		    "/LogLevel:Warning",
		    "/ScriptFile:$CurrentUndoPath\U$($Param1.Version)__Undo.sql"
	    )
	
	    if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
	    {
		    $CLIArgs += @(
			    "/username2:$($param1.uid)",
			    "/Password2:$($param1.pwd)"
		    )
	    }
	    if (-not (Test-Path -PathType Container $CurrentUndoPath))
	    {
		    # is the path to the scripts directory
		    # not there, so we create the directory 
		    $null = New-Item -ItemType Directory -Force $CurrentUndoPath;
	    }
		# if it is done already, then why bother? (delete it if you need a re-run for some reason 	
		Sqlcompare @CLIArgs #run SQL Compare with splatted arguments
		if ($LASTEXITCODE-eq 63) { "no changes to the metadata between $PreviousVersion and this version $($param1.Version) of $($param1.Project)" }
		if ($?) { "Written build script for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
		else # if no errors then simple message, otherwise....
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $CLIArgs | foreach{ $_ }
			$Problems += "SQLCompare Went badly. (code $LASTEXITCODE) with paramaters $Arguments"
		}
		if ($problems.count -gt 0)
		{ $Param1.Problems.'CreateUNDOScriptIfNecessary' += $problems; }
	    else
	    {
	    $Param1.WriteLocations.'CreateUNDOScriptIfNecessary' = "$CurrentUndoPath\U$($Param1.Version)__Undo.sql";
	    }

	}
	else { "This version '$($param1.Version)' already has a undo script to get to $PreviousVersion at $CurrentUndoPath\U$($Param1.Version)__Undo.sql " }
	
}

<# this creates a first-cut migration script for the metadata (not the data) which can
be adjusted, documented  and modified quickly to produce an migration Script. It does this by using
SQL Compare to generate a  idepotentic script comparing contents of the current version of the database with the 
 live version. Do not do this within a Flyway Session (such as an 'afterEach')#>
$CreatePossibleMigrationScript = {
	Param ($param1) # $CreatePossibleMigrationScript (Don't delete this) 
	$problems = @(); # well, not yet
     #check that we have values for the necessary details
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null,'')) { $Problems += "no value for '$($_)'" } }
	# the alias must be set to the path of your installed version of SQL Compare
	Set-Alias SQLCompare $SQLCompareAlias -Scope Script
	if (!(test-path  ((Get-alias -Name SQLCompare).definition) -PathType Leaf))
	{ $Problems += 'The alias for SQLCompare is not set correctly yet' }
	#the database scripts path would be up to you to define, of course
    $scriptsPath= if ([string]::IsNullOrEmpty($param1.scriptsPath)) {'scripts'} else {"$($param1.scriptsPath)"}
    $sourcePath= if ([string]::IsNullOrEmpty($param1.sourcePath)) {'Source'} else {"$($param1.SourcePath)"}
    $EscapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
    $CurrentVersionPath = 
        if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
          {"$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)"} 
        else {"$ReportLocation\$($param1.Version)"} #else the simple version
 	
    $CLIArgs = @(# we create an array in order to splat the parameters. With many command-line apps you
		# can use a hash-table 
        "/Scripts2:$CurrentVersionPath\$SourcePath"
		"/server1:$($param1.server)",
        '/include:identical',#a migration may just be data, no metadata.
		"/database1:$($param1.database)",
		"/exclude:table:$($param1.flywayTable)",
        "/report:$CurrentVersionPath\Drift.xml",
        "/reportType:XML"
		"/force", # 
		"/options:NoErrorHandling,IgnoreExtendedProperties,IgnoreQuotedIdentifiersAndAnsiNullSettings,NoTransactions,DoNotOutputCommentHeader,ThrowOnFileParseFailed,ForceColumnOrder,IgnoreNoCheckAndWithNoCheck,IgnoreSquareBrackets,IgnoreWhiteSpace,ObjectExistenceChecks,IgnoreSystemNamedConstraintNames,IgnoreTSQLT,NoDeploymentLogging", 
# so that we can use the script with Flyway more easily
		"/LogLevel:Warning",
		"/ScriptFile:$CurrentVersionPath\$scriptsPath\MigrationFrom$($param1.Version)ToNextVersion.sql"
	)
	
	if ($param1.uid -ne $NULL) #add the arguments for credentials where necessary
	{
		$CLIArgs += @(
			"/username1:$($param1.uid)",
			"/Password1:$($param1.pwd)"
		)
	}
	if (-not (Test-Path -PathType Container $CurrentVersionPath))
	{
		# is the path to the scripts directory
		# not there, so we create the directory 
		$null = New-Item -ItemType Directory -Force $CurrentVersionPath;
	}
	# if it is done already, then why bother? (delete it if you need a re-run for some reason 	
	Sqlcompare @CLIArgs #run SQL Compare with splatted arguments
	if ($LASTEXITCODE-eq 63) {$param1.feedback.'CreatePossibleMigrationScript'= "There have been no changes to version $($param1.Version) of $($param1.Project)" }
	if ($?) { "Written build script for $($param1.Project) $($param1.Version) to $MyDatabasePath" }
	else # if no errors then simple message, otherwise....
	{
		#report a problem and send back the args for diagnosis (hint, only for script development)
		$Arguments = '';
		$Arguments += $CLIArgs | foreach{ $_ }
		$Problems += "SQLCompare Went badly. (code $LASTEXITCODE) with paramaters $Arguments"
	}
	if ($problems.count -gt 0)
	{ $Param1.Problems.'CreatePossibleMigrationScript' += $problems; }
	else
	{
	$Param1.WriteLocations.'CreatePossibleMigrationScript' = "$CurrentVersionPath\$scriptsPath\MigrationFrom$($param1.Version)ToNextVersion.sql";
    $Param1.feedback.'CreatePossibleMigrationScript'="A migration file has been created from the present version ($($param1.Version))" 
	}
	
}


<#
This script performs a bulk copy operation to get data into a database. It
can only do this if the data is in a suitable directory. At the moment it assumes
that you are using a DATA directory at the same level as the scripts directory. 
BCP must have been previously installed in the path 
Unlike many other tasks, you are unlikely to want to do this more than once for any
database.If you did, you'd need to clear out the existing data first! It is intended
for static scripts AKA baseline migrations.
#>
$BulkCopyIn = {
	Param ($param1) # $BulkCopyIn (Don't delete this) 
	$problems = @(); # well, not yet
	$WeCanDoIt = $true; #assume that we can BCP data in.so far!
	#check that we have values for the necessary details
	@('server', 'database', 'project', 'version') |
	foreach{ if ($param1.$_ -in @($null, '')) { $Problems += "no value for '$($_)'" } }
    if ([string]::IsNullOrEmpty($param1.dataPath)) #has he specified a datapath
            {$FilePath = '..\Data'}
	    else
            {$FilePath = "..\$($param1.datapath)"};
	
	#Now finished getting credentials. Is the data directory there
	if (!(Test-Path -path $Filepath -PathType Container))
	{
		$Problems += 'No appropriate directory with bulk files yet';
		$weCanDoIt = $false;
	}
	if ($weCanDoIt)
	{
		#now we know the version we get a list of the tables.
		$Tables = $GetdataFromSQLCMD.Invoke($Param1, @"
SELECT Object_Schema_Name (object_id) AS [Schema], name
     FROM sys.tables
     WHERE
     is_ms_shipped = 0 AND name NOT LIKE 'Flyway%'
  FOR JSON AUTO
"@) | ConvertFrom-Json
		Write-verbose "Reading data in from $DirectoryToLoadFrom"
		if ($Tables.Error -ne $null)
		{
			$internalLog += $Tables.Error;
			$weCanDoIt = $false;
		}
	}
	
	$Result = $GetdataFromSQLCMD.Invoke($Param1, @'
    EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
'@);
	if ($Result.Error -ne $null)
	{
		$internalLog += $Tables.Error;
		$weCanDoIt = $false;
	}
	
	if ($weCanDoIt)
	{
		$directory = "$Filepath\$($version.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')";
		$Tables |
		foreach {
			# calculate where it gotten from #
			$filename = "$($_.Schema)_$($_.Name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_';
			$progress = '';
			Write-Verbose "Reading in $filename from $($directory)\$filename.bcp"
			if ($User -ne '') #using standard credentials 
			{
				$Progress = BCP "$($_.Schema).$($_.Name)" in "$directory\$filename.bcp" -q -n -E `
								"-U$($user)"  "-P$password" "-d$($Database)" "-S$server"
			}
			else #using windows authentication
			{
				#-E Specifies that identity value or values in the imported data are to be used
				$Progress = BCP "$($_.Schema).$($_.Name)" in "$directory\$filename.bcp" -q -n -E `
								"-d$($Database)" "-S$server"
			}
			if (-not ($?) -or $Progress -like '*Error*') # if there was an error
			{
				$Problems += "Error with data import  of $($directory)\$($_.Schema)_$($_.Name).bcp -  $Progress ";
			}
		}
	}
	$Result = $GetdataFromSQLCMD.Invoke($Param1, @'
ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all
'@)
	if ($problems.count -gt 0)
	{ $Param1.Problems.'BulkCopyIn' += $problems; }
	
}

<#
This script performs a bulk copy operation to get data out of a database, and
into a suitable directory. At the moment it assumes that you wish to use a 
DATA directory at the same level as the scripts directory. 
BCP must have been previously installed in the path.
#>
$BulkCopyOut = {
	Param ($param1) # $BulkCopyOut (Don't delete this) 
	$problems = @(); # well, not yet
	$WeCanDoIt = $true; #assume that we can BCP data in.so far!
	#check that we have values for the necessary details
	@('version', 'server', 'database', 'project') |
	foreach{ if ($param1.$_ -in @($null, '')) { $Problems += "no value for '$($_)'" } }
	if ([string]::IsNullOrEmpty($param1.dataPath)) #has he specified a datapath
        {$FilePath = '..\Data'}
	else
        {$FilePath = "..\$($param1.datapath)"}
	if (!(Test-Path -path $Filepath -PathType Container))
	{
		$Null = New-Item -ItemType Directory -Path $FilePath -Force
	}
	
	#now we know the version we get a list of the tables.
	$Tables = $GetdataFromSQLCMD.Invoke($param1, @"
SELECT Object_Schema_Name (object_id) AS [Schema], name
     FROM sys.tables
     WHERE
     is_ms_shipped = 0 AND name NOT LIKE 'Flyway%'
  FOR JSON AUTO
"@) | ConvertFrom-Json
	Write-verbose "Reading data in from $DirectoryToLoadFrom"
	if ($Tables.Error -ne $null)
	{
		$internalLog += $Tables.Error;
		$WeCanDoIt = $false;
	}
	if ($WeCanDoIt)
	{
		$directory = "$Filepath\$($version.Split([IO.Path]::GetInvalidFileNameChars()) -join '_')";
        if (-not (Test-Path "$directory" -PathType Container))
        { New-Item -ItemType directory -Path "$directory" -Force}        
		$Tables |
		foreach {
			# calculate where it gotten from #
			$filename = "$($_.Schema)_$($_.Name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_';
			$progress = '';
			Write-Verbose "writing out $filename to  $($directory)\$filename.bcp"
			if ($User -ne '') #using standard credentials 
			{
				$Progress = BCP "$($_.Schema).$($_.Name)"  out  "$directory\$filename.bcp"  `
								-n "-d$($Database)"  "-S$($server)"  `
								"-U$user" "-P$password"
			}
			else #using windows authentication
			{
				#-E Specifies that identity value or values in the imported data are to be used
				
				$Progress = BCP "$($_.Schema).$($_.Name)" in "$directory\$filename.bcp" -q -n -E `
								"-d$($Database)" "-S$server"
				
			}
			if (-not ($?) -or $Progress -like '*Error*') # if there was an error
			{
				$Problems += "Error with data export  of $($directory)\$($_.Schema)_$($_.Name).bcp -  $Progress ";
			}
		}
	}
	if ($problems.count -gt 0)
	{ $Param1.Problems.'BulkCopyOut' += $problems; }


}


<#
This script creates a PUML file for a Gantt chart at the current version of the database. This can be
read into any editor that takes PlantUML files to give a Gantt chart
#>
$GeneratePUMLforGanttChart = {
	Param ($param1) # $GeneratePUMLforGanttChart (Don't delete this) 
	$problems = @(); #no problems so far
	#check that you have the  entries that we need in the parameter table.
	@('server', 'database', 'project', 'uid') | foreach{
		if ([string]::IsNullOrEmpty($Param1.$_))
		{ $Problems += "no value for '$($_)'" }
	}
    $EscapedProject=($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
	$MyDatabasePath =
	if  ($param1.directoryStructure -in ('classic',$null)) #If the $ReportDirectory has a value
	{ "$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)\$($param1.Version)\Reports" }
	else { "$ReportLocation\$($param1.Version)\Reports" } #else the simple version
	$flywayTable = $Param1.flywayTable
	if ($flywayTable -eq $null)
	{ $flywayTable = 'dbo.flyway_schema_history' }
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		# does the path to the reports directory exist?
		# not there, so we create the directory 
		$null = New-Item -ItemType Container -Force $MyDatabasePath;
	}
    $Puml=''
	if ($problems.Count -eq 0)
	{
		$puml = $GetdataFromSQLCMD.Invoke($param1, @"
/* we read the Flyway Schema History into a table variable so we can then do a line--by-line select with 
a guarantee of doing it in the order of the primary key */
set nocount on
DECLARE @FlywaySchemaTable TABLE
   ([installed_rank] [INT] NOT NULL PRIMARY KEY,
   [version] [NVARCHAR](50) NULL,
   [description] [NVARCHAR](200) NULL,
   [installed_by] [NVARCHAR](100) NOT NULL,
   [installed_on] [DATETIME] NOT NULL)
/* now read in the table */
INSERT INTO @FlywaySchemaTable
  (Installed_rank, version,  
   installed_by, installed_on, description )
   --I've added the placeholders in case you want to execute this in a callback
SELECT fsh.installed_rank, version, installed_by, installed_on, description
  FROM $flywayTable FSH 
    INNER JOIN
      (SELECT  Max (installed_rank) AS installed_rank
         FROM $flywayTable 
         WHERE
         success = 1 AND type = 'SQL' AND version IS NOT NULL
         GROUP BY version) f
      ON f.installed_rank = fSH.installed_rank
  ORDER BY fSH.installed_rank;

/* now we calculate the version. This is slightly complicated by the
possibility that you've done an UNDO. I've added the placeholders
in case you want to execute this in a callback */
DECLARE @Version [NVARCHAR](50) =
    (SELECT TOP 1 [version] --we need to find the greatest successful version.
        FROM $flywayTable -- 
        WHERE
        installed_rank =
        (SELECT Max (installed_rank)
            FROM $flywayTable 
            WHERE success = 1));

DECLARE @PlantUMLCode NVARCHAR(MAX)='@startgantt
skinparam LegendBorderRoundCorner 2
skinparam LegendBorderThickness 1
skinparam LegendBorderColor silver
skinparam LegendBackgroundColor white
skinparam LegendFontSize 11
printscale weekly
saturday are closed
sunday are closed
title Gantt Chart for version '+@Version+'
legend top left
  Database: '+Db_Name()+'
  Server: '+@@ServerName+'
  RDBMS: sqlserver
  Flyway Version: '+@Version+'
endlegend
printscale weekly
saturday are closed
sunday are closed
'
DECLARE @PreviousDescription NVARCHAR(100) 
--used to temporarily hold the previous description

SELECT @PlantUMLCode=@PlantUMLCode + 
  CASE WHEN @PreviousDescription IS NULL THEN 'Project starts '+Convert(NCHAR(11),Convert(DATETIME2,Installed_on,112)) +'
' ELSE '' END+
'['+version+' - '+description+'] on {'+[installed_by]+'} starts '+ Convert(NCHAR(11),Convert(DATETIME2,Installed_on,112))+'
' 
+ CASE WHEN @PreviousDescription IS NOT NULL THEN '['+@Previousdescription+'] ends '+Convert(NCHAR(11),Convert(DATETIME2,Installed_on,112))+'
' ELSE '' END,
      @PreviousDescription = version+' - '+description
FROM @FlywaySchemaTable WHERE version IS NOT null
SELECT @PlantUMLCode=@PlantUMLCode+'@endgantt'
SELECT @PlantUMLCode

"@, $null, $true)
		
		[IO.File]::WriteAllLines("$MyDatabasePath\GanttChart.puml", $puml) # It must be UTF8!!!
	}
if ($problems.count -gt 0)
	{ $Param1.Problems.'GeneratePUMLforGanttChart' += $problems; 
	}
	else
	{
	$Param1.WriteLocations.'GeneratePUMLforGanttChart' = "$MyDatabasePath\GanttChart.puml";
	}

}



Function GetorSetPassword{
[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[string]$uid,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[string]$Server,
		[Parameter(Mandatory = $false,
				   Position = 3)]
		[string]$RDBMS =$null) #change to your  database system if you have two on the one server!





    $PwdDetails= @{
        'RDBMS'=$RDBMS; #jdbc name. Only necessary for systems with several RDBMS on the same server
	    'Server'=$server;
        'pwd' = ''; #Always leave blank
	    'uid' = $uid; #leave blank unless you use credentials
	    'problems' = @{ }; # for reporting any big problems
         }
 
    $FetchAnyRequiredPasswords.Invoke($PwdDetails);
    if ($PwdDetails.Problems.FetchAnyRequiredPasswords.Count -gt 0)
         {Write-error "$($PwdDetails.Problems.FetchAnyRequiredPasswords)" }
    $PwdDetails.pwd
}


function Process-FlywayTasks
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[System.Collections.Hashtable]$DatabaseDetails,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[array]$Invocations
	)
	
	$Invocations | foreach{
        if ($_ -eq $null) {
            Write-error "the scriptblock wasn't recognised"
                }
		elseif ($DatabaseDetails.Problems.Count -eq 0)
		{#try to get the name of the task
			if ($_.Ast.Extent.Text -imatch '(?<=# ?\$)([\w]{5,80})')
			{ $TaskName = $matches[0] }
			else { $TaskName = 'unknown' }
			try # try executing the script block
			{ $returnedArray = $_.Invoke($DatabaseDetails) }
			catch #if it hit an exception
			{
				# handle the exception
				$where = $PSItem.InvocationInfo.PositionMessage
				$ErrorMessage = $_.Exception.Message
				$FailedItem = $_.Exception.ItemName
				$DatabaseDetails.Problems.exceptions += "$Taskname failed with $FailedItem : $ErrorMessage at `n $where."
			}
           	 "Executed $TaskName"
        }
		
	}
	#print out any errors and warnings. 
	if ($DatabaseDetails.Problems.Count -gt 0) #list out every problem and which task failed
	{
		$DatabaseDetails.Problems.GetEnumerator() |
		   Foreach{ Write-warning "Problem! $($_.Key)---------"; $_.Value } |
		      foreach { write-warning "`t$_" }
        
	}
	if ($DatabaseDetails.Warnings.Count -gt 0) #list out exery warning and which task failed
	{
		$DatabaseDetails.Warnings.GetEnumerator() |
		Foreach{ Write-warning "$($_.Key)---------"; $_.Value } |
		foreach { write-warning  "`t$_" }
	$DatabaseDetails.Warnings=@{}    
    }

	$DatabaseDetails.WriteLocations.GetEnumerator() |
		Foreach{ Write-Output "For the $($_.Key), we saved the report in $($_.Value)"
    $DatabaseDetails.WriteLocations=@{}   
 } 

	$DatabaseDetails.feedback.GetEnumerator() |
		Foreach{ Write-Output "in $($_.Key), $($_.Value)"
    $DatabaseDetails.feedback=@{}  
     } 

    #$Reports=$DatabaseDetails.WriteLocations.GetEnumerator() |
	#	Foreach{ @{"Source"= $($_.Key); "Report"=$($_.Value)} 
    #if ($Reports.Count -gt 0) {write-warning "$($Reports| ConvertTo-Json)"}
    
   }


'scriptblocks and cmdlet loaded. V1.2.76'
