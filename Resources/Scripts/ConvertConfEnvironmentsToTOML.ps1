$win1252 = [System.Text.Encoding]::GetEncoding(1252) # rules must be in this format
dir "$env:USERPROFILE\*.conf" | select -ExpandProperty fullName | foreach{
	$TheEnvironment = Type $_ -Raw | convertfrom-ini
	$Params = ("$($_)".Split('\') | select -last 1) -split '_|-'
	if ($Params.count -eq 4)
	{ $DisplayName = "`"project='$($Params[0])' ($($Params[1])), branch='$($Params[2])', user='$($Params[3].Replace('.conf', ''))'`"" }
	elseif ($Params.count -eq 3)
	{ $DisplayName = "`"project='$($Params[0])' ($($Params[1])), branch='$($Params[2].ToLower())', user=`"`"" }
	else { $DisplayName = "`"$($Params.Replace('.conf', ''))`"" }
$Env='develop'
if ($Params[2] -ne $null){$Env=$Params[2].ToLower()}
$Contents=@"
flyway.environment = `"$Env`"
[environments.$Env]
url = `"$($TheEnvironment.flyway.url)`"
user = `"$($TheEnvironment.flyway.user)`"
password = `"$($TheEnvironment.flyway.password)`"
schemas = [ `"dbo`", `"classic`", `"people`", `"accounting`" ]
"@
[System.IO.File]::WriteAllText("$($_.Replace('.conf','.toml'))", $Contents , $win1252)

}
