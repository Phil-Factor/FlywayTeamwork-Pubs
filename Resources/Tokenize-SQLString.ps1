<#
	.SYNOPSIS
		Simple break down into the essential units
	
	.DESCRIPTION
		Takes a sql string and produces a stream of its component parts such as comments, strings numbers, identifiers and so on.
	
	.PARAMETER SQLString
		A description of the SQLString parameter.
	
	.PARAMETER parserRegex
		A description of the parserRegex parameter.
	
	.PARAMETER ReservedWords
		A description of the ReservedWords parameter.
	
	.EXAMPLE
		PS C:\> Tokenize-SQLString -SQLString 'Value1'
	Tokenize-SQLString -SQLString$SecondSample
	.NOTES
		Additional information about the function.
#>
function Tokenize-SQLString
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[string]$SQLString,
		[regex]$parserRegex = $null,
		[array]$TheKeywords = @()
	)
	
	if ($parserRegex -eq $null)
	{
		$parserRegex = [regex]@'
(?i)(?s)(?<JavaDoc>/\*\*.*?\*/)|(?#
)(?<BlockComment>/\*.*?\*/)|(?#
)(?<EndOfLineComment>--[^\n\r]*)|(?#
)(?<String>N?'.*?')|(?#
)(?<number>[+\-]?\d+\.?\d{0,100}[+\-0-9E]{0,6})|(?#
)(?<SquareBracketed>\[.{1,255}?\])|(?#
)(?<Quoted>".{1,255}?")|(?#
)(?<Identifier>[@]?[\p{N}\p{L}_][\p{L}\p{N}@$#_]{0,127})|(?#
)(?<Operator><>|<=>|>=|<=|==|=|!=|!|<<|>>|<|>|\|\||\||&&|&|-|\+|\*(?!/)|/(?!\*)|\%|~|\^|\?)|(?#
)(?<Punctuation>[^\w\s\r\n])
'@
	}
	$LineRegex = [regex]'(\r\n|\r|\n)';
<# we need to know the SQL reserved words #>
            <#
Types of reserved words
custom      1 functions and extensions   Magenta in SSMS
standard    2 standard SQL               Black in SSMS
expression  3 keywords in expressions    Grey in SSMS
Query        4 Keywords dealing with data Blue in SSMS

#> 
 
$TheKeywords=@{
'ABS'=1;'ABSOLUTE'=4;'ACTION'=4;'ADD'=4;'ADMIN'=4;'AFTER'=4;'AGGREGATE'=2;'ALIAS'=2;'ALL'=3;'ALLOCATE'=2;'ALTER'=4;
'AND'=3;'ANY'=3;'ARE'=2;'ARRAY'=2;'AS'=4;'ASC'=4;'ASSERTION'=2;'AT'=4;'ATOMIC'=4;'AUTHORIZATION'=4;'AVG'=1;
'BEFORE'=4;'BEGIN'=4;'BIGINT'=4;'BINARY'=4;'BIT'=4;'BLOB'=2;'BOOLEAN'=2;'BOTH'=2;'BREADTH'=2;'BY'=4;'CALL'=4;
'CASCADE'=4;'CASCADED'=2;'CASE'=4;'CAST'=1;'CATALOG'=4;'CEIL'=2;'CHAR'=4;'CHARACTER'=4;'CHECK'=4;'CLASS'=2;
'CLOB'=2;'CLOSE'=4;'COLLATE'=1;'COLLATION'=2;'COLLECT'=2;'COLUMN'=4;'COMMIT'=4;'COMPLETION'=2;'CONCAT'=1;
'CONDITION'=2;'CONNECT'=4;'CONNECTION'=2;'CONSTRAINT'=4;'CONSTRAINTS'=2;'CONSTRUCTOR'=2;'CONTAINS'=1;
'CONTINUE'=4;'CORRESPONDING'=2;'COUNT'=1;'CREATE'=4;'CROSS'=3;'CUBE'=4;'CURRENT'=4;'CURRENT_DATE'=4;
'CURRENT_PATH'=2;'CURRENT_ROLE'=2;'CURRENT_TIME'=1;'CURRENT_TIMESTAMP'=1;'CURRENT_USER'=1;'CURSOR'=4;
'CYCLE'=2;'DATA'=4;'DATALINK'=2;'DATE'=4;'DATE_ADD'=2;'DATE_PART'=2;'DAY'=1;'DEALLOCATE'=4;'DEC'=4;
'DECIMAL'=4;'DECLARE'=4;'DEFAULT'=4;'DEFERRABLE'=2;'DELETE'=4;'DENSE_RANK'=1;'DEPTH'=2;'DEREF'=2;'DESC'=4;
'DESCRIPTOR'=2;'DESTRUCTOR'=2;'DIAGNOSTICS'=2;'DICTIONARY'=2;'DISCONNECT'=2;'DO'=2;'DOMAIN'=2;'DOUBLE'=4;
'DROP'=4;'ELEMENT'=2;'END'=4;'END-EXEC'=4;'EQUALS'=2;'ESCAPE'=4;'EXCEPT'=4;'EXCEPTION'=2;'EXECUTE'=4;
'EXIT'=4;'EXPAND'=4;'EXPANDING'=2;'FALSE'=2;'FIRST'=4;'FLOAT'=4;'FLOOR'=1;'FOR'=4;'FOREIGN'=4;'FREE'=2;
'FROM'=4;'FUNCTION'=4;'FUSION'=2;'GENERAL'=2;'GET'=4;'GLOBAL'=4;'GO'=4;'GOTO'=4;'GROUP'=4;'GROUPING'=1;
'HANDLER'=2;'HASH'=4;'HOUR'=1;'IDENTITY'=4;'IF'=4;'IGNORE'=2;'IMMEDIATE'=4;'IN'=3;'INDICATOR'=2;'INITIALIZE'=2;
'INITIALLY'=2;'INNER'=3;'INOUT'=2;'INPUT'=2;'INSERT'=4;'INT'=4;'INTEGER'=4;'INTERSECT'=4;'INTERSECTION'=2;
'INTERVAL'=2;'INTO'=2;'IS'=3;'ISOLATION'=4;'ITERATE'=2;'JOIN'=3;'KEY'=4;'LAG'=1;'LANGUAGE'=4;'LARGE'=2;
'LAST'=4;'LATERAL'=2;'LEAD'=1;'LEADING'=2;'LEAVE'=2;'LEFT'=3;'LEN'=1;'LENGTH'=4;'LESS'=2;'LEVEL'=4;'LIKE'=3;
'LIMIT'=2;'LOCAL'=4;'LOCALTIME'=2;'LOCALTIMESTAMP'=2;'LOCATOR'=2;'LOOP'=4;'LOWER'=1;'MATCH'=4;'MAX'=1;
'MEETS'=2;'MEMBER'=2;'MERGE'=4;'MIN'=1;'MINUTE'=1;'MODIFIES'=2;'MODIFY'=4;'MODULE'=2;'MONTH'=1;'MULTISET'=2;
'NAMES'=2;'NATIONAL'=4;'NATURAL'=2;'NCHAR'=4;'NCLOB'=2;'NEW'=2;'NEXT'=4;'NO'=4;'NONE'=4;'NORMALIZE'=1;'NOT'=3;
'NULL'=3;'NUMERIC'=4;'OBJECT'=4;'OF'=4;'OFF'=4;'OLD'=2;'ON'=4;'ONLY'=2;'OPEN'=4;'OPERATION'=2;'OPTION'=4;
'OR'=3;'ORDER'=4;'ORDINALITY'=2;'OUT'=4;'OUTER'=3;'OUTPUT'=4;'PAD'=2;'PARAMETER'=2;'PARAMETERS'=2;
'PARTIAL'=4;'PATH'=4;'PERIOD'=4;'POSTFIX'=2;'POWER'=1;'PRECEDES'=2;'PRECISION'=4;'PREFIX'=2;'PREORDER'=2;
'PREPARE'=2;'PRESERVE'=2;'PRIMARY'=4;'PRIOR'=2;'PRIVILEGES'=2;'PROCEDURE'=4;'PUBLIC'=4;'RANK'=1;'READ'=2;
'READS'=2;'REAL'=4;'RECURSIVE'=4;'REDO'=2;'REF'=2;'REFERENCES'=4;'REFERENCING'=2;'RELATIVE'=4;'REPEAT'=4;
'RESIGNAL'=2;'RESTRICT'=4;'RESULT'=2;'RETURN'=2;'RETURNS'=4;'REVOKE'=4;'RIGHT'=3;'ROLE'=4;'ROLLBACK'=4;
'ROLLUP'=4;'ROUND'=1;'ROUTINE'=2;'ROW'=4;'ROW_NUMBER'=1;'ROWS'=4;'SAVEPOINT'=2;'SCHEMA'=4;'SCROLL'=4;
'SEARCH'=2;'SECOND'=1;'SECTION'=2;'SELECT'=4;'SEQUENCE'=4;'SESSION'=4;'SESSION_USER'=1;'SET'=4;'SETS'=4;
'SIGNAL'=2;'SIZE'=2;'SMALLINT'=4;'SPECIFIC'=2;'SPECIFICTYPE'=2;'SQL'=4;'SQLEXCEPTION'=2;'SQLSTATE'=2;
'SQLWARNING'=2;'SQRT'=1;'START'=4;'STATE'=4;'STATIC'=4;'STRUCTURE'=2;'SUBMULTISET'=2;'SUBSTRING'=1;'SUCCEEDS'=2;
'SUM'=1;'SYSTEM_USER'=1;'TABLE'=4;'TABLESAMPLE'=4;'TEMPORARY'=2;'TERMINATE'=2;'THAN'=2;'THEN'=2;'TIME'=4;
'TIMESTAMP'=2;'TIMEZONE_HOUR'=2;'TIMEZONE_MINUTE'=2;'TO'=4;'TRAILING'=2;'TRANSACTION'=4;'TRANSLATION'=2;
'TREAT'=2;'TRIGGER'=4;'TRIM'=1;'TRUE'=2;'Type'=4;'UESCAPE'=2;'UNDER'=2;'UNDO'=2;'UNION'=4;'UNIQUE'=4;
'UNKNOWN'=2;'UNTIL'=2;'UPDATE'=1;'UPPER'=1;'USAGE'=2;'USER'=4;'USING'=4;'VALUE'=4;'VALUES'=4;'VARCHAR'=4;
'VARIABLE'=2;'VARYING'=4;'VIEW'=4;'WHEN'=4;'WHENEVER'=2;'WHERE'=4;'WHILE'=4;'WITH'=4;'WRITE'=2;'YEAR'=1;
'ZONE'=4;
}
#$TheKeywords.Keys|foreach{if ($TheKeywords.$_ -eq $null) {Write-warning "$_ was null"}}
	# we start by breaking the string up into a pipeline of objects according to the
    # type of string. First get the match objects
	$allmatches = $parserRegex.Matches($SQLString)
    # we also break the script up into lines so we can say where each token is 
	$Lines = $Lineregex.Matches($SQLString); #get the offset where lines start
	# we put each token through a pipeline to attach the line and column for 
    # each token 
    $allmatches | foreach  {
		$_.Groups | where { $_.success -eq $true -and $_.name -ne 0 }
	} | # now we convert each object with the columns we later calculate 
	Select name, index, length, value,
		   @{ n = "Type"; e = { '' } }, @{ n = "line"; e = { 0 } },
		   @{ n = "column"; e = { 0 } } | foreach -Begin {
		$state = 'not'; $held = @(); $FirstIndex = $null; $Theline = 1; $token=$null;
	}{
		#get the value, save the previous value, and try to identify the nature of the token
		$PreviousToken=$Token;
        $Token = $_;
		$ItsAnIdentifier = ($Token.name -in ('SquareBracketed', 'Quoted', 'identifier'));
		if ($ItsAnIdentifier)
		{#strip delimiters out to get the value inside
            $TheString=switch ($Token.name )
            {
            'SquareBracketed' { $Token.Value.TrimStart('[').TrimEnd(']') }
            'Quoted' { $Token.Value.Trim('"') }
            default {$Token.Value}
            }
            $Token.Type = $Token.Name; 
            # Catch local identifiers in some RDBMSs with leading '@'
            if ($Token.Type -eq 'identifier' -and $Token.Value -like '@*')
                {$Token.Type='LocalIdentifier'}    
            # distinguish krywords from references.
            <#
in SSMS ...

magenta--custom   1
black--standard   2
Grey--expression  3
Blue--Query        4
#> 
            #write-warning ($TheKeywords.GetType()).name
            #$TheTypeOfKeyword=$TheKeywords.PSObject.Properties[$TheString].Value
            $TheTypeOfKeyword=$TheKeywords.$TheString;
            #write-Warning "'$TheString' has '$TheTypeOfKeyword'"
            $ItsAnIdentifier=$false
			$Token.Name= switch ( $TheTypeOfKeyword  )
                {
                 1{'Custom'} #magenta
                 2{'Standard'}#Black
                 3{'Expression'}#Grey
                 4{'Query'}#Blue
                 default {$ItsAnIdentifier=$true; 'reference'}
            }
             if ($TheString -eq 'INSERT') {$Token.Name='query'};


		} #Now we calculate the location
		$TheIndex = $Token.Index;
		While ($lines.count -gt $TheLine -and #do we bump the line number
			$lines[$TheLine - 1].Index -lt $TheIndex)
		{ $Theline++ }
		$TheStart = switch
		($Theline)
		{
			({ $PSItem -le 2 }) { 0 }
			Default { $lines[$TheLine - 2].Index }
		}
		$TheColumn = $TheIndex - $TheStart; 
        #index of where we found the token - index of start of line
        #now we record the location
		$Token.'Line' = $TheLine; $Token.'Column' = $TheColumn;
        # we now need to extract the multi-part identifiers, and determine 
        # what is just a local identifier.
		$ItsADot = ($_.name -eq 'Punctuation' -and $_.value -eq '.')
        $ItsAnAS = ($_.name -eq 'Query' -and $_.value -eq 'AS')
        # Write-Verbose "state-$State value=$($token.Value)"       
        # Write-Verbose "Itsanas=$ItsAnAS itsanidentifier=$ItsAnIdentifier state-$State type=$($token.type) name=$($token.Name) value=$($token.Value) previousTokenValue=$($previousToken.Value) CTE=$cte"       
		switch ($state)
		{
			'not' {
				if ($ItsAnIdentifier -and $token.type -ne 'localIdentifier')
                # local identifiers cannot be multi-part identifiers
				{ $Held += $token; $FirstIndex = $token.index; 
                  $CTE=($previousToken.Value -in ('WITH',','));
                  $FirstLine = $TheLine; $FirstColumn = $TheColumn; $state = 'first'; }
				else { write-output $token }
				break
			}
			
			'first' {
				if ($ItsADot) { $state = 'another'; }
				elseif ($ItsAnIdentifier) 
                    {write-output $held; $held = @(); $Held += $token }
                elseif ($ItsAnAS -and $CTE)
                    {$state = 'not'; $held[0].type='localIdentifier';
                     write-output $held; write-output $token; $held = @(); }
                else
                    { write-output $held; write-output $token; $held = @(); $state = 'not' }
				; break
			}
			'another' { if (!($ItsADot)) {$state = 'following'} else {$Token.Value=''};
                       $Held += $token; break }
			'following' {
				if ($ItsADot) { $state = 'another' }
				else
				{
					$held | foreach -begin { $length = 0; $ref = "" } {
						$ref = "$ref.$($_.value.trim())"; $length += $_.length;
					}
					$ref = $ref.trim('.')
					[psCustomObject]@{
						'Name' = 'identifier'; 'index' = $FirstIndex; 'Length' = $length;
						'Value' = $ref; 'Type' = "$($Held.Count)-Part Dotted Reference";
						'Line' = $FirstLine; 'Column' = $FirstColumn
					}
					Write-output $token
					$held = @()
					$state = 'not'
				}
			} # end more
			
		} # end switch	
		
	} -End{if ($state -ne 'not') 
        {
        $held | foreach -begin { $length = 0; $ref = "" } {
						$ref = "$ref.$($_.value.trim())"; $length += $_.length;
					}
					$ref = $ref.trim('.')
					[psCustomObject]@{
						'Name' = 'identifier'; 'index' = $FirstIndex; 'Length' = $length;
						'Value' = $ref; 'Type' = "$($Held.Count)-Part Dotted Reference";
						'Line' = $FirstLine; 'Column' = $FirstColumn
					}
					#Write-output $token
        }
        }
}



#-----sanity checks
$Correct="CREATE VIEW [dbo].[titleview] /* this is a test view */ AS --with comments select 'Report' , title , au_ord , au_lname , price , ytd_sales , pub_id from authors , titles , titleauthor where authors.au_id = titleauthor.au_id AND titles.title_id = titleauthor.title_id ;"
$values = @'
CREATE VIEW [dbo].[titleview] /* this is a test view */
AS --with comments
select 'Report', title, au_ord, au_lname, price, ytd_sales, pub_id
from authors, titles, titleauthor
where authors.au_id = titleauthor.au_id
   AND titles.title_id = titleauthor.title_id
;
'@ | Tokenize-SQLString | Select -ExpandProperty Value
$resultingString=($values -join ' ')
if ($resultingString -ne $correct)
{ write-warning "ooh. that first test to check the values in the output stream wasn't right"}

Set-alias -Name 'Tokenize_SQLString' -Value 'Tokenize-SQLString'

$result=@'
/* we no longer access NotMyServer.NotMyDatabase.NotMySchema.NotMyTable */
-- and we wouldn't use NotMySchema.NotMyTable
Select * from MyServer.MyDatabase.MySchema.MyTable
Print 'We are not accessing NotMyDatabase.NotMySchema.NotMyTable' 
Select * from MyDatabase.MySchema.MyTable
Select * from MyDatabase..MyTable
Select * from MySchema.MyTable
Select * from [My Server].MyDatabase.[My Schema].MyTable
Select * from "MyDatabase".MySchema.MyTable
Select * from MyDatabase..[MyTable]
Select * from MySchema."MyTable"
--of course we don't access NotMyDatabase..[NotMyTable]

'@ |
Tokenize-SQLString | 
     where {$_.type -like '*Part Dotted Reference'}|
        Select Value, line, Type
$ReferenceObject=@'
[{"Value":"MyServer.MyDatabase.MySchema.MyTable","Line":3,"Type":"4-Part Dotted Reference"},
  {"Value":"MyDatabase.MySchema.MyTable","Line":5,"Type":"3-Part Dotted Reference"},
  {"Value":"MyDatabase..MyTable","Line":6,"Type":"3-Part Dotted Reference"},
  {"Value":"MySchema.MyTable","Line":7,"Type":"2-Part Dotted Reference"},
  {"Value":"[My Server].MyDatabase.[My Schema].MyTable","Line":8,"Type":"4-Part Dotted Reference"},
  {"Value":"\"MyDatabase\".MySchema.MyTable","Line":9,"Type":"3-Part Dotted Reference"},
  {"Value":"MyDatabase..[MyTable]","Line":10,"Type":"3-Part Dotted Reference"},
  {"Value":"MySchema.\"MyTable\"","Line":11,"Type":"2-Part Dotted Reference"}
  ]
'@ | convertfrom-json

$BadResults=Compare-Object -Property Value, Line, Type -IncludeEqual -ReferenceObject $ReferenceObject -DifferenceObject $result |
    where {$_.sideIndicator -ne '=='}
if ($BadResults.Count -ne 0) { write-warning "ooh. that second test wasn't right"}

$Correct=[ordered]@{}
$TestValues=[ordered]@{}
$Correct=@'
[{"Name":"Query","Value":"CREATE"},{"Name":"Query","Value":"TABLE"},{"Name":"reference","Value":"tricky"},{"Name":"Punctuation","Value":"("},{"Name":"Expression","Value":"\"NULL\""},{"Name":"Query","Value":"[INT]"},{"Name":"Query","Value":"DEFAULT"},{"Name":"Expression","Value":"NULL"},{"Name":"Punctuation","Value":")"},{"Name":"Query","Value":"INSERT"},{"Name":"Standard","Value":"INTO"},{"Name":"reference","Value":"tricky"},{"Name":"Punctuation","Value":"("},{"Name":"Expression","Value":"\"NULL\""},{"Name":"Punctuation","Value":")"},{"Name":"Query","Value":"VALUES"},{"Name":"Punctuation","Value":"("},{"Name":"Expression","Value":"NULL"},{"Name":"Punctuation","Value":")"},{"Name":"Query","Value":"SELECT"},{"Name":"Expression","Value":"NULL"},{"Name":"Query","Value":"AS"},{"Name":"Query","Value":"\"VALUE\""},{"Name":"Punctuation","Value":","},{"Name":"Expression","Value":"[null]"},{"Name":"Punctuation","Value":","},{"Name":"Expression","Value":"\"null\""},{"Name":"Punctuation","Value":","},{"Name":"String","Value":"\u0027NULL\u0027"},{"Name":"Query","Value":"as"},{"Name":"reference","Value":"\"String\""},{"Name":"Query","Value":"FROM"},{"Name":"reference","Value":"tricky"},{"Name":"Punctuation","Value":";"}]
'@|convertfrom-json 
$TestValues= Tokenize-SQLString @'
 CREATE TABLE tricky ("NULL" [INT] DEFAULT NULL)
 INSERT INTO tricky ("NULL") VALUES (NULL)
 SELECT NULL AS "VALUE",[null],"null",'NULL'as "String" FROM tricky;
'@|select Name,value
$BadResults=Compare-Object -Property Name, Value -IncludeEqual -ReferenceObject $correct -DifferenceObject $TestValues |
    where {$_.sideIndicator -ne '=='}
if ($BadResults.Count -ne 0) { write-warning "ooh. that third test wasn't right"}

$result=@'
CREATE OR ALTER FUNCTION dbo.PublishersEmployees
(
    @company varchar(30) --the name of the publishing company or '_' for all.
)
RETURNS TABLE AS RETURN
(
SELECT fname
       + CASE WHEN minit = '' THEN ' ' ELSE COALESCE (' ' + minit + ' ', ' ') END
       + lname AS NAME, job_desc, pub_name, person.person_id
  FROM
  employee
    INNER JOIN jobs
      ON jobs.job_id = employee.job_id
    INNER JOIN dbo.publishers
      ON publishers.pub_id = employee.pub_id
	INNER JOIN people.person
	ON person.LegacyIdentifier='em-'+employee.emp_id
	WHERE pub_name LIKE '%'+@company+'%'
)
'@ |Tokenize-SQLString |Where {$_.Type -eq 'LocalIdentifier'}|select  -ExpandProperty value|sort -Unique
if ($result -ne '@company')  { write-warning "ooh. that fourth test checking for '@' variables wasn't right"}


$Result=@'
WITH top_authors
AS (SELECT au.au_id as au, au.au_fname, au.au_lname,
                 SUM (sale.qty) AS total_sales
      FROM
      dbo.authors as au
        JOIN dbo.titleauthor ta
          ON au.au_id = ta.au_id
        JOIN dbo.sales sale
          ON ta.title_id = sale.title_id
      GROUP BY
      au.au_id, au.au_fname, au.au_lname
      ORDER BY total_sales DESC limit 5), avg_sales
AS (SELECT title_id, AVG (qty) AS avg_qty FROM dbo.sales GROUP BY title_id)
  SELECT ta.au_id, ta.au_fname, ta.au_lname, t.title_id, t.title, t.price,
         s.avg_qty
    FROM
    top_authors as ta
      JOIN dbo.titleauthor ta2
        ON ta.au_id = ta2.au_id
      JOIN dbo.titles t
        ON ta2.title_id = t.title_id
      JOIN avg_sales s
        ON t.title_id = s.title_id;
'@  |Tokenize-SQLString  |Where {$_.Type -eq 'LocalIdentifier'}|select  -ExpandProperty value|sort -Unique
if ($result[0] -ne 'avg_sales' -or $result[1] -ne 'top_authors' )
      { write-warning "ooh. that fifth test about the WITH wasn't right"}


