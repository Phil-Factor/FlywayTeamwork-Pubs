$ENV:NarrativeLog='MigrationNarrative'
$weHaveTheSourceData=$false;
# if you have put the json output of the migration from Flyway 
# into a file called migrateFeedback.json
if (Test-path -PathType Leaf -Path 'migrateFeedback.json')
{
	$weHaveTheSourceData=$true;
}
if ($env:NarrativeLog -ne $null -and $weHaveTheSourceData)
{
    $feedback = get-content -raw '.\migrateFeedback.json' | ConvertFrom-JSON
	$initialVersion = Switch ($feedback.initialSchemaVersion)
	{
		{ [string]::IsNullOrEmpty($psitem) } { 'empty' }
		default { "V$psitem" }
	}
	$Success = if ($feedback.success) { 'A ' }
	else { 'An un' }
	$Warnings = if ($feedback.warnings.count -eq 0) { 'no' }
	else { "$($feedback.warnings.count)" }
	$TheMigrationList = $feedback.migrations
	if ($TheMigrationList -isnot [array])
	{
		$MigrationDescription = $TheMigrationList.description
		$TheMigrationList.executionTime
		$From = $initialVersion
		$To = $TheMigrationList.version
	}
	else
	{
		
		$TheMigrationList | foreach -begin {
			$From = $null, $FromDescription = $null
		} {
			if ($From -eq $Null) { $From = $_.version; }
			if ($FromDescription -eq $Null) { $FromDescription = $_.Description };
			$To = $_.version
			$MigrationDescription = "$FromDescription $(
                if ($_.Description -ne $FromDescription) { " to $($_.Description)" }
				else { '' })"
		}
	}
    $timespan = [TimeSpan]::FromMilliseconds($feedback.totalMigrationTime)	
    $HowLongItTook=switch ($timespan.Minutes){ {$psitem -gt 0} {
        "$($timespan.Minutes) mins, $($timespan.Seconds) secs"} default {
        "$($timespan.Seconds) seconds"}};
    $OurURL = $env:FLYWAY_URL #contains the current database, port and server 
    $FlywayURLRegex = 'jdbc:(?<RDBMS>[\w]{1,20}):(//(?<server>[\w\\\-\.]{1,40})(?<port>:[\d]{1,4}|)|thin:@)((;.*databaseName=|/)(?<database>[\w]{1,20}))?'
    if ($OurURL -imatch $FlywayURLRegex) #This copes with having no port.
    {
	    #we can extract all the info we need
         $server = $matches['server'];
    }
    else #whatever your default
    {
    $server = 'LocalHost';
    
    }
	"$($success)successful '$($feedback.operation)' operation of $
        ($feedback.databaseType) host $server database '$(
		$feedback.database)' from $initialVersion to V$($feedback.targetSchemaVersion
	) ($MigrationDescription)  on $(get-date $feedback.timestamp -UFormat " %r %a %e %b %Y"
	) took $HowLongItTook and had $warnings warnings">>$ENV:NarrativeLog
}
