# load the script preliminary script 
if ($Env:FlywayWorkPath -eq $null) {
  write-warning 'this script needs the environment variable FlywayWorkPath to be set' -WarningAction Stop}
. "$Env:FlywayWorkPath\callbacks\afterMigrate__snapshot.ps1"

