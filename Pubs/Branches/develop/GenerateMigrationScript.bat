@echo off
setlocal
   REM read all parameters.
  set "sourceDacpacPath=%~1"
  set "targetDacpacPath=%~2"
  set "outputScriptPath=%~3"
  REM This needs to be filled in appropriately
  set "sqlPackagePath=%ProgramFiles%\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
  REM these are not used except in comments
  set "serverName=My_Server"
  set "databaseName=My_Database"
  REM This is the line that actually generates the script from the two DACPACs
  "%sqlPackagePath%" /a:script /p:CommentOutSetVarDeclarations=true  /SourceFile:"%sourceDacpacPath%" /Targetfile:"%targetDacpacPath%" /OutputPath:"%outputScriptPath%"  /TargetServerName:"%serverName%" /TargetDatabaseName:"%databaseName% "
  
  echo Migration script %outputScriptPath% generated successfully.
  REM remove any SQLCMD code from the file  
  powershell -ExecutionPolicy Bypass -File "TidyUpCode.ps1" "%outputScriptPath%"
  echo Migration script %outputScriptPath% cleaned of SQLCMD code.
exit /b

endlocal