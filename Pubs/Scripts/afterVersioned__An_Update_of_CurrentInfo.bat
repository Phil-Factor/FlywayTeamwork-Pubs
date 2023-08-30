REM Run Flyway Info within a callback with care (Don't use it in a beforeInfo or afterInfo
set "flyway=C:\ProgramData\chocolatey\lib\flyway.commandline\tools\flyway-9.19.1\flyway.cmd"
%flyway% info -outputType=json >CurrentInfo.json
ECHO CurrentInfo.json updated