#Set-Alias Flyway  'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-8.0.2\flyway.cmd' -Scope local
$FlywayCommand=(Get-Command "Flyway" -ErrorAction SilentlyContinue)
if ($null -eq $FlywayCommand) {
    throw "This script requires Flyway to be installed and available on a PATH or via an alias"
}
if ($FlywayCommand.CommandType -eq 'Application' -and $FlywayCommand.Version -lt [version]'8.0.1.0') {
    throw "Your Flyway Version is too outdated to work"
}
<# tell PowerShell where Flyway is. You need to change that to the correct path for your installation.
You only need to do this if your flyway installation has not provideded a path cvommand #>
Set-Alias SQLite  'C:\ProgramData\chocolatey\lib\SQLite\tools\sqlite-tools-win32-x86-3360000\sqlite3.exe' -Scope local

#test these aliases
if (!(test-path  ((Get-alias -Name Flyway).definition) -PathType Leaf))
{ write-error 'The alias for Flyway is not set correctly yet' }
if (!(test-path  ((Get-alias -Name SQLite).definition) -PathType Leaf))
{ write-error 'The alias for SQLite is not set correctly yet' }
# we collect all the useful information in a log. Here we start it up
$internalLog=@("$(Get-date)- started with $env:FLYWAY_USER ")
# we create a variable to work out if we can go ahead
$WeCanContinue = $true #start off with optimism
#our regex for gathering variables from Flyway's URL
$FlywayURLRegex =
'jdbc:(?<RDBMS>[\w]{1,20})://(?<server>[\w\-\.]{1,40})(?<port>:[\d]{1,4}|)(;.+databaseName=|/)(?<database>[\w]{1,20})'
$FlywayURLTruncationRegex = 'jdbc:.{1,30}://.{1,30}(;|/)'
#this FLYWAY_URL contains the current database, port and server so
# it is worth grabbing
$ConnectionInfo = $env:FLYWAY_URL #get the environment variable
if ($ConnectionInfo -eq $null) #OMG... it isn't there for some reason
{ $internalLog += 'missing value for flyway url'; $WeCanContinue = $false; }
#get the user ID
$uid = $env:FLYWAY_USER;
$ProjectFolder = $PWD.Path;
#test the path
if (!(test-path  $ProjectFolder -PathType Container))
{ write-error "There isn't a valid scripts folder at $ProjectFolder" }


if ($ConnectionInfo -imatch $FlywayURLRegex)
{
	#we can extract all the info we need
	$RDBMS = $matches['RDBMS'];
	$server = $matches['server'];
	$port = $matches['port'];
	$database = $matches['database']
}
elseif ($ConnectionInfo -imatch 'jdbc:(?<RDBMS>[\w]{1,20}):(?<database>[\w:\\]{1,80})')
{
	#no server or port
	$RDBMS = $matches['RDBMS'];
	$server = 'LocalHost';
	$port = 'default';
	$database = $matches['database']
}
else
{
	$internalLog += 'unmatched connection info'
}
#write to our log for debugging purposes
$internalLog += "RDBMS=$RDBMS, Server='$server' Port='$port' and Database= '$database'"
if ($weCanContinue)
{
	# now we get the password if necessary
	if ($username -ne '' -and $RDBMS -ne 'sqlite') #then it is using Credentials
	{
		# we see if we've got these stored already
		$escapedServer=($server.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.','-'
        $SqlEncryptedPasswordFile = "$env:USERPROFILE\$($uid)-$escapedServer-$($RDBMS).xml"
		# test to see if we know about the password in a secure string stored in the user area
		if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
		{
			#has already got this set for this login so fetch it
			$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
			
		}
		else #then we have to ask the user for it (once only)
		{
			# hasn't got this set for this login
			$SqlCredentials = get-credential -Credential $uid
			# Save in the user area 
			$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
		}
		$FlyWayArgs =
		@("-url=$ConnectionInfo",
			"-locations=filesystem:$PWD", <# the migration folder #>
			"-user=$($SqlCredentials.UserName)",
			"-password=$($SqlCredentials.GetNetworkCredential().password)")
	}
	else
	{
		$FlyWayArgs =
		@("-url=$($ConnectionInfo)(if $RDBMS -eq 'sqlserver'){'integratedSecurity=true'}else {''})".
			"-locations=filesystem:$PWD")<# the migration folder #>
	}
    $FlyWayArgs+=gci env:FP__* |
       Foreach {
          "$($_.Name -ireplace 'FP__(?<Variable>[\w]*)__', '-placeholders.${Variable}=')$($_.Value.ToLower())"}

#flush the usage log
	$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
	$internalLog = @()
	
	#get a JSON report of the history. We only want the record for the current version
    try{
	$report = Flyway info  @FlywayArgs -outputType=json | convertFrom-json
        }
    catch
        {
        $report.error ="We got an uncaugt error from Flyway $($_.ScriptStackTrace)"
        }
    
	if ($report.error -ne $null) #if an error was reported by Flyway
	{
		#if an error (usually bad parameters) error out.
		$report.error | foreach { $internalLog += "$($_.errorCode): $($_.message)" }
	}
	if ($report.allSchemasEmpty) #if it is an empty database
	{ $internalLog += "all schemas of $database are empty. No version has been created here" }
	else
	{
		#looking good, so first get the paramaters that are not specific to the version
		$RecordOfCurrentVersion = [pscustomobject]@{
			# get the global variables
			'Database' = $report.database;
			'Server' = $server;
			'RDBMS' = $RDBMS;
			'Schema names' = $report.schemaName;
			'Flyway Version' = $report.flywayVersion;
		}
	} # now add all the values from the record for the current version
	$Report.migrations |
	where { $_.version -eq $Report.schemaVersion } | select -Last 1| foreach{
		$rec = $_; #remember this for gettinmg it's value
		$rec | gm -MemberType NoteProperty
	} | foreach{
		# do each key/value pair in turn
		$RecordOfCurrentVersion |
		Add-Member -MemberType NoteProperty -Name $_.Name -Value $Rec.($_.Name)
	}
	if ($RecordOfCurrentVersion.state -ne 'Success')
	{ write-error "Have you given the correct project folder?" }
	#now all we have to do is to write it into the database if the record
	#does not already exist
	$internalLog += "Now saving $($RecordOfCurrentVersion) to SQLite"
	$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
	$internalLog = @()
	#in this case, we have only one record but we'll use a pipeline
	#just for convenience.
	$RecordOfCurrentVersion | foreach{
		sqlite '..\flywayHistory.db' "
CREATE TABLE IF NOT EXISTS 
Versions(
    Database Varchar(80),
    Server Varchar(80),
    RDBMS  Varchar(20),
    Schema_names Varchar(200),
    Flyway_Version Varchar(20),
    category Varchar(80),
    description Varchar(80),
    executionTime int,
    filepath  Varchar(200),
    installedBy Varchar(80),
    installedOn Varchar(25),
    installedOnUTC Varchar(25),
    state Varchar(80),
    type Varchar(10),
    undoable Varchar(5),
    version Varchar(80),
    PRIMARY KEY (Database, Server, RDBMS, Version))
;
INSERT INTO Versions( Database, Server, RDBMS, Schema_names,
Flyway_Version, category, description, executionTime,
filepath, installedBy, installedOn, installedOnUTC,
state, type, undoable, version) 
SELECT '$($_.Database)', '$($_.Server)', '$($_.RDBMS)', 
  '$($_.'Schema names')', '$($_.'Flyway Version')', '$($_.category)',
  '$($_.description)', '$($_.executionTime)', '$($_.filepath)',
  '$($_.installedBy)', '$($_.installedOn)', '$($_.installedOnUTC)',
  '$($_.state)', '$($_.type)', '$($_.undoable)', '$($_.version)'
WHERE NOT EXISTS(SELECT 1 FROM Versions
        WHERE Database='$($_.Database)' AND Server= '$($_.Server)' 
        AND RDBMS= '$($_.RDBMS)' AND version = '$($_.Version)'); 
"  .exit
	}
}
else
{ $internalLog += "$(Get-date)- had to abandon reporting" }

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$internalLog | foreach{ "Logged $_" }
$internalLog | foreach{ $_ >> "$(Split-Path  $PWD -Parent)\Usage.log" }
