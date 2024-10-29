<#
	.SYNOPSIS
		Gets a hash of the actual SQL code, ignoring formatting and comments. Requires Tokenize_SQLString 
	
	.DESCRIPTION
		This function uses Tokenise-SQLString to calculate the SHA256 checksum of a SQL String, ignoring extra whitespace, block comments and end-of-line comments 
	
	.PARAMETER SQLString
		The sql code as a string.
	
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
	
	.NOTES
		Additional information about the function.
#>
function Get-SQLCodeHash
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[string]$SQLString
	)
	
	Begin
	{
		
	}
	Process
	{
		$mystream = [IO.MemoryStream]::new([byte[]][char[]](
				$SQLString |Tokenize_SQLString| where {
					$_.name -notin ('BlockComment', 'EndOfLineComment')
				} | foreach -Begin { $skinnedSQL = '' }{
					$skinnedSQL += "$($_.value.ToLower()) "
				} -End { $skinnedSQL }
			)
		);
		Get-FileHash -InputStream $mystream -Algorithm SHA256 | select -ExpandProperty Hash
	}
	End
	{
		
	}
}

if ((
@'
WITH SalesCTE AS (
    SELECT p.ProductID, SUM(s.Quantity) AS TotalQuantity
    FROM Sales s
    INNER JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.SaleDate BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY p.ProductID
)
SELECT p.ProductName, c.CategoryName, sc.TotalQuantity
FROM SalesCTE sc
JOIN Products p ON sc.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY sc.TotalQuantity DESC;
'@ |Get-SQLCodeHash) -ne (
@'
WITH SalesCTE /* get the total quantity for each product 
between the two dates */
AS (SELECT p.ProductID, Sum (s.Quantity) AS TotalQuantity
      FROM
      sales s
        INNER JOIN Products p
          ON s.ProductID = p.ProductID
      WHERE
      s.SaleDate BETWEEN '2023-01-01' AND '2023-12-31'
      GROUP BY p.ProductID)
  SELECT p.ProductName, c.CategoryName, sc.TotalQuantity
    FROM
    SalesCTE sc --execute the CTE 
      JOIN Products p
        ON sc.ProductID = p.ProductID
      JOIN Categories c
        ON p.CategoryID = c.CategoryID
    ORDER BY sc.TotalQuantity DESC;
'@|Get-SQLCodeHash)){
Write-warning 'Test 1 of Get-SQLCodeHash failed'
}
















