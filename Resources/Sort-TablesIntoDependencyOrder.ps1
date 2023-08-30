<#
	.SYNOPSIS
		Sorts a model containing tables into their  dependency order, returns an array of  schema/table names
	
	.DESCRIPTION
		This routine takes a JSON database model and uses the foreign key relationships described in the model to return a list of the tables in the database in dependency order. Remember that deleting data from tables must be done in reverse order, perhaps by using [array]::reverse()
	
	.PARAMETER dbModel
		The database model, converted into powershell from JSON text
	
	.EXAMPLE
				PS C:\> Sort-TablesIntoDependencyOrder -dbModel $MyDatabaseModel
                PS C:\> $MyDatabaseModel|Sort-TablesIntoDependencyOrder
	

#>
function Sort-TablesIntoDependencyOrder
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[ValidateNotNullOrEmpty()]
		$dbModel
	)
	$TableReferences = @(); #a list of every table reference
	$ListOfTables = @(); #A list of all the tables with their schemas
	
	$ListOfTables = $dbModel.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select just the tables
		$_.Value.PSObject.Properties | where { $_.name -like 'table' } |
		foreach{ $_.Value.PSObject.Properties } | foreach{
			$table = $_;
			$ObjectName = $table.Name;
			"$SchemaName.$ObjectName";
		}
	}
	#For every table, we now get the tables they refer to in foreign keys.
	$TableReferences = $dbModel.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select just the tables
		$_.Value.PSObject.Properties | where { $_.name -like 'table' } |
		foreach{ $_.Value.PSObject.Properties } | foreach{
			$table = $_;
			$ObjectName = $table.Name;
			$Fullname = "$SchemaName.$ObjectName";
			$table.Value.PSObject.Properties | where { $_.name -eq 'foreign key' } |
			foreach { $_.Value.PSObject.Properties } | foreach{
				[pscustomObject]@{
					'referencing' = $Fullname;
					'references' = ($_.Value.PSObject.Properties | where { $_.name -eq 'Foreign Table' }).value
				}
			}
		}
	}
	# Now we work out the dependency order. 
	# We put them in sorted order within their dependency group, starting with the tables that
	# don't reference anything. 
	$TablesInDependencyOrder = @()
	$ii = 20; # just to stop mutual dependencies hanging the script
	Do
	{
		$NotYetPicked = $ListOfTables | where { $_ -notin $TablesInDependencyOrder }
		$TablesInDependencyOrder += $notyetpicked | foreach{
			$Name = $_; $Referencing = ($TableReferences | where { $_.referencing -eq $Name }).references;
			$AlreadyThere = $Referencing | where { $_ -in $TablesInDependencyOrder }
			if ($Referencing.Count -eq $AlreadyThere.Count) { $Name }
		} | sort-object
		$ii--;
	}
	while (($TablesInDependencyOrder.count -lt $ListOfTables.count) -and ($ii -gt 0))
	if ($TablesInDependencyOrder.count -ne $ListOfTables.count)
	{ Throw 'could not get tables in dependency order' }
	
	$TableReferences = @(); #a list of every table reference
	$ListOfTables = @(); #A list of all the tables with their schemas
	
	$ListOfTables = $dbModel.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select just the tables
		$_.Value.PSObject.Properties | where { $_.name -like 'table' } |
		foreach{ $_.Value.PSObject.Properties } | foreach{
			$table = $_;
			$ObjectName = $table.Name;
			"$SchemaName.$ObjectName";
		}
	}
	#For every table, we now get the tables they refer to in foreign keys.
	$TableReferences = $dbModel.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select just the tables
		$_.Value.PSObject.Properties | where { $_.name -like 'table' } |
		foreach{ $_.Value.PSObject.Properties } | foreach{
			$table = $_;
			$ObjectName = $table.Name;
			$Fullname = "$SchemaName.$ObjectName";
			$table.Value.PSObject.Properties | where { $_.name -eq 'foreign key' } |
			foreach { $_.Value.PSObject.Properties } | foreach{
				[pscustomObject]@{
					'referencing' = $Fullname;
					'references' = ($_.Value.PSObject.Properties | where { $_.name -eq 'Foreign Table' }).value
				}
			}
		}
	}
	# Now we work out the dependency order. 
	# We put them in sorted order within their dependency group, starting with the tables that
	# don't reference anything. 
	$TablesInDependencyOrder = @()
	$ii = 20; # just to stop mutual dependencies hanging the script
	Do
	{
		$NotYetPicked = $ListOfTables | where { $_ -notin $TablesInDependencyOrder }
		$TablesInDependencyOrder += $notyetpicked | foreach{
			$Name = $_; $Referencing = ($TableReferences | where { $_.referencing -eq $Name }).references;
			$AlreadyThere = $Referencing | where { $_ -in $TablesInDependencyOrder }
			if ($Referencing.Count -eq $AlreadyThere.Count) { $Name }
		} | sort-object
		$ii--;
	}
	while (($TablesInDependencyOrder.count -lt $ListOfTables.count) -and ($ii -gt 0))
	if ($TablesInDependencyOrder.count -ne $ListOfTables.count)
	{ Throw 'could not get tables in dependency order' }
	$TablesInDependencyOrder
}