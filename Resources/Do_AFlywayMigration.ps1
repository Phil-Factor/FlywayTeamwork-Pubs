<#
	.SYNOPSIS
		Executes a Flyway migration using Flyway CLI, with the parameters you choose and with an optional path to a secrets file 
	
	.DESCRIPTION
		This function is used where you need to differentiate the noise (verbose) freom the warnings and errors for long migrations. It is also handy if you need to store configurations in secure directories.
	
	.PARAMETER Parameters
		An optional  options Array of parameters that specify how Flyway should do the migration.
	
	.PARAMETER Secrets
		an optional path to a 'secrets' file
	
	.EXAMPLE
		$Result= Do-AFlywayMigration @("-target=1.1.4") $Secrets -Verbose
	#>
function Do-AFlywayMigration
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $False,
				   ValueFromPipeline = $true,
				   HelpMessage = 'The parameters that specify what you wish  Flyway to do ')]
		[array]$parameters = $(),
		[Parameter(Mandatory = $false)]
		[String]$Secrets = ''
	)
	$ExtraParameters = @();
	if ($parameters.Count>0)
		{ $ExtraParameters = { $parameters }.Invoke() }
	if (!([string]::IsNullOrEmpty($Secrets)))
	{
		get-content $Secrets | foreach {
			$_.Split("`n") |
			where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
			foreach{ $Extraparameters.Add(($_ -replace '\Aflyway\.', '-')) }
		}
		$Extraparameters += "-placeholders.ParameterConfigItem=$Secrets";
	}
	flyway migrate $Extraparameters | Where { $_ -notlike '1 row updated*' } | foreach{
		if ($_ -like '*(SQL State: S0001 - Error Code: 0)*') # SQL Server print statement 
		{ Write-Verbose "$($_ -ireplace 'Warning: DB: (?<BodyOfMessage>.+?)\(SQL State: S0001 - Error Code: [50]0{0,5}\)', '${BodyOfMessage}')" }
		elseif ($_ -like 'WARNING*') # Some other Flyway warning
		{ write-warning ("$($_ -ireplace 'Warning: (?<BodyOfMessage>.*)', '${BodyOfMessage}')") }
		elseif ($_ -match '(?m:^)\||(?m:^)\+-') # result
		{ write-output $_ }
		else { write-verbose $_ }
	}
}

