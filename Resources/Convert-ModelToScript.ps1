
<#
	.SYNOPSIS
		Converts a database model to a build script
	
	.DESCRIPTION
		This will parse a model and create from it a build scripts. Obviopusly, this isn't the full script, just a standard SQL98 representation of what is in the model. Because the code of all troutines and views is in the model, this is easier than it sounds, but the effort is in the tables.
		This is mostly used to test out the model to make sure it is correct. I haven't yet attempted to conform with individual dialects. Nope, this is just an elaborate test harness for the framework
	
	.PARAMETER PathToModel
		A description of the PathToModel parameter.
	
	.PARAMETER RDBMS
		A description of the RDBMS parameter.
	
	.EXAMPLE
		cls;
		'S:\work\Github\FlywayTeamwork\Pubs\Versions\1.3\Reports\DatabaseModel.JSON'|
		Convert-ModelToScript
		Convert-ModelToScript -PathToModel 'S:\work\Github\FlywayTeamwork\Pubs\Versions\1.3\Reports\DatabaseModel.JSON'
		
    .NOTES
		
#>

function Convert-ModelToScript
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[string]$PathToModel,
		[string]$RDBMS = 'sqlserver'
	)
	
	#$PathToModel=' S:\work\Github\FlywayTeamwork\Pubs\Versions\1.3\Reports\DatabaseModel.JSON';$RDBMS='SQLServer';
	
	$Terminator = if ($RDBMS -eq 'sqlserver') { "GO" }
	else { "" }
	$PreliminaryTypes = @('UserType');
	
	$model = [IO.File]::ReadAllText($PathToModel) #read the json text of the model
	try { $DB = $model | convertfrom-json } #convert it into a powershell model 
	catch { Write-error "The JSON model at $PathToModel isn't valid JSON" };
	$TableReferences = @(); #a list of every table reference
	$ListOfTables = @(); #A list of all the tables with their schemas
	
	$ListOfTables = $db.PSObject.Properties | Foreach{
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
	$TableReferences = $db.PSObject.Properties | Foreach{
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

    #now we have to do the views

	$viewDefinitions= $db.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select just the views
		$_.Value.PSObject.Properties | where { $_.name -like 'view' }
    } | foreach{ $_.Value.PSObject.Properties } | foreach{
			$view = $_;
			$ObjectName = $view.Name;
			$Fullname = "$SchemaName.$ObjectName";
			$Definition = $view.value.Definition;
			[pscustomObject]@{ 'ObjectName' = $ObjectName; 'FullName'=$Fullname; 'definition' = $Definition }
		}
	$ViewReferences=$viewDefinitions | foreach{
		$TheView = $_;
		$viewDefinitions | where { $_.ObjectName -ne $TheView.ObjectName } | foreach{
			if ($_.definition -clike "*$($TheView.ObjectName)*")
			{
				[pscustomObject]@{
					'referencing' = $_.FullName;
					'references' = $TheView.FullName
				}
			}
		}
	}
	
    # Now we work out the view interdependency order. 
	# We put them in sorted order within their dependency group, starting with the viewas that
	# don't reference any other views. 
    $ViewsInDependencyOrder = @()
	$ii = 20; # just to stop mutual dependencies hanging the script
    $ViewsToDo=$viewDefinitions.Count
	Do
	{
		$NotYetPicked = $viewDefinitions | select -ExpandProperty FullName | where { $_ -notin $ViewsInDependencyOrder }
		$viewsInDependencyOrder += $notyetpicked | foreach{
			$Name = $_; $Referencing = ($viewReferences | where { $_.referencing -eq $Name }).references;
			$AlreadyThere = $Referencing | where { $_ -in $ViewsInDependencyOrder }
			if ($Referencing.Count -eq $AlreadyThere.Count) { $Name }
		} | sort-object
		$ii--;
	}
	while ($ViewsInDependencyOrder.count -lt $ViewsToDo -and ($ii -gt 0))
	if ($ViewsInDependencyOrder.count -ne $ViewsToDo)
	{ Throw 'could not get views in dependency order' }


	#first we do the preliminary stuff that tables depend on such as user types 
	
	$PreliminaryTypes = @('UserType');
	# a list of all the types that need to be in place before tables
	$script = $db.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select just thepreliminaries
		$_.Value.PSObject.Properties | where { $_.name -in $PreliminaryTypes } |
		foreach{ $ObjectType = $_.name; $_.Value.PSObject.Properties } | foreach{
			$Object = $_
			$Definition = '';
			$documentation = '';
			$ObjectName = $_.Name;
			$fullname = "$SchemaName.$ObjectName";
			$Object.Value.PSObject.Properties | foreach {
				$attribute = $_;
				switch ($_.Name)
				{
					'Definition' { $Definition = $Attribute.Value }
					'Documentation'{ $Documentation = $Attribute.Value }
				}
			}
			if (!([string]::IsNullOrEmpty($Documentation)))
			{ $Documentation = "/* $Documentation */`n" };
			"$Documentation$Definition;`n"
			
		}
	}
	
	#With the preliminaries out of the way, we do the table definitions 
	$TablesInDependencyOrder | foreach{
		$fullName = $_.Split('.')
		$SchemaName = $fullname[0]
		$table = $db.$SchemaName.table.($fullname[1])
		$Documentation = '';
		$ObjectName = $fullname[1];
		# now select all attributes of a table that aren't columns or indexes
		$ConstraintsForTheTable = @();
		if ($table.documentation -ne $null) { $Documentation = $table.documentation }
		$table.PSObject.Properties | where { $_.name -notin ('columns', 'documentation', 'index') } | foreach{
			$constraint = $_
			$ConstraintType = $_.Name;
			$constraint.Value.PSObject.Properties | where { $_.MemberType -eq 'NoteProperty' } | foreach{
				$ConstraintName = $_.name;
				$Colcount = 0; $cols = ''; $content = ''
				if ($ConstraintType -in 'primary key', 'unique key', 'check constraint')
				{
					$Colcount = $_.Value.Count #applies to unique, primary, default  and check
					$cols = "($($_.Value -join ','))";
				}
				elseif ($ConstraintType -eq 'default constraint')
				{
					$Defaultconstraint = $_
					$Colcount = 1;
					$TheDefault = $Defaultconstraint.Value -split '=' | foreach{ $_.trim() }
					$Cols = $TheDefault[0]
					$Content = $TheDefault[1]
				}
				elseif ($ConstraintType -eq 'Foreign Key')
				{
					$What = $_
					$Cols = "($($what.Value.Cols -join ','))"
					$Colcount = $what.Value.cols.Count
					$ForeignTable = $what.Value.'Foreign Table'
					$Referencing = "($($what.Value.Referencing -join ','))"
					$content = '';
				}
				else { Write-Warning "Unknown constraint $Constraintname $ConstraintType" }
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
		if (!([string]::IsNullOrEmpty($Documentation)))
		{ $DDL += "/* $Documentation */`n" }
		$table.PSObject.Properties | where {
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
			$ColumnValues = $ColumnValues.Trim() -join ",`n     ";
			$ColumnValues = $ColumnValues -creplace '(?<comment>\s*--.*),(?m:$)', ',${comment}' #|foreach{$DDL="$DDL`n    $($_)"}
		}
		$TableConstraints = $ConstraintsForTheTable | where { $_.columns -gt 1 } | foreach{ ",`n     $($_.Expression)" }
		$script += "$DDL $ColumnValues $TableConstraints`n );"
		#now do table constraints.
		$script += $table.Value.PSObject.Properties | where {
			$_.name -like 'index'
		} | foreach{
			$WhatIndex = $_;
			$WhatIndex.Value.PSObject.Properties | foreach {
				"`n CREATE INDEX $($_.Name) on $SchemaName.$ObjectName ($($($_.Value -join ',')));"
			}
		}
	}

#now do the views
 $ViewsInDependencyOrder|foreach { 
        $fullName = $_.Split('.')
		$SchemaName = $fullname[0]
		$view = $db.$SchemaName.view.($fullname[1])
		$Documentation = '';
		$ObjectName = $fullname[1];
		if ($view.documentation -ne $null) { $Documentation = $view.documentation }
        if (!([string]::IsNullOrEmpty($Documentation)))
			{ $Documentation = "/* $Documentation */`n" }
            else {$Documentation = "/* Create the $fullname View  */`n"};
			$script += "`n$Terminator`n$Documentation$($view.Definition)`n"
        }

<#Now we add all the other non-table objects. In SQL Server, tables can reference these
in constraints so that any referenced ones have to be created first #>
	$PreliminaryTypes += ('table','service queue','view'); # we want to filter these and tables out
	$db.PSObject.Properties | Foreach{
		$SchemaName = $_.Name; #Get the name of the schema
		#now get all object-types from the schema and select everything other than 
		$_.Value.PSObject.Properties | where { $_.name -notin ($PreliminaryTypes) 
        } | foreach{ $ObjectType = $_.name; $_.Value.PSObject.Properties } | foreach{
			$Object = $_;
            $Documentation='';$Definition='';
			$ObjectName = $_.Name;
			$fullname = "$SchemaName.$ObjectName";
			$Object.Value.PSObject.Properties | foreach {
				$attribute = $_;
				switch ($_.Name)
				{
					'columns' { $Columns = $Attribute.Value -join ',' }
					'Definition' { $Definition = $Attribute.Value }
					'Documentation'{ $Documentation = $Attribute.Value }
					default { $_ }
				}
			}
			if (!([string]::IsNullOrEmpty($Documentation)))
			{ $Documentation = "/* $Documentation */`n" }
            else {$Documentation = "/* Create the $ObjectType $fullname */`n"};
			$script += "`n$Terminator`n$Documentation$Definition`n"
			
		}
	}
	$script
}

