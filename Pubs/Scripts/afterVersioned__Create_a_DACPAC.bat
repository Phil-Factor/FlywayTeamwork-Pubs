REM Assume that the currentinfo.json is up to date
echo Now determining parameters
REM Get the value of the schemaVersion (current version of the database schema)
For /F "Delims=" %%G in ('"type currentinfo.json" ^| jq -r .schemaVersion') Do Set "schemaVersion=%%G"
REM Get the name of the relational database system from the Flyway URL
for /F "tokens=2 delims=:;\" %%A in ("%FLYWAY_URL%") do (
    set "RDBMS=%%A"
)
REM Get the name of the relational database system from the Flyway URL
for /F "tokens=3 delims=:;/" %%A in ("%FLYWAY_URL%") do (
    set "serverName=%%A"
    setlocal enabledelayedexpansion
    for /F "delims=" %%B in ("%%A") do (
        endlocal
        set "serverName=%%B"
    )
)
REM create the filename from the database and vewrsion, changing dots '.' to dashes '-'.
Set "FName=%FP__flyway_database__%_%schemaVersion:.=-%"
echo Now creating DACPAC %FName%.dacpac
Rem if you haven't installed a path to SQLPackage.EXE, specify it here
set "sqlPackagePath=%ProgramFiles%\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
Rem. Now execute the command
"%sqlPackagePath%" /Action:Extract /TargetFile:%FName%.dacpac /DiagnosticsFile:%FName%.log /p:ExtractAllTableData=false /p:VerifyExtraction=true /SourceServerName:%ServerName% /SourceDatabaseName:%FP__flyway_database__% /SourceUser:%FLYWAY_USER% /SourcePassword:%FLYWAY_PASSWORD% /SourceTrustServerCertificate:True
