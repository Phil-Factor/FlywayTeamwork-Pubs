IF Object_Id(N'dbo.IterativeWordChop') IS NOT NULL DROP FUNCTION dbo.IterativeWordChop;
go
CREATE FUNCTION dbo.IterativeWordChop
/*
summary:   >
 
This Table-valued function takes any text as a parameter and splits it into its constituent words,
passing back the order in which they occured and their location in the text. 
Author: Phil Factor
Revision: 1.3
date: 2 Apr 2014
example:
     - code: SELECT * FROM IterativeWordChop('this tests stuff. Will it work?')
     - code: SELECT * FROM IterativeWordChop('this ------- tests it again; Will it work ...')
     - code: SELECT * FROM IterativeWordChop('Do we allow %Wildcards% like %x%?')
returns:   >
Table of SequenceNumber, item (word) and sequence no.
**/
( 
@string VARCHAR(MAX)
) 
RETURNS
@Results TABLE
(
Item VARCHAR(255),
location int,
Sequence int identity primary key
)
AS
BEGIN
DECLARE @Len INT, @Start INT, @end INT, @Cursor INT,@length INT
SELECT @Cursor=1, @len=LEN(@string)
WHILE @cursor<@len
   BEGIN
   SELECT @start=PATINDEX('%[^A-Za-z0-9][A-Za-z0-9%]%',
                   ' '+SUBSTRING (@string,@cursor,50)
                   )-1
   if @start<0 break                
   SELECT @length=PATINDEX('%[^A-Z''a-z0-9-%]%',SUBSTRING (@string,@cursor+@start+1,50)+' ')   
   INSERT INTO @results(item, location) 
       SELECT  SUBSTRING(@string,@cursor+@start,@length), @cursor+@start
   SELECT @Cursor=@Cursor+@Start+@length+1
   END
RETURN
END
go
---sanity-check the word-chop routine to make sure it is more or less working
if exists (select count(*)
from (
  Select item, location,sequence
   FROM dbo.IterativeWordChop('Hello. This tests it again; Will it work? ...')
  union all
   Select * from ( values
     ('Hello',1,1), ('This',8,2), ('tests',13,3), ('it',19,4), ('again',22,5), ('Will',29,6),
     ('it',34,7), ('work',37,8)) CorrectResult(item, location,sequence)
     )f --our 'correct' values
  group by sequence, location,item having count(*)<2
  )
  Raiserror('fault in IterativeWordChop', 16,1)


IF  OBJECT_ID(N'people.Word') IS NOT NULL DROP table people.Word
GO

--create a table with the occurrence of each word in it.
Create table people.Word
(
Item   VARCHAR(255) not null,
frequency  int not null default(0)
)
ALTER TABLE people.Word ADD CONSTRAINT PKWord PRIMARY KEY(item);
GO


IF Object_Id('people.WordOccurence') IS NOT NULL DROP TABLE people.WordOccurence
--create a table with the word-mapping in it.
Create table people.WordOccurence
(
Item  VARCHAR(255) not null ,
location int not null,
Sequence int not null,
Note  int not null
)

ALTER TABLE people.WordOccurence ADD CONSTRAINT PKWordOcurrence PRIMARY KEY(item, sequence,Note);
 
insert into people.WordOccurence (Item,location,Sequence,Note)
  SELECT Item,location,Sequence,Note_id  FROM people.note
  cross APPLY Iterativewordchop(note)

insert into people.word(item, frequency)
Select  item, count(*) 
     from people.WordOccurence group by item 

ALTER TABLE people.WordOccurence ADD CONSTRAINT FKWordOccurenceWord FOREIGN KEY (item) REFERENCES people.word
go
CREATE FUNCTION [dbo].[FindWords]
  /*
summary:  >
 
This Table-valued function takes text as a parameter and tries to find it in the people.WordOccurence table
 
Author: Phil Factor

example:
   - code: SELECT * FROM FindWords('disgusting')
   - code: SELECT * FROM FindWords('Yvonne')
   - code: SELECT * FROM FindWords('unacceptable')
   - code: SELECT TOP 10 note_id, Max(NoteStart) AS Note_Start, 
                 Max(InsertionDate)AS Insertion_Date, 
                 Max(InsertedBy) AS Inserted_by  
             from 
	         (SELECT note_id, NoteStart, InsertionDate, InsertedBy 
	         FROM people.note NS
	         INNER JOIN FindWords('disgusting ridiculous') FW
	         ON FW.note=NS.note_id)f
             group by Note_id
             order by Max(InsertionDate) desc
 
returns:  >
passes back the location where they were found, and the number of words matched in the string.
**/
  (@string VARCHAR(100))
RETURNS @finds TABLE (location INT NOT NULL, Note INT NOT NULL, hits INT NOT NULL)
AS
  BEGIN
    DECLARE @WordsToLookUp TABLE
      (
      Item VARCHAR(255) NOT NULL,
      location INT NOT NULL,
      Sequence INT NOT NULL PRIMARY KEY
      );
    DECLARE @wordCount INT, @searches INT;
    -- chop the string into its constituent words, with the sequence
    INSERT INTO @WordsToLookUp (Item, location, Sequence)
      SELECT Item, location, Sequence FROM dbo.IterativeWordChop(@string);
    -- determine how many words and work out what proportion to search for
    SELECT @wordCount = @@RowCount;
    SELECT @searches =
       CASE WHEN @wordCount < 6 THEN @wordCount ELSE 2 + (@wordCount / 2) END;
    IF @wordcount=1
		BEGIN
		INSERT INTO @finds (location, Note, hits)
			SELECT MIN(location), Note, 1 
			FROM people.WordOccurence WHERE item LIKE @string GROUP BY Note
        return
		END 
		INSERT INTO @finds (location, Note, hits)
		   SELECT Min(Firstlocation), Note, @wordcount  FROM 
	  (SELECT wordswanted.[sequence] AS theorder,Note,
	  Min(WordOccurence.location) AS FirstLocation 
        FROM -- @WordsToLookUp wordsWanted
		(
            SELECT TOP (@searches) Word.Item, searchterm.Sequence
              FROM @WordsToLookUp searchterm
                INNER JOIN people.Word
                  ON searchterm.Item = Word.Item
              ORDER BY frequency
            ) wordsWanted(item, Sequence)
	  INNER JOIN people.WordOccurence ON WordOccurence.Item = wordsWanted.Item
	  GROUP BY Note,wordsWanted.[sequence])f
 GROUP BY Note
 HAVING Count(*)=@searches
    RETURN;
  END;

GO
IF Object_Id(N'FindString') IS NOT NULL DROP FUNCTION FindString;
GO
CREATE FUNCTION [dbo].[FindString]
  /*
summary:  >
 This Table-valued function takes text as a parameter and 
 tries to find it in the WordOccurence table
example:
   - code: SELECT * FROM FindString('disgusting')
   - code: SELECT TOP 10 note_id, Max(NoteStart) AS Note_Start, 
                 Max(InsertionDate)AS Insertion_Date, 
                 Max(InsertedBy) AS Inserted_by  
             from 
	         (SELECT note_id, NoteStart, InsertionDate, InsertedBy 
	         FROM people.note NS
	         INNER JOIN FindString('despite trying all sorts') FW
	         ON FW.note=NS.note_id)f
             group by Note_id
             order by Max(InsertionDate) desc
returns:  >
passes back the location where they were found, and 
the number of words matched in the string.
**/
  (@string VARCHAR(100))
RETURNS @finds TABLE (location INT NOT NULL, note INT NOT NULL, hits INT NOT NULL)
AS
  BEGIN
    DECLARE @WordsToLookUp TABLE
      (
      Item VARCHAR(255) NOT NULL,
      location INT NOT NULL,
      Sequence INT NOT NULL PRIMARY KEY
      );
    DECLARE @wordCount INT, @searches INT;
    -- chop the string into its constituent words, with the sequence
    INSERT INTO @WordsToLookUp (Item, location, Sequence)
      SELECT Item, location, Sequence FROM dbo.IterativeWordChop(@string);
    -- determine how many words and work out what proportion to search for
    SELECT @wordCount = @@RowCount;
    SELECT @searches =
       CASE WHEN @wordCount < 3 THEN @wordCount ELSE 2 + (@wordCount / 2) END;
    IF @wordcount=1
		BEGIN
		INSERT INTO @finds (location, note, hits)
			SELECT MIN(location), note, 1 
				FROM people.wordoccurence WHERE item LIKE @string GROUP BY note
        return
		END 
    INSERT INTO @finds (location, Note, hits)
      SELECT Min(WordOccurence.location), Note, Count(*) AS matches
        FROM people.WordOccurence
          INNER JOIN
            (
            SELECT TOP (@searches) Word.Item, searchterm.Sequence
              FROM @WordsToLookUp searchterm
                INNER JOIN people.Word
                  ON searchterm.Item = Word.Item
              ORDER BY frequency
            ) LessFrequentWords(item, Sequence)
            ON LessFrequentWords.item = WordOccurence.Item
        GROUP BY WordOccurence.Sequence - LessFrequentWords.Sequence,
        note
        HAVING Count(*) >= @searches
        ORDER BY Count(*) DESC;
    RETURN;
  END;
GO
/*
*/









