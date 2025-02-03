<#	
	.NOTES
	===========================================================================
	 Last Updated on: 	11/11/2024 15:04
	 Created by:    	Phil Factor
	 Filename:     		afterMigrate_Report
	===========================================================================
	.DESCRIPTION
		This file uses the saved output from the migrate command to put a record
	of the migration, when it happened, who did it and what was the result. It 
	saves this to a file. In a production version it saves it to a notification 
	system
#>
$ENV:FP__NarrativeLog = 'MigrationNarrative'
$weHaveTheSourceData = $false;
# if you have put the json output of the migration from Flyway 
# into a file called migrateFeedback.json
if (Test-path -PathType Leaf -Path 'migrateFeedback*.json')
{
	$weHaveTheSourceData = $true;
} #now see if we want a narrative log 
if ($env:FP__NarrativeLog -ne $null -and $weHaveTheSourceData)
{
	# if we signal that we want a report and we've provided one with the right name
	$feedback = get-content -raw '.\migrateFeedback.json' | ConvertFrom-JSON
	#convert the JSoN to an object & get the start version
	$initialVersion = Switch ($feedback.initialSchemaVersion)
	{
		{ [string]::IsNullOrEmpty($psitem) } { 'empty' }
		default { "V$psitem" }
	}
	# prepare the phrase about the success of the migration operation
	$Success = if ($feedback.success) { 'A ' }
	else { 'An un' }
	# and the string that gives the number of warnings
	$Warnings = if ($feedback.warnings.count -eq 0) { 'no' }
	else { "$($feedback.warnings.count)" }
	# now prepare the Migration Description
	$MigrationDescription = 'unknown'; #the default
	$TheMigrationList = $feedback.migrations; # get the list of migrations
	if ($TheMigrationList -isnot [array]) #just one migration
	{
		$MigrationDescription = $TheMigrationList.description
	}
	elseif ($feedback.migrationsExecuted -eq 0) #none at all
	{
		$MigrationDescription = 'no action necessary'
	}
	else
	{
		#get the first and last migration description in the run
		$TheMigrationList | foreach -begin {
			$From = $null, $FromDescription = $null
		} {
			if ($From -eq $Null) { $From = $_.version; }
			if ($FromDescription -eq $Null) { $FromDescription = $_.Description };
			
			$MigrationDescription = "'$FromDescription' $(
				if ($_.Description -ne $FromDescription) { " to '$($_.Description)'" }
				else { '' })"
		}
	} # prepare the phrase that indicates the change in version
	if ($feedback.targetSchemaVersion -eq $null)
	{ $FromAndToVersions = "stayed at $initialVersion" }
	else { $FromAndToVersions = "from $initialVersion to V$($feedback.targetSchemaVersion)" }
	
	if ($feedback.totalMigrationTime -ne $null) #is there a toal time 
	{ $timespan = [TimeSpan]::FromMilliseconds($feedback.totalMigrationTime) }
	else
	{
		# we have to calculate it ourselves
		$Totaltime = $migration.migrations | foreach -begin { $executionTime = 0 }{
			$executionTime += $_.executionTime
		} -end {
			$executionTime
		};
		$timespan = [TimeSpan]::FromMilliseconds($Totaltime)
	}
	$HowLongItTook = switch ($timespan)
	{ { $psitem.minutes -gt 0 } {
			"$($psitem.Minutes) mins, $($psitem.Seconds) secs"
		}
		{ $psitem.Seconds -gt 0 }
		{
			"$($psitem.Seconds) seconds"
		}
		default { "$($psitem.Milliseconds) ms" }
	};
	#get the name of the server
	$OurURL = $env:FLYWAY_URL #contains the current database, port and server 
	$FlywayURLRegex = 'jdbc:(?<RDBMS>[\w]{1,20}):(//(?<server>[\w\\\-\.]{1,40})(?<port>:[\d]{1,4}|)|thin:@)((;.*databaseName=|/)(?<database>[\w]{1,20}))?'
	if ($OurURL -imatch $FlywayURLRegex) #This copes with having no port.
	{ $server = $matches['server']; } #whatever your default
	else { $server = 'LocalHost'; }
	#now we write the message (by default it is written to a text file)
	"$($success)successful '$($feedback.operation)' operation of $(
		$feedback.databaseType) host $server database '$(
		$feedback.database)' $FromAndToVersions ($MigrationDescription) $(
	) on $(get-date $feedback.timestamp -UFormat " %r %a %e %b %Y"
	) took around $HowLongItTook and had $warnings warnings">>$ENV:FP__NarrativeLog
}
