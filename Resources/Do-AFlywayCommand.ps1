<#
	.SYNOPSIS
		Executes a Flyway command using Flyway CLI, with the parameters you choose
		and with an optional path to a secrets file. It sends warnings to the warning
		channel, chatter to the -verbose channel and it sends errors either to the
		screen or to a function (e.g. webhook or logging) that you specify.
	
	.DESCRIPTION
		This function is used where you need to differentiate the noise (verbose)
		from the warnings and errors for long migrations.
		It is also handy if you need to store configurations in secure directories,
		when you get unexpectedly asked for passwords.
		It is designed to allow you to save the error message, add them to a log or
		send them to a notification system
	
	.PARAMETER Parameters
		An options array of parameters that specify how Flyway should do the migration.
	
	.PARAMETER Secrets
		an optional path to a 'secrets' .conf file. Note that this routine does not
		allow Flyway to interrogate the user to provide a password. If it does so,
		it is provided with a dummy password
	
	.PARAMETER ErrorNotifier
		an optional powershell scriptblock that alerts your notification system of
		an error
	
	.PARAMETER name
		The name of the action being done, for reporting purposes
	
	.EXAMPLE
		$Result= Do-AFlywayCommand @("migrate", "-target=1.1.4") $Secrets -Verbose
	
	.EXAMPLE
		get info on current project in the working directory, taking the connection info and
		credentials from the flyway.conf
		'info'| Do-AFlywayCommand -verbose
	
	.EXAMPLE
		get info on current project in the working directory, taking the connection info and
		credentials from the specified file in the user area
		$Secrets='MySecrets.conf'
		
		'info'| Do-AFlywayCommand -Secrets $Secrets
	
	.EXAMPLE
		get info followed by a migrate  on current project in the working directory,
		taking the connection info and credentials from the specified file in the user
		area
		
		'info','migrate'|foreach {
		Do-AFlywayCommand -parameters $_ -Secrets $Secrets -name 'MySQL Pubs Main branch' -Verbose
		}
	
	.EXAMPLE
		get info followed by running a clean, and finally doing a migrate  on two differet
		projects; taking the connection info and credentials from the specified file in the user
		area
		@(
		@{'Directory'='<MyPathTo>\pubs';
		'secrets'='Pubs_SQLServer_Main_<MyServer>.conf';
		'Name'='Pubs on the router'}
		@{'Directory'='<MyPathTo>\pubs\Branches\develop';
		'secrets'='Pubs_SQLServer_Develop_<MyServer>.conf';
		'Name'='Pubs Dev branch on the router'}
		)| foreach {
		cd $_.Directory;
		$Secrets=$_.Secrets
		$name=$_.Name
		@('info','clean','migrate')| foreach{
		Do-AFlywayCommand -parameters $_ -Secrets $Secrets -Name $Name -Verbose
		}
		}
	
	.EXAMPLE
		Do-AFlywayCommand   @("-url=AnUnusableURL") '' -ErrorNotifier $OurErrorNotifier
	
	.Example
		Do-AFlywayCommand -ErrorNotifier { param($TheErrorMessage)
		$FlywayChannel='https://OurWebhook/webapi/entry.cgi?api=MyApp'
		Send-SynologyChatMessage $FlywayChannel "In $pwd $TheErrorMessage"
		}
	
	.NOTES
		Additional information about the function.
#>
function Do-AFlywayCommand
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   HelpMessage = 'The parameters that specify what you wish  Flyway to do ')]
		[array]$parameters = @(),
		[Parameter(Mandatory = $false,
				   HelpMessage = 'The path to an extra .conf file. it looks in the user area is you just provide a filename')]
		[String]$Secrets = '',
		[Parameter(Mandatory = $false,
				   HelpMessage = 'The scriptblock for handling or reporting errors ')]
		[scriptblock]$ErrorNotifier = { },
		[Parameter(Mandatory = $false,
				   HelpMessage = 'The name of the description of the  flyway action  being done')]
		[String]$Name = 'current database',
		[Parameter(Mandatory = $false,
				   HelpMessage = 'Do we announce the work to be done?')]
		[String]$quiet = $False)
	
	$ExtraParameters = { $parameters }.Invoke() # get any extra parameters
	if ('outputype=json' -in $ExtraParameters) { $Quiet = $true };
	if (-not $quiet) { write-verbose "now doing flyway command $Parameters with $Name" }
	if (!([string]::IsNullOrEmpty($Secrets))) # if you've specified an extra .conf file 
	{
		if (-not (Test-Path $Secrets))
		{ $Secrets = "$($env:USERPROFILE)\$Secrets" }
		get-content $Secrets | foreach {
			$_.Split("`n") |
			where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
			foreach{ $Extraparameters.Add(($_ -replace '\Aflyway\.', '-')) }
		} #pass these config lines as parameters
		$Extraparameters += "-placeholders.ParameterConfigItem=$Secrets";
	}
	#create a temporary file with a random name to catch any errors
	$ErrorCatcher = "$env:TEMP\MyErrorFile$(Get-Random -Minimum 1 -Maximum 900).txt"
	try
	{
		echo "dummyPassword" | flyway $Extraparameters 2>"$ErrorCatcher" |
		Where { $_ -notlike '1 row *' } <#the oracle noise #> | foreach{
			if ($_ -match 'Warning: DB: (?<BodyOfMessage>.+?)\(SQL State: S000[1-5] - Error Code: \d{1,10}\)') # SQL Server print statement noise
            <# we can put interesting chatter in the verbose stream and optionally read it #>
			{ Write-Verbose "$($_ -ireplace 'Warning: DB: (?<BodyOfMessage>.+?)\(SQL State: S000[1-5] - Error Code: \d{1,10}\)', '${BodyOfMessage}')" }
			elseif ($_ -like 'WARNING*') # Some other Flyway warning
			{ write-warning ("$($_ -ireplace 'Warning: (?<BodyOfMessage>.*)', '${BodyOfMessage}')") }
			elseif ($_ -match '(?m:^)\||(?m:^)\+-') # result of a SQL Statement 
			{ write-output $_ }
			else { write-verbose $_ }
		}
	}
	catch
	{
    @"
 $($error[0].Exception.Message) $($error[0].InvocationInfo.PositionMessage)
"@ >$ErrorCatcher # make sure that we catch a terminating error
	}
	$TheErrorMessage = '';
	if (Test-Path $ErrorCatcher -PathType Leaf) #have we anything in the error catcher file
	{ $TheErrorMessage = get-content $ErrorCatcher -Raw };
	if (![string]::IsNullOrEmpty($TheErrorMessage)) #if there really is something
	{
		&$ErrorNotifier  "In $pwd $Name $TheErrorMessage" #send it to our notification system
		throw "In $pwd $name $TheErrorMessage" #generally you'll want to halt execution there
	};
	del $ErrorCatcher
}