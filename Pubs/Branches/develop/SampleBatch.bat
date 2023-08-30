REM set the current working directory to the flyway project you want
cd S:\work\Github\FlywayTeamwork\PubsPG\Branches\Develop
REM if you haven't done a java install, set the path to your favourite version of Flyway
set "flyway=C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-9.19.1\flyway.cmd"
REM Write out the current version, and all the files that make up the version
%flyway% info -outputType=json >CurrentInfo.json

