SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create   function [dbo].[SentenceFrom] (
 @JsonData NVARCHAR(MAX), --the collection of objects, each one
 -- consisting of arrays of strings. If a word is prepended by  a 
 -- ^ character, it is the name of the object whose value is the array 
 -- of strings
 @Reference NVARCHAR(100), --the JSON reference to the object containing the
 -- list of strings to choose one item from.
 @level INT = 5--the depth of recursion allowed . 0 means don't recurse.
 ) 
/**
Summary: > 
   this function takes a json document that describes all the
   alternative components
   of a string and from it, it returns a string.
   basically, you give it a list of alternatives and it selects one of them. However
   if you put in the name of an array as one of the alternatives,rather than a word,
   it will, if it selects it, treat it as a new reference and will select one of 
   these alternatives.
Author: PhilFactor
Date: 05/11/2020
Database: PhilsScripts
Examples:
   - select dbo.SentenceFrom('{
     "name":[ "^prefix ^firstname ^lastname ^suffix",
	   "^prefix ^firstname ^lastname","^firstname ^lastname"
      ],
      "prefix":["Mr","Mrs","Miss","Sir","Dr","professor"
      ],
      "firstname":["Dick","Bob","Ravi","Jess","Karen"
      ],
      "lastname":["Stevens","Payne","Boyd","Sims","Brown"
      ],
      "suffix":["3rd","MA","BSc","","","","",""
      ]
    }
    ','$.name',5)
Returns: >
  a randomised string.
**/

RETURNS NVARCHAR(MAX)
AS
  BEGIN
    IF coalesce(@level,-1) < 0 RETURN 'too many levels'; /* if there is mutual 
references, this can potentially lead to a deadly embrace. This checks for that */
    IF IsJson(@JsonData) <> 0 --check that the data is valid
      BEGIN
        DECLARE @Choices TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @words TABLE ([KEY] INT, value NVARCHAR(MAX));
        DECLARE @ii INT, @iiMax INT, @Output NVARCHAR(MAX);
        DECLARE @Endpunctuation VARCHAR(80); -- used to ensure we don't lose end punctuation
        DECLARE @SingleWord NVARCHAR(800), @ValidJsonList NVARCHAR(800);
		--we check for a missing or global reference and use the first object
        IF coalesce(@Reference,'$') = '$' 
		   SELECT top 1 @Reference = '$.'+[key] --just get the first
		     FROM OpenJson(@JSONData ,'$') where type=4;
        insert into @choices ([key],Value) --put the choices in a temp table
          SELECT [key],value FROM OpenJson(@JSONData ,@reference) where type=1
		-- if there was an easy way of getting the length of the array then we
		--could use JSON_VALUE ( expression , path ) to get the element   
        -- and get the chosen string
		DECLARE @string NVARCHAR(4000) =
           (SELECT TOP 1 value FROM @Choices 
		     CROSS JOIN RAN ORDER BY RAN.number);
        SELECT @ValidJsonList = N'["' + Replace(string_escape(@string,'json'), ' ', '","') + N'"]';
        IF IsJson(@ValidJsonList) = 0 RETURN N'invalid reference- '
                                             + @ValidJsonList;
        --now we examine each word in the string to see if it is reference
		--to another array within the JSON.
		INSERT INTO @words ([KEY], value)
		  SELECT [KEY], value
			FROM OpenJson( @ValidJsonList,'$');
        IF @@RowCount = 0 RETURN @ValidJsonList + ' returned no words';
        SELECT @ii = 0, @iiMax = Max([KEY]) FROM @words;
		-- we now loop through the words either treating the words as strings
		-- or symbols representing arrays
        WHILE (@ii < (@iiMax + 1))
          BEGIN
            SELECT @SingleWord = value FROM @words WHERE [KEY] = @ii;
            IF @@RowCount = 0
              BEGIN
                SELECT @Output =
                N'no words in' + N'["' + Replace(@string, ' ', '","') + N'"]';
                RETURN @Output;
              END;
            SELECT @ii = @ii + 1;
            IF Left(LTrim(@SingleWord), 1) = '^'-- it is a reference
              BEGIN -- nick out the '^' symbol
                SELECT @Reference = '$.' + Stuff(@SingleWord, 1, 1, ''),
                @Endpunctuation = '';
                WHILE Reverse(@Reference) LIKE '[:;.,-_()]%'
                  BEGIN --rescue any punctuation after the symbol
                    DECLARE @End INT = Len(@Reference);
                    SELECT @Endpunctuation = Substring(@Reference, @End, 1);
                    SELECT @Reference = Substring(@Reference, 1, @End - 1);
                  END; --and we call it recursively
                IF @level > 0
                  SELECT @Output =
                    Coalesce(@Output + ' ', '')
                    + dbo.SentenceFrom(@JsonData, @Reference, @level - 1)
                    + @Endpunctuation;
              END;
            -- otherwise it is plain sailing. Would that it were always
			-- that simple
            ELSE SELECT @Output = Coalesce(@Output + ' ', '') + @SingleWord;
          END;
      END;
    ELSE SELECT @Output = 'sorry. Error in the JSON';
    RETURN @Output; --and return whatever (it could be a novel!)
  END;
GO
