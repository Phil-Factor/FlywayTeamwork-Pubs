<#
	.SYNOPSIS
		This creates a SQL script into an HTML document (string) suitably colourised just like the IDE
	
	.DESCRIPTION
		This routine is designed to convert a sQL script into HTML that can be viewed in a browser or browser-based IDE. At the moment, the colours are based on SSMS, but it is easy to tweak it for the colourisation scheme that developers are used to.
		The HTML header and footer can be specified
		
		.DEPENDENCY
		uses the SQL Tokenizer Tokenize_SQLString
	
	.PARAMETER SQLScript
		The SQL Script as a string that you wish to colourize as HTML.
	
	.PARAMETER TheTitle
		The Title of the HTML  document
	
	.PARAMETER HTMLHeader
		The header of the HTML  document
	
	.PARAMETER HTMLFooter
		The footer of the HTML document
	
	.PARAMETER MaxLength
		The maximum amount of the file that we bother with
	
	.PARAMETER SavedTokenStream
		If not null, the file to save your token stream to.
	
	.EXAMPLE
		Convert-SQLtoHTML -SQLScript 'Select * from The_Table' -SavedTokenStream 'MyTokens' > "<myPathTo>colorised.html"
		Start-Process -FilePath "<myPathTo>colorised.html"
	

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
		[int]$MaxLength = 182400,
		[Parameter(HelpMessage = 'If not null, the file to save your token stream to ')]
		[string]$SavedTokenStream =$null
	)
	
	Begin
	{
		$HTMLHeader = $HTMLHeader -ireplace '<TheTitle>', $TheTitle
		if ($MaxLength -ne $null)
		{
			if ($SQLScript.Length -gt $MaxLength)
			{
				Write-verbose "truncating huge migration of $($SQLScript.Length) bytes long to $MaxLength"
				$SQLScript = $SQLScript.Substring(0, $MaxLength)
			}
		}
	}
	Process
	{
		$HTMLString = $SQLScript
		$tokens = Tokenize_SQLString $SQLScript
		if ($SavedTokenStream -ne $null) { $tokens | ConvertTo-json -Compress >$SavedTokenStream}
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
				'custom' { 'Magenta' }
				'standard' { 'Black' }
				'expression'{ ' Grey' }
				'Query'{ 'Blue' }
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
		} -End { "$HTMLHeader<font color=`"$nextcolor`">$HTMLString$HTMLfooter" }
		
	}
}

#---Sanity checks 
if ((Convert-SQLtoHTML -SQLScript 'Select * from The_Table') -ne @'
<!DOCTYPE html>
<html>
<head>
    <title>The SQL Code</title>
</head>
<body>
    <pre><font color="Blue">Select</font><font color="black"> *</font><font color="Blue"> from</font><font color="black"> The_Table</font></pre>
</body>
</html>
'@) {Write-warning "Something isn't right with Convert-SQLtoHTML"}
