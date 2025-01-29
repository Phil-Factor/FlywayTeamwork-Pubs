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
        if (!(test-path $SecretsPath -PathType Leaf)) 
            {$SecretsPath="$env:USERPROFILe\$SecretsPath"}

		$Info=Flyway ($SecretsPath | get-conf) '-outputType=json' info | convertFrom-json #check that you've got a connection
		$ExecutedWell = $?
		if ($ExecutedWell)
		{
			Flyway ($SecretsPath | get-conf) clean #clean the existing 
            if (Test-Path -Path .\versions -PathType Container)
                {del .\versions\*.* -Recurse -ErrorAction Ignore} #remove any reports for all the versions
		}
		else
		{
			write-verbose "Could not connect properly, using the $($_.Name) database"
		}
        
        if ($PostMigrationTasks -ne $null)
		#we would only need to do this for every migration file if using Flyway Community
				{ . '.\preliminary.ps1'; $OurDBDetails=$DBDetails}
        
      <# now we are going to do each version in turn so that we are sure of 
      getting a report and list of changes for each version #>
        $Info.migrations | where { $_.category -eq 'Versioned' -and
			(!($ThereIsAStartVersionForMigrations -and $_.version -lt $StartVersion) -and
				!($ThereIsAnEndVersionForMigrations -and $_.version -gt $EndVersion))
		} |
		Sort-Object -Property @{ Expression = "version"; Descending = $false } | foreach{
			if ($ExecutedWell)
			{
				# Now we have a list of versions, we do each single migration in turn
				Write-Verbose "migrating $($Info.database) database to $($_.version)"
				Flyway ($SecretsPath | get-conf) migrate "-target=$($_.version)" | Where { $_ -notlike '1 row updated*' } | foreach{
					if ($_ -like '*(SQL State: S0001 - Error Code: 0)*') # SQL Server print statement 
					{ Write-Verbose "$($_ -ireplace 'Warning: DB: (?<BodyOfMessage>.+?)\(SQL State: S0001 - Error Code: [50]0{0,5}\)', '${BodyOfMessage}')" }
					elseif (($_ -like 'WARNING*') -or ($_ -imatch '\A[*\-\s]{0,10}?error')) # Some other Flyway warning
					{ write-warning ("$($_ -ireplace 'Warning: (?<BodyOfMessage>.*)', '${BodyOfMessage}')") }
					elseif ($_ -match '(?m:^)\||(?m:^)\+-') # result
					{ write-output $_ }
					else { write-verbose $_ }
				};
				$ExecutedWell = $?
				if ($ExecutedWell -and ($PostMigrationTasks -ne $null))
				#we would only need to do this for every migration file if using Flyway Community
				{
				    . '.\preliminary.ps1'
                   	Process-FlywayTasks $OurDBDetails $PostMigrationTasks
				}
			}
		}
	}
    End
	{
		
	}
}
