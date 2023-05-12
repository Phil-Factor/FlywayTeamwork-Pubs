<#
	.SYNOPSIS
		Compare two DACPACs and create a change script from them using SQLPackage that
		Creates a Transact-SQL incremental update script that updates the schema of a 
        target DACPAC to match the schema of a source DACPAC.
	
	.DESCRIPTION
		This compares two dacpacs and creates a schange script from them It is a thin shell over SQLPackage.
	
	.PARAMETER SourceDacPac
		The path to the source Dacpac
	
	.PARAMETER TargetDacPac
		The path to the The target DACPAC
	
	.PARAMETER OutputFilePath
		The path to the change script
	
	.PARAMETER OverWrite
		Do we overwrite the generated script if it already exists?
	
	.EXAMPLE
		PS C:\> Export-ChangeScriptFromDACPACS -SourceDacPac $path1 -TargetDacPac $path2 -OutputFilePath $path3
	
	.NOTES
		This is designed to support various specific script-generation tasks
#>
function Export-ChangeScriptFromDACPACS
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$SourceDacPac,
		[Parameter(Mandatory = $true)]
		$TargetDacPac,
		[Parameter(Mandatory = $true)]
		$OutputFilePath,
		[bool]$OverWrite = $false,
        $DatabaseName ='Database'
	)
	
<# The file is processed to remove  any CREATE SCHEMA statements, and any SQLCMD parameter
 definitions #>
	$problems = @(); # well, not yet
	$feedback = @()
	$WeCanDoIt = $true # until proven otherwise
	# the alias must be set to the path of your installed version of SQLpackage
	$command = get-command sqlpackage -ErrorAction Ignore
	if ($command -eq $null)
	{
		if ($SQLPackageAlias -ne $null)
		{ Set-Alias sqlpackage   $SQLPackageAlias }
		else
		{ $problems += 'You must have provided a path to $SQLPackage.exe in the ToolLocations.ps1 file in the resources folder' }
	}
	
	@($SourceDacPac, $TargetDacPac) | foreach {
		if (-not (Test-Path "$_")) { $WeCanDoIt = $false; $Feedback += "cannot find the dacpac file $_ " }
	}
	if ($OverWrite -eq $false -and (Test-Path "$OutputFilePath")) { $WeCanDoIt = $false; $Feedback += "Migration file $OutputFilePath already exists" }
	if ($WeCanDoIt) #if it has passed the tests
	{
		$ScriptArguments = @(
    <# Creates a Transact-SQL incremental update script that updates the schema of a 
       target to match the schema of a source. #>
			"/Action:Script", <#
         Specifies a source file to be used as the source of action instead of a
         database. For the Publish and Script actions, SourceFile may be a .dacpac
         file or a schema compare .scmp file. If this parameter is used, no other
         source parameter is valid. #>
			"/SourceFile:$SourceDACPAC",
         <#Specifies a source file to be used as the source of action instead of a
         database. For the Publish and Script actions, SourceFile may be a .dacpac
         file or a schema compare .scmp file. If this parameter is used, no other
         source parameter is valid. #>
			"/OutputPath:$OutputFilePath", <#
         Specifies the file path where the output files are generated. (short form
         /op)#>
			"/OverwriteFiles:$OverWrite", <#
         Specifies if SqlPackage.exe should overwrite existing files. Specifying
         false causes SqlPackage.exe to abort action if an existing file is
         encountered. Default value is True. (short form /of)"/TargetUser:<string>",<#
         For SQL Server Auth scenarios, defines the SQL Server user to use to
         access the target database. (short form /tu) #>
			"/TargetDatabaseName:$DatabaseName",
			"/TargetFile:$TargetDacPac",    <# Specifies a target file (that is, a 
			.dacpac file) to be used as the target of action instead of a database.
			If this parameter is used, no other target parameter shall be valid. 
			This parameter shall be invalid for actions that only support database
			targets.#>
			'/p:CommentOutSetVarDeclarations=true'
			"/p:CreateNewDatabase=False"
		)
		$console = sqlpackage $ScriptArguments
		$Feedback += "$console"
		if ($?)
		{
            $TargetVersion=split-path -Path $TargetDacPac -Leaf
			$SourceVersion=split-path -Path $SourceDacPac -Leaf
            $feedback += "Written $prefix migration for $($param1.Project) from $TargetVersion to $SourceVersion" 
		}
		else # if no errors then simple message, otherwise....
		{
			#report a problem and send back the args for diagnosis (hint, only for script development)
			$Arguments = '';
			$Arguments += $ScriptArguments | foreach{ $_ }
			$Problems += "Script generation Went badly. (code $LASTEXITCODE) with parameters $Arguments"
		}
		if ($problems.count -eq 0)
		{
			# now convert all the SQLcmd output and other things not allowed
			$script = [IO.File]::ReadAllText($OutputFilePath)
			
			@(
				@(@'
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END
'@, ''),
				@(@'
GO
USE [$(DatabaseName)];
'@, '')
			) | foreach {
				$Script = $script.replace($_[0], $_[1])
			}
			# remove code to create schemas This has to be done by a regex
			$Script = $Script -creplace ':setvar.*|:on error exit', ''
			$Script = $Script -creplace '(\n|\r)+\s(\n|\r)+', "`n"
			$Script = $Script -creplace '(?s)PRINT N''Creating Schema \[.{1,256}?\]...'';\s+?GO\s+?CREATE SCHEMA \[.{1,256}?\].+?GO', ''
			# and write the script back
			[System.IO.File]::WriteAllLines($OutputFilePath, $script);
			$WriteLocations = "$OutputFilePath";
		}
	}	
    @($problems, $Feedback, $WriteLocations)
}
