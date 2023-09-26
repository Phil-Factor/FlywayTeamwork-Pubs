<#
	.SYNOPSIS
		This will do every migration file  in the  migrations folders specified for the project
	
	.DESCRIPTION
		A detailed description of the Redo-EveryFlywayMigrationSingly function.
	
	.PARAMETER ProjectPath
		The path to the project folder.
	
	.PARAMETER StartVersion
		optional string specifing where we start singlestepping through the migrations
	
	.PARAMETER EndVersion
		optional string specifing where we end singlestepping through the migrations
	
	.PARAMETER AfterMigration
		Specify an array list of tasks to parform after a migration. Only necessary for Flyway Community
	
	.EXAMPLE
				PS C:\> Redo-EveryFlywayMigrationSingly -ProjectPath 'Value1' -StartVersion 'Value2'
	
	.NOTES
		Additional information about the function.
#>
function Redo-EveryFlywayMigrationSingly
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   HelpMessage = 'The path to the project folder.')]
		[string]$ProjectLocation,
		[string]$SecretsPath,
		[string]$StartVersion,
		[string]$EndVersion,
		[array]$PostMigrationTasks,
		[string]$Name = 'current'
	)
	
	Begin
	{
		
	}
	Process
	{
		if (!([string]::IsNullOrEmpty($StartVersion)))
		{
			$ThereIsAStartVersionForMigrations = $true;
			$From = " from $StartVersion"
		}
		else
		{
			$ThereIsAStartVersionForMigrations = $False;
			$From = ''
		}
		if (!([string]::IsNullOrEmpty($EndVersion)))
		{
			$ThereIsAnEndVersionForMigrations = $true;
			$To = " to $EndVersion"
		}
		else
		{
			$To = '';
			$ThereIsAnEndVersionForMigrations = $False;
		}
		write-verbose "doing the $Name database$From$To"
		$ExecutedWell = $true; #so we can abandon the work if there was an error
		cd $ProjectLocation #make the correct directory the project directory
		#Make the directory your current working directory
		#define where your Flyway config secrets should be 
		Flyway ($SecretsPath | get-conf) info #check that you've got a connection
		$ExecutedWell = $?
		if ($ExecutedWell)
		{
			Flyway ($SecretsPath | get-conf) clean #clean the existing 
			del .\versions\*.* -Recurse #remove any reports for all the versions
		}
		else
		{
			write-verbose "Could not connect properly, using the $($_.Name) database"
		}
      <# now we are going to do each version in turn so that we are sure of 
      getting a report and list of changes for each version #>
      $Configuration= Get-FlywayConfContent $SecretsPath
        $Configuration.'flyway.locations'-split ','|
            foreach{$_ -replace 'filesystem:', ''} |
		foreach{Dir "$_\V*.sql" -Recurse} |
		foreach{
			[pscustomobject]@{
				'file' = $_.Name;
				'version' = [version]($_.Name -ireplace '(?m:^)V(?<Version>.*)__.*', '${Version}')
			}
		} |
        <#where {
			(!($StartVersion -ne $null -and $_.version -lt $StartVersion) -and
				!($EndVersion -ne $null -and $_.version -gt $EndVersion))
		} #>
		
		where {
			(!($ThereIsAStartVersionForMigrations -and $_.version -lt $StartVersion) -and
				!($ThereIsAnEndVersionForMigrations -and $_.version -gt $EndVersion))
		} |
		Sort-Object -Property @{ Expression = "version"; Descending = $false } | foreach{
			if ($ExecutedWell)
			{
				# Now we have a list of versions, we do each single migration in turn
				Write-Verbose "migrating $Name database to $($_.version)"
				Flyway ($SecretsPath | get-conf) migrate "-target=$($_.version)" | Where { $_ -notlike '1 row updated*' } | foreach{
					if ($_ -like '*(SQL State: S0001 - Error Code: 0)*') # SQL Server print statement 
					{ Write-Verbose "$($_ -ireplace 'Warning: DB: (?<BodyOfMessage>.+?)\(SQL State: S0001 - Error Code: [50]0{0,5}\)', '${BodyOfMessage}')" }
					elseif ($_ -like 'WARNING*') # Some other Flyway warning
					{ write-warning ("$($_ -ireplace 'Warning: (?<BodyOfMessage>.*)', '${BodyOfMessage}')") }
					elseif ($_ -match '(?m:^)\||(?m:^)\+-') # result
					{ write-output $_ }
					else { write-verbose $_ }
				};
				$ExecutedWell = $?
				if ($ExecutedWell -and ($PostMigrationTasks -ne $null))
				#we would only need to do this for every migration file if using Flyway Community
				{
					Process-FlywayTasks $DBDetails $PostMigrationTasks
				}
			}
		}
	}
	End
	{
		
	}
}
