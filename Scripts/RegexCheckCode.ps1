
$VerbosePreference='continue'
<# 
 Flyway doesn't currently support TOML files containing a collection of rules.
At the moment, Flyway requires the rules to be in single files, one per
rule which are saved separately in Windows 1252 encoding text format

It is no fun to actively maintain a large set of rules when each rule requires
its own file. To do this, it is much easier to store them in a JSON documentt, or
in an application that can output in JSON.


{
    "rules": [
        {
            "name": "ToDo_Test",
            "dialects": [
                "TEXT"
            ],
            "regex": [
            "(?i)ToDo|ToTest|TEARDOWN"
            ],
            "description": "possible unfinished alteration or Test artefact."
        },
        {
            "name": "select_star",
            "dialects": [
                "TEXT"
            ],
            "regex": [
            "(?i)SELECT\\\\s+\\\\*"
            ],
            "description": "Avoid `SELECT *`; specify columns explicitly."
        }
    ]   
}     

We can edit the files in JSON and save each rule to their TOML file in the rules 
directory that you choose. 

We'll store the rules with the project in a subdirectory off the main branch
its name will be defined in the $ProjectLevelResources variable.
#>
$workingDirectory='S:\work\Github\FlywayTeamwork\Pubs';
$ProjectLevelResources='Scripts'; #the name of the project level resources
$win1252 = [System.Text.Encoding]::GetEncoding(1252) # rules must be in this format
$Rules=type "$workingDirectory\$ProjectLevelResources\Rules.json"|convertFrom-JSON
$rules.rules| foreach -begin {$ii=1}{
$RuleFilename="$workingDirectory\Rules\Rule$($ii)__$($_.name).toml"
$AmbiguousRuleFilename="$workingDirectory\Rules\Rule*$($_.name).toml"

# we'll remove the old version if any  
if (Test-Path $AmbiguousRuleFilename -PathType Leaf)
    {
    write-verbose "deleting $RuleFilename"
    Del $AmbiguousRuleFilename
    }
$TheRules=($_.regex -join '","')
$TheDialects=($_.dialects|foreach{if ($_ -eq 'All'){'TEXT'}else{$_.ToUpper()}}) -join '","'
$Contents=@"
dialects = ["$TheDialects"]
rules = ["$TheRules"]
passOnRegexMatch = $(if ($_.passOnRegexMatch -eq $null) {'false'} else {$_.passOnRegexMatch})
description = `"$($_.description)`"
"@ 
[System.IO.File]::WriteAllText($RuleFilename, $Contents , $win1252)
$ii+=1
}



<# To run code analysis we can do something like this 

1. Copy all the Flyway rules from the install directory to your project rules
subdirectory. This must be accessible from all branches of your project
Now, if you've been adding to the rules in the rules document, you must
re-generate all the one-file-per-rule files from the rules document #>

<# We need to create an environment (actually, the connection details for your
database etc) because Flyway needs to work out which dialect of SQL you're 
using #>

$Project = 'Pubs' # for working directory and the name of the credentials file
$Branch = 'Main' # the branch. We use this just for suitable login credentials 
$Server = 'Philf01'
$RDBMS = 'SQLServer'
#
$credentialsFile = "$($RDBMS)_$($Branch)_$Server"
$ProjectArtefacts = ".\Versions" # the directory for artefacts
#we specify where in the user area we store connections and credentials
$currentCredentialsPath = "$env:USERPROFILE\$($Project)_$($credentialsFile).toml"
#go to the appropriate directory - make it your working directory
cd "$env:FlywayWorkPath\$Project"
<# $current just contains your 'current' environment. If you call it something different,
you'll need to change it in the subsequent code #>
$current = "-configFiles=$CurrentCredentialsPath"
$SQLSmells=(flyway $current check -rulesLocation='.\rules' -outputType=json -code)|convertFrom-json
if ($SQLSmells.error -ne $null) { Write-error "$($SQLSmells.error.message)" }
$Smellyfile=($SQLSmells.individualResults[0].results[0].filepath -split '\\')|select -Last 1
$Smells = $SQLSmells.individualResults[0].results[0].violations
$Smells| Out-GridView -Title "SQL Code Smells for $Smellyfile"
$Smells |convertTo-CSV





<#we can import the default rules into an object or on into a TOML/JSON file
I use ConvertTo-INI to gulp in TOML or Conf files #>

$FlywayDirectory=$env:path -split ';' | where {$_ -like '*Flyway*'}|select -first 1
$MyInstallDirectory=$FlywayDirectory -replace '\\flyway.cmd\z','\rules'
$TheDefaultRules=dir $MyInstallDirectory| foreach {(type $_.fullname -raw)|convertFrom-ini}
$TheDefaultRules|convertTo-json

<# we can, of course, convert it to a single TOML file when this is supported #>
@{'rules'=$TheDefaultRules}|convertTo-TOML

<# 
 We can store rules in PowerShell. This is actually easier than any java-based
 representation of an object such as JSON or TOML, because a regex \
 is represented without extra escapes. The Java Regex uses a single slash. The
 extra slash is used by the jave text input routiner
#>

@{
'Rules' = @(
# TEXT, BIGQUERY, DBS,MYSQL, ORACLE, POSTGRES,REDSHIFT, SNOWFLAKE,SQLITE, TSQL
@{'dialects' =@('TEXT');
'rules' = @('["(?i)(^|\\s)TO\\s+DO($|\\s|;)"]');
'passOnRegexMatch' = $false;
'description' = "Phrase 'to do' remains in the code"},
@{'dialects' =@('TEXT');
'rules' = @('(?i)(?<=^|\\s)DROP\\s+PARTITION(?=$|\\s|;)');
'passOnRegexMatch' = $false;
'description' = "DROP PARTITION statement"}
) 
}|convertTo-TOML

<# 
we can easily generate the TOML from Javascript files if you can bear having
to write a single slash four times  
#>

$Rules=type "$workingDirectory\Scripts\Rules.json"|convertFrom-JSON
$rules|convertTo-TOML


