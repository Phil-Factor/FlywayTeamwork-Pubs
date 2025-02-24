<#  
  .NOTES
  ===========================================================================
   Created on:     17/09/2024 10:01
   Created by:     Phil Factor
  ===========================================================================
  .DESCRIPTION
    if the flyway user placeholder 'CurrentSettings' has a value, this routine
  which needs to be run in a script or callback, finds all the flyway settings made
  for the connection and saves them in the user area as a JSON file. 
#>
$VerbosePreference = switch ($Env:FP__TeamworkVerbosity__)
{
	'verbose' { 'continue' }
	'continue' { 'continue' }
	default { 'SilentlyContinue' }
}
if ($Env:FP__CurrentSettings__ -ne $null) # if this variable has a value
{ # get all the Flyway variable and placeholder values held in the session environment
  ('env:FLYWAY_*', 'env:FP__*') | foreach{ gci $_ } | sort-object name | foreach-object -Begin {
    $TheObject = @{ 'Flyway' = @{ 'Placeholder' = @{ } } }
  } -Process { #take each relevant environment variable and strip out the actual name
    if ($_.Name -imatch @'
(?m:^)(?#
Old-style Flyway Variable
)(FLYWAY_(?<FlywayVariable>.+)|(?#
new-style Flyway placeholder var1able
)FP__flyway_(?<FlywayPlaceholder>.+)__|(?#
user variable
)FP__(?<UserPlaceholder>.+)__)
'@)
    { # process according to the type of value
      if ($matches['FlywayVariable'] -ne $null)
      { $TheObject.Flyway.($matches['FlywayVariable']) = $_.Value }
      elseif ($matches['FlywayPlaceholder'] -ne $null)
      { $TheObject.Flyway.($matches['FlywayPlaceholder']) = $_.Value }
      elseif ($matches['UserPlaceholder'] -ne $null)
      { $TheObject.Flyway.Placeholder.($matches['userPlaceholder']) = $_.Value }
      else { Write-Warning "unrecognised Flyway environment variable $($_.Name)" }
    }
    else
    {
      Write-Warning "mystery Flyway environment variable $($_.Name)"
    }
  } -end {
 if ($TheObject.Flyway.PASSWORD -ne $null){$TheObject.Flyway.PASSWORD = 'redacted'};
 ($TheObject  | convertTo-json)>"$env:USERPROFILE\$($Env:FP__CurrentSettings__).json" }
}

