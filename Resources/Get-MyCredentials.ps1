<#
	.SYNOPSIS
		returns configuration information for Flyway consisting of userID and 
		password from an encrypted file in the user area.
	
	.DESCRIPTION
		This PowerShell routine will save the UserID and Password in an encrypted 
		form on the first time you run it for that particular server and UserId. 
		On any subsequent calls with the same parameter, it will provide it. 
		If your password changes, you just delete the existing file and ask again. 
		It accesses the same passwords as Flyway Teamwork framework, so you can use it 
		when you don't need the full 'works'.
	
	.PARAMETER Server
		A description of the Server parameter.
	
	.PARAMETER UID
		the userID you wish to use
	
	.PARAMETER RDBMS
		the brand of relational database (from the jdbc URL)
	
	.NOTES
		Additional information about the function.
#>
function Get-MyCredentials
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Server,
		$UID,
		$RDBMS
	)
	
	try
	{
		$escapedServer = ($Server.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'
		# now we get the password if necessary
		
		if (!([string]::IsNullOrEmpty($UID))) #then it is using SQL Server Credentials
		{
			# we see if we've got these stored already. If specifying RDBMS, then use that.
			if ([string]::IsNullOrEmpty($RDBMS))
			{ $SqlEncryptedPasswordFile = "$env:USERPROFILE\$($uid)-$($escapedServer).xml" }
			else
			{ $SqlEncryptedPasswordFile = "$env:USERPROFILE\$($uid)-$($escapedServer)-$($RDBMS).xml" }
			# test to see if we know about the password in a secure string stored in the user area
			if (Test-Path -path $SqlEncryptedPasswordFile -PathType leaf)
			{
				#has already got this set for this login so fetch it
				$SqlCredentials = Import-CliXml $SqlEncryptedPasswordFile
			}
			else #then we have to ask the user for it (once only)
			{
				# hasn't got this set for this login
				$SqlCredentials = get-credential -Credential $uid
				# Save in the user area 
				$SqlCredentials | Export-CliXml -Path $SqlEncryptedPasswordFile
        <# Export-Clixml only exports encrypted credentials on Windows.
        otherwise it just offers some obfuscation but does not provide encryption. #>
			}
			$UID = $SqlCredentials.UserName;
			$MyPassword = $SqlCredentials.GetNetworkCredential().password
			"flyway.user=$UID`nflyway.password=$MyPassword"
		}
		else
		{ '' }
	}
	Catch { write-error "sadly we couldn't get $SqlEncryptedPasswordFile" }
}

