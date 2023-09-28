cd S:\work\Github\FlywayTeamwork\PubsPG\Branches\Develop

@echo off

for /F "usebackq tokens=1,* delims=:," %%a in (`jq -r ".schemaVersion,.schemaName" "CurrentInfo.json"`) do (
    echo %%a
)

