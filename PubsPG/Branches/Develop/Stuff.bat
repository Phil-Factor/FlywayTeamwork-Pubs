REM cd S:\work\Github\FlywayTeamwork\PubsPG\Branches\Develop
REM set "flyway=C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-9.19.1\flyway.cmd"
REM %flyway% info -outputType=json >CurrentInfo.json

rem Use jq to extract values from JSON and store them in variables
for /F "usebackq tokens=1,* delims=:," %%a in (`jq -r ".schemaVersion,.schemaName,.flywayVersion,.database,.allSchemasEmpty,.timestamp,.operation,.exception,.licenseFailed,.jsonReport,.htmlReport" "CurrentInfo.json"`) do (
    if "%%a" == "schemaVersion" set "schemaVersion=%%b"
    if "%%a" == "schemaName" set "schemaName=%%b"
    if "%%a" == "flywayVersion" set "schemaName=%%b"
    if "%%a" == "database" set "schemaName=%%b"
    if "%%a" == "allSchemasEmpty" set "allSchemasEmpty%%b"
    if "%%a" == "timestamp" set "timestamp=%%b"
    if "%%a" == "operation" set "operation=%%b"
    if "%%a" == "exception" set "exception=%%b"
    if "%%a" == "licenseFailed set "licenseFailed=%%b"
    if "%%a" == "jsonReport" set "jsonReport=%%b"
    if "%%a" == "htmlReport" set "htmlReport=%%b"
)

echo schemaVersion   %schemaVersion%
echo schemaName      %schemaName%
echo flywayVersion   %flywayVersion%  
echo database        %database%       
echo allSchemasEmpty %allSchemasEmpty%
echo timestamp       %timestamp%      
echo operation       %operation%      
echo exception       %exception%      
echo licenseFailed   %licenseFailed%  
echo jsonReport      %jsonReport%     
echo htmlReport      %htmlReport%     

  