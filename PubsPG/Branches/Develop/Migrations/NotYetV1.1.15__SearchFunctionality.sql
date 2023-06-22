
CREATE TABLE people.Word (
    Item      VARCHAR (255) NOT NULL,
    frequency INT           NOT NULL,
    CONSTRAINT PKWord PRIMARY KEY CLUSTERED (Item ASC)
);

CREATE TABLE people.WordOccurence (
    Item     VARCHAR (255) NOT NULL,
    location INT           NOT NULL,
    Sequence INT           NOT NULL,
    Note     INT           NOT NULL,
    CONSTRAINT PKWordOcurrence PRIMARY KEY CLUSTERED (Item ASC, Sequence ASC, Note ASC)
);

ALTER TABLE people.Word
    ADD DEFAULT ((0)) FOR frequency;

ALTER TABLE people.WordOccurence WITH NOCHECK
    ADD CONSTRAINT FKWordOccurenceWord FOREIGN KEY (Item) REFERENCES people.Word (Item);

CREATE FUNCTION dbo.FindString
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
      SELECT Item, location, Sequence FROM dbo.SplitStringToWords (@string);
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
PRINT N'Creating Function dbo.FindWords...';
GO
CREATE FUNCTION dbo.FindWords
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
      SELECT Item, location, Sequence FROM dbo.SplitStringToWords (@string);
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
	  (SELECT wordswanted.sequence AS theorder,Note,
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
	  GROUP BY Note,wordsWanted.sequence)f
 GROUP BY Note
 HAVING Count(*)=@searches
    RETURN;
  END;
GO
PRINT N'Creating Function dbo.SearchNotes...';
GO
/*
*/
Create FUNCTION dbo.SearchNotes (@TheStrings NVARCHAR(400))
/**
Summary: >
  This is the application interface, in that it provides the 
  context and works out if the user is specifying a string to
  search for or a collection of words. It chooses to use one 
  of two search algorithms depending on whether it is given
  a word or phrase to search for.
Author: Phil Factor
Date: Wednesday, 13 July 2022
Database: PubsSearch- for the pubs project
Examples:
  - SELECT * FROM dbo.searchNotes('"I''ve tried calling"')
  - SELECT * FROM dbo.searchNotes('I''ve tried calling')
Returns: >
  a table of results, giving the context where the string was found and 
  thew key to the record.
**/
RETURNS @FoundInRecord TABLE
  (TheOrder INT,
   theWord NVARCHAR(100),
   context NVARCHAR(800),
   Thekey INT,
   TheDate DATETIME,
   InsertedBy NVARCHAR(100))
AS
  BEGIN
    DECLARE @SearchResult TABLE
      (TheOrder INT IDENTITY,
       location INT,
       Note INT,
       hits INT);
    DECLARE @InputWasAString INT;
    SELECT @InputWasAString =
    CASE WHEN LTrim(@TheStrings) LIKE '''"%' AND RTrim(@TheStrings) LIKE '%''"'  THEN 1 ELSE 0 END;
    /* the output of the search */
    IF @InputWasAString = 0
      INSERT INTO @SearchResult (location, Note, hits)
        SELECT location, Note, hits FROM FindWords (@TheStrings);
    ELSE
      INSERT INTO @SearchResult (location, Note, hits)
        SELECT location, note, hits FROM FindString (@TheStrings);
    DECLARE @ii INT, @iiMax INT, @Location INT, @Key INT;
    SELECT @ii = Min (TheOrder), @iiMax = Max (TheOrder) FROM @SearchResult;
    WHILE (@ii <= @iiMax)
      BEGIN
        SELECT @Location = location, @Key = Note FROM @SearchResult WHERE
        TheOrder = @ii;
        INSERT INTO @FoundInRecord
          (TheOrder, theWord, context, Thekey, TheDate, InsertedBy)
          SELECT @ii, @TheStrings,
                 '...' + Substring (Note, @Location - 70, 150) + '...',
                 @key, InsertionDate, InsertedBy
            FROM people.Note
            WHERE Note_id = @Key;
        SELECT @ii = @ii + 1;
      END;
    RETURN;
  END;
GO
 
--switch off the foreign key check temporarily
ALTER TABLE people.WordOccurence NOCHECK CONSTRAINT FKWordOccurenceWord;
insert into people.WordOccurence (Item,location,Sequence,Note)
SELECT Item,location,Sequence,Note_id  FROM people.note
LEFT   JOIN LATERAL Iterativewordchop (note) f on true
WHERE  f.col_c = _col_c;
Select * from dbo.IterativeWordChop


  SELECT Item,location,Sequence,Note_id  FROM people.note
  cross APPLY Iterativewordchop(note)

insert into people.word(item, frequency)
Select  item, count(*) 
     from people.WordOccurence group by item 
--switch back on the foreign key check constraint 

PRINT N'Checking existing data against newly created constraints';
GO
ALTER TABLE people.WordOccurence WITH CHECK CHECK CONSTRAINT FKWordOccurenceWord;
PRINT N'Update complete.';
GO

