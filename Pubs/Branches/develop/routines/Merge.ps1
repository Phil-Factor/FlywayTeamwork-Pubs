# At the start we must change working directory to the branch we are working
# on
cd S:\work\Github\FlywayTeamwork\Pubs\branches\develop
#we start off by finding out all we can about the branch and project
. '.\preliminary.ps1'
<# 
Now we have a hashtable with everything we need barring project-specific placeholders
we then set the placeholder values for the capability of the version of SQL Server.
#>
$ServerVersion = $GetdataFromSQLCMD.Invoke($DBdetails, "
 Select  Cast(ParseName ( Cast(ServerProperty ('productversion') AS VARCHAR(20)), 4) AS INT)")
[int]$VersionNumber = $ServerVersion[0]
if ($VersionNumber -ne $null)
{
    $canDoJSON="$(if ($VersionNumber -ge 13) { 'true' }	else { 'false' })";
	$canDoStringAgg="$(if ($VersionNumber -ge 14) { 'true' } else { 'false' })";
}
else
{
    $canDoJSON=false;
	$canDoStringAgg=false;
}

if (!(Test-Path Env:FLYWAY_PLACEHOLDERS_CANDOJSON )) {$Env:FLYWAY_PLACEHOLDERS_CANDOJSON=$canDoJSON} 
if (!(Test-Path Env:FLYWAY_PLACEHOLDERS_CANDOSTRINGAGG )) {$Env:FLYWAY_PLACEHOLDERS_CANDOSTRINGAGG=$canDoStringAgg}
# we now set the password. This can be done as an environment variable. but that isn't quite as saecure #/ 
$pword="-password=$($dbDetails.pwd)"
<#
we should now alert the user as to the branch the user is in
#>
Write-Output @"
Processing the $($dbDetails.branch) branch of the $($dbDetails.project) project using $($dbDetails.database) database on $($dbDetails.server) server with user $($dbDetails.installedBy)"
"@
#save the dry-run script in the scripots subdirectory of the branch      
Flyway $pword migrate  '-target=1.1.11' "-dryRunOutput=$pwd\scripts\V1.12__SecondRelease1-1-2to1-1-11.sql"

Flyway $pword info 
$TheBranch=$pwd #remember where you are 
cd ../../ #migrate to the parent branch
. '.\preliminary.ps1'
$pword="-password=$($dbDetails.pwd)"
Flyway  $pword info
cd $TheBranch

Dir "$pwd\$($dbDetails.migrationsPath)\V*.sql"|
    foreach{@{$_.Name=[version]($_.Name -ireplace '(?m:^)V(?<Version>.*)__.*', '${Version}')}}|
        sort-object -Property @{Expression = "Value"; Descending = $false}





















