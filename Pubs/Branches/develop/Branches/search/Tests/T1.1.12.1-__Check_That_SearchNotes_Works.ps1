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
SELECT @phrase =
'"' + SUBSTRING (@beginning, @start + 1, 20 + @end - 2) + '"';
--can our routine find this phrase in the note we got it from?
IF EXISTS (SELECT * FROM dbo.searchNotes (@phrase) WHERE @Note_id = TheKey)
  SELECT 1 AS success,
         'Found ' + @Phrase + ' as expected in note '
         + CONVERT (Varchar(6), @Note_ID) AS explanation

ELSE
  SELECT 0 AS success,
         'Didn''t find ' + @Phrase + ' in note '
         + CONVERT (Varchar(6), @Note_ID) AS explanation
'@
write-output "running the test to check for phrases"

@(1 .. 5) | foreach {Execute-SQLStatement $dbDetails $TheSQL}

$TheSQL=@'
set nocount on
DECLARE @Result TABLE
  (TheResult nvarchar(10),
   SearchHits int,
   NotesWithWord int,
   Item nvarchar(100));
DECLARE @RandomWords TABLE (theOrder int IDENTITY, item nvarchar(255));
INSERT INTO @RandomWords (item) 
	SELECT TOP 20 item FROM people.word where len(item)>1 ORDER BY NEWID ();
DECLARE @ii int = @@RowCount; --the number of tests to run
WHILE (@ii > 0)
  BEGIN
    DECLARE @Item varchar(100), @frequency int, @EndChar CHAR,
            @SearchHits int, @NotesWithWord int, @Notgotten int;
    SELECT @item = item FROM @Randomwords WHERE @ii = theOrder;
    SELECT @SearchHits = COUNT (*) FROM dbo.searchNotes (@item);
    SELECT @NotesWithWord = COUNT (*)
      FROM
        (SELECT 1
           FROM people.wordoccurence
           WHERE item LIKE @item
           GROUP BY note) F(hit);
    INSERT INTO @Result (TheResult, SearchHits, NotesWithWord, Item)
      SELECT CASE WHEN @SearchHits = @NotesWithWord THEN 'passed' ELSE
                                                                  'failed' END,
             @SearchHits, @NotesWithWord, @Item;
    SELECT @ii = @ii - 1; --decrement the counter for the number of tests
  END;
SELECT * FROM @Result;
'@

Execute-SQLStatement $dbDetails $TheSQL  

