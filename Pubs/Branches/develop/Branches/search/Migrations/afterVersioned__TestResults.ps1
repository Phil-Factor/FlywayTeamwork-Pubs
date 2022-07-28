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

#now we just scoop up all the test files that are relevant, collect their information  and execute them

# to just run the local tests,...
# Run-TestsForMigration $dbDetails  $dbDetails.TestsLocations[0]

#to run all the tests for this project
$dbDetails.TestsLocations | foreach {
	#for each test location
	$TestLocation = $_
	@('sql', 'ps1') | foreach {
		#for each type (sql or powershell) of test
		#run the unit and integration tests
		Run-TestsForMigration -DatabaseDetails $DBDetails -ThePath $TestLocation -type 'T' -script $_
		#run the performance tests
		Run-TestsForMigration -DatabaseDetails $DBDetails -ThePath $TestLocation -type 'P' -script $_
	}
}