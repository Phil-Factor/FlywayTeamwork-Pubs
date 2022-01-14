. '.\preliminary.ps1'

#get a JSON report of the history. 
$report = Flyway info -teams -outputType=json "-password=$($DBDetails.pwd)"| convertFrom-json
#
if ($report.error -ne $null) #if an error was reported by Flyway
{ #if an error (usually bad parameters) error out.
	$report.error | foreach { Write-error "$($_.errorCode): $($_.message)" }
} 
if ($report.allSchemasEmpty) #if it is an empty database
{ write-verbose "all schemas are empty. No version has been created here" }
else
{ <# we first create the PlantUML Gantt header as a single string #>

$PUML=@"
@startgantt
skinparam LegendBorderRoundCorner 2
skinparam LegendBorderThickness 1
skinparam LegendBorderColor silver
skinparam LegendBackgroundColor white
skinparam LegendFontSize 11
printscale weekly
saturday are closed
sunday are closed
title Gantt Chart for version $($Report.schemaVersion)
legend top left
  Database: $($Report.database)
  Server: $server
  RDBMS: $rdbms
  Flyway Version: $($Report.flywayVersion)
endlegend

"@

<# now we add to the header each line that represents a line in the gantt chart. To make
things more interesting, we have to terminate the period of the previous line if there is one
at the same time so that the period for the next version starts when the previous one ends #>
$puml+= $Report.migrations| where {$_.version -ne '' -and $_.state -in @('Success','Future')}|
 group version | Sort-Object -Property @{Expression = {[version]$_.version}; Descending = $true}|
%{$theGroup=$_;
[PSCustomObject]@{
     version = $_.name;
    installedBy=$_.Group.installedBy|select -First 1; 
    description=$_.Group.description|select -First 1; 
    installedOnUTC = $_.Group.installedOnUTC|sort-object|select -Last 1 
}}|sort-object -Property installedOnUTC|
foreach -Begin {$oldmigration=$null} -Process {
    #first, do a 'Project starts, taking it back to the start of the initial week.
    $migration=$_
    if ($oldmigration -eq $null) {
    $StartDate=[datetime]$migration.installedOnUTC
    "Project starts $($StartDate.AddDays(1 - $StartDate.DayOfWeek.value__).ToString("yyyy-MM-dd"))
"}
    "[$($migration.version) - $($migration.Description)] on {$($migration.installedBy)} starts $($migration.installedOnUTC.Remove(10))
"
    if ($oldmigration -ne $null)
        {"[$($oldmigration.version) - $($oldmigration.Description)] ends $($oldmigration.installedOnUTC.Remove(10))
"}
    $oldmigration=$_
    } -End {'@endgantt'} #we end the chart with this
# we create a filename to write the result into, and the same filename for the graphic
$filename="$($env:tmp)\$($Report.database)-v$($Report.schemaVersion)--$(Get-random -maximum 99).puml"
[IO.File]::WriteAllLines($filename, $puml) # It must be UTF8!!!
<# I've chosen to output a svg image because it looks better in a website but you can use
a number of different report types #>
plantumlc -tsvg $filename
}

