
Del 'S:\work\Github\FlywayTeamwork\Pubs\Versions\test\Reports\DatabaseModel.JSON' -ErrorAction SilentlyContinue

<#
$SaveDatabaseModelIfNecessary

This writes a JSON model of the database to a file that can be used subsequently
to check for database version-drift or to create a narrative of changes for the
flyway project between versions.
To run this, you need to provide values for 
'server', The name of the database server
'database', The name of the database
'version', The version directory that is to be ascribed to the file
'project', The name of the whole project for the output filenames
'RDBMS', the rdbms being used, e.g. sqlserver, mysql, mariadb, postgresql, sqlite
'schemas', the schemas to be used to create the model
'flywayTable' the name and schema of the flyway table
/#>
$SaveDatabaseModelIfNecessary = {
	Param ($param1,
		$MyOutputReport = $null,
		$MyCurrentReport = $null,
		$MyModelPath = $null) # $SaveDatabaseModelIfNecessary - dont delete this
 	$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' #we'll be using out redirection
	$problems = @() #none yet!
   Trap
    {
	    # Handle the error
	    $err = $_.Exception
	    $problems += $err.Message
	    while ($err.InnerException)
	    {
		    $err = $err.InnerException
		    $problems += $err.Message
	    };
        $Param1.Problems.'SaveDatabaseModelIfNecessary' += $problems;
	    # End the script.
	    break
    }

	$feedback = @();
	$AlreadyDone = $false;
	#check that you have the  entries that we need in the parameter table.
	$Essentials = @('server', 'database', 'RDBMS', 'flywayTable')
    if ($param1.RDBMS -ne 'sqlite'){$Essentials +='schemas'}
	$WeHaveToCalculateADestination = $false; #assume default report locations
	if ($MyOutputReport -eq $null -or $MyCurrentReport -eq $null -or $MyModelPath -eq $null)
	{
		#slightly less required for an ad-hoc model.
		$Essentials += @('project', 'Reportdirectory');
		$WeHaveToCalculateADestination = $true;
	}
	
	$Essentials | foreach{
		if ([string]::IsNullOrEmpty($param1.$_))
		{ $Problems += "no value for '$($_)' parameter in db Details" }
	}
	if ($WeHaveToCalculateADestination)
	{# by default, we need to calculate destinations from the param1
		$escapedProject = ($Param1.project.Split([IO.Path]::GetInvalidFileNameChars()) -join '_') -ireplace '\.', '-'
		# if any of the optional parameters aren't given
		if ($param1.directoryStructure -in ('classic', $null)) #If the $ReportDirectory has a classic or NULL value
		{ $where = "$($env:USERPROFILE)\$($param1.Reportdirectory)$($escapedProject)" }
		else { $where = "$($param1.reportLocation)" }
		
		#if all parameters not provided
		$MyDatabasePath = "$where\$($param1.Version)\Reports";
		$MyCurrentPath = "$where\current";
	}
	if ($MyModelPath -eq $null)
	{ $MyModelPath = "$where\$($param1.Version)\model" };
	# so if not specified in the parameters, generate the correct location.
	if ($MyOutputReport -eq $null)
	{ $MyOutputReport = "$MyDatabasePath\DatabaseModel.JSON" }
	if ($MyCurrentReport -eq $null)
	{ $MyCurrentReport = "$MyCurrentPath\Reports\DatabaseModel.JSON" }
	if ($MyDatabasePath -eq $null)
    {$MyDatabasePath=split-path -Path $MyOutputReport -Parent}
    

    #handy stuff for where clauses in SQL Statements
	$ListOfSchemas = ($param1.schemas -split ',' | foreach{ "'$_'" }) -join ',';
    
	if ($param1.flywayTable -ne $null)
	{ $FlywayTableName = (($param1.flywayTable -split '\.')[1]).Trim('"') }
	else
	{ $FlywayTableName = 'flyway_schema_history' }

	if (!(Test-Path -PathType Leaf  $MyOutputReport)) #only do it once
	{
		try
		{
			@($MyDatabasePath, "$(split-path -path $MyCurrentReport -Parent)") | foreach {
				if (Test-Path -PathType Leaf $_)
				{
					# does the path to the reports directory exist as a file for some reason?
					# there, so we delete it 
					remove-Item $_;
				}
				if (-not (Test-Path -PathType Container $_))
				{
					# does the path to the reports directory exist?
					# not there, so we create the directory 
					$null = New-Item -ItemType Directory -Force $_;
				}
			}
			switch -Regex ($param1.RDBMS)
			{
<# this is the section that creates a SQLite Database Model  #>
				'sqlite' {
					$SQLlines = @() #we build the SQL dynamically - SQLite is a bit awkward for metadata!
					$TablesAndViews = Execute-SQL $param1 "SELECT Name, Type FROM sqlite_schema WHERE TYPE <> 'index';" | convertfrom-json
            <# we process tables and views first but not indexes as they are actually child objects of tables  #>
					$TablesAndViews | foreach{
						$type = $_.type;
						$SQLlines += "SELECT '$($_.type)' as type, '$($_.name)' as object, Name||' '||TYPE||CASE `"notnull`" when 1 THEN ' NOT' ELSE '' END
                 ||' NULL '||CASE WHEN dflt_value IS NOT NULL THEN 'DEFAULT ('||`"dflt_value`"||')' ELSE '' end as col, pk
                  FROM pragma_table_info('$($_.name)')"
					}
            <# we want to scoop up as much metadata as we can in one query so we do this with a UNION ALL. #>
					$query = ($SQLlines -join "`r`nUNION ALL`r`n") + ';'
            <# The query was created dynamically, now we execute it  #>
					$TheRelationMetadata = Execute-SQL $param1 $query | ConvertFrom-json
					
            <# Now get the details of all the indexes that aren't primary keys, including the columns,  #>
					$indexes = Execute-SQL $param1 @"
            SELECT m.name as index_name, m.tbl_Name as table_name, i.seqno, i.cid, i.name as column_name
              FROM sqlite_schema AS m,
              pragma_index_info(m.name) AS i
               WHERE TYPE='index' AND sql IS NOT NULL;
"@ | ConvertFrom-Json
					
            <# we get the list of different base types (obvious in SQLite but it can get tricky with other
            RDBMS  #>
                    $TheSchema=(split-path $param1.database -Leaf).replace('.sqlite3','')
					$THeTypes = $TablesAndViews | Select type -Unique #|foreach{$_.type}
            <# OK. we now have to assemble all this into a model that is as human-friendly as possible  #>
					$SchemaTree =@{$TheSchema=@{}; } <# This will become our model of the schema. Fist we put in
            all the types of relations  #>
 					$TheTypes | foreach{
						#$SchemaTree.database | add-member -notePropertyName $_.type -notePropertyValue @{ }
                        $SchemaTree.$TheSchema += @{$_.type=@{ }}
					}
                    
                    $TheRelationMetadata | Select type, object -Unique | foreach{
						$type = $_.type;
						$object = $_.object;
                        $pk = @{ }
						$TheColumnList = $TheRelationMetadata |
						where {$_.type -eq $type -and $_.object -eq $object } -OutVariable pk |
						   foreach{ $_.col }
                        $SchemaTree.$TheSchema.$type += @{ $object = @{ 'columns' = $TheColumnList } }
                        $primaryKey = $pk | Where { $_.pk -gt 0 } |
						Sort-Object -Property pk |
						Foreach{ [regex]::matches($_.col, '\A\S{1,80}').value }
						if ($primaryKey.count -gt 0)
						{
							$SchemaTree.$TheSchema.$type.$object += @{ 'PrimaryKey' = $primaryKey }
						}
					} 
					
            <# now inject all the objects into the schema tree. First we get all the relations  
					$TheRelationMetadata | Select type, object -Unique | select -first 3| foreach{
						$type = $_.type;
						$object = $_.object;
						$pk = @{ }
						$TheColumnList = $TheRelationMetadata |
						where { $_.type -eq $type -and $_.object -eq $object } -OutVariable pk |
						foreach{ $_.col }
						$primaryKey = @();
						$SchemaTree.'database'.$type += @{ $object = @{ 'columns' = $TheColumnList } }
						$primaryKey = $pk | Where { $_.pk -gt 0 } |
						Sort-Object -Property pk |
						Foreach{ [regex]::matches($_.col, '\A\S{1,80}').value }
						if ($primaryKey.count -gt 0)
						{
							$SchemaTree.'database'.$type.$object += @{ 'PrimaryKey' = $primaryKey }
						}
					}#>
            <# now stitch in the indexes with their columns  #>
					$indexes | Select table_name, index_name -Unique | foreach{
						$indexedTable = $_.table_name
						$indexName = $_.index_name
						$columns = $indexes |
						where{ $_.table_name -eq $indexedTable -and $_.index_name -eq $indexName } |
						Sort-Object -Property seqno | Select -ExpandProperty column_name
						$SchemaTree.$TheSchema.table.$indexedTable.indexes += @{ $indexName = $columns }
					}
					$SchemaTree | convertTo-json -depth 10 > "$MyOutputReport"
					$SchemaTree | convertTo-json -depth 10 > "$MycurrentReport"
					
				} #end of SQLite version
<# this is the section that creates a PostgreSQL Database Model based where
possible on information schema
 #>				
				'postgresql' {
					#fetch all the relations (anything that produces columns)
					$query = @"
            SELECT json_agg(e) 
            FROM (
            Select columns.table_schema as schema, columns.TABLE_NAME as object, COLUMN_NAME||' '||data_type||
               CASE WHEN data_type LIKE 'char%' THEN ' ('||character_maximum_length||')'ELSE''END||
	            CASE WHEN numeric_precision IS NOT NULL THEN 
		            CASE WHEN data_type LIKE '%int%' THEN ' '
		            ELSE ' ('|| numeric_precision_radix ||','|| numeric_scale || ')' END
	            ELSE '' END||
	            CASE is_identity WHEN 'YES' THEN 'GENERATED '||identity_generation||' AS IDENTITY'
	            ELSE	 
		            CASE is_nullable WHEN 'NO' THEN ' NOT' ELSE '' END ||
	            ' NULL ' ||
		            CASE when column_default is NOT NULL THEN 'DEFAULT ('||
		              column_default || ')' ELSE '' END
	            END AS COLUMN,
	            CASE WHEN views.table_name IS NULL THEN 'table' else 'view' END AS type
            FROM information_schema."columns" 
            left outer JOIN (SELECT  table_schema,table_name FROM information_schema."views")as views
            ON columns.table_schema=views.table_schema AND  columns.TABLE_NAME=views.table_name
            WHERE columns.table_catalog=current_database() AND columns.table_schema IN ($listOfSchemas)
            and columns.TABLE_NAME <> '$FlywayTableName'
            ORDER BY columns.table_schema, columns.TABLE_NAME, ordinal_position
                ) e;
"@
					$TheRelationMetadata = Execute-SQL $param1 $query | ConvertFrom-json 
					#now get the details of the routines
					$query = @"
 SELECT json_agg(e) 
            FROM (SELECT 
		Routine_name AS "name", Routine_Schema AS "schema", 
		CONCAT(Routine_Schema,'.', Routine_name) AS "fullname", 
		LOWER(routine_type) AS "type",
		routine_definition AS definition, 
		MD5(routine_definition) AS "hash" --,
		-- description AS "comment"
   FROM information_schema.routines
	-- INNER JOIN pg_proc ON proname LIKE routine_name
	-- LEFT OUTER JOIN pg_description
	-- ON OID= objoid
	WHERE Routine_Schema IN ($ListOfSchemas) 	
UNION ALL
SELECT 
		Table_name AS "name", 
		Table_Schema AS "schema", 
		CONCAT(table_Schema,'.', table_name) AS "fullname", 
		LOWER(replace(table_type,'BASE ','')) AS "type",
		'' AS definition, 
		MD5('') AS HASH -- ,
		-- description AS COMMENT
	FROM information_schema.tables
	--	INNER JOIN pg_class ON relname LIKE table_name
	-- LEFT OUTER JOIN pg_description
	-- ON OID= objoid
	WHERE Table_Schema IN ($listOfSchemas) 
		AND TABLE_NAME NOT LIKE '$FlywayTableName'
                ) e;
"@
					$Routines = Execute-SQL $param1 $query | ConvertFrom-json
					#now do the constraints 
					$query = @"
            SELECT json_agg(e) 
            FROM (SELECT lower(tc.constraint_type) as type, tc.table_schema as schema, 
               tc.Table_name, kcu.constraint_name, kcu.column_name, 
					ordinal_position,
					rel_tco.table_schema || '.' || rel_tco.table_name AS "referenced_table",
					kcu.column_name AS "referenced_column_name"
            FROM information_schema.table_constraints AS tc 
            JOIN information_schema.key_column_usage AS kcu 
              ON tc.constraint_name = kcu.constraint_name 
              AND tc.table_name=kcu.table_name
              AND tc.table_schema=kcu.table_schema
left outer join information_schema.referential_constraints rco
          on tc.constraint_schema = rco.constraint_schema
          and tc.constraint_name = rco.constraint_name
left outer join information_schema.table_constraints rel_tco
          on rco.unique_constraint_schema = rel_tco.constraint_schema
          and rco.unique_constraint_name = rel_tco.constraint_name
           WHERE tc.table_catalog=current_database() 
              and tc.Table_name <> '$FlywayTableName' 
              AND tc.table_schema NOT IN ('pg_catalog','information_schema')
                ) e;
"@
					$Constraints = Execute-SQL $param1 $query | ConvertFrom-json 
            <# Now get the details of all the indexes that aren't primary keys, including the columns,  #>
					$indexes = Execute-SQL $param1 @"
            SELECT json_agg(e) 
            FROM(SELECT distinct
	             allindexes.schemaname AS schema,
                t.relname as table_name,
                i.relname as index_name,
                a.attname AS "column_name",
                allindexes.indexdef AS definition
            from
                pg_index ix 
	             INNER join pg_class t on t.oid = ix.indrelid
                INNER JOIN  pg_class i ON i.oid = ix.indexrelid
                inner join pg_attribute a on a.attrelid = t.oid
                LEFT OUTER JOIN pg_indexes allindexes ON t.relname= allindexes.tablename AND i.relname=allindexes.indexname
            where
                a.attnum = ANY(ix.indkey)
                and t.relkind = 'r'
                AND indisprimary=FALSE AND indisunique=FALSE
                AND allindexes.schemaname <>'pg_catalog'
                AND t.relname <> '$FlywayTableName'
            order by
                t.relname,
                i.relname
                ) e;    
"@ | ConvertFrom-Json
					
					#now get all the triggers
					$triggers = Execute-SQL $param1 @'
            SELECT json_agg(e) 
            FROM(
            SELECT TRIGGER_SCHEMA as schema, TRIGGER_NAME, event_object_schema, event_object_table
            FROM information_schema.triggers t
            WHERE t.trigger_catalog=current_database() 
              AND t.trigger_schema NOT IN ('pg_catalog','information_schema')
                ) e; 
'@ | ConvertFrom-Json
					
            <# RDBMS  #>
					$THeTypes = $Routines | Select schema, type -Unique
            <# OK. we now have to assemble all this into a model that is as human-friendly as possible  #>
					$SchemaTree = @{ } <# This will become our model of the schema. Fist we put in
            all the types of relations  #>
					
					
					$TheTypes | Select -ExpandProperty schema -Unique | foreach{
						$TheSchema = $_;
						$ourtypes = @{ }
						$TheTypes | where { $_.schema -eq $TheSchema } | Select -ExpandProperty type | foreach{ $OurTypes += @{ $_ = @{ } } }
						$SchemaTree | add-member -NotePropertyName $TheSchema -NotePropertyValue $OurTypes
						
					}
					
            <# now inject all the objects into the schema tree. First we get all the relations  #>
					$TheRelationMetadata | Select schema, type, object -Unique | foreach{
						$schema = $_.schema;
						$type = $_.type;
						$object = $_.object;
						$TheColumnList = $TheRelationMetadata |
						where { $_.schema -eq $schema -and $_.type -eq $type -and $_.object -eq $object } -OutVariable pk |
						foreach{ $_.column }
						$SchemaTree.$schema.$type += @{ $object = @{ 'columns' = $TheColumnList } }
					}
					#display-object $schemaTree
            <# now stitch in the constraints with their columns  #>
					$constraints | Select schema, table_name, Type, constraint_name, referenced_table -Unique | foreach{
						$constraintSchema = $_.schema;
						$constrainedTable = $_.table_name;
						$constraintName = $_.constraint_name;
						$ConstraintType = $_.type;
						$referenced_table = $_.referenced_table;
						# get the original object
						$OriginalConstraint = $constraints |
						where{
							$_.schema -eq $constraintSchema -and
							$_.table_name -eq $constrainedTable -and
							$_.Type -eq $ConstraintType -and
							$_.constraint_name -eq $constraintName
						} | Select -first 1
						$Columns = $OriginalConstraint | Sort-Object -Property ordinal_position |
						Select -ExpandProperty column_name
						if ($ConstraintType -eq 'foreign key')
						{
							$Referencing = $OriginalConstraint | Sort-Object -Property ordinal_position |
							Select -ExpandProperty referenced_column_name
							$SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{
								$constraintName = @{ 'Cols' = $columns; 'Foreign Table' = $referenced_table; 'Referencing' = "$Referencing" }
							}
						}
						else
						{ $SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{ $constraintName = $columns } }
						
					}
              <# now stitch in the routines and their contents #>
					$routines | Foreach {
						$TheSchema = $_.schema;
						$TheName = $_.name;
						$TheType = $_.type;
						$TheHash = $_.hash;
						$Thecomment = $_.comment;
						$TheDefinition = $_.definition;
						$Contents = @{ }
						if (!([string]::IsNullOrEmpty($TheDefinition))) { $Contents.'definition' = $TheDefinition }
						if ($TheType -ne 'table') { $Contents.'hash' = $Thehash }
						if (!([string]::IsNullOrEmpty($Thecomment))) { $Contents.'comment' = $TheComment }
						if ($SchemaTree.$TheSchema.$TheType.$TheName -eq $null)
						{ $SchemaTree.$TheSchema.$TheType.$TheName = $Contents }
						else
						{ $SchemaTree.$TheSchema.$TheType.$TheName += $Contents }
						
					}
					
<# now stitch in the indexes with their columns  #>
					$indexes | Select schema, table_name, Type, index_name, definition -Unique | foreach{
						$indexSchema = $_.schema;
						$indexedTable = $_.table_name;
						$indexName = $_.index_name;
						$definition = $_.definition;
						$columns = $indexes |
						where{
							$_.schema -eq $indexSchema -and
							$_.table_name -eq $indexedTable -and
							$_.index_name -eq $indexName
						} |
						Select -ExpandProperty column_name
						$SchemaTree.$indexSchema.table.$indexedTable.index += @{ $indexName = @{ 'Indexing' = $columns; 'def' = "$definition" } }
					}
					
					$SchemaTree | convertTo-json -depth 10 > "$MyOutputReport"
					$SchemaTree | convertTo-json -depth 10 > "$MycurrentReport"
				}
<# this is the section that creates a MariaDB or MySQL Database Model based where
possible on information schema 
 #>
				'mysql|mariaDB' {
					#create a delimited list for SQL's IN command
					#fetch all the relations (anything that produces columns)
					$query = @"
        SELECT c.TABLE_SCHEMA as "schema", c.TABLE_NAME as "object", 
            case when v.Table_Name IS NULL then 'Table' ELSE 'View' END AS "Type",
            c.COLUMN_NAME as "column", c.ordinal_position,
            CONCAT (column_type, 
			case when IS_nullable = 'NO' then ' NOT' ELSE '' END ,
			' NULL', 
		  	case when COLUMN_DEFAULT IS NULL then '' ELSE CONCAT (' DEFAULT (',COLUMN_DEFAULT,')') END,
			' ',
			Extra,
			' '
			-- case COLUMN_KEY when 'PRI' then ' PRIMARY KEY' ELSE '' end,
			-- case when column_comment <> '' then CONCAT('-- ',column_comment) ELSE '' end
		 ) AS coltype  
        FROM information_schema.columns c 
        LEFT OUTER JOIN information_schema.views v 
        ON c.TABLE_NAME=v.Table_Name
        AND v.table_Schema=c.table_Schema
        WHERE c.table_schema in ($ListOfSchemas)
        and c.TABLE_NAME <> '$FlywayTableName';
"@
					$TheRelationMetadata = Execute-SQL $param1 $query | ConvertFrom-json
					#now get the details of the routines
					$query = @"
            SELECT 
		Routine_name AS "name", Routine_Schema AS "schema", 
		CONCAT(Routine_Schema,'.', Routine_name) AS "fullname", 
		LOWER(routine_type) AS "type",
		CONCAT(LEFT(routine_definition,800), CASE WHEN LENGTH(routine_definition)>800 THEN '...' ELSE '' END) AS definition, 
		MD5(routine_definition) AS "hash" -- ,
		-- Routine_Comment AS "comment"
	FROM information_schema.routines
	WHERE Routine_Schema IN ($ListOfSchemas) 
UNION ALL
SELECT 
		Table_name AS "name", 
		Table_Schema AS "schema", 
		CONCAT(table_Schema,'.', table_name) AS "fullname", 
		'table' AS "type",
		'' AS definition, 
		MD5('') AS HASH -- ,
		-- TABLE_Comment AS COMMENT
	FROM information_schema.tables
	WHERE Table_type='base table' 
		AND Table_Schema IN ($ListOfSchemas) 
		AND TABLE_NAME NOT LIKE '$FlywayTableName' 
UNION ALL
	SELECT 
		Table_name AS "name", 
		Table_Schema AS "schema", 
		CONCAT(Table_Schema,'.', Table_name) AS "fullname", 
		'view' AS "type",
		View_definition AS definition, 
		MD5(View_definition) AS HASH -- ,
		-- '' AS COMMENT
	FROM information_schema.views
		WHERE Table_Schema IN ($ListOfSchemas) 
		AND TABLE_NAME NOT LIKE '$FlywayTableName'
"@
					$Routines = Execute-SQL $param1 $query | ConvertFrom-json
					#now do the constraints
					$query = @"
             SELECT lower(tc.constraint_type) AS "type", tc.table_schema AS "schema", 
               tc.Table_name, kcu.constraint_name, kcu.column_name,ordinal_position,
			   concat(Referenced_table_Schema,'.',Referenced_table_name) AS "referenced_table",referenced_column_name
            FROM information_schema.table_constraints AS tc 
            JOIN information_schema.key_column_usage AS kcu 
              ON tc.constraint_name = kcu.constraint_name 
              AND tc.table_name=kcu.table_name
              AND tc.table_schema=kcu.table_schema
            WHERE tc.table_schema IN ($ListOfSchemas)
            and tc.TABLE_NAME <> '$FlywayTableName'; 
"@
					$Constraints = Execute-SQL $param1 $query | ConvertFrom-json
            <# Now get the details of all the indexes that aren't primary keys, including the columns,  #>
					$indexes = Execute-SQL $param1 @"
            SELECT Table_Schema as "schema",TABLE_NAME, Index_name, COLUMN_NAME, Seq_in_Index AS "sequence" 
            FROM information_schema.statistics
            WHERE table_Schema IN ($ListOfSchemas) 
              AND index_name NOT IN ('PRIMARY','UNIQUE')
              and TABLE_NAME <> '$FlywayTableName';    
"@ | ConvertFrom-Json
					
					#now get all the triggers
					$triggers = Execute-SQL $param1 @"
            SELECT TRIGGER_SCHEMA, TRIGGER_NAME, event_object_schema, event_object_table
            FROM information_schema.triggers t
            WHERE t.trigger_catalog IN ($ListOfSchemas); 
"@ | ConvertFrom-Json
					
            <# RDBMS  #>
					$THeTypes = $Routines | Select schema, type -Unique
            <# OK. we now have to assemble all this into a model that is as human-friendly as possible  #>
					$SchemaTree = @{ } <# This will become our model of the schema. Fist we put in
            all the types of relations  #>
					
					
					$TheTypes | Select -ExpandProperty schema -Unique | foreach{
						$TheSchema = $_;
						$ourtypes = @{ }
						$TheTypes | where { $_.schema -eq $TheSchema } | Select -ExpandProperty type | foreach{ $OurTypes += @{ $_ = @{ } } }
						$SchemaTree | add-member -NotePropertyName $TheSchema -NotePropertyValue $OurTypes
						
					}
					
            <# now inject all the objects into the schema tree. First we get all the relations  #>
					$TheRelationMetadata | Select schema, type, object -Unique | foreach{
						$schema = $_.schema;
						$type = $_.type;
						$object = $_.object;
						$TheColumnList = $TheRelationMetadata |
						where { $_.schema -eq $schema -and $_.type -eq $type -and $_.object -eq $object } -OutVariable pk |
						Sort-Object -Property ordinal_position |
						foreach{ "$($_.column) $($_.coltype)" }
						$SchemaTree.$schema.$type += @{ $object = @{ 'columns' = $TheColumnList } }
					}
					
            <# now stitch in the constraints with their columns  #>
					$constraints | Select schema, table_name, Type, constraint_name, referenced_table -Unique | foreach{
						$constraintSchema = $_.schema;
						$constrainedTable = $_.table_name;
						$constraintName = $_.constraint_name;
						$ConstraintType = $_.type;
						$referenced_table = $_.referenced_table;
						# get the original object
						$OriginalConstraint = $constraints |
						where{
							$_.schema -eq $constraintSchema -and
							$_.table_name -eq $constrainedTable -and
							$_.Type -eq $ConstraintType -and
							$_.constraint_name -eq $constraintName
						} | Select -first 1
						$Columns = $OriginalConstraint | Sort-Object -Property ordinal_position |
						Select -ExpandProperty column_name
						if ($ConstraintType -eq 'foreign key')
						{
							$Referencing = $OriginalConstraint | Sort-Object -Property ordinal_position |
							Select -ExpandProperty referenced_column_name
							$SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{
								$constraintName = @{ 'Cols' = $columns; 'Foreign Table' = $referenced_table; 'Referencing' = "$Referencing" }
							}
						}
						else
						{ $SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{ $constraintName = $columns } }
						
					}
					
            <# now stitch in the indexes with their columns  #>
					$indexes | Select schema, table_name, Type, index_name, definition -Unique | foreach{
						$indexSchema = $_.schema;
						$indexedTable = $_.table_name;
						$indexName = $_.index_name;
						$definition = $_.definition;
						$columns = $indexes |
						where{
							$_.schema -eq $indexSchema -and
							$_.table_name -eq $indexedTable -and
							$_.index_name -eq $indexName
						} |
						Select -ExpandProperty column_name
						$SchemaTree.$indexSchema.table.$indexedTable.index += @{ $indexName = @{ 'Indexing' = $columns; 'def' = "$definition" } }
					}
					$routines | Foreach {
						$TheSchema = $_.schema;
						$TheName = $_.name;
						$TheType = $_.type;
						$TheHash = $_.hash;
						$Thecomment = $_.comment;
						$TheDefinition = $_.definition;
						$Contents = @{ }
						if (!([string]::IsNullOrEmpty($TheDefinition))) { $Contents.'definition' = $TheDefinition }
						if ($TheType -ne 'table') { $Contents.'hash' = $Thehash }
						if (!([string]::IsNullOrEmpty($Thecomment))) { $Contents.'comment' = $TheComment }
						if ($SchemaTree.$TheSchema.$TheType.$TheName -eq $null)
						{ $SchemaTree.$TheSchema.$TheType.$TheName = $Contents }
						else
						{ $SchemaTree.$TheSchema.$TheType.$TheName += $Contents }
						
					}
					
					
					
					$SchemaTree | convertTo-json -depth 10 > "$MyOutputReport"
					$SchemaTree | convertTo-json -depth 10 > "$MycurrentReport"
				}
<# start of the oracle section #> 
                'oracle'
                {
                	$ScriptsToExecute = @(
		                @{
			                ResultFile = 'Objects.json';
			                SQL =@"
                /*--- get list of objects ---*/
                select obj.OBJECT_TYPE as "type", obj.OWNER as "schema"
                from sys.all_objects obj
                where obj.owner in ($ListOfSchemas)  
                and object_type not in ('INDEX','SEQUENCE')
                group by obj.object_type,obj.owner;
"@
		                }
		                @{
			                ResultFile = 'columns.json';
			                SQL =@"
                /*--- get all columns and their definitions ---*/
                select col.column_id as "ordinal_position", col.owner as "schema",  type.The_Type as "type",
                       col.table_name as "object", col.column_name as "column", 
                       data_type||
                case
                when col.data_precision is not null and nvl(col.data_scale,0)>0 
                    then '('||col.data_precision||','||col.data_scale||')'
                when col.data_precision is not null and nvl(col.data_scale,0)=0 
                    then '('||col.data_precision||')'
                when col.data_precision is null and col.data_scale is not null 
                    then '(*,'||col.data_scale||')'
                when col.char_length>0 
                    then '('||col.char_length|| 
                        case col.char_used 
                             when 'B' then ' Byte'
                             when 'C' then ' Char'
                             else null 
                        end||')'
                end||decode(nullable, 'N', ' NOT NULL') as "coltype"
                from sys.all_tab_columns col
                inner join 
                    (Select Table_name, 'Table' as The_Type, owner
                    from sys.all_tables
                    union all 
                    Select view_name, 'View',owner
                    from sys.all_views)type
                on col.owner = type.owner 
                and col.table_name = type.table_name
                where type.owner  in ('DBO','PEOPLE','ACCOUNTING') 
                and  type.table_name <> '$FlywayTableName'
                order by "schema", "object", "type", "ordinal_position";
"@
		                }
		                @{
			                ResultFile = 'routines.json';
			                SQL =@"
                /*--- get all routines ---*/
                Select f.schema, f.name, f.type, f.definition, '' as "comment", 0 as "hash",
                 LISTAGG(args.in_out || ' ' || args.data_type, '; ')
                              WITHIN GROUP (ORDER BY position) as arguments
                from (
                select obj.owner as schema,
                       obj.object_id,
                       obj.object_name as name,
                       obj.object_type as type,
                       listagg(text) within group (order by line) as definition
                from sys.all_objects obj
                inner join sys.all_source source 
                  on  source.owner=obj.owner 
                  and source.name=obj.object_name and source.type=object_type
                where obj.object_type in ('PROCEDURE','FUNCTION')
                      and obj.owner in ($ListOfSchemas)  
                      group by obj.owner, obj.object_id, obj.object_type, obj.object_name)f
                left outer join sys.all_arguments args on args.object_id = f.object_id
                left outer join (
                      select object_id,
                             object_name,
                             data_type
                      from sys.all_arguments
                      where position = 1
                ) ret on ret.object_id = f.object_id
                       and ret.object_name = f.name
                group by f.schema, f.name, f.type, f.definition;

"@
		                }
		                @{
			                ResultFile = 'constraints.json';
			                SQL =@"
                /* get all constraints and foreign key constraint targets */
                Select cols.position as "ordinal_position", source.owner as "schema",source.table_name as "table_name", case source.constraint_type  when 'C' then 'check constraint' when 'P' then 'primary key' when 'F' then 'foreign key' when 'U' then 'unique key' 
                        when 'R' then 'foreign_key' when 'V' then 'View Check option'  when 'O' then 'With read only' else source.constraint_type end  as "type", source.constraint_name, 
                source.owner || '.' || source.table_name as Source_Table,cols.column_name as "column_name",
                source.search_condition as "condition", 
                case when source.constraint_type = 'R' then source.R_constraint_name else null end as target_Constraint, 
                case when target.table_name is not null then target.owner || '.' || target.table_name else null end  as "referenced_table",
                FKcols.column_name as "referenced_column_name"
                from all_cons_columns cols
                inner join  all_constraints source
                on cols.TABLE_Name=source.table_name and cols.owner=source.owner  and source.constraint_name=cols.constraint_name
                left outer join all_constraints target
                on source.R_constraint_name =target.constraint_name and source.owner=target.owner 
                left outer join all_cons_columns FKcols
                on FKcols.TABLE_Name=target.table_name and FKcols.owner=target.owner and target.constraint_name=fkcols.constraint_name
                where source.owner in ($ListOfSchemas)  
                and source.table_name not like 'BIN$%'
                and source.table_name not like '$FlywayTableName'
                and source.constraint_name not like 'SYS%';
"@
		                }
		                @{
			                ResultFile = 'triggers.json';
			                SQL =@"
                /*--- get all Triggers ---*/
                select trig.table_owner as "schema", trig.table_name as "Name", trig.owner as "triggerSchema",
                       trig.trigger_name as "triggerName",  trig.trigger_type as "triggerType",
                       trig.base_object_type as "baseObjectType", trig.triggering_event as "event", 
                       trig.status as "status", trig.trigger_body as "script"       
                from sys.all_triggers trig
                inner join sys.all_tables tab on trig.table_owner = tab.owner
                                                and trig.table_name = tab.table_name
                where trig.owner in ($ListOfSchemas);
"@
		                }
		                @{
			                ResultFile = 'Indexes.json';
			                SQL =@"
                /*--- get all Indexes ---*/
                select ind.index_name,
                       ind_col.column_name,
                       ind.index_type,
                       ind.uniqueness as definition,
                       ind.table_owner as schema,
                       ind.table_name as table_name,
                       ind.table_type as object_type,
                       f.column_expression
                from sys.all_indexes ind
                inner join sys.all_ind_columns ind_col on ind.owner = ind_col.index_owner
                                                    and ind.index_name = ind_col.index_name
                LEFT JOIN all_ind_expressions f
                 ON   ind_col.index_owner     = f.index_owner
                 AND  ind_col.index_name      = f.index_name
                 AND  ind_col.table_owner     = f.table_owner
                 AND  ind_col.table_name      = f.table_name
                 AND  ind_col.column_position = f.column_position
                where ind.table_owner like 'DBO'
                and ind.table_name not like '$FlywayTableName'
                order by ind.table_owner,
                         ind.table_name,
                         ind.index_name,
                         ind_col.column_position;
"@
		                }
	                )
	                $ExecutePLSQLScript.invoke($param1, $null, $ScriptsToExecute)
	                $TheTypes = ([IO.File]::ReadAllText("$pwd/objects.json") | convertfrom-json).results.items
	                $TheRelationMetadata = ([IO.File]::ReadAllText("$pwd/columns.json") | convertfrom-json).results.items
	                $constraints = ([IO.File]::ReadAllText("$pwd/constraints.json") | convertfrom-json).results.items
	                $indexes = ([IO.File]::ReadAllText("$pwd/indexes.json") | convertfrom-json).results.items
	                $routines = ([IO.File]::ReadAllText("$pwd/routines.json") | convertfrom-json).results.items

                    @("$pwd\objects.json","$pwd\columns.json","$pwd\constraints.json",
                    "$pwd\indexes.json","$pwd\routines.json","$pwd\triggers.json") | foreach{
	                    If (Test-Path -Path "$_")
	                    {
		                    Remove-Item "$_"
	                    }
                    }	
                           <# RDBMS  #>
                            <# OK. we now have to assemble all this into a model that is as human-friendly as possible  #>
	                $SchemaTree = @{ } <# This will become our model of the schema. Fist we put in
                            all the types of relations  #>
	
	
	                $TheTypes | Select -ExpandProperty schema -Unique | foreach{
		                $TheSchema = $_;
		                $ourtypes = @{ }
		                $TheTypes | where { $_.schema -eq $TheSchema } | Select -ExpandProperty type | foreach{ $OurTypes += @{ $_ = @{ } } }
		                $SchemaTree | add-member -NotePropertyName $TheSchema -NotePropertyValue $OurTypes
		
	                }
	
                            <# now inject all the objects into the schema tree. First we get all the relations  #>
	                $TheRelationMetadata | Select schema, type, object -Unique | foreach{
		                $schema = $_.schema;
		                $type = $_.type;
		                $object = $_.object;
		                $TheColumnList = $TheRelationMetadata |
		                where { $_.schema -eq $schema -and $_.type -eq $type -and $_.object -eq $object } -OutVariable pk |
		                Sort-Object -Property ordinal_position |
		                foreach{ "$($_.column) $($_.coltype)" }
		                $SchemaTree.$schema.$type += @{ $object = @{ 'columns' = $TheColumnList } }
	                }
	
                            <# now stitch in the constraints with their columns  #>
	                $constraints | Select schema, table_name, Type, constraint_name, referenced_table -Unique | foreach{
		                $constraintSchema = $_.schema;
		                $constrainedTable = $_.table_name;
		                $constraintName = $_.constraint_name;
		                $ConstraintType = $_.type;
		                $referenced_table = $_.referenced_table;
		                # get the original object
		                $OriginalConstraint = $constraints |
		                where{
			                $_.schema -eq $constraintSchema -and
			                $_.table_name -eq $constrainedTable -and
			                $_.Type -eq $ConstraintType -and
			                $_.constraint_name -eq $constraintName
		                } | Select -first 1
		                $Columns = $OriginalConstraint | Sort-Object -Property ordinal_position |
		                Select -ExpandProperty column_name
		                if ($ConstraintType -eq 'foreign key')
		                {
			                $Referencing = $OriginalConstraint | Sort-Object -Property ordinal_position |
			                Select -ExpandProperty referenced_column_name
			                $SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{
				                $constraintName = @{ 'Cols' = $columns; 'Foreign Table' = $referenced_table; 'Referencing' = "$Referencing" }
			                }
		                }
		                else
		                {
			                $SchemaTree.$constraintSchema.table.$constrainedTable."$ConstraintType" += @{ $constraintName = $columns }
		                }
		
	                }
	
                            <# now stitch in the indexes with their columns  #>
	                $indexes | Select schema, table_name, Type, index_name, definition -Unique | foreach{
		                $indexSchema = $_.schema;
		                $indexedTable = $_.table_name;
		                $indexName = $_.index_name;
		                $definition = $_.definition;
		                $columns = $indexes |
		                where{
			                $_.schema -eq $indexSchema -and
			                $_.table_name -eq $indexedTable -and
			                $_.index_name -eq $indexName
		                } |
		                Select -ExpandProperty column_name
		                $SchemaTree.$indexSchema.table.$indexedTable.index += @{ $indexName = @{ 'Indexing' = $columns; 'def' = "$definition" } }
	                }
	                $routines | Foreach {
		                $TheSchema = $_.schema;
		                $TheName = $_.name;
		                $TheType = $_.type;
		                $TheHash = $_.hash;
		                $Arguments = $_.arguments;
		                $Thecomment = $_.comment;
		                $TheDefinition = $_.definition;
		                $Contents = @{ }
		                if (!([string]::IsNullOrEmpty($TheDefinition))) { $Contents.'definition' = $TheDefinition }
		                if ($TheType -ne 'table') { $Contents.'hash' = $Thehash }
		                if (!([string]::IsNullOrEmpty($Thecomment))) { $Contents.'comment' = $TheComment }
		                if ($SchemaTree.$TheSchema.$TheType.$TheName -eq $null)
		                { $SchemaTree.$TheSchema.$TheType.$TheName = $Contents }
		                else
		                { $SchemaTree.$TheSchema.$TheType.$TheName += $Contents }
		
	                }
		            $Triggers | Foreach {
                        $Theschema= $_.schema;
                        $Thename= $_.name;
                        $Thetriggerschema= $_.triggerschema;
                        $Thetriggername= $_.triggername;
                        $Thetriggertype= $_.triggertype;
                        $Thebaseobjecttype= $_.baseobjecttype;
                        $Theevent= $_.event; 
                        $Thestatus= $_.status; 
                        $Thescript= $_.script;
		                $Contents = @{'Name'=$Thetriggername; 'Type'=$Thetriggertype;
                        'event'=$Theevent;'status'=$Thestatus; 'script'=$Thescript};
     	                $SchemaTree.$TheSchema.$Thebaseobjecttype.$Thename.'trigger' = $Contents
	                    }	
	
	                $SchemaTree | convertTo-json -depth 10 > "$MyOutputReport"
	                $SchemaTree | convertTo-json -depth 10 > "$MycurrentReport"
                }
				
<# this is the section that creates a SQL Server Database Model based where
possible on information schema #>
				'sqlserver'  {
					#fetch all the relations (anything that produces columns)
					$query = @"
SELECT ParentObjects.[Schema] AS "Schema", ParentObjects.type,
       ParentObjects.Name,
       colsandparams.name + ' ' +
-- SQL Prompt formatting off
			t.[name]+ CASE --do the basic datatype
			WHEN t.[name] IN ('char', 'varchar', 'nchar', 'nvarchar')
			THEN '(' + -- we have to put in the length
				CASE WHEN ValueTypemaxlength = -1 THEN 'MAX'
				ELSE CONVERT(VARCHAR(4),
					CASE WHEN t.[name] IN ('nchar', 'nvarchar')
					THEN ValueTypemaxlength / 2 ELSE ValueTypemaxlength
					END)
				END + ')' --having to put in the length
			WHEN t.[name] IN ('decimal', 'numeric')
			--Ah. We need to put in the precision
			THEN '(' + CONVERT(VARCHAR(4), ValueTypePrecision)
					+ ',' + CONVERT(VARCHAR(4), ValueTypeScale) + ')'
			ELSE ''-- no more to do
			END+ --we've now done the datatype
			CASE WHEN XMLcollectionID <> 0 --when an XML document
			THEN --deal with object schema names
				'(' +
				CASE WHEN isXMLDocument = 1 THEN 'DOCUMENT ' ELSE 'CONTENT ' END
				+ COALESCE(
				QUOTENAME(Schemae.name) + '.' + QUOTENAME(SchemaCollection.name)
				,'NULL') + ')'
				ELSE ''
			END -- +Coalesce(' -- '+Description,'')
        	AS "Column",
			TheOrder
-- SQL Prompt formatting on
  FROM --columns, parameters, return values ColsAndParams.
    --first get all the parameters
    (SELECT cols.object_id, cols.name, 'Columns' AS "Type",
            Convert (NVARCHAR(2000), value) AS "Description",
            column_id AS TheOrder, cols.xml_collection_id,
            cols.max_length AS ValueTypemaxlength,
            cols.precision AS ValueTypePrecision,
            cols.scale AS ValueTypeScale,
            cols.xml_collection_id AS XMLcollectionID,
            cols.is_xml_document AS isXMLDocument, cols.user_type_id
       FROM
       sys.objects AS object
         INNER JOIN sys.columns AS cols
           ON cols.object_id = object.object_id
         LEFT OUTER JOIN sys.extended_properties AS EP
           ON cols.object_id = EP.major_id
          AND class = 1
          AND minor_id = cols.column_id
          AND EP.name = 'MS_Description'
       WHERE is_ms_shipped = 0
     UNION ALL
     --get in all the parameters
     SELECT params.object_id, params.name AS "Name",
            CASE WHEN parameter_id = 0 THEN 'Return' ELSE 'Parameters' END AS "Type",
            --'Parameters' AS "Type",
            Convert (NVARCHAR(2000), value) AS "Description",
            parameter_id AS TheOrder, params.xml_collection_id,
            params.max_length AS ValueTypemaxlength,
            params.precision AS ValueTypePrecision,
            params.scale AS ValueTypeScale,
            params.xml_collection_id AS XMLcollectionID,
            params.is_xml_document AS isXMLDocument, params.user_type_id
       FROM
       sys.objects AS object
         INNER JOIN sys.parameters AS params
           ON params.object_id = object.object_id
         LEFT OUTER JOIN sys.extended_properties AS EP
           ON params.object_id = EP.major_id
          AND class = 2
          AND minor_id = params.parameter_id
          AND EP.name = 'MS_Description'
       WHERE is_ms_shipped = 0) AS colsandparams
    INNER JOIN sys.types AS t
      ON colsandparams.user_type_id = t.user_type_id
    LEFT OUTER JOIN sys.xml_schema_collections AS SchemaCollection
      ON SchemaCollection.xml_collection_id = colsandparams.xml_collection_id
    LEFT OUTER JOIN sys.schemas AS Schemae
      ON SchemaCollection.schema_id = Schemae.schema_id
    RIGHT OUTER JOIN --catch parent objects without columns
      (SELECT TheObjects.object_id,
              Object_Schema_Name (TheObjects.object_id) AS "Schema",
              Replace (Lower (Replace (Replace (TheObjects.type_desc, 'user_', ''), 'sql_', '')), '_',' ') AS type, 
			  Object_Name (TheObjects.object_id) Name
         FROM sys.objects TheObjects
         WHERE
         Object_Schema_Name (TheObjects.object_id) IN ($ListOfSchemas)
     AND TheObjects.parent_object_id = 0
     AND type <> 'SQ') ParentObjects
      ON ParentObjects.object_id = colsandparams.object_id
  WHERE Object_Name (ParentObjects.object_id) <> '$FlywayTableName'
  ORDER BY
  "Schema", "type", Name, TheOrder
FOR JSON AUTO
"@
					$TheRelationMetadata = Execute-SQL $param1 $query | ConvertFrom-json
					#now get the details of the routines
					$query = @'
    SELECT Replace (Lower (Replace(Replace(so.type_desc,'user_',''),'sql_','')), '_', ' ') as type,
        so.name, Object_Schema_Name(so.object_id) AS "schema", 
        left(definition,2000)+CASE when LEN(definition)>2000 THEN '...' ELSE '' END AS definition, 
        checksum(definition) AS hash 
        FROM sys.sql_modules ssm
        INNER JOIN sys.objects so
        ON so.OBJECT_ID=ssm.object_id
        FOR JSON auto               
'@
					$Routines = Execute-SQL $param1 $query | ConvertFrom-json
					
					#now do the constraints
					$query = @"
SELECT *
  FROM
    (SELECT Schema_Name (tab.schema_id) AS "schema",
            tab.name AS [table_name], 'Foreign Key' AS "type",
            fk.name AS "constraint_name", '' AS "definition",
            Schema_Name (pk_tab.schema_id) + '.' + pk_tab.name AS referenced_table,
            col.name AS column_name,
            fk_cols.constraint_column_id AS ordinal_position,
            pk_col.name AS referenced_column,
            fk_cols.constraint_column_id AS referenced_ordinal_position
       FROM
       sys.tables tab
         INNER JOIN sys.columns col
           ON col.object_id = tab.object_id
         INNER JOIN sys.foreign_key_columns fk_cols
           ON fk_cols.parent_object_id = tab.object_id
          AND fk_cols.parent_column_id = col.column_id
         INNER JOIN sys.foreign_keys fk
           ON fk.object_id = fk_cols.constraint_object_id
         INNER JOIN sys.tables pk_tab
           ON pk_tab.object_id = fk_cols.referenced_object_id
         INNER JOIN sys.columns pk_col
           ON pk_col.column_id = fk_cols.referenced_column_id
          AND pk_col.object_id = fk_cols.referenced_object_id
     UNION ALL
     SELECT Object_Schema_Name (tab.object_id) AS "Schema", tab.name,
            CASE WHEN pk.is_primary_key = 1 THEN 'primary key'
              WHEN pk.is_unique_constraint = 1 THEN 'unique key' ELSE 'index' END AS "Type",
            pk.name, '' AS "Definition", NULL AS referenced_table,
            col.name AS fk_column_name, col.column_id AS fk_ordinal_position,
            NULL AS referenced_column, NULL AS referenced_ordinal_position
       FROM
       sys.tables tab
         LEFT OUTER JOIN sys.indexes pk
           ON tab.object_id = pk.object_id
         INNER JOIN sys.index_columns ic
           ON ic.object_id = tab.object_id AND ic.index_id = pk.index_id
         INNER JOIN sys.columns col
           ON ic.object_id = col.object_id AND ic.column_id = col.column_id
     UNION ALL
     SELECT Schema_Name (t.schema_id) AS "Schema", t.[name],
            'Check constraint', con.[name] AS constraint_name,
            con.[definition], NULL, NULL, NULL, NULL, NULL
       FROM
       sys.check_constraints con
         LEFT OUTER JOIN sys.objects t
           ON con.parent_object_id = t.object_id
         LEFT OUTER JOIN sys.all_columns col
           ON con.parent_column_id = col.column_id
          AND con.parent_object_id = col.object_id
     UNION ALL
     SELECT Schema_Name (t.schema_id) AS "Schema", t.[name],
            'Check constraint', con.[name] AS constraint_name,
            con.[definition], NULL, NULL, NULL, NULL, NULL
       FROM
       sys.check_constraints con
         LEFT OUTER JOIN sys.objects t
           ON con.parent_object_id = t.object_id
         LEFT OUTER JOIN sys.all_columns col
           ON con.parent_column_id = col.column_id
          AND con.parent_object_id = col.object_id
     UNION ALL
     SELECT Schema_Name (t.schema_id) AS "Schema", t.[name],
            'Default constraint', con.[name],
            col.[name] + ' = ' + con.[definition], NULL, NULL, NULL, NULL,
            NULL
       FROM
       sys.default_constraints con
         LEFT OUTER JOIN sys.objects t
           ON con.parent_object_id = t.object_id
         LEFT OUTER JOIN sys.all_columns col
           ON con.parent_column_id = col.column_id
          AND 
           con.parent_object_id = col.object_id) f
 where f.table_name <> '$FlywayTableName'
FOR JSON AUTO
"@
					$Constraints = Execute-SQL $param1 $query | ConvertFrom-json
					if (!($constraints.Error -eq $null)) { $Problems += $constraints.Error }
            <# 
            Now get the details of all the indexes that aren't primary keys, including the columns,  
					$indexes = Execute-SQL $param1 @"
    SELECT Schema_Name (t.schema_id) AS "schema", t.name AS table_name,
       Replace (
         Lower (Replace (Replace (t.type_desc, 'user_', ''), 'sql_', '')),
         '_',
         ' ') AS type, i.type_desc AS indexType, i.[name] AS Index_name,
       col.name, ic.key_ordinal
      FROM
      sys.indexes i
        INNER JOIN sys.objects t
          ON t.object_id = i.object_id
        INNER JOIN sys.index_columns ic
          ON ic.object_id = t.object_id AND ic.index_id = i.index_id
        INNER JOIN sys.columns col
          ON ic.object_id = col.object_id AND ic.column_id = col.column_id
      WHERE
      t.is_ms_shipped = 0
    AND i.is_primary_key = 0
    AND i.is_unique = 0
    AND i.type IN (1, 2)
       for json path
"@ | ConvertFrom-Json
#>
					
					#now get all the triggers
					$triggers = Execute-SQL $param1 @'
 select schema_name(tab.schema_id) AS "schema",
 tab.name as [table],
    trig.name as trigger_name,
    case when is_instead_of_trigger = 1 then 'Instead of'
        else 'After' end as [activation],
    (case when objectproperty(trig.object_id, 'ExecIsUpdateTrigger') = 1 
            then 'Update ' else '' end
    + case when objectproperty(trig.object_id, 'ExecIsDeleteTrigger') = 1 
            then 'Delete ' else '' end
    + case when objectproperty(trig.object_id, 'ExecIsInsertTrigger') = 1 
            then 'Insert ' else '' end
    ) as [event],
    case when trig.[type] = 'TA' then 'Assembly (CLR) trigger'
        when trig.[type] = 'TR' then 'SQL trigger' 
        else '' end as [type],
    case when is_disabled = 1 then 'Disabled'
        else 'Active' end as [status],
		left(object_definition(trig.object_id),70)+CASE when LEN(object_definition(trig.object_id))>70 THEN '...' ELSE '' END AS definition, 
        checksum(object_definition(trig.object_id)) AS hash
from sys.triggers trig
    inner join sys.objects tab
        on trig.parent_id = tab.object_id
order by schema_name(tab.schema_id) + '.' + tab.name, trig.name
FOR JSON auto
'@ | ConvertFrom-Json
					
            <# RDBMS  #>
					#$ErrorActionPreference='Stop' 
					$THeTypes = $TheRelationMetadata | Select schema, type -Unique
					if ($Routines -ne $null)
					{ $TheTypes = $THeTypes + $Routines | Select schema, type -Unique }
            <# OK. we now have to assemble all this into a model that is as human-friendly as possible  #>
					$SchemaTree = @{ } <# This will become our model of the schema. Fist we put in
            all the types of relations  #>
					
					
					$TheTypes | Select -ExpandProperty schema -Unique | foreach{
						$TheSchema = $_;
						$ourtypes = @{ }
						$TheTypes | where { $_.schema -eq $TheSchema } | Select -ExpandProperty type | foreach{ $OurTypes += @{ $_ = @{ } } }
						$SchemaTree | add-member -NotePropertyName $TheSchema -NotePropertyValue $OurTypes
					}
					
            <# now inject all the objects into the schema tree. First we get all the relations  #>
					$TheRelationMetadata | Select schema, type, name -Unique | foreach{
						$schema = $_.schema;
						$type = $_.type;
						$object = $_.name;
						$TheColumnList = $TheRelationMetadata |
						where { $_.schema -eq $schema -and $_.type -eq $type -and $_.name -eq $object } -OutVariable pk |
						foreach{ $_.column }
						$SchemaTree.$schema.$type += @{ $object = @{ 'columns' = $TheColumnList } }
					}
					#display-object $schemaTree|convertto-json -depth 10
            <# now stitch in the constraints and indexes with their columns  #>
					$constraints | Select schema, table_name, Type, constraint_name, referenced_table, definition -Unique | foreach{
						$constraintSchema = $_.schema;
						$constrainedTable = $_.table_name;
						$constraintName = $_.constraint_name;
						$ConstraintType = $_.type;
						$referenced_table = $_.referenced_table;
						$definition = $_.definition;
						# get the original object
						if ($ConstraintType -notin @('Unique key','index', 'Primary key', 'foreign key'))
						{ $SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType = @{ $constraintName = $definition } }
						else
						{
							#we have to deal with columns
							$OriginalConstraint = $constraints |
							where{
								$_.schema -eq $constraintSchema -and
								$_.table_name -eq $constrainedTable -and
								$_.Type -eq $ConstraintType -and
								$_.constraint_name -eq $constraintName
							} #| Select -first 1 --why this?
							$Columns = $OriginalConstraint | Sort-Object -Property ordinal_position |
							Select -ExpandProperty column_name
							if ($ConstraintType -eq 'foreign key')
							{
								$Referencing = $OriginalConstraint | Sort-Object -Property ordinal_position |
								Select -ExpandProperty referenced_column
								$SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{
									$constraintName = @{ 'Cols' = $columns; 'Foreign Table' = $referenced_table; 'Referencing' = "$Referencing" }
								}
							}
							elseif ($ConstraintType -in @('Unique key', 'index', 'Primary key'))
							{ $SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{ $constraintName = $columns } }
							
						}
						
					}
					
					
            <# now stitch in the indexes with their columns  
					$indexes | Select schema, table_name, Type, IndexType, index_name -Unique | foreach{
						$indexSchema = $_.schema;
						$indexedTable = $_.table_name;
						$indexName = $_.index_name;
						$indexType = $_.indexType;
                        $columns = $indexes |
						where{
							$_.schema -eq $indexSchema -and
							$_.table_name -eq $indexedTable -and
							$_.index_name -eq $indexName
						} | Sort-Object -Property key_ordinal | Select -ExpandProperty name
                        Write-Warning "$indexSchema $indexedTable $indexName "
						$SchemaTree.$indexSchema.table.$indexedTable.index += @{ $indexName = @{ 'Indexing' = $columns;'IndexType'=$indexType } }
					} #>
					$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
					$SchemaTree | convertTo-json -depth 10 > "$MyOutputReport"
					$SchemaTree | convertTo-json -depth 10 > "$MycurrentReport"
					
					
				} #end SQL Server
				default
				{
					$Param1.Problems.'SavedDatabaseModelIfNecessary' += "The $_ database isn't supported yet. Sorry about that."
				}
			}
			#Final things to do: Break up the model into individual objects, in different folders depending on type
            #while we are about it, we'll do the table manifest
			if (Test-Path "$MyOutputReport" -PathType leaf)
			{
			$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8' #we'll need it
			$Model = [IO.File]::ReadAllText("$MyOutputReport") | ConvertFrom-JSON
			$model.psobject.Properties |
			foreach{ $schema = $_.Name; $_.Value.psobject.Properties } |
			Foreach{ $Type = $_.Name.ToLower(); $_.Value.psobject.Properties } |
			foreach{
				$objectName = $_.Name;
				$WhereToStoreIt = "$MyModelPath\$type"
				if (-not (Test-Path "$WhereToStoreIt" -PathType Container))
				{ $null = New-Item -ItemType directory -Path "$WhereToStoreIt" -Force }
				$_.Value | convertto-json > "$WhereToStoreIt\$schema.$objectName.json"
				Copy-Item -Path "$MyModelPath" -Destination "$MyCurrentPath" -Recurse -Force
			}
			$feedback += "written object-level model to $MyModelPath"
			
            #now do the table manifest
            #calculate the path to save the manifest to
            $MyManifestPath="$(split-path -Path $MyOutputReport -Parent)\TableManifest.txt";
            #get all the foreign key references
            $TableReferences = Display-Object $Model | where { $_.path -like '$*.*.table.*.Foreign key.*' } | foreach{
	            $Splitpath = ($_.Path -split '\.')
	            $References = $_.value.'Foreign Table'; $Table = "$($Splitpath[1]).$($Splitpath[3])";
	            [pscustomObject]@{ 'referencing' = $Table; 'references' = $references }
            }
            $ObjectsToBuild = Display-Object $Model -reportNodes $true | where {
                 ($_.path -split '\.').count -eq 4 
                 } | select Path # get all the objects (for later full manifests)
            $Tables = $ObjectsToBuild | where { $_.path -like '$*.*.table.*' } | foreach {
	            $Splitpath = ($_.Path -split '\.'); "$($Splitpath[1]).$($Splitpath[3])"
            }
            #now we work out the dependency order. First we put in the tables that aren't being
            #referenced by anything
            $TablesInDependencyOrder = $Tables | where { $_ -notin $TableReferences.referencing }
            $ii = 10;
            do #add tables  their dependent 
            {
	            $PreviousCount = $TablesInDependencyOrder.count #$tables.count
	            $NotYetPicked = $Tables | where { $_ -notin $TablesInDependencyOrder }
	            $TablesInDependencyOrder += $NotYetPicked | where {
		            $_  -notin  ($NotyetPicked | foreach{
				            $notpicked = $_; $TableReferences | where {
					            $_.Referencing -eq $notpicked
				            }
			            } |
			            where {
				            $_.references -notin $TablesInDependencyOrder
			            } | Select -ExpandProperty referencing)
	            }
	            $ii--;
            }
            while (($TablesInDependencyOrder.count -lt $Tables.count) -and ($ii -gt 0))
            if ($TablesInDependencyOrder.count -ne $Tables.count)
            { Throw 'could not get tables in dependency order' }
            $TablesInDependencyOrder > $MyManifestPath #and save the manifest
            $feedback += "written table manifest  to $MyManifestPath"
            }
		}
		catch { $problems += "$($PSItem.Exception.Message)" }
	}
	else
	{
		$AlreadyDone = $true;
		$feedback += "Nothing to do. The model is already there in '$MyOutputReport'"
	}
	if ($problems.Count -gt 0)
	{
		$Param1.Problems.'SaveDatabaseModelIfNecessary' += $problems;
	}
	else
	{
		if ($AlreadyDone)
		{
			$Param1.Feedback.'SaveDatabaseModelIfNecessary' = "$MyOutputReport already exists"
		}
		else
		{
			if ($feedback.count -gt 0)
			{ $Param1.Feedback.'SaveDatabaseModelIfNecessary' = $feedback }
			$Param1.WriteLocations.'SaveDatabaseModelIfNecessary' = $MyOutputReport;
		}
	}
	
}

Process-FlywayTasks $dbDetails $SaveDatabaseModelIfNecessary 