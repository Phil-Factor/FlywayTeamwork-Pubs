set "outputScriptPath=%~1"

powershell -ExecutionPolicy Bypass -File "TidyUpCode.ps1" "%outputScriptPath%"