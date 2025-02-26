
$Testing=$true;

<#
	.SYNOPSIS
		Converts a string containing a CFG, Conf, or .INI file (not full TOML) into 
        the corresponding powershell Hashtable
	
	.DESCRIPTION
		This routine will interpret an INI file, including one  that contains nested 
        sections or multi-line strings into a Powershell Object. It doesn't do elaborate
        syntax checks or TOML array extensions.
	
	.PARAMETER ConfigLinesToParse
		The  String containing the INI or Config lines, usually read from a file
	
	.EXAMPLE
				PS C:\> ConvertFrom-INI -ConfigLinesToParse 'Value1'
	
	.NOTES
		
#>
function ConvertFrom-INI
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[string]$ConfigLinesToParse
	)
	
	Begin
	{
		$UsedArrayNames = @();
		$UsedObjectNames = @();
        $ArrayPosition=@{}
        $Basename='';
        $CurrentElement=-1
		$CurrentLocation = $null; # used for remembering sections to resolve relative subsections
  
		# first we define our scriptblocks, used for private routines within the task 
		
	
$ConvertStringToNativeValue = {
    param (
        [string]$InputString
    )

    # Remove underscores for readability (applies to all formats)
    $cleanedInput = $InputString.Replace('_', '')

    if ($cleanedInput -match '^(?:\+|-)?\d+$') {
        # Integer (e.g., +99, -17, 0)
        return [int]$cleanedInput
    } elseif ($cleanedInput -match '^0x[0-9a-fA-F]+$') {
        # Hexadecimal (e.g., 0xDEADBEEF)
        return [convert]::ToInt64($cleanedInput, 16)
    } elseif ($cleanedInput -match '^0o[0-7]+$') {
        # Octal (e.g., 0o755)
        return [convert]::ToInt64($cleanedInput.Substring(2), 8)
    } elseif ($cleanedInput -match '^0b[01]+$') {
        # Binary (e.g., 0b11010110)
        return [convert]::ToInt64($cleanedInput.Substring(2), 2)
    } elseif ($cleanedInput -match '^(?:\+|-)?\d*\.?\d+(?:e[+-]?\d+)?$') {
        # Float or scientific notation (e.g., 3.1415, 5e+22)
        return [double]$cleanedInput
    } elseif ($cleanedInput -match '[ +1\r\n]inf') {
        # Infinity (e.g., +inf, -inf)
        if ($cleanedInput -like '-inf') 
        {return [double]::NegativeInfinity } 
        else {return [double]::PositiveInfinity }
    } elseif ($cleanedInput -match '^(?:\+|-)?nan$') {
        # NaN (e.g., nan, +nan, -nan)
        return [double]::NaN
    } else {
        return $InputString -replace "^[`"\'](.*)[`"\']$", '$1' 
    }
}

<#	
	.DESCRIPTION
	===========================================================================
	$BuildInlineTableorArray compiles a TOML nested array or hashtable e.g.
	{table = [ { a = 42, b = "test" }, {c = 4.2} ]}
	or
    [ { x = 1, y = 2, z = 3 },
    { x = 7, y = 8, z = 9 },
    { x = 2, y = 4, z = 8 } ]
    ===========================================================================
#>
$BuildInlineTableorArray = {<# compile nested hashtables and arrays #>
	Param ([string]$String)
	$Stacklength = 20 #the depth of the arrays and tables.
	$VerbosePreference = 'continue'
	$TheStack = @(0) * $stacklength; $Stackpointer = 0 # set up the stack
	([regex]@"
(?#  Regex for inline tables and arrays
Octal value       )(?<Octal>0o[\d0-7]*)(?# 
LocalTime         )|(?<LocalTime>\d\d:\d\d:\d\d[.\d]*)(?#
OffsetDateTime    )|(?<OffsetDatetime>\d{4}-\d\d-\d\dT\d\d:.*)(?#
DateTime          )|(?<Date>\d{4}-\d\d-\d\d*)(?#
hex value         )|(?<Hex>0x[\d0-9|\wa-f]*)(?#
binary value      )|(?<Bin>0b[\d0-1]*)(?#
Not a number or infinity)|(?<NAN>[-+]?NAN|INF)(?#
Boolean           )|(?<Boolean>true|false)(?#
integer value     )|(?<Int>[-+]?\d{1,12}?)(?#
Scientific float notation)|(?<Float>[-+]?(?:\b[0-9_]+(?:\.[0-9_]*)?|\.[0-9]+\b)(?:[eE][-+]?[0-9]+\b)?)(?# 
BareString          )|(?<BareString>[\.\w\:/]{1,100}(?=,)|(?<=)[\.\w\:/]{1,100})(?# 
bare key          )|(?<Barekey>\w{1,40})(?# 
Multiline String  )|"""(?<MultiLineQuotedLiteral>(?s:.)*?)"""(?# 
single-quoted Multiline String )|'''(?<MultiLinedelimitedLiteral>(?s:.)*?\s?)'''(?# 
Quoted " string   )|"(?<QuotedLiteral>[^"]*?)"(?# 
Delimited ' string)|'(?<delimitedLiteral>[^']*?)'(?# 
Array Start       )|(?<ArrayStart>\[)(?# 
Array End         )|(?<ArrayEnd>\])(?# 
Table Start       )|(?<TableStart>\{)(?# 
Table End         )|(?<TableEnd>\})(?# 
Separator         )|(?<Separator>,)
"@).matches($String).Groups | sort-object -property index -Descending | where {
		$_.success -eq $true -and $_.Length -gt 0 -and $_.name -ne '0'
	} | foreach -begin { $Conversion = $string }{
		$Name = $_.Name; $value = $_.Value; $Index = $_.Index; $Length = $_.Length;
		$insertion = switch ($name)
		{
			'TableStart' { '@{' } 'TableEnd' { '}' }
			'ArrayEnd' { ')' } 'ArrayStart' { '@(' }
			'MultiLineDelimitedLiteral' { "@`"`n$value`n`"@" }
			'MultiLineQuotedLiteral' { "@'`n$value`n`'@" } # need to deal with escape codes
			'DelimitedLiteral' { "$value" }
			'QuotedLiteral' { "$value" } # need to deal with escape codes
			'BareString' { "`"$value`"" } # 
			'BareKey' { "$value" } # 
			'Octal' { [Convert]::ToInt32($value, 8) } # 
			'LocalTime' { [timespan]::Parse("$value") } # 
			'OffsetDateTime' { [datetimeoffset]::Parse("$value") } # 
			'Date' {[datetime]::Parse("$value")}
			'Hex' { "$value" } # 
			'bin' { [convert]::ToInt32("$value", 2) } # 
			'NAN' { switch ( $Value){  '-INF' {'[double]::NegativeInfinity' }
            'INF' {'[double]::PositiveInfinity' } default { '[double]::NaN' }}} # 
			'Float' { "$value" } # 
			'int' { "$value" } # 
			'boolean' { "`$$value" } # 
			'Separator' {
				if ($TheStack[$Stackpointer] -eq 'table') { ';' }
                elseif ($ArrayEnd) {''}
				else { ',' }
			}
			default { '' }
		}
        $ArrayEnd=$false
        #we emulate a recursive technique 
		if ($name -eq 'ArrayEnd') { $TheStack[++$Stackpointer] = 'array'; $ArrayEnd=$true }
		elseif ($name -eq 'TableEnd') { $TheStack[++$Stackpointer] = 'table' }
		elseif ($name -in @('ArrayStart', 'TableStart')) { $Stackpointer-- }
        #remove existing delimiters
        if ($name -in @('MultiLineDelimitedLiteral','MultiLineQuotedLiteral'))
            {$offset=3} else {$offset=0};
		$BeforeRange = $Conversion.Substring(0, $index-$offset)
		$AfterRange = $Conversion.Substring($index+$offset + $Length)
		# Concatenate the parts with the new substring
		$Conversion = $BeforeRange + $insertion + $AfterRange
	} -end {
		#now turn the script into a hashtable/array
		$allowedCommands = @('Invoke-Expression')
		# Convert the array to a List<string> using array cast
		$allowedCommandsList = [System.Collections.Generic.List[string]]($allowedCommands)
		$lookingDodgy = $false
        # write-verbose "conversion was $Conversion"
		$scriptBlock = [scriptblock]::Create($Conversion)
		try { $scriptBlock.CheckRestrictedLanguage($allowedCommandsList, $null, $true) }
		catch
		{
			$lookingDodgy = $True
			Write-error " '$conversion' is not Valid Powershell Object Notation!"
		}
		if (!($lookingDodgy))
		{
			try { $scriptBlock.invoke() }
			catch { Write-error " '$conversion' is not Valid Powershell Object Notation!" }
		}
	} #End of the (end of the) foreach loop
} # end of the scriptblock
	
#a utility scriptblock to convert escaped characters in delimited strings
		$ConvertEscapedChars = {
			Param ([string]$String)
			@(@('\A"""[\t\r\n]{0,2}|"""\z', ''), @("\A'''[\t\r\n]{0,2}|'''\z", ''), @('\A"|"\z', ''),@("\A'|'\z", ''),
				@('\\\\', '\'), @("\\(?-s)\s+", ''), @('\\"', '"'), @('\\n', "`n"), @('\\t', "`t"),
				@('\\f', "`f"), @('\\b', "`b"), @('\\f', "`f")) |
			foreach {
				$String = $String -replace $_[0], $_[1]
			}
			[string]$String
		}
		#a utility scriptblock to convert unicode characters
		$ConvertEscapedUnicode = {
			Param ([string]$String) # $FormatTheBasicFlywayParameters (Don't delete this)
			
			([regex]'(?i)\\U\s*(?<Unicode>[0-9A-F]+)(?#Find All Unicode Strings)').matches($String) |
			sort-object -property index -Descending | foreach{
				$_.Groups | where { $_.success -eq $true } | foreach {
					if ($_.Name -eq '0') { $UnicodeStart = $_.index; $UnicodeLength = $_.Length }
					if ($_.Name -eq 'Unicode') { $UnicodeHexValue = $_.Value; }
				}
				
				$String = $String.Substring(0, $UnicodeStart) + [char][int]"0x$UnicodeHexValue" + $String.Substring($UnicodeStart + $UnicodeLength)
			}
			[string]$String
		}
		#a utility for splitting lists of strings
		$ParseStringArray = {
			Param ($String,
				$LD = ',')
			#write-verbose "delimiter $ld"
			([regex]@"
                  """(?<MultiLineQuotedLiteral>(?s:.)*?)"""$($LD)?\s?(?# Multiline String
                )|'''(?<MultiLinedelimitedLiteral>(?s:.)*?\s?)'''$($LD)?\s?(?# single-quoted Multiline String
                )|"(?<DoubleQuoted>(?<!\\").*?(?<!\\))"$($LD)?\s?(?# quoted " string
                )|'(?<delimited>[^']*)'$($LD)?\s?(?# Delimited ' string
                )|\s*(?<literal>[^$($LD)]*)$($LD)?\s?(?# Bare literal
                )
"@).matches($String) | foreach{
				$_.Groups | where {
					$_.success -eq $true -and $_.Length -gt 0 -and $_.name -ne '0'
				} | Sort-Object index | foreach {
                write-verbose "$string was a $($_.Name) sort of string"
					if ($_.Name -in ('MultiLineQuotedLiteral', 'DoubleQuoted'))
					{
						$ConvertEscapedChars.Invoke($ConvertEscapedUnicode.Invoke($_.value));
					}
					else { $_.value };
				}
			}
		}
		
		
	}
	Process
	{
	<# This script is for converting INI/Conf files to a hash table in PowerShell, 
with the addition of handling TOML-like nested structures processes the
INI/Conf file lines, creates a hash table, and handles nested sections using
a dotted notation. #>
		
		# Regex for parsing comments, sections, and key-value pairs
		$parserRegex = [regex]@'
(?<CommentLine>[#;](?<Value>.*))(?# Matches lines or end of lines starting with # or ;.
)|(?<ArrayOfTables>(?m:^)[\s]*?\[\[(?<Value>.{1,200}?)\]\])(?# Matches array of tables enclosed in [[]].
)|(?<section>(?m:^)[\s]*?\[(?<Value>.{1,200}?)\])(?# Matches section headers enclosed in [].
)|(?<MultilineLiteralKeyValuePair>(?m:^)[^=]{1,200}[ ]*?=[ ]*?'''(?s:.)+?[^\\]''')(?# Multi-line literal -' Key-Value Pair
)|(?<MultilineQuotedKeyValuePair>(?m:^)[^=]{1,200}[ ]*?=[ ]*?"""(?s:.)+?[^\\]""")(?# Multi-line quoted -" Key-Value Pair
)|(?<ArrayPair>(?m:^)[^=]{1,200}[ ]*?=[ ]*?(?<Value>\[(?s:.)+?\])\s*(?m:$))(?# Array [] possibly multiline
)|(?<InlineTable>(?<InlineSection>(?m:^)[^=]{1,200})[ ]*?=[ ]*?\{(?<list>(?s:.)+?)\})(?# Inline Table Key/value pairs {} possibly multiline
)|(?<QuotedKeyValuePair>(?m:^)[ ]*?[^=\r\n]{1,200}[ ]*?=[ ]*?".+")(?# Quoted Key-Value Pair
)|(?<DelimitedKeyValuePair>(?m:^)[ ]*?[^=\r\n]{1,200}[ ]*?=[ ]*?'.+?')(?# Delimited Key-Value Pair
)|(?<KeyCommaDelimitedValuePair>(?m:^).{1,40}=(?:'[^']*'|\b\w+\b)\s*,\s*(?:'[^']*'|\b\w+\b)(?:\s*,\s*(?:'[^']*'|\b\w+\b))*)(?# 
Matches key-value pairs where the value is a simple comma-delimited list
)|(?<KeyValuePair>(?m:^)[^=\r\n]{1,200}[ ]*?=[ ]*?[^#\r\n]{1,200})(?# Matches key-value pairs separated by =.
)
'@
# was
#)|(?<KeyValuePair>(?m:^)[ ]*?[[^=\s]]{1,40}[ ]*?=[ ]*?.{1,200})(?# Matches key-value pairs separated by =.
#)		
		# Parse the input string into a collection of matches based on the Regex
		# first take out line folding, '\' followed by linebreak plus indent
		# for backward compatibility
		$ConfigLinesToParse = $ConfigLinesToParse -ireplace '\\[\n\r]+\s*', ''
		# unwrap any inline tables *** replace this next line ***
		# $ConfigLinesToParse = $UnwrappedInlineTables.Invoke($ConfigLinesToParse)
		$allmatches = $parserRegex.Matches($ConfigLinesToParse)
		
		# Initialize variables
		$Comments = @(); $ObjectName = ''; $IniHashTable= @{ }
		$current = @{ } ;$ItsASection=$True
		
<# Process each match. For each match, determine the type (comment, section,
or key-value pair) and process accordingly.#>
		$allmatches | foreach -begin { $LocationList = @() }{
			$State = 'GetKVPair';
			$_.Groups | where { $_.success -eq $true -and $_.name -ne 0 }
		} | # Convert matches to objects with necessary properties
		Select name, index, length, value | Sort-Object index | foreach {
			$MatchName = $_.Name;
			$MatchValue = $_.Value;
            write-verbose "the match was '$matchname' giving $MatchValue"
			# Comments: Capture comment lines if needed.
			if ($MatchName -eq 'commentline')
			{
				# Handle comment lines
				$state = 'getCommentvalue'
			}
			elseif ($MatchName -eq 'value' -and $state -eq 'getCommentvalue')
			{
				# Capture comment value
				$Comments += $_.Value
				$State = 'GetKVPair'
			}
			#Sections: Update the current section name whenever necessary.
			elseif ($MatchName -eq 'section')
			{
				# Handle section headings
				$state = 'getSectionvalue'
			}
            elseif ($MatchName -eq 'ArrayOfTables')
			{
				# Handle section headings
				$state = 'getArrayOfTablevalues'
			}
			elseif ($MatchName -eq 'value' -and $state -eq 'getSectionvalue')
			{
				# Capture section value
				if ($_.Value -match '\A\s*\.') #it is a section nesting
				{
					if ($CurrentLocation -eq $null) { Error "subsection without a preceding section" }
					$ObjectName = $CurrentLocation + $_.Value
                    $ItsASection=$True;
				}
				else #Straightforward  section
				{
					$ObjectName = $_.Value
					$CurrentLocation = $ObjectName; #Remember in case there is more than one subsection
				}
				$LocationList = $ParseStringArray.Invoke($ObjectName, '\.')
				$State = 'GetKVPair'
			}
            elseif ($MatchName -eq 'value' -and $state -eq 'getArrayOfTablevalues')
			{
				$ObjectName = $null; #so we know it isn't a section (object)
				$ArrayName = $_.Value #could be dotted, denoting a # nested array of tables
				If ($ArrayName -notin $UsedArrayNames) { $UsedArrayNames += $ArrayName }
                #cope with a dotted array
				$ArrayList = $ParseStringArray.Invoke($ArrayName, '\.')
                $ArrayPosition = $IniHashTable
				$ArrayList | Select -First ($ArrayList.count - 1) | foreach -Begin { $ArrayPosition = $IniHashTable } {
					$key = $_.Trim()
                    #if it doesn't exist create an object
					if (-not $ArrayPosition.Contains($key)) { $ArrayPosition[$key] = @{ } }
					$ArrayPosition = $ArrayPosition[$key]
				}
                #if our array is new and empty 
                $Basename= $($ArrayList[$ArrayList.count - 1])
                # we have $Basename $($ArrayPosition.GetType().Name) and  $($ArrayPosition|convertto-json -Compress)
                if ($ArrayPosition.GetType().Name -eq 'Hashtable') {
                    write-verbose " it is a Hashtable $($ArrayPosition|convertto-json -Compress)"                   
                    if  (!($ArrayPosition.Contains($Basename)))
				    {
					    $ArrayPosition.$Basename=[System.Collections.ArrayList]::new()
                    }
                    $ArrayPosition.$Basename+=@{}
                }
                elseif  ($ArrayPosition.GetType().Name -eq 'object[]')
                    {
                    write-verbose "the object is $($ArrayPosition.Count) long having $($ArrayPosition[$ArrayPosition.Count-1]|ConvertTo-json -Compress)"
                    if ($Basename -notin $ArrayPosition[$ArrayPosition.Count-1].Keys)
                        {$ArrayPosition[$ArrayPosition.Count-1]+=@{$Basename=[System.Collections.ArrayList]::new()}}
                    #$ArrayPosition.$Basename+=@{}
                    write-verbose " it is an object $($ArrayPosition|convertto-json -Compress)"                   
                    }
				else
                    {Write-Verbose "Lost $Basename" }
                
                $ItsASection=$False; 

                $State = 'GetKVPair'
			}
			else
			{
<#Key-Value Pairs: Split and trim the key and value. Handle nested keys 
 by splitting on . and creating necessary nested hash tables.#>
				if ($MatchName -in ('MultilineLiteralKeyValuePair', 'QuotedKeyValuePair', 'MultilineQuotedKeyValuePair',
						'DelimitedKeyValuePair', 'KeyValuePair', 'KeyCommaDelimitedValuePair', 'ArrayPair', 'InlineTable'))
				{
					# Process key-value pairs
					# if the value has no dot, it is a relative reference. if it  starts with a dot, it is
					# a relative reference, otherwise it must be an absolute reference
					# Split the expression into key and value, removing leading dot if present
					Write-verbose "The matchname was '$MatchName'"
					#$Assignment = "$($_.Value)" -ireplace '\A\s*\.', '' -split '=' | foreach{ "$($_)".trim() }
					$Assignment = $MatchValue  -split '=', 2 | foreach { "$($_)".trim() }
					# if there is no section, the lvalue contains the location 
					# or if the lvalue is relative just combine the two
					$Rvalue = "$($Assignment[1])".Trim();
					$Lvalue = $Assignment[0].trim();
					if ($Matchname -in ('InlineTable')) #it is an array, assigned to a key
					{
						Write-verbose "InlineTable for '$lvalue' '$Rvalue' being processed"
						$Rvalue = ($BuildInlineTableorArray.invoke($RValue))[0]####
					}
                    elseif ($Matchname -in ('arraypair'))
                    {
                        Write-verbose "Arraypair for '$lvalue' '$Rvalue' being processed"
					    $Rvalue = ($BuildInlineTableorArray.invoke($RValue))
                    }

					elseif ($Matchname -in ( 'MultilineQuotedKeyValuePair',	'QuotedKeyValuePair',
                                             'MultilineLiteralKeyValuePair',	'DelimitedKeyValuePair'))
					{
						$RValue=$ConvertEscapedChars.Invoke($ConvertEscapedUnicode.Invoke($Rvalue)) -join "";
					}
                    elseif ($Matchname -eq 'KeyCommaDelimitedValuePair')
					{
						Write-verbose "array $RValue"
                        $RValue = $BuildInlineTableorArray.invoke($RValue);
 					}
					else
					{   Write-verbose "$Matchname that is '$RValue'"
						if ($RValue -like '*,*') #it is a list 
						{ $RValue = $BuildInlineTableorArray.invoke($RValue) }
						else { $RValue = $ConvertStringToNativeValue.invoke($RValue)[0] }#sreingarray
					}
                    #$ParseStringArray.invoke('pinky,perky,bill,ben')
					$ObjectHierarchy = $ParseStringArray.Invoke($LValue, '\.')
					# if there is no defined location and there is no initial dot 
					#then use the LValue as the location
					If ($LocationList.Count -gt 0)
					{ $tree = $LocationList + $ObjectHierarchy }
					Else
					{
						$tree = $ObjectHierarchy
					}
                    if ($ItsASection)
                    {
					    # now we figure out where to put it
					    # Traverse the tree to create necessary nested structures
					    $tree | Select -First ($tree.count - 1) | foreach -Begin { $current = $IniHashTable } {
						    $key = $_.Trim()
						    if (-not $current.Contains($key))
						    {
							    $current[$key] = @{ }
						    }
						
						    $current = $current[$key]
					    }
					    # Set the value at the appropriate key in the nested structure.
					
					    $AssignedValue = $Rvalue
					    if ($current[$tree[$tree.count - 1]] -eq $null)
					    {Try
						   { $current[$tree[$tree.count - 1]] = $AssignedValue}
                        catch {write-warning "Key $key redefined with $AssignedValue"}
					    }
					    else { write-warning "Attempt to redefine Key $lvalue with '$AssignedValue'" }
                    }
                    else #then it is an array
                    {
                    Write-Verbose "writing $Basename at $($ArrayPosition.GetType().Name) which is   $($ArrayPosition|ConvertTo-json -Compress)"
                    if ($ArrayPosition.GetType().Name -eq 'Hashtable')
                        {$ArrayPosition.$Basename[$ArrayPosition.$Basename.count-1] += @{ $lvalue = $rvalue }}
                    else
                        {Write-Verbose " we are trying to write to the $basename array at $($ArrayPosition.$Basename) that has keys $($ArrayPosition.Keys -join ',')"
                        $ArrayPosition[$ArrayPosition.count-1].$Basename += @{ $lvalue = $rvalue }}
                    }
				}
				else
				{
					# Handle unexpected cases
					Write-verbose "Unidentified object '$ObjectName' named '$($_.Name)' of value '$($_.Value)'"
				}
			}
		}
	}
	End
	{
		$IniHashTable
	}
}

If ($Testing){

$VerbosePreference = 'Silentlycontinue'

@( #Beginning if tests	
<# sample test
 @{'Name'='value'; 'Type'='equivalence/Equlity/ShouldBe/test etc'; 'Ref'=@'
'@; 'Diff'=@' 
'@}
#>
	
	
	@{
		'Name' = 'Dotted Section'; 'Type' = 'equivalence';
		'Ref' = @'
[dog."tater.man"]
type.name = "pug"
'@; 'Diff' = @' 
[dog."tater.man".type]
name = "pug"
'@
	},
	@{
		'Name' = 'Single Entry Array'; 'Type' = 'ShouldBe'; 'Ref' = @'
[flyway]
mixed = true
outOfOrder = true
locations = ["filesystem:migrations"]
validateMigrationNaming = true
defaultSchema = "dbo"

[flyway.placeholders]
placeholderA = "A"
placeholderB = "B"
'@; 'ShouldBe' = @{
			'flyway' = @{
				'url' = 'jdbc:mysql://localhost:3306/customer_test?autoreconnect'; 'placeholders' = @{
					'email_type' = @{
						'work' = 'Traba'; 'primary' = 'Primario'
					}; 'phone_type' = @{ 'home' = 'Casa' }
				};
				'password' = 'pa$$w3!rd'; 'driver' = 'com.mysql.jdbc.Driver';
				'locations' = 'filesystem:src/main/resources/sql/migrations';
				'schemas' = 'customer_test'; 'user' = 'sysdba'
			}
		}
	},
	# test of an array with a trailing comma
	@{
		'Name' = 'array of values with trailing comma'; 'Type' = 'ShouldBe';
		# The ini code
		'Ref' = @'
array1 = ["value1", "value2", "value3,"] 
'@;
		# The PSON 
		'Shouldbe' = @{ 'array1' = @('value1', 'value2', 'value3') }
	},
	# test of a map
	@{
		'Name' = 'map of values'; 'Type' = 'ShouldBe';
		# The ini code
		'Ref' = @'
array1 = ["value1", "value2", "value3,"] 
'@;
		# The PSON 
		'Shouldbe' = @{ 'array1' = @('value1', 'value2', 'value3') }
	},
	# The quick brown fox equivalence test
	@{
		'Name' = 'folding of strings'; 'Type' = 'test';
		'Ref' = @'
# The following strings are byte-for-byte equivalent:
[truisms]
str1 = "The quick brown fox jumps over the lazy dog."
str2 = """
The quick brown \


  fox jumps over \
    the lazy dog."""
str3 = """\
       The quick brown \
       fox jumps over \
       the lazy dog.\
       """

'@;
		'test' = {
			param ($test)
			$test.truisms.str1 -eq $test.truisms.str1 -and $test.truisms.str1 -eq $test.truisms.str3
		}
	}
	# End of tests
) | foreach{
	$FirstString = $_.Ref; $SecondString = $_.Diff; $ShouldBe = $_.Shouldbe; $Test = $_.test;
	if ($_.Type -notin ('equality', 'equivalence', 'shouldbe', 'test'))
	{ Write-error "the $($_.Name) $($_.Type) Test was of the wrong type" }
	if ($FirstString -eq $null)
	{ Write-error "no reference object in the $($_.Name) $($_.Type) Test" }
	$ItWentWell = switch ($_.Type)
	{
		'Equivalence' {
			# Are they exactly equivalent (not necessarily correct) ?
			(($FirstString | convertfrom-ini | convertTo-json -depth 5) -eq
				($SecondString | convertfrom-ini | convertTo-json -depth 5))
		}
		'Equality' {
			# Are is it the same as the supplied Javascript ? (where you have a checked result))
			# caution as hashtables aren't ordered.
			(($FirstString | convertfrom-ini | convertTo-json -depth 5) -eq $SecondString)
		}
		'Test' {
			# does it pass the test supplied as a scriptbox by returning 'true' rather than 'false'
			$Test.Invoke(($FirstString | convertfrom-ini))
		}
		'ShouldBe' { # compare with a powershell object directly 
            $TheTOML = $FirstString | Convertfrom-ini 
            !(Compare-Object -ReferenceObject $TheTOML -DifferenceObject $ShouldBe)
		}
		default { $false }
	}
	write-output "The $($_.Name) '$($_.Type)' test went $(if ($ItWentWell) { 'well' }
		else { 'badly' })"
}

@(#  Tests
	@('embedded parameter Test',
		'table = [{ a = 42, b = test }, {c = 4.2} ]',
		'{"table":[{"a":42,"b":"test"},{"c":4.2}]}'
	),
	@('Array with embedded tables',
		'MyArray = [ { x = 1, y = 2, z = 3 }, { x = 7, y = 8, z = 9 }, { x = 2, y = 4, z = 8 } ]
    ',
		'{"MyArray":[{"y":2,"z":3,"x":1},{"y":8,"z":9,"x":7},{"y":4,"z":8,"x":2}]}'
	),
	@('embedded table Test',
		'table = [ { a = 42, b = "test" }, {c = 4.2} ]',
		'{"table":[{"a":42,"b":"test"},{"c":4.2}]}'
	),
	@('array of arrays',
		' MyArray = [ { x = 1, y = 2, z = 3 },
    { x = 7, y = 8, z = 9 },
    { x = 2, y = 4, z = 8 } ]
', '{"MyArray":[{"y":2,"z":3,"x":1},{"y":8,"z":9,"x":7},{"y":4,"z":8,"x":2}]}'
	),
	@('inline_table',
		'MyInlineTable={ key1 = "value1", key2 = 123, key3 = "true"}',
		'{"MyInlineTable":{"key3":"true","key1":"value1","key2":123}}'
	),
	@('Flyway config file', @'
flyway.driver=com.mysql.jdbc.Driver
flyway.url=jdbc:mysql://localhost:3306/customer_test?autoreconnect=true
flyway.user=sysdba
flyway.password=pa$$w3!rd
flyway.schemas=customer_test
flyway.locations=filesystem:src/main/resources/sql/migrations
flyway.placeholders.email_type.primary=Primario
flyway.placeholders.email_type.work=Traba
flyway.placeholders.phone_type.home=Casa
'@,
		'{"flyway":{"url":"jdbc:mysql://localhost:3306/customer_test?autoreconnect=true","placeholders":{"email_type":{"work":"Traba","primary":"Primario"},"phone_type":{"home":"Casa"}},"password":"pa$$w3!rd","driver":"com.mysql.jdbc.Driver","locations":"filesystem:src/main/resources/sql/migrations","schemas":"customer_test","user":"sysdba"}}'
	), #long strings that wrap
	@('long strings that wrap', @'
# Settings are simple key-value pairs
flyway.key=value
# Single line comment start with a hash

# Long properties can be split over multiple lines by ending each line with a backslash
flyway.locations=filesystem:my/really/long/path/folder1,\
    filesystem:my/really/long/path/folder2,\
    filesystem:my/really/long/path/folder3

# These are some example settings
flyway.url=jdbc:mydb://mydatabaseurl
flyway.schemas=schema1,schema2
flyway.placeholders.keyABC=valueXYZ
'@, @'
{"flyway":{"url":"jdbc:mydb://mydatabaseurl","schemas":["schema1","schema2"],"key":"value","placeholders":{"keyABC":"valueXYZ"},"locations":["filesystem:my/really/long/path/folder1","filesystem:my/really/long/path/folder2","filesystem:my/really/long/path/folder3"]}}
'@
	), #Flyway config with array
	@('Flyway config with array', @'
[environments.sample]
url = "jdbc:h2:mem:db"
user = "sample user"
password = "sample password"
dryRunOutput = "/my/output/file.sql"
[flyway]
# It is recommended to configure environment as a commandline argument. This allows using different environments depending on the caller.
environment = "sample" 
locations = ["filesystem:path/to/sql/files","Another place"]
[environments.build]
 url = "jdbc:sqlite::memory:"
 user = "buildUser"
 password = "buildPassword"
[flyway.check]
buildEnvironment = "build"
'@, @'
{"environments":{"sample":{"dryRunOutput":"/my/output/file.sql","url":"jdbc:h2:mem:db","user":"sample user","password":"sample password"},"build":{"url":"jdbc:sqlite::memory:","user":"buildUser","password":"buildPassword"}},"flyway":{"environment":"sample","check":{"buildEnvironment":"build"},"locations":["filesystem:path/to/sql/files","Another place"]}}
'@
	), #are escaped quotes ignored?
	@('are escaped quotes ignored?', @'
str = "I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
# This is a full-line comment
key = "value"  # This is a comment at the end of a line
another = "# This is not a comment"
'@, @'
{"another":"# This is not a comment","key":"value","str":"I\u0027m a string. \"You can quote me\". Name\tJosé\nLocation\tSF."}
'@
	), #check for unicode and quoted values
	@('check for unicode and quoted values', @'
"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
'key2' = "value"
'quoted "value"' = "value"
'@, @'
{"ʎǝʞ":"value","key2":"value","character encoding":"value","quoted \"value\"":"value","127.0.0.1":"value"}
'@
	), #Check for escapes in quoted values
	@('Check for escapes in quoted values', @'
name = "Orange"
physical.color = "orange"
physical.shape = "round"
site."google.com" = true
'@, @'
{"site":{"google.com":"true"},"physical":{"shape":"round","color":"orange"},"name":"Orange"}
'@
	), #dotted hashtable
	@('Title', @'
name = "Orange"
physical.color = "orange"
physical.shape = "round"
site."google.com" = true
'@, @'
{"site":{"google.com":"true"},"physical":{"shape":"round","color":"orange"},"name":"Orange"}
'@
	), #white space between the dots
	@('white space between the dots', @'
fruit.name = "banana"     # this is best practice
fruit. color = "yellow"    # same as fruit.color
fruit . flavor = "banana"   # same as fruit.flavor
'@, @'
{"fruit":{"color":"yellow","name":"banana","flavor":"banana"}}
'@
	), # Array as an assignment to a key
	@('Array as an assignment to a key', @'
MyArray = ["Yan",'Tan','Tethera']
'@, @'
{"MyArray":["Yan","Tan","Tethera"]}
'@
	), #Embedded hashtable as assignment
	@('Embedded hashtable as assignment', @'
[dog."tater.man"]
type.name = "pug"
'@, @'
{"dog":{"tater.man":{"type":{"name":"pug"}}}}
'@
	), #ini-style table
	@('ini-style table', @'
# Top-level table begins.
name = Fido
breed = "pug"

# Top-level table ends.
[owner]
name = 'Regina Dogman'
member_since = 1999-08-04
'@, @'
{"name":"Fido","breed":"pug","owner":{"name":"Regina Dogman","member_since":"1999-08-04"}}
'@
	)
<#	  #My Test
,	@('Title', @'
INI
'@, @'
JSON
'@
	) 

#>
) | foreach {
	Write-Verbose "Running the '$($_[0])' test"
    $result = ConvertFrom-ini($_[1]) | convertTo-JSON -Compress -depth 10
	    if ($result -ne $_[2])
	    {
		    Write-Warning "Oops! $($_[0]): $($_[1]) produced `n$result ...not... `n$($_[2])"
	    }
	    else { Write-host "$($_[0]) test successful" }
    }
	

$TheErrorFile="$($env:TEMP)\warning.txt"
"no error">$TheErrorFile
$null=ConvertFrom-INI @'
name = "Tom"
name = "Pradyun"
'@ 3>$TheErrorFile
if ((Type $TheErrorFile) -ne "Attempt to redefine Key name with 'Pradyun'")
    {Write-Warning "Should have given warning`"Attempt to redefine Key name with 'Pradyun'`""}
else {write-host " test to prevent redefining  Key name succeeded"}

$null=ConvertFrom-INI @'
spelling = "favorite"
"spelling" = "favourite"
'@ 3>$TheErrorFile
if ((Type $TheErrorFile) -ne "Attempt to redefine Key `"spelling`" with 'favourite'")
    {Write-Warning "Should have given warning`"Attempt to redefine Key `"spelling`" with 'favourite'`""}
else {write-host " test to prevent attempt to redefine Key succeeded"}

# THE FOLLOWING IS INVALID
$null=ConvertFrom-INI @'
# This defines the value of fruit.apple to be an integer.
fruit.apple = 1

# But then this treats fruit.apple like it's a table.
# You can't turn an integer into a table.
fruit.apple.smooth = true
'@3>$TheErrorFile
if ((Type $TheErrorFile) -ne "Key apple redefined with true")
    {Write-Warning "Should have given the warning`"Key apple redefined with true`""}
else {write-host " test to prevent attempt to implcitly redefine a simple value as an object succeeded"}

}

