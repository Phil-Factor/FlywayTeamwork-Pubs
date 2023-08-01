SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
*/
Create FUNCTION [dbo].[SearchNotes] (@TheStrings NVARCHAR(400))
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
    CASE WHEN LTrim(@TheStrings) LIKE '[''"]%' AND RTrim(@TheStrings) LIKE '%[''"]'  THEN 1 ELSE 0 END;
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
