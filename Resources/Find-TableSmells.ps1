 <#
	.SYNOPSIS
		finds a few obvious mistakes in the tables within a model
	
	.DESCRIPTION
		A detailed description of the Find-TableSmells function.
	
	.PARAMETER ShortDocumentation
		What is too short a phrase to be a reasonable documentation?
	
	.PARAMETER TableWildcard
		A description of the TableWildcard parameter.
	
	.PARAMETER LotsOfColumns
		What number of columns represents a suspiciously-large number. 
	
	.PARAMETER SourceJSONModel
		The path to the JSON model for the database
	
	.EXAMPLE
				PS C:\> Find-TableSmells -ShortDocumentation $value1 -TableWildcard 'Value2'
	
	.NOTES
		Additional information about the function.
#>
function Find-TableSmells
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[string]$SourceJSONModel,
		[Parameter(Position = 2)]
		[int]$ShortDocumentation = 20,
		[Parameter(Position = 3)]
		[string]$TableWildcard='*', 
		[Parameter(Position = 4)]
		[int]$LotsOfColumns = 20
		#what no. of columns constitutes a wide table?

	)
	
	Begin
	{
		
	}
	Process
	{
		$model = [IO.File]::ReadAllText($SourceJSONModel)
		$DB = $model | convertfrom-json
		$Errors = @();
		$TableReferences = @() #a list of every table reference
		$ListOfTables = @() #A list of all the tables
		$db.PSObject.Properties | Foreach{
			$SchemaName = $_.Name; #Get the name of the schema
			#now get all object-types from the schema and select just the tables
			$_.Value.PSObject.Properties | where { $_.name -like 'table' } | foreach{
				# for each table
				$ObjectType = "$($_.Name)"
				$TableObject = $_;
				$TableObject.Value.PSObject.Properties | where { $_.name -like $TableWildcard } | foreach{
					#for each table
					$table = $_;
					$primary_key = @{ }; $columns = @{ }; $unique_key = @{ };
					$check_constraint = @{ }; $default_constraint = @{ };
					$foreign_key = @{ }; $index = @{ }; $Documentation = '';
					$HasForeignKey = $False; $HasUniqueKey = $False; $HasIndex = $False;
					$HasCheckConstraint = $False; $HasDocumentation = $False;
					$HasPrimaryKey = $False;
					$ObjectName = $table.Name;
					$Fullname = "$SchemaName.$ObjectName";
					$ListOfTables += $Fullname
					$table.Value.PSObject.Properties |
					Foreach{
						$AttributeType = $_.name;
						$AttributeValue = $_.Value;
						switch ($AttributeType)
						{
							'primary key' { $HasPrimaryKey = $true; $primary_key = $AttributeValue }
							'columns' { $columns = $AttributeValue }
							'unique key' { $HasUniqueKey = $true; $unique_key = $AttributeValue }
							'check constraint'{ $HasCheckConstraint = $true; $check_constraint = $AttributeValue }
							'default constraint'{ $default_constraint = $AttributeValue }
							'foreign key'{ $HasForeignKey = $true; $foreign_key = $AttributeValue }
							'index' { $HasIndex = $True; $index = $AttributeValue }
							'documentation'{ $HasDocumentation = $True; $Documentation = $AttributeValue }
							default { write-error "unknown table attribute $_ for $Fullname" }
						}
					}
					$foreign_key | foreach{ $_.PSObject.Properties.value.'Foreign Table' } | foreach{
						if ($_ -ne $null)
						{
							$TableReferences += [pscustomObject]@{
								'referencing' = $Fullname; 'references' = $_
							}
						}
					}
					# check the number of columns
					$NumberOfColumns = $Columns.count
					if ($NumberOfColumns -gt $lotsOfColumns)
					{
						$Errors += "The $Fullname table has $NumberOfColumns columns"
					}
					# check for a heap
					if (-not $HasPrimaryKey -and -not $HasUniqueKey -and -not $HasIndex)
					{
						$Errors += "The $Fullname heap has no index"
					}
					# check for no candidate key#
					elseif (-not $HasPrimaryKey -and -not $HasUniqueKey)
					{
						$Errors += "The $Fullname heap has no suitable candidate for a primary key"
					}
					# check for a primary key  
					elseif (-not $HasPrimaryKey)
					{
						$Errors += "The $Fullname table has no primary key"
					}
					
					#Check for bad documentation. At the moment it just does the table.
					if (!($HasDocumentation) -or ([string]::IsNullOrEmpty($documentation)))
					{ $Errors += "The $Fullname table has no documentation" }
					elseif ("$Documentation".Length -lt $ShortDocumentation)
					{ $Errors += "The $Fullname table has only sparse documentation '$documentation'" }
					
					# check for bad naming ----
					$MyArray = @()
					if ($HasForeignKey)
					{
						$MyArray += $Foreign_key | foreach{ @{ 'Type' = 'foreign Key'; 'SQLName' = $_.PSObject.Properties.Name } }
					}
					if ($HasUniqueKey)
					{
						$MyArray += $Unique_key | foreach{ @{ 'Type' = 'Unique Key'; 'SQLName' = $_.PSObject.Properties.Name } }
					}
					if ($HasIndex)
					{
						$MyArray += $Index | foreach{ @{ 'Type' = 'Index'; 'SQLName' = $_.PSObject.Properties.Name } }
					}
					$MyArray += $Columns | foreach{ @{ 'Type' = 'column'; 'SQLName' = $_ } }
					$MyArray | foreach{
						$What = $_;
						$SQLType = $What.Type
						if ($What.SQLName -cmatch
							@'
(?<SquareBracketed>\A\[.{1,255}?\])|(?#
)(?<Quoted>\A".{1,255}?")|(?#
)(?<legal>\A[@]?[\p{N}\p{L}_][\p{L}\p{N}@$#_]{0,127})
'@
						)
						{ $SQLName = $matches[0] }
						else
						{ $SQLName = 'unknown' }
						if ($matches.legal -eq $null)
						{ $Errors += "The $Fullname table has an 'escaped' $SQLType name '$SQLName'" }
						if ($SQLName -cmatch '\A[^aeiou]{1,20}\z') #No vowels!
						{ $Errors += "The $Fullname table has a $SQLType name '$SQLName' that is incomprehensible" }
						if ($SQLName -cmatch '\d{2,}') #pesky numbers!
						{ $Errors += "The $Fullname table has a $SQLType name '$SQLName' that looks auto-generated" }
						# End of check on bad naming ----
					}
				}
			}
			$Errors
		}
	}
	End
	{
		
	}
}
