@echo off

setlocal

rem Define function to generate migration script
:GenerateMigrationScript
  set "sourceDacpacPath=%~1"
  set "targetDacpacPath=%~2"
  set "outputScriptPath=%~3"
  set "sqlPackagePath=%ProgramFiles%\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
  set "serverName=Pubs"
  set "databaseName=PubsDev"

  "%sqlPackagePath%" /a:script /SourceFile:"%sourceDacpacPath%" /Targetfile:"%targetDacpacPath%" /OutputPath:"%outputScriptPath%"  /TargetServerName:"%serverName%" /TargetDatabaseName:"%databaseName% /p:CommentOutSetVarDeclarations=true "

  echo Migration script generated successfully.
exit /b

endlocal