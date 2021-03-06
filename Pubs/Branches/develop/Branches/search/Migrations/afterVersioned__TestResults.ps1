# test this on SQL Server
. '.\preliminary.ps1'
Process-FlywayTasks $DBDetails $GetCurrentVersion
#report on exactly who and on what and where 
Write-Output @"
$($Env:USERNAME) Testing the $($dbDetails.variant) variant of $($dbDetails.branch) branch
of the $($dbDetails.RDBMS) $($dbDetails.project) project using $($dbDetails.database) database 
on $($dbDetails.server) server with user $($dbDetails.installedBy)"
"@
#firstly we make sure that this version of 'preliminary.ps1' is not an old one 
if ($dbDetails.TestsLocations -eq $null)
{ Throw "Please upgrade the Preliminary.ps1 to the latest version" }
#double-check that the version is properly in place. We're going to need that
if ([string]::IsNullOrEmpty($DBDetails.Version))
{ Process-FlywayTasks $DBDetails $GetCurrentVersion }
#now we just scoop up all the test files that are relevant, collect their information  and execute them

# to just run the local tests,...
# Run-TestsForMigration $dbDetails  $dbDetails.TestsLocations[0]

#to run all the tests for this project
$dbDetails.TestsLocations|foreach {
    Run-TestsForMigration -DatabaseDetails $DBDetails -ThePath $_} 
# to run all the SQL performance tests
$dbDetails.TestsLocations|foreach {
    Run-TestsForMigration -DatabaseDetails $DBDetails -ThePath $_ -type 'P' -script 'sql'} 
	
