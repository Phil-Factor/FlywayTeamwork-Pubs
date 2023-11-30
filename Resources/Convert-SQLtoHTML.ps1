<#
	.SYNOPSIS
		This creates a SQL script into an HTML document (string) suitably colourised just like the IDE 
	
	.DESCRIPTION
		This routine is designed to convert a sQL script into HTML that can be viewed in a browser or browser-based IDE. At the moment, the colours are based on SSMS, but it is easy to tweak it for the colourisation scheme that developers are used to. 
		The HTML header and footer can be specified
	
	.DEPENDENCY
		uses the SQL Tokenizer Tokenize_SQLString

    .PARAMETER SQLScript
		A description of the SQLScript parameter.
	
	.PARAMETER HTMLHeader
		The header of the HTML  document
	
	.PARAMETER HTMLFooter
		The footer of the HTML document

	.PARAMETER MaxLength
		The maximum amount of the file that we bother with
	
	.EXAMPLE
		Convert-SQLtoHTML -SQLScript 'Select * from The_Table'
        Start-Process -FilePath "C:\Users\andre\Documents\colorised.html"
#>
function Convert-SQLtoHTML
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[string]$SQLScript,
        [Parameter(HelpMessage = 'The Title the HTML  document')]
		[string]$TheTitle = 'The SQL Code',
        [Parameter(HelpMessage = 'The header of the HTML  document')]
		[string]$HTMLHeader = '<!DOCTYPE html>
<html>
<head>
    <title><TheTitle></title>
</head>
<body>
    <pre>',
		[Parameter(HelpMessage = 'The footer of the HTML document')]
		$HTMLFooter = '</pre>
</body>
</html>',
        [Parameter(HelpMessage = 'The maximum length of the HTML document to be converted')]
		[int]$MaxLength = 182400
	)
	
	Begin
	{
	$HTMLHeader = $HTMLHeader -ireplace '<TheTitle>', 'My Splendid Title'
    if ($MaxLength -ne $null)
        {
        if ($SQLScript.Length -gt $MaxLength) {
            Write-verbose "truncating huge migration of $($SQLScript.Length) bytes long to $MaxLength"
            $SQLScript=$SQLScript.Substring(0,$MaxLength)
            }	
	    }
    }
	Process
	{
		$HTMLString = $SQLScript
		$tokens = Tokenize_SQLString $HTMLString
		[array]::Reverse($tokens)
		$tokens | foreach -Begin { $NextColor = ''; }{
			$TokenName = $_.name;
			$TokenType = $_.type;
			$Currentcolor = switch ($TokenName)
			{
				'JavaDoc'          { 'darkgreen' }
				'BlockComment'     { 'darkgreen' }
				'EndOfLineComment' { 'darkgreen' }
				'String'{ 'red' }
				'number'{ 'black' }
				'custom' {'Magenta'}
				'standard' {'Black'}
                'expression'{ ' Grey'}
                'Query'{ 'Blue'}
                'reference'{ 'black' }
				'Identifier' { 'black' }
				'Operator' { 'black' }
				'Punctuation' { 'Gray' }
				default { write-warning "$TokenName" }
			}
			if ($nextcolor -ne $CurrentColor)
			{
				if ($NextColor -eq '')
				{ $HTMLString = $HTMLString.Insert($_.index + $_.length, "</font>") }
				else
				{
					$HTMLString = $HTMLString.Insert($_.index + $_.length, "</font><font color=`"$nextcolor`">")
				}
				$nextcolor = $CurrentColor;
			}
			$previousToken = $_.Value;
		} -End { "$HTMLHeader<font color=`"$nextcolor`">$HTMLString$HTMLfooter"}
				
	}
}
