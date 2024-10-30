<#
.SYNOPSIS
Gets a hash of the actual SQL code, ignoring formatting and comments. 

.DESCRIPTION
This function uses Tokenise-SQLString to calculate the SHA256 checksum of 
a SQL String, ignoring extra whitespace, block comments and end-of-line comments

.PARAMETER SQLString
The sql code as a string.

.PARAMETER Filepath
A description of the Filepath parameter.

.EXAMPLE
PS C:\> Get-SQLCodeHash -SQLString @'
/* Complex update with case and subquery */
UPDATE Inventory
SET StockLevel = CASE
WHEN StockLevel < 10 THEN StockLevel + 5
ELSE (SELECT AVG(StockLevel) FROM Inventory WHERE CategoryID = Inventory.CategoryID)
END
WHERE ProductID = 101;
'@
	
#>
function Get-SQLCodeHash
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true)]
		[string]$SQLString = '', #if you are parssing a string rather than a filename
		[string]$Filepath # if you wish to pass a filepath containing the SQL
	)
	Begin
	{
	#The regex string will check for the major SQL Components	
		$parserRegex = [regex]@' 
(?i)(?s)(?<BlockComment>/\*.*?\*/)|(?#
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
	Process
	{
		if (!([string]::IsNullOrEmpty($Filepath))) {
             $SQLString = Get-Content -path $Filepath } #get from a filepath if it is provided
		$exceptions = @(0, 'BlockComment', 'EndOfLineComment') #things we want to ignore
		$parserRegex.Matches($SQLString).Groups | foreach -begin { $script = '' }{
			if ($_.success -eq $true -and $_.name -ne 0 -and $_.name -notIn $exceptions)
			{
				$script += " $($_.Value.ToLower())"
			}
		} -end {
			$mystream = [IO.MemoryStream]::new([byte[]][char[]]($script)
				
			); #no calculated the hash
			Get-FileHash -InputStream $mystream -Algorithm SHA256 | select -ExpandProperty Hash
		}
	}
}

# can it spot that the code is the same when comments change or the SQL is formatted?
@( <# with initial blockquote #>@'
/* Complex update with case and subquery */
UPDATE Inventory
SET StockLevel = CASE
WHEN StockLevel < 10 THEN StockLevel + 5
ELSE (SELECT AVG(StockLevel) FROM Inventory WHERE CategoryID = Inventory.CategoryID)
END
WHERE ProductID = 101;
'@,<# with initial blockquote #>@'
UPDATE Inventory
SET StockLevel = CASE --alter stocklevel of low items
WHEN StockLevel < 10 THEN StockLevel + 5
ELSE (SELECT AVG(StockLevel) FROM Inventory WHERE CategoryID = Inventory.CategoryID)
END
WHERE ProductID = 101;
'@,<# Test in initial caps #>@'
Update Inventory
Set Stocklevel = Case --Alter Stocklevel Of Low Items
When Stocklevel < 10 Then Stocklevel + 5
Else (Select Avg(Stocklevel) From Inventory Where Categoryid = Inventory.Categoryid)
End
Where Productid = 101;
'@,<# upper case #>@'
UPDATE INVENTORY SET STOCKLEVEL = CASE --ALTER STOCKLEVEL OF LOW ITEMS
WHEN STOCKLEVEL < 10 THEN STOCKLEVEL + 5
ELSE (SELECT AVG(STOCKLEVEL) FROM INVENTORY WHERE CATEGORYID = INVENTORY.CATEGORYID)
END
WHERE PRODUCTID = 101;
'@,<# reformatted #>@'
UPDATE Inventory
  SET Stocklevel = CASE --Alter Stocklevel Of Low Items
                     WHEN Stocklevel < 10 THEN Stocklevel + 5 ELSE
                     (SELECT Avg (Stocklevel) FROM Inventory WHERE
                      Categoryid = Inventory.Categoryid) END
  WHERE Productid = 101;
'@)|Get-SQLCodeHash|foreach -begin{$ii=0;$previousHash =''}{
    if($ii -gt 0){
    if ($previousHash -ne $_){write-warning "Hash No. $($ii+1) doesn't match the previous one"}
    $previousHash =  $_
    $ii++
    }
  }

# can it spot differences in the SQL
$TestItems=  @( <# sql query #>@'
/* Complex update with case and subquery */
UPDATE Inventory
SET StockLevel = CASE
WHEN StockLevel < 10 THEN StockLevel + 5
ELSE (SELECT AVG(StockLevel) FROM Inventory WHERE CategoryID = Inventory.CategoryID)
END
WHERE ProductID = 101;
'@,<# changed stocklevel criterion  #>@'
/* Complex update with case and subquery */
UPDATE Inventory
SET StockLevel = CASE
WHEN StockLevel < 5 THEN StockLevel + 5
ELSE (SELECT AVG(StockLevel) FROM Inventory WHERE CategoryID = Inventory.CategoryID)
END
WHERE ProductID = 101;
'@,<# changed the aggregate function #>@'
/* Complex update with case and subquery */
UPDATE Inventory
SET StockLevel = CASE
WHEN StockLevel < 10 THEN StockLevel + 5
ELSE (SELECT SUM(StockLevel) FROM Inventory WHERE CategoryID = Inventory.CategoryID)
END
WHERE ProductID = 101;
'@)
if ($TestItems.count -ne (($TestItems|Get-SQLCodeHash|Sort-object -unique).count))
    {write-warning "one or more of the hashes were the same. and shouldn't be"}
