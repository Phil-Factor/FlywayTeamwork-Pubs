#We provide the name of the test file with the correct result in it.
$Test1="$(Split-Path $MyInvocation.MyCommand.Path  -Parent)\PeopleAuthors.json"
# the SQL is SQL Server specific. 
# For other RDBMSs, you need to tweak the SQL. 
# to execute raw queries. I'd stick to running JSON
# To get json from SQLCMD, the query needs the FOR JSON clause but 
# is then modified, so leave out the terminating semicolon!
$TheSQL=@'
SELECT city, Count (*) AS authors
  FROM people.authors
  GROUP BY city
  ORDER BY authors DESC,city
FOR JSON AUTO
'@
$TheKeyField='city'

if (-not(Test-Path $Test1))
    # normally, we'd error out at this point because the correct result has to be
    # created and checked before we implement the object that we are teasting
    # but here we are merely demonstrating the plumbing of the system so we will
    # create a result that passes. We can always edit it to see what happens
    { #create it first time around
    execute-sql $dbDetails $TheSQL >"$Test1"
    }      #check that it actually exists in the test directory

$correctResult=convertFrom-JSON ([IO.File]::ReadAllText($Test1)) 


# now get the result from the database under test
# This returns JSON. 
$TestResult=execute-sql $dbDetails $TheSQL |convertFrom-JSON 

#we now report any differences 
compare-Resultsets -TestResult $TestResult -CorrectResult $correctResult -KeyField $TheKeyField

