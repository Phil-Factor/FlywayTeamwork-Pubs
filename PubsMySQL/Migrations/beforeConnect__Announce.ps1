# load the script preliminary script 
if ($Env:FlywayWorkPath -eq $null) {
  write-Error 'this script needs the environment variable FlywayWorkPath to be set' -WarningAction Stop}
if (-not (Test-Path "$Env:FlywayWorkPath\callbacks\ColourCode.ps1"))
   { write-warning "sorry but "$Env:FlywayWorkPath\callbacks\ColourCode.ps1" must exist"}
. "$Env:FlywayWorkPath\callbacks\ColourCode.ps1"

