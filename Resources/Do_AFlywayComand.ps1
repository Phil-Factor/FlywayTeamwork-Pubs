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
	
	.EXAMPLE
		$Result= Do-AFlywayCommand @("migrate", "-target=1.1.4") $Secrets -Verbose

    .EXAMPLE
		

    .EXAMPLE
        Do-AFlywayCommand   @("-url=AnUnusableURL") '' -ErrorNotifier $OurErrorNotifier

    .Example 
        Do-AFlywayCommand -ErrorNotifier { param($TheErrorMessage)
            $FlywayChannel='https://OurWebhook/webapi/entry.cgi?api=MyApp'
            Send-SynologyChatMessage $FlywayChannel "In $pwd $TheErrorMessage"
        }

#>
function Do-AFlywayCommand
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $False,
				   ValueFromPipeline = $true,
				   HelpMessage = 'The parameters that specify what you wish  Flyway to do ')]
		[array]$parameters = @(),
		[Parameter(Mandatory = $false)]
		[String]$Secrets = '',
		[Parameter(Mandatory = $false,
				   HelpMessage = 'The scriptblock for hamdling errors ')]
		[scriptblock]$ErrorNotifier = { },
        [Parameter(Mandatory = $false,
                   HelpMessage = 'The name of the action ') ]
		[String]$Name= 'current database'
	)
	write-verbose "now doing flyway command with $Name"
	$ExtraParameters = { $parameters }.Invoke() # get any extra parameters
	if (!([string]::IsNullOrEmpty($Secrets))) # if you've specified an extra .conf file 
	{
       if (-not (Test-Path $Secrets))
            { $Secrets="$($env:USERPROFILE)\$Secrets" }
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
