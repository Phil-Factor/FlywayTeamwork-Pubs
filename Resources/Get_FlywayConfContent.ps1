<#
$Env:FLYWAY_PASSWORD  = 'password'                                                           
$Env:FLYWAY_URL  = 'jdbc:sqlserver://philf01;databaseName=PubsMain;encrypt=true;trustServerCertificate=true;'
$Env:FLYWAY_USER  = 'PhilFactor'                                                              
$Env:FP__Branch__  =  'Main'                                                                    
$Env:FP__canDoStringAgg__  = 'true'                                                                    
$Env:FP__DSN__  = 'PubsDSN'                                                                 
$Env:FP__flyway_database__  = 'PubsMain'                                                                
$Env:FP__flyway_defaultSchema__  = 'dbo'                                                                     
$Env:FP__flyway_environment__  = 'main'                                                                    
$Env:FP__flyway_filename__  = 'afterInfo__Env.ps1'                                                      
$Env:FP__flyway_table__  = 'flyway_schema_history'                                                   
$Env:FP__flyway_timestamp__  = '2025-02-06 14:16:10'                                                     
$Env:FP__flyway_user__  = 'PhilFactor'                                                              
$Env:FP__flyway_workingDirectory__  = 'S:\work\Github\FlywayTeamwork\Pubs'                                      
$Env:FP__projectDescription__  = 'A sample team-based Flyway project'                                      
$Env:FP__projectName__  = 'Pubs'                    
$Env:FP__SnapshotDirectory__  = "Snapshots"                                      

$Env:FLYWAY_PASSWORD  = $null                                                           
$Env:FLYWAY_URL  = $null 
$Env:FLYWAY_USER  = $null                                                              
$Env:FP__Branch__  =  $null                                                                     
$Env:FP__canDoStringAgg__  =$null                                                                     
$Env:FP__DSN__  = $null                                                                  
$Env:FP__flyway_database__  = $null                                                              
$Env:FP__flyway_defaultSchema__  = $null                                                                     
$Env:FP__flyway_environment__  = $null                                                                   
$Env:FP__flyway_filename__  = $null                                                     
$Env:FP__flyway_table__  = $null                                                   
$Env:FP__flyway_timestamp__  = $null                                                     
$Env:FP__flyway_user__  = $null                                                             
$Env:FP__flyway_workingDirectory__  = $null                                       
$Env:FP__projectDescription__  = $null                                       
$Env:FP__projectName__  = $null                     
$Env:FP__SnapshotDirectory__  = $null                                    

#>





<#
	.SYNOPSIS
		Get the configuration values from all the Flyway sources, including any encrypted files
	
	.DESCRIPTION
		This gathers up all of the Flyway configuration values  frtom file or environment 
        variable in order of precendence. It uses the current working folder to get its values
	
	.PARAMETER ListOfExtraSources
		A list of extra resources with config information such as config information passed as parameters.
	
	.EXAMPLE
		PS C:\> Get-FlywayConfContent |convertTo-json
        PS C:\> Get-FlywayConfContent -WeWantConfigInfo $false #just give the environment variables

	
#>
function Get-FlywayConfContent
{
	param
	(
		[array]$ListOfExtraSources = @(),
		[boolean]$WeWantConfigInfo = $true
	)
	
	$FlywaylinesToParse = @()
	$FlywayConfContent = @{ 'Placeholders' = @{ } };
	
	if (test-path 'env:FP__ParameterConfigItem__')
	# make sure an extra config file hasn't been specified
	{
		if ("$env:FP__ParameterConfigItem__" -notin $ListOfExtraSources)
		{ $ListOfExtraSources += "$env:FP__ParameterConfigItem__" }
	}
    #Started to collect all environment variables
	#Firstly we get the environment variables as they take precedence
	# get all the Flyway variable and placeholder values held in the session environment
	@('env:FLYWAY_*', 'env:FP__*') | foreach{ gci $_ } | sort-object name -Unique | foreach-object -Process {
    # Write-verbose "processing $($_.name)"
		#take each relevant environment variable and strip out the actual name
		if ($_.Name -match @'
(?m:^)(?#
    Old-style Flyway placeholder user parameter
    )FLYWAY_PLACEHOLDERS_(?<FlywayParameter>.+)|(?#
    Old-style Flyway parameter
    )(FLYWAY_(?<FlywayVariable>.+)|(?#
    Flyway placeholder var1able passed to callback or script
    )FP__flyway_(?<FlywayPlaceholder>.+)__|(?#
    user placeholder var1able passed to callback or script
    )FP__(?<UserPlaceholder>.+)__)
'@)
		{
			# process according to the type of value
			if ($matches['FlywayVariable'] -ne $null) #Old-style Flyway parameter
			{ $FlywayConfContent.([regex]::Replace($matches['FlywayVariable'].ToLower(), '_(.)', { param ($matches) $matches.Groups[1].Value.ToUpper() })) = $_.Value }
			elseif ($matches['FlywayPlaceholder'] -ne $null) # Old-style Flyway Placeholder
			{ $FlywayConfContent.([regex]::Replace($matches['FlywayPlaceholder'].ToLower(), '_(.)', { param ($matches) $matches.Groups[1].Value.ToUpper() })) = $_.Value }
			elseif ($matches['FlywayParameter'] -ne $null) # Old-style Flyway placeholder user parameter
			{ $FlywayConfContent.Placeholders.($matches['FlywayParameter'].ToLower()) = $_.Value }
			elseif ($matches['UserPlaceholder'] -ne $null) #user placeholder var1able passed to callback or script
			{ $FlywayConfContent.Placeholders.($matches['userPlaceholder'].ToLower()) = $_.Value }
			else { Write-Warning "unrecognised Flyway environment variable $($_.Name)" }
		}
		else
		{
			Write-Warning "mystery Flyway environment variable $($_.Name)"
		}
	}
   
	
	#if we also want to get config information
	If ($WeWantConfigInfo)
	{
		#We need to add unencrypted file import too 
		#has the placeholder been set to explain that an encrypted file was imported into Flyway?
		#Flyway will do placeholder substitutions 
		if (!([string]::IsNullOrEmpty("$env:FP__dpeci__")))
		{
			$secureString = Import-Clixml "$env:FP__dpeci__"
			$bstrPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
			try
			{
				$originalText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstrPtr)
			}
			finally
			{
				[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstrPtr)
				
			}
			$FlywaylinesToParse += $originalText -split "`n"
		}
		
		if ($ListOfExtraSources.count -gt 0 -and !([string]::IsNullOrEmpty($ListOfExtraSources)))
		{
			$ListOfExtraSources | foreach { $FlywaylinesToParse += Get-content "$_" }
		}
		if (test-path "flyway.toml" -PathType Leaf)
		{
			$FlywaylinesToParse = Get-Content -Raw "flyway.toml"
            $TomlData = ConvertFrom-ini "$FlywaylinesToParse"
			$TomlData.flyway.GetEnumerator() | foreach{
				$Key = $_.name; $TheValue = $_.Value;
				if ($FlywayConfContent.$Key -eq $null)
				{ $FlywayConfContent.$Key = $TheValue }
			}
			$FlywayConfContent.environments = $TomlData.environments
			if (($TomlData.flyway.environment -ne $null) -and ($TomlData.environments -ne $null))
			{
				$TomlData.environments[$TomlData.flyway.environment].GetEnumerator() | foreach{
					$Key = $_.name; $TheValue = $_.Value;
					if ($FlywayConfContent.$Key -eq $null)
					{ $FlywayConfContent.$Key = $TheValue }
				}
			}
		}
		elseif (test-path "flyway.conf" -PathType Leaf)
		{
			$FlywaylinesToParse += Get-Content "flyway.conf"
		
		    if (test-path "$env:userProfile\flyway.conf" -PathType Leaf)
		    {
			    $FlywaylinesToParse += Get-content "$env:userProfile\flyway.conf"
		    }
		    $FlywaylinesToParse |
		    where { ($_ -notlike '#*') -and ("$($_)".Trim() -notlike '') } |
		    foreach{ $_ -replace '\\', '\\' } |
		    ConvertFrom-StringData | foreach {
			    $TheValue = "$($_.Values)"
			    if ("$($_.keys)" -like 'flyway.placeholders*')
			    {
				    $Key = "$($_.keys)" -replace ('flyway.placeholders.')
				    if ($FlywayConfContent.Placeholders.$Key -eq $null)
				    { $FlywayConfContent.Placeholders.$Key = $TheValue }
			    }
			    else
			    {
				    $Key = "$($_.keys)" -replace ('flyway.')
				    if ($FlywayConfContent.$Key -eq $null)
				    { $FlywayConfContent.$Key = $TheValue }
			    }
            }
		}
	}
	 $FlywayConfContent
}