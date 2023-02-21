<# These are used to help find various tools. you need to keep them up-to-date as you upgrade apps.
they are held in the project directory in a file called MyToolLocations.ps1. If you make a  #>

# use Remove-Item Alias:<MyAlias> whenever you change any values
#we always use SQLCMD to access SQL Server
if ( ([string]::IsNullOrEmpty($Dir))) 
    {write-error "we couldn't initialise the aliases. Have you executed 'preliminary.ps1'?"}
else
    {$LocationOfPaths="$Dir\MyToolLocations.ps1"}
   
<# these that follow are just defaults that are generated if there isnt an existing file.
They don't need to be set to your locations and you can just  alter
the existing locations file if you need to make a change. It is easier to change code than
write it from scratch! 
When you edit the 'MyToolLocations.ps1' in your resources file, Leave an entry blank if you 
have the location in a path so that it doesn't need an alias.(such as MySQL who looks after 
all that.)#>
if (-not (Test-Path $LocationOfPaths))
    {
@'
@{SQLCmdAlias = "$($env:ProgramFiles)\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\sqlcmd.exe";
#We use SQL Code Guard just for code analysis.
CodeGuardAlias = "${env:ProgramFiles(x86)}\SQLCodeGuard\SqlCodeGuard30.Cmd.exe";
# We use SQL Compare to compare build script with database
# and for generating scripts.
SQLCompareAlias = "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 14\sqlcompare.exe";
# We use SQL Compare to compare build script with database
# and for generating scripts.
SQLDataCompareAlias = "${env:ProgramFiles(x86)}\Red Gate\SQL Data Compare 14\SQLDataCompare.exe";
#we use pgdump for doing ProgreSQL build scripts
PGDumpAlias = "${env:ProgramFiles}\PostgreSQL\14\bin\pg_dump.exe";
#${env:ProgramFiles}\PostgreSQL\14\bin\pg_dump.exe
#we always use PSQL to access ProgreSQL
psqlAlias = "$($env:LOCALAPPDATA)\Programs\pgAdmin 4\v5\runtime\psql.exe";
#we always use sqlite.exe to access SQLite and get build scripts from it
sqliteAlias = 'C:\ProgramData\chocolatey\lib\SQLite\tools\sqlite-tools-win32-x86-3360000\sqlite3.exe';
#we always use Oracle's SqlCl to access oracle 
OracleCmdAlias = "$($env:ProgramFiles)\sqldeveloper\sqlcl\bin\sql.exe"
#we use MySQLDump for doing MySQL and MariaDB build scripts
MySQLDumpAlias = $null;
#we use MySQL.exe for doing queries to MySQL databases.
MySQLAlias = $null;
SQLPackageAlias="$($env:ProgramFiles)\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe";

}
'@ > $LocationOfPaths
    }


$ourLocation= (. $LocationOfPaths);
$ourLocation.GetEnumerator()| where {$_.Key -in @('SQLCmdAlias', 'CodeGuardAlias', 'SQLCompareAlias', 'SQLDataCompareAlias', 'PGDumpAlias',
	'psqlAlias', 'sqliteAlias', 'OracleCmdAlias', 'MySQLDumpAlias', 'MySQLAlias','SQLPackageAlias')}|foreach{Set-Variable -Name $_.Key -Value $_.Value}

