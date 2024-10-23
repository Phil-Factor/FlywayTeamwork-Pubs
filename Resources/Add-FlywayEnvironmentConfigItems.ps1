<#
	.SYNOPSIS
		Adds a number of Environment vartiables that are read as parameters by Flyway.
        removes the existing Flyway parameters and placeholders. It also parses the URL
        to get the server and port details which you'll need for ODBC work and for some
        database utilities
	
	.DESCRIPTION
		This allows us to use Flyway without so much typing and keeps credentials and connection info out of the way
	
	.PARAMETER CredentialsPath
		This is the path to the .conf file in the user area holding the connection information
	
	.EXAMPLE
		 PS C:\> Add-FlywayEnvironmentConfigItems -CredentialsPath 'Value1'
#>
function Add-FlywayEnvironmentConfigItems
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[string]$CredentialsPath
	)
	
	Begin
	{
		
	}
	Process
	{
		@((gci env:FP__*),(gci env:Flyway_*)) | foreach {$_}|foreach{
         remove-item "env:$($_.Name)" }
        #remove the existing Flyway parameters and placeholders
		if (Test-Path $CredentialsPath -PathType leaf)
		{
			# Read each line from the config file
			Get-Content $CredentialsPath | ForEach-Object {
				# Skip empty lines and comments
				if (!($_ -match '^\s*$' -or $_ -match '^\s*#'))
				{
					# Split the line into key and value
					$key, $value = $_ -split '=', 2
					if ($key -eq 'flyway.url')
					{
						#Extract all useful info from the JDBC URL
						Write-Verbose "got $key"
						$OurURL = $value; #this FLYWAY_URL contains the current database, port and server so it is worth grabbing
						$FlywayURLRegex = 'jdbc:(?<RDBMS>[\w]{1,20}):(//(?<server>[\w\\\-\.]{1,40})(?<port>:[\d]{1,4}|)|thin:@)((;.*databaseName=|/)(?<database>[\w]{1,20}))?'
						$FlywaySimplerURLRegex = 'jdbc:(?<RDBMS>[\w]{1,20}):(?<database>[\w:\\/\.]{1,80})';
						if ($OurURL -imatch $FlywayURLRegex) #This copes with having no port.
						{
							#we can extract all the info we need
							$RDBMS = $matches['RDBMS']; $port = $matches['port'];
							$database = $matches['database']; $server = $matches['server'];
						}
						elseif ($OurURL -imatch $FlywaySimplerURLRegex)
						{
							#no server or port
							$RDBMS = $matches['RDBMS']; $database = $matches['database']; $server = 'LocalHost';
						}
						else #whatever your default
						{
							$RDBMS = 'sqlserver';
							$server = 'LocalHost';
							$Database = $env:FP__flyway_database__
						}
						#Now save the useful extra info
						@(@{ 'RDBMS' = $RDBMS }, @{ 'PORT' = $port },
							@{ 'DATABASE' = $database }, @{ 'SERVER' = $server }) | foreach{
							[System.Environment]::SetEnvironmentVariable(
								"FLYWAY_PLACEHOLDERS_$($_.Keys)", "$($_.Values)".Trim())
						}
					}
					#Now save each key value as an environment variable
					# Trim any leading/trailing spaces
					[System.Environment]::SetEnvironmentVariable(
						"FLYWAY_$(
							(($key.Trim() -replace 'flyway.', '') -replace 'placeholders.', 'PLACEHOLDERS_').toUpper()
						)", $Value.Trim())
					if ($Port -ne '') # we have to 
					{
						$ODBCServer = switch ($rdbms)
						{
							'sqlserver' { "$Server,$port" }
							{ $psitem -in ('Postgresql', 'MySQL', 'MariaDB') } { "$Server;Port=$port" }
							'DB2' { "$Server;Portnumber=$port" }
							
							default { "$($server):$port" }
						}
					}
					else { $ODBCServer = $Server }
					# Save the ODBC Connection
					[System.Environment]::SetEnvironmentVariable(
						"FLYWAY_PLACEHOLDERS_ODBCSERVER", $ODBCServer)
					
				}
			}
		}
		else
		{
			write-error "the path '$CredentialsPath' to the .conf file with the credentials was invalid!"
		}
	}
	End
	{
		
	}
}
