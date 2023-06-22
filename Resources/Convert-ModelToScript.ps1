

<#
	.SYNOPSIS
		Converts a database model to a build script
	
	.DESCRIPTION
		This will parse a model and create from it a build scripts. Obviopusly, this isn't the full script, just a standard SQL98 representation of what is in the model. Because the code of all troutines and views is in the model, this is easier than it sounds, but the effort is in the tables.
		This is mostly used to test out the model to make sure it is correct. I haven't yet attempted to conform with individual dialects. Nope, this is just an elaborate test harness for the framework
	
	.PARAMETER PathToModel
		A description of the PathToModel parameter.
	
	.EXAMPLE
				PS C:\> Convert-ModelToScript -PathToModel 'Value1'
	
#>
function Convert-ModelToScript
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[string]$PathToModel
	)
$model = [IO.File]::ReadAllText($PathToModel)
$DB = $model | convertfrom-json
$db.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		$_.Value.PSObject.Properties | where { $_.name -like 'table' } | foreach{
			#for each objectType
			$ObjectType = "$($_.Name)"
			$_.Value.PSObject.Properties | foreach{
				#for each objectType
				$table = $_;
				$ObjectName = $table.Name;
				# now select all attributes of a table that aren't columns or indexes
				$ConstraintsForTheTable = @();
				$table.Value.PSObject.Properties | where { $_.name -notin ('columns', 'index') } | foreach{
					$Constraint = $_;
					$ConstraintType = $Constraint.Name;
					$Constraint.Value.PSObject.Properties | foreach{
						if ($ConstraintType -in 'primary key', 'unique key', 'check constraint')
						{
							$ConstraintName = $_.name
							$Colcount = $_.Value.Count #applies to unique, primary, default  and check
							$cols = "($($_.Value -join ','))";
						}
						elseif ($ConstraintType -eq 'default constraint')
						{
							$Defaultconstraint = $_
							$Colcount = 1;
							$ConstraintName = $Defaultconstraint.name
							$TheDefault = $Defaultconstraint.Value -split '=' | foreach{ $_.trim() }
							$Cols = $TheDefault[0]
							$Content = $TheDefault[1]
						}
						else #there is extra info here for foreign keys
						{
							$What = $_
							$Cols = "($($what.Value.Cols -join ','))"
							$Colcount = $what.Value.Cols.Count
							$ForeignTable = $what.Value.'Foreign Table'
							$Referencing = "($($what.Value.Referencing -join ','))"
						}
						$Expression =
						switch ($ConstraintType)
						{
							'primary key' { "CONSTRAINT $ConstraintName PRIMARY KEY $cols" }
							'unique key' { "CONSTRAINT $ConstraintName UNIQUE $cols" }
							'check constraint'{ "CONSTRAINT $ConstraintName CHECK $cols" }
							'default constraint'{ "CONSTRAINT $ConstraintName DEFAULT $Content" }
							'foreign key'{ "CONSTRAINT $ConstraintName FOREIGN KEY $cols`n               REFERENCES $ForeignTable $Referencing" }
							default { $_ }
						}
						$ConstraintsForTheTable += @{ columns = $Colcount; 'ColumnName' = $Cols.trim('(', ')'); 'Expression' = $expression }
					}
				}
				$DDL = "`nCREATE TABLE $SchemaName.$ObjectName (`n     "
				$table.Value.PSObject.Properties | where {
					$_.name -like 'columns'
				} | foreach{
					$What = $_
					#for each objectType
					$ColumnValues = $What.Value | foreach {
						if ($_ -cmatch '
                    (?<SquareBracketed>\A\[.{1,255}?\])|(?#
                    )(?<Quoted>\A".{1,255}?")|(?#
                    )(?<legal>\A[@]?[\p{N}\p{L}_][\p{L}\p{N}@$#_]{0,127})'
						)
						{ $columnName = $matches[0] }
						else
						{ $columnName = 'unknown' }
						$_ + ($ConstraintsForTheTable | where {
								$_.columns -eq 1 -and $_.columnName -eq $columnName
							} | foreach{
								"`n        $($_.Expression)"
							})
						
					}
					$ColumnValues = $ColumnValues -join ",`n     " #|foreach{$DDL="$DDL`n    $($_)"}
				}
				$TableConstraints = $ConstraintsForTheTable | where { $_.columns -gt 1 } | foreach{ ",`n     $($_.Expression)" }
				"$DDL $ColumnValues $TableConstraints`n );"
				#now do table constraints.
				$table.Value.PSObject.Properties | where {
					$_.name -like 'index'
				} | foreach{
					$WhatIndex = $_;
					$WhatIndex.Value.PSObject.Properties | foreach {
						"`n CREATE INDEX $($_.Name) on $SchemaName.$ObjectName ($($($_.Value -join ',')));"
					}
				}
			}
		}
	}
}