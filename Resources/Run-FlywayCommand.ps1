<#
	.SYNOPSIS
		runs the Flyway Commands you specify based on the config in the project directory that you specify, using the connection and credentials that you specify
	
	.DESCRIPTION
		This is a way of running a whole lot of different Flyway projects at once
	
	.PARAMETER TheProjects
		A list of the projects - an array of hashtables
	
	.PARAMETER commands
		A list of the commands you wish to run.

	.EXAMPLE
    Run-FlywayCommand  @(@{
		'Comment' = 'Northwind Main for Oracle';
		'secrets' = "Northwind_oracle_Main_RGClone.conf";
		'Directory' = "$env:FlywayWorkPath\NorthwindOracle"
	}
) @('clean','migrate')	
#>
function Run-FlywayCommand
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$TheProjects,
		[Parameter(Mandatory = $false)]
		$commands = @('clean', 'migrate')
	)
	$TheProjects | foreach {
		write-verbose "running $($_.Comment) in  $($_.Directory)";
		cd $_.Directory;
		$Secrets = $_.Secrets;
		$Extraparameters = @();
		if (-not (Test-Path $Secrets))
		{ $Secrets = "$($env:USERPROFILE)\$Secrets" }
		get-content $Secrets | foreach {
			$_.Split("`n") |
			where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
			foreach{ $Extraparameters += (($_ -replace '\Aflyway\.', '-')) }
		} #pass these config lines as parameters
		$Extraparameters += "-placeholders.ParameterConfigItem=$Secrets";
		Try
		{
			$commands | foreach{
				flyway $Extraparameters $_ | where {
					$_ -notin @('Table altered.', '1 row created.')
				}
			}
		}
		catch
		{
			$Extraparameters
		}
		if (!($?)) { Write-output "$($Extraparameters -join ' ')" }
	}
}

