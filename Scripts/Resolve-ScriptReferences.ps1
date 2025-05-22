<#
	.SYNOPSIS
		Checks to see if any script files are  referenced in a script and if so do they contain
	
	.DESCRIPTION
		Checks a script file for all references to other script files and so on, taking care to
		never examine the same file more than once in a session
	
	.PARAMETER ScriptPath
		Array of paths to scripts that need to be checked
	
	.PARAMETER visited
		a hashtable that keeps a record of what has been checked (instaead of true and false will eventually have status
	
	.PARAMETER parent
		used in recursion to record where script was found
	
	.PARAMETER ExtensionsWanted
		the extensions we can check
	
	.PARAMETER TheInvocationPatterns
		What represents an invocation for each type of script
	
    .usage

        # Start with all top-level scripts
        cd "$env:FlywayWorkPath\pubs\branches\develop"
        ."$env:FlywayWorkPath\scripts\Resolve-ScriptReferences.ps1"
        #get all the script files within the configuration 
        $currentCredentialsPath = '-configFiles=C:\Users\andre\Pubs_SQLServer_develop_Philf01.toml'
        $TheReport= flyway $currentCredentialsPath info -X 
        $VisibleScripts= ."$env:FlywayWorkPath\scripts\GetFlywayFilesAndTypes.ps1" $TheReport
        $Scripts= $VisibleScripts|where {([System.IO.Path]::GetExtension($_.Filename).ToLowerInvariant().trim()) -in @(
        ".ps1", ".bat", ".cmd", ".sh", ".bash", ".py") }|select -ExpandProperty Filename
        $VerbosePreference='continue'
        $visited=@{}
        Resolve-ScriptReferences -ScriptPath $Scripts -Visited $visited
#>  
#>
function Resolve-ScriptReferences
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[string[]]$ScriptPath,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[hashtable]$visited,
		$parent = '',
		$ExtensionsWanted = @(".ps1", ".bat", ".cmd", ".sh", ".bash", ".py"),
		$TheInvocationPatterns = @{
			'.ps1' = '(?<Path>(\\|\w\:|\.){1,2}(\w|\s|\\|/){2,}?\.ps1)'
			'.bat' = '\bcall\s+(?<Path>[^\s&|><"]+\.bat)'
			'.cmd' = '\bcall\s+(?<Path>[^\s&|><"]+\.cmd)'
			'.sh' = '\b(?:sh|bash)\s+(?<Path>[^\s&|><"]+\.sh)'
			'.py' = '\bpython(?:3)?\s+(?<Path>[^\s&|><"]+\.py)'
		}
	)
	
	$ScriptPath | where { $_ -ne $null } | Foreach {
		$EachScriptPath = $_;
		$WeShouldSearch = $true; #assume the best
		#have we checked this file already? If so, quit
		if ($visited.ContainsKey($EachScriptPath))
		{
			if ($visited.$EachScriptPath)
			{
				write-verbose "Already checked $EachScriptPath"
				$WeShouldSearch = $false;
			}
		}
		#Add this file to the 'checked' list
		$visited.$EachScriptPath = $true
		#Does this file actually exist?
		if (-not (Test-Path $EachScriptPath))
		{
			$where = if ($parent -eq '') { 'at all' }
			else { "in $parent" }
			write-verbose "$EachScriptPath doesn't exist $where"; return
			$WeShouldSearch = $false;
		}
		#Is this one of the file types that we want to check?
		$ext = [System.IO.Path]::GetExtension($EachScriptPath).ToLowerInvariant().trim()
		if ($ext -notin $ExtensionsWanted)
		{
			write-verbose "'$ext' isn't a supported flyway script- skipping";
			$WeShouldSearch = $false;
		}
		if ($WeShouldSearch) #now check the contents for references to other scripts
		{
			$where = if ($parent -eq '') { 'listed' }
			else { "found in $parent" }
			write-verbose " now actually checking $EachScriptPath reference $where"
			$lines = Get-Content $EachScriptPath -Raw
			$pattern = $TheinvocationPatterns.GetEnumerator() | where { $_.name -eq $ext }
			$regex = [regex]($pattern.Value)
			$References = $regex.matches($lines).Groups |
			where { $_.Success -eq $true -and $_.Name -eq 'path' } |
			sort-object -property Value -Unique | select -ExpandProperty Value;
			if ($References.Count -gt 0)
			{ 
            write-verbose "found references to  $($References|convertTo-JSON -Compress) in $parent" 
            Resolve-ScriptReferences -ScriptPath $references -visited $visited -parent $EachScriptPath  }
		}
	}
}