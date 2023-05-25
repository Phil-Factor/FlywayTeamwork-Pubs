CREATE OR REPLACE FUNCTION dbo.SplitStringToWords (TheString text)
/**
Summary: >
  This table function takes a string of text and splits it into words. 
Author: Phil Factor
Date: 27/05/2021
Revised: 28/10/2021
Examples:
   - SELECT * FROM dbo.SplitStringToWords 
         ('This, (I think), might be working')
   - SELECT * FROM dbo.SplitStringToWords('This, 
        must -I assume - deal with <brackets> ')
Returns: >
  a table of the words and their order in the text.
**/
RETURNS TABLE (TheOrder INT, TheWord VARCHAR(50) )
AS $$
BEGIN
	CREATE TEMPORARY TABLE Words(TheOrder int GENERATED always AS IDENTITY , TheWord VARCHAR(50));
	insert into words(TheWord) Select REGEXP_MATCHES(TheString, '\w+' ,'g') as TheWords;
    RETURN QUERY
    SELECT Words.TheOrder,  trim(Both '{}' from words.theword)::varchar(50)
    FROM Words;
    Drop table words;
END
$$ LANGUAGE plpgsql;



Select 'Oh Dear, Test1 didnt work'
where exists (
  SELECT TheOrder, TheWord 
  FROM dbo.SplitStringToWords ('This, (I think), might be working')
   EXCEPT 
Select column1 as TheOrder, Column2 as TheWord from (values 
(1 ,'This' ),(2,'I'),(3,'think'),(4,'might'),(5,'be'),(6,'working')) as mytable);

Select 'Oh Dear, Test2 didnt work'
where exists (
  SELECT TheOrder, TheWord 
  FROM dbo.SplitStringToWords ('Yan, Tan, Tether, Mether, Pip, Azer, Sezar') 
   EXCEPT 
 Select column1 as TheOrder, Column2 as TheWord from (values 
(1 ,'Yan' ),(2 ,'Tan' ),(3 ,'Tether' ),(4 ,'Mether' ),
(5 ,'Pip' ),(6 ,'Azer' ),(7 ,'Sezar' )) as mytable); 
 

Select 'Oh Dear, Test3 didnt work'
where exists (
  SELECT TheOrder, TheWord 
  FROM dbo.SplitStringToWords (('This!!!




is 
a <very>
{cautious} test') ) 
   EXCEPT 
Select column1 as TheOrder, Column2 as TheWord from (values 
(1,'This'),(2,'is'),(3,'a'),(4,'very'),(5,'cautious'),(6,'test')
) as mytable); 

