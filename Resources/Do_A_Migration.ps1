function Do_A_Migration
{
	[CmdletBinding()]
	param ($parameters)
	flyway migrate $parameters | Where { $_ -notlike '1 row updated*' } | foreach{
		if ($_ -like '*(SQL State: S0001 - Error Code: 0)*') # SQL Server print statement 
		{ Write-Verbose "$($_ -ireplace 'Warning: DB: (?<BodyOfMessage>.+?)\(SQL State: S0001 - Error Code: [50]0{0,5}\)', '${BodyOfMessage}')" }
		elseif ($_ -like 'WARNING*') # Some other Flyway warning
		{ write-warning ("$($_ -ireplace 'Warning: (?<BodyOfMessage>.*)', '${BodyOfMessage}')") }
		elseif ($_ -match '(?m:^)\||(?m:^)\+-') # result
		{ write-output $_ }
		else { write-verbose $_ }
	}
}