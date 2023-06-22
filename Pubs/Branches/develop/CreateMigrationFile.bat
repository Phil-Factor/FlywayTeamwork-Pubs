REM  This batch script merely demonstrates how to call the function GenerateMigrationScript.bat
REM which creates a migration file from two dacpacs to migrate from 
REM the second version 'target'  to the first, the 'Source'.
REM  producing the script in the file named in the third parameter
cd S:\work\Github\FlywayTeamwork\Pubs\Branches\develop
REM Sourcefile, Targetfile, OutputFilePath
call GenerateMigrationScript.bat "Versions\1.1.15\pubs1.1.15.DACPAC" "Versions\1.1.11\pubs1.1.11.DACPAC"  "MigrateFromV11toV15.sql"
