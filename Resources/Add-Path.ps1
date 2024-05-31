<#
	.SYNOPSIS
		Adds a path to the registry at any of the required levels	
	    thanks to 'mklement0' on Stack overflow  for the code.
     Original: https://stackoverflow.com/questions/69236623/adding-path-permanently-to-windows-using-powershell-doesnt-appear-to-work
	
	.DESCRIPTION
		The following Add-Path helper function:
		Adds (appends) a given, single directory path to the persistent user-level Path environment
		variable by default; use -Scope Machine to target the machine-level definition, which requires
		elevation (run as admin).
		
		If the directory is already present in the target variable, no action is taken.
		
		The relevant registry value is updated, which preserves its REG_EXPAND_SZ data type, based
		on the existing unexpanded value - that is, references to other environment variables are
		preserved as such (e.g., %SystemRoot%), and may also be used in the new entry being added.
		
		Triggers a WM_SETTINGCHANGE message broadcast to inform the Windows shell of the change.
		
		Also updates the current session's $env:Path variable value
	
	.PARAMETER LiteralPath
		A description of the LiteralPath parameter.
	
	.PARAMETER Scope
		This is the type of path. User', 'CurrentUser', 'Machine' or 'LocalMachine'  User is a good default
	
	.NOTES
		a user without administrator privileges can edit their own USER path variable by going to Settings and 
        searching for "Edit environment variables for your account" which will pull up all of your environment
        variables. Then just highlighting "Path" in the top user variables box, you can click edit and set the
        path
#>
function Add-Path
{
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$LiteralPath,
		[Parameter(Mandatory = $false)]
		[ValidateSet('User', 'CurrentUser', 'Machine', 'LocalMachine')]
		[string]$Scope = 'User'
	)
	Set-StrictMode -Version 1; $ErrorActionPreference = 'Stop'
	
	$isMachineLevel = $Scope -in 'Machine', 'LocalMachine'
	if ($isMachineLevel -and -not $($ErrorActionPreference = 'Continue'; net session 2>$null))
	{ throw "You must run AS ADMIN to update the machine-level Path environment variable." }
	$regPath = 'registry::' + (
		'HKEY_CURRENT_USER\Environment',
		'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment')[$isMachineLevel]
	
	# Note the use of the .GetValue() method to ensure that the *unexpanded* value is returned.
	$currDirs = (Get-Item -LiteralPath $regPath).GetValue('Path', '', 'DoNotExpandEnvironmentNames') -split ';' -ne ''
	# check if this is necessary
	if ($LiteralPath -in $currDirs)
	{
		Write-Verbose "Already present in the persistent $(
			('user', 'machine')[$isMachineLevel])-level Path: $LiteralPath"
		return
	}
	
	$newValue = ($currDirs + $LiteralPath) -join ';'
	
	# Update the registry.
	Set-ItemProperty -Type ExpandString -LiteralPath $regPath Path $newValue
	
	# Broadcast WM_SETTINGCHANGE to get the Windows shell to reload the
	# updated environment, via a dummy [Environment]::SetEnvironmentVariable() operation.
	$dummyName = [guid]::NewGuid().ToString()
	[Environment]::SetEnvironmentVariable($dummyName, 'foo', 'User')
	[Environment]::SetEnvironmentVariable($dummyName, [NullString]::value, 'User')
	
	# Finally, also update the current session's `$env:Path` definition.
	# Note: For simplicity, we always append to the in-process *composite* value,
	#        even though for a -Scope Machine update this isn't strictly the same.
	$env:Path = ($env:Path -replace ';$') + ';' + $LiteralPath
	
	Write-Verbose "`"$LiteralPath`" successfully appended to the persistent $(
		('user', 'machine')[$isMachineLevel])-level Path and also the current-process value."
}