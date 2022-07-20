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
 
	




























































$checked=0
$checkedOK=0
$TheErrors = @();
$MatchedKeys=@()
$KeyField = 'city';
$TestResult | select -First 100 | foreach{
	$TestLine=$_
	$KeyValue = $TestLine.$KeyField;
	$matches = $CorrectResult | where { $_.$KeyField -eq $keyvalue }
	if ($matches.count -eq 0)
	{
		$TheErrors += "extra test row $($testline|convertTo-json -Compress) not in correct result"
	}
	elseif ($matches.count -gt 1)
	{
		$TheErrors += "extra row in correct data with $keyvalue key = $keyvalue"
	}
	else
	{
		$MatchedKeys += $matches.$KeyField;
		$RecordWasOK = $true; #assume optimistically that it is OK
		$fields | where {$_ -ne $KeyField}|foreach {
			# for each column in common
			if ($Testline.$_ -ne $matches[0].$_)
			{
				#not the same. Oh dear. Record each failure
				$TheErrors += "for row with the $keyfield '$keyValue', the values for the $($_) column, $($Testline.$_) and $($matches[0].$_) don't match";
				$RecordWasOK = $false;
			}
		}
		$checked++;
		if ($RecordWasOK) { $checkedOK++; } # keep a tally of successes
	}
}    
$correctResult |where {$_.$keyfield -notin $matchedkeys}|foreach{
    $missing=$_;
	$TheErrors += "missing record $($missing|convertTo-json -Compress)";
	}

