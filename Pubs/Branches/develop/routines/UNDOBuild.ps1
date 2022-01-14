. '.\preliminary.ps1'

# now we use the scriptblock to determine the version number and name from SQL Server

$ServerVersion = $GetdataFromSQLCMD.Invoke($DBdetails, "
 Select  Cast(ParseName ( Cast(ServerProperty ('productversion') AS VARCHAR(20)), 4) AS INT)")

[int]$VersionNumber = $ServerVersion[0]

if ($VersionNumber -ne $null)
{
    $Env:FLYWAY_PLACEHOLDERS_CANDOJSON="$(if ($VersionNumber -ge 13) { 'true' }	else { 'false' })";
	$Env:FLYWAY_PLACEHOLDERS_canDoStringAgg="$(if ($VersionNumber -ge 14) { 'true' } else { 'false' })";
}
else
{
    $Env:FLYWAY_PLACEHOLDERS_CANDOJSON=false;
	$Env:FLYWAY_PLACEHOLDERS_canDoStringAgg=false;
}

gci env:* | sort-object name


@('1.1.2','1.1.3','1.1.4',
'1.1.5','1.1.6','1.1.7','1.1.8',
'1.1.9','1.1.10','1.1.11')| foreach{
Flyway  migrate "-password=$($dbDetails.pwd)" "-target=$_"
}
       
Flyway "-password=$($dbDetails.pwd)" info 
Flyway "-password=$($dbDetails.pwd)" clean


Flyway @FlywayUndoArgs undo '-target=1.1.10'
Flyway @FlywayUndoArgs migrate '-target=1.1.1'

Flyway -?

























