<#
	.SYNOPSIS
		By default, this finds CREATE, ALTER or DROP statements in SQL Code within Flyway migration files
	
	.DESCRIPTION
		This function gets the list of successful migration files and uses these in the correct order
		and searches each one for the strings specified by the Regex you provide. By default it 
		searches for 
	
	.PARAMETER FirstVersion
		The version to search from (defaults to $null meaning no lower limit
	
	.PARAMETER LastVersion
		The version to search to (defaults to $null meaning no lower limit
	
	.PARAMETER RegexToUse
		If you wish to do other regex  searches, then provide the correct
        regex. Defaults to finding CREATE, ALTER and DROP TABL statements
	
	.EXAMPLE
				PS C:\> Find-MigrationSQLCode -FirstVersion '1.1.6' 
	
#>
function Find-MigrationSQLCode
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false)]
		[version]$FirstVersion = $null,
		[Parameter(Mandatory = $false)]
		[version]$LastVersion = $null,
		[Parameter(Mandatory = $false)]
		[Regex]$RegexToUse = $null
	)
	$script:StartVersion = $null;
	if ($RegexToUse -eq $null)
	{
		$RegexToUse = [regex]@'
(?s)(?#Find create or alter for the table specified
)(?<Action>(CREATE|ALTER|DROP))\s{1,100}?(?<Object>(INDEX|TABLE|TRIGGER|VIEW|FUNCTION))\s{1,10}(?#
Ignore block comments, IF EXISTS  or inline comments
)(/\*.{1,1000}\*/|--[\w\s\d]{1,1000}|IF EXISTS){0,1}(?#
treat square brackets if present for schema
)\s{0,100}(?<Schema>(\[[\w\s\d]{1,1000}\]|[\w\d]{1,1000}))\.(?#
and for the table!
)(?<Name>(\[[\w\s\d]{1,1000}\]|[\w\d]{1,1000}))
'@
	}
	$Migrations = Flyway info -outputType=json | convertfrom-json
	if ($Migrations.error -ne $null)
	{
		#if getting the migration list was unsuccessful
		write-warning $Migrations.error.message
	}
	else
	{
		#if getting the migration list was successful
		$StartVersion = $null
		$ver = $migrations.schemaVersion;
		$db = $migrations.Database
		$Results = $migrations.migrations |
		where {
			![string]::IsNullOrEmpty($_.filepath) -and
			($_.type -ieq 'SQL') -and ($_.state -ieq 'Success')
		} | Where {
			($firstVersion -eq $Null -or $_.version -ge $firstVersion) -and
			($LastVersion -eq $null -or $_.version -le $lastVersion)
		} |
		foreach  {
			# read each file
			$filename = Split-Path $_.filepath -leaf;
			$fileVersion = $_.version;
			if ($StartVersion -eq $null) { $StartVersion = $fileVersion };
			[IO.File]::ReadAllText("$($_.filepath)") |
			foreach{
				$allmatches = $RegexToUse.Matches($_);
				if ($allmatches.count -gt 0)
				{
					$allmatches | Select-Object  Groups | Foreach{
						$group = $_;
						$ThisMatch = [ordered]@{ };
						$group.Groups | Where { $_.Name -match '\D' } | foreach  {
							$What = $_;
							$TheValue = $_.Value
							$TheValue = $TheValue.Replace('[', '').Replace(']', '')
							$ThisMatch.Add($_.Name, $TheValue)
						}
						$ThisMatch.Add('filename', $filename)
						$ThisMatch.Add('Version', $fileVersion)
						[pscustomobject]$ThisMatch
					} # for each match
				} #if there was a match
				
			} #end read file contents
		}
		$Results | Out-GridView -Title "Showing all Create/alter/drop actions between on  objects in scripts for $db (from $StartVersion to $ver)"
	}
}
