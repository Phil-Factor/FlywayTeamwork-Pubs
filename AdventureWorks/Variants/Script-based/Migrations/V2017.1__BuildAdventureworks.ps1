. '.\preliminary.ps1'

Process-FlywayTasks $dbDetails $GetdataFromSQLCMD @(
    "", #query
	".\Migrations\Adventureworks_Build.sql",#file to execute
    $true #simple query
)
