SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[IterativeWordChop]
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
location INT,
Sequence INT IDENTITY PRIMARY KEY
)
AS
BEGIN
DECLARE @Len INT, @Start INT, @end INT, @Cursor INT,@length INT
SELECT @Cursor=1, @len=Len(@string)
WHILE @cursor<@len
   BEGIN
   SELECT @start=PatIndex('%[^A-Za-z0-9][A-Za-z0-9%]%',
                   ' '+Substring (@string,@cursor,50)
                   )-1
   IF @start<0 BREAK                
   SELECT @length=PatIndex('%[^A-Z''a-z0-9-%]%',Substring (@string,@cursor+@start+1,50)+' ')   
   INSERT INTO @results(item, location) 
       SELECT  Substring(@string,@cursor+@start,@length), @cursor+@start
   SELECT @Cursor=@Cursor+@Start+@length+1
   END
RETURN
END
GO
