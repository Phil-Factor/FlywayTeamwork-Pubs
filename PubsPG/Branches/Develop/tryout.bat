@echo off

set "connectionString=jdbc:sqlserver://win-ilch1809mqp\sql2017;databaseName=PubsMain;encrypt=true;trustServerCertificate=true;"

for /F "tokens=3 delims=:;/" %%A in ("%connectionString%") do (
    set "serverName=%%A"
    setlocal enabledelayedexpansion
    for /F "delims=" %%B in ("%%A") do (
        endlocal
        set "serverName=%%B"
    )
)

echo Database Server Name: %serverName%