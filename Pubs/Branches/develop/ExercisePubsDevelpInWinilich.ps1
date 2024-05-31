# Set-Alias -Name 'Flyway' -Value 'C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-10.10.0\flyway.cmd'
# Remove-Item Alias:Flyway

Dir $env:userprofile\*.conf

gci env:* | sort-object name
cd S:\work\Github\FlywayTeamwork\Pubs\Branches\develop 
. ./preliminary.ps1 "$env:userprofile\Pubs_SQLServer_Develop_win-ilch1809mqp.conf"
$dbdetails
flyway validate -ignoreMigrationPatterns='*:pending'
# Dir $env:USERPROFILe\*.conf
flyway -X validate |where {$_ -like 'DEBUG: Validating*'}
flyway -X info  |where {$_ -like 'DEBUG: Validating*'} 
flyway info 
Flyway validate
flyway clean
flyway migrate
@( 
         @{'Directory'='S:\work\github\FlywayTeamwork\pubs\Branches\develop'; 
       'secrets'="$env:USERPROFILe\Pubs_SQLServer_Develop_win-ilch1809mqp.conf"; 
       'Name'='Pubs Develop branch in the attic router'}
)| foreach {Redo-EveryFlywayMigrationSingly -ProjectLocation "$($_.Directory)" -SecretsPath "$($_.secrets)" -name "$($_.name)"}


flyway check -code
sh "S:\work\Github\FlywayTeamwork\Pubs\Branches\develop\Migrations\Callbacks\afterInfo__Test.sh"
sh S:\work\Github\FlywayTeamwork\Pubs\Branches\develop\.\migrations\Callbacks\afterInfo__Test.sh
@"
my_flyway_project/
└── flyway.conf
migrations/
│       ├── V1__create_table.sql
│       └── V2__alter_table.sh
└── ...
"@


cd S:\work\Github\FlywayTeamwork\Northwind
./preliminary.ps1 "$env:USERPROFILe\NorthWind_SQLServer_Main_win-ilch1809mqp.conf"
flyway info
<#
+-----------+---------+------------------------+------+--------------+---------+----------+
| Category  | Version | Description            | Type | Installed On | State   | Undoable |
+-----------+---------+------------------------+------+--------------+---------+----------+
| Versioned | 1.4.0.0 | NorthWind 1994 to 2000 | SQL  |              | Pending | No       |
+-----------+---------+------------------------+------+--------------+---------+----------+
#>
flyway  migrate
<#
Schema history table [Northwind].[dbo].[flyway_schema_history] does not exist yet
Successfully validated 1 migration (execution time 00:00.522s)
Creating Schema History table [Northwind].[dbo].[flyway_schema_history] ...
Current version of schema [dbo]: << Empty Schema >>
Migrating schema [dbo] to version "1.4.0.0 - NorthWind 1994 to 2000"
Successfully applied 1 migration to schema [dbo], now at version v1.4.0.0 (execution time 00:08.976s)
#>
Flyway info
<#
+-----------+---------+------------------------+------+---------------------+---------+----------+
| Category  | Version | Description            | Type | Installed On        | State   | Undoable |
+-----------+---------+------------------------+------+---------------------+---------+----------+
| Versioned | 1.4.0.0 | NorthWind 1994 to 2000 | SQL  | 2024-04-15 15:43:23 | Success | No       |
+-----------+---------+------------------------+------+---------------------+---------+----------+
#>

Flyway clean
Flyway validate
Flyway repair