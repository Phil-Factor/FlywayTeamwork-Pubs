. '.\preliminary.ps1'

<# now we use the GetdataFromSQLCMD scriptblock to determine the version number and name from SQL Server.
we then set the placeholder values for the capability of the version of SQL Server.
#>

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
# we now set the password. This can be done as an environment variable. but that isn't quite as saecure #/ 
$pword="-password=$($dbDetails.pwd)"

Write-Output @"
Processing the $($dbDetails.branch) branch of the $($dbDetails.project) project using $($dbDetails.database) database on $($dbDetails.server) server with user $($dbDetails.installedBy)"
"@

Flyway $pword clean
@('1.1.1','1.1.2','1.1.3','1.1.4',
'1.1.5','1.1.6','1.1.7','1.1.8',
'1.1.9','1.1.10','1.1.11')| foreach{
Flyway  $pword migrate  "-target=$_"
}
       
Flyway $pword info 
Flyway $pword clean


Flyway $pwords undo '-target=1.1.10'


Flyway -?























