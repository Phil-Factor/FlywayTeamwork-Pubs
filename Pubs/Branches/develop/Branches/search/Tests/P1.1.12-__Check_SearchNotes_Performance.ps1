#We provide the name of the test file with the correct result in it.
$TheSQL=@'
Set nocount on;
DECLARE @Note varchar(8000), @Note_id int, @phrase varchar(80);
--get a note at random from the database table
SELECT TOP 1 @Note = note, @Note_id = note_id FROM people.note 
   ORDER BY NEWID ();
--now find just before the beginning of a  phrase
DECLARE @beginning Varchar(400) =
          (SELECT SUBSTRING (
                  @note, CONVERT (int, RAND () * LEN (@Note)), 8000));
-- find the start of the phrase
DECLARE @start int, @end int;
SELECT @start = PATINDEX ('%[^A-Za-z0-9][A-Za-z0-9%]%', @beginning);
-- find the end of the phrase
SELECT @End =
  PATINDEX (
    '%[A-Za-z0-9][^A-Za-z0-9%]%',
    ' ' + SUBSTRING (@beginning, @Start + 20, 8000));
--now we can retrieve the phrase
SELECT '"' + SUBSTRING (@beginning, @start + 1, 20 + @end - 2) + '"';
'@

@(1 .. 10) | foreach {
$Phrasetosearchfor= Execute-SQLStatement $dbDetails  $TheSQL
write-output "running a test for dbo.searchNotes with a phrase  to see how long it took"
$SQLToTime="Select COUNT (*) FROM dbo.searchNotes ($(($Phrasetosearchfor).Trim()));"
Execute-SQLTimedStatement  $dbDetails $SQLToTime  -muted $true
}

$TheSQL=@'
set nocount on
SELECT TOP 10 item FROM people.word where len(item)>5 ORDER BY NEWID () for json auto
'@
$JSONResult=Execute-SQLStatement $dbDetails $TheSQL
$TheWordsToSearchFor=$JSONResult|convertfrom-JSON;
$TheWordsToSearchFor|foreach{
    $OurTimedSQL= "SELECT COUNT (*) FROM dbo.searchNotes ('$($_.item)')";
    write-output "running a test for wordsearch with dbo.searchNotes  to see how long it took"
    Execute-SQLTimedStatement  $dbDetails $OurTimedSQL -muted $true;
    }
 


