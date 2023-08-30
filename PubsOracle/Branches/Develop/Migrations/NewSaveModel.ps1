<#
$SaveDatabaseModelIfNecessary

This writes a JSON model of the database to a file that can be used subsequently
to check for database version-drift or to create a narrative of changes for the
flyway project between versions.
'server', The name of the database server
'database', The name of the database
'pwd',The password 
'uid',  The UserID
'version', The version directory that is to be ascribed to the file
'project', The name of the whole project for the output filenames
'RDBMS', the rdbms being used, e.g. sqlserver, mysql, mariadb, postgresql, sqlite
'schemas', the schemas to be used to create the model
'flywayTable' the name and schema of the flyway table
'ReportDirectory' for an ad-hoc model
You can, though use parameters to specify the path to the model and reports for ad-hoc models 
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
'mysql|mariaDB' {
					#create a delimited list for SQL's IN command
					#fetch all the relations (anything that produces columns)
        Schema, type, Name , Column, TheOrder
		$query = @"
        SELECT c.TABLE_SCHEMA as "schema",  
            case when v.Table_Name IS NULL then 'Table' ELSE 'View' END AS "Type",
            c.TABLE_NAME as "Name",
            c.COLUMN_NAME as "column", c.ordinal_position,
            CONCAT (column_type, 
			case when IS_nullable = 'NO' then ' NOT' ELSE '' END ,
			' NULL', 
		  	case when COLUMN_DEFAULT = 'NULL' then '' ELSE CONCAT (' DEFAULT (',COLUMN_DEFAULT,')') END,
			' ',
			Extra,
			' ',
			-- case COLUMN_KEY when 'PRI' then ' PRIMARY KEY' ELSE '' end,
			case when column_comment <> '' then CONCAT('-- ',column_comment) ELSE '' end
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
#Fetch the preliminaries such as user-defined types, schemas, and RDBMS-specifics.
$Preliminaries = Execute-SQL $param1 @"
    SELECT TheSchema.name AS "schema", 'userType' AS "Type",
       UserTypes.name AS name,
       'CREATE TYPE ' + TheSchema.name + '.' + UserTypes.name + ' FROM '
       + sysTypes.name + ' '
       + CASE WHEN UserTypes.precision <> 0 AND UserTypes.scale <> 0 THEN
                '(' + Convert (VARCHAR(5), UserTypes.precision) + ','
                + Convert (VARCHAR(5), UserTypes.scale) + ')'
           WHEN UserTypes.max_length > 0 THEN
             '(' + Convert (VARCHAR(5), UserTypes.max_length) + ')'
           WHEN UserTypes.max_length = -1 THEN '(MAX)' ELSE '' END
       + CASE WHEN UserTypes.is_nullable = 0 THEN ' NOT' ELSE '' END
       + ' NULL' AS "definition"
  FROM
  sys.types UserTypes
    INNER JOIN sys.types sysTypes
      ON UserTypes.system_type_id = sysTypes.system_type_id
     AND sysTypes.is_user_defined = 0
     AND UserTypes.is_user_defined = 1
     AND sysTypes.system_type_id = sysTypes.user_type_id
    INNER JOIN sys.schemas AS TheSchema
      ON TheSchema.schema_id = UserTypes.schema_id
    for json path
"@ | ConvertFrom-Json
if ($Preliminaries.Error -ne $null)
                        { $Problems += $Preliminaries.Error
                        write-error "$($Preliminaries.Error)"}
                         
					#fetch all the relations (anything that produces columns)
	$query = @"
SELECT
	Object_Schema_Name(ParentObjects.object_id) AS "Schema",
	REPLACE(LOWER(REPLACE(REPLACE(ParentObjects.type_Desc, 'user_', ''), 'sql_', '')), '_', ' ') AS "type",
	ParentObjects.Name,
	colsandparams.name + ' ' +
	CASE
		WHEN colsandparams.definition IS NOT NULL THEN ' AS ' + colsandparams.definition
		ELSE
			CASE
				WHEN t.is_user_defined = 1 THEN ts.name + '.'
				ELSE ''
			END + t.[name] +
			CASE
				WHEN t.[name] IN ('char', 'varchar', 'nchar', 'nvarchar') THEN
					'(' +
					CASE
						WHEN colsandparams.ValueTypemaxlength = -1 THEN 'MAX'
						ELSE CONVERT(VARCHAR(4),
							CASE
								WHEN t.[name] IN ('nchar', 'nvarchar') THEN colsandparams.ValueTypemaxlength / 2
								ELSE colsandparams.ValueTypemaxlength
							END
						)
					END + ')'
				WHEN t.[name] IN ('decimal', 'numeric') THEN
					'(' + CONVERT(VARCHAR(4), colsandparams.ValueTypePrecision) +
					',' + CONVERT(VARCHAR(4), colsandparams.ValueTypeScale) + ')'
				ELSE ''
			END +
			CASE
				WHEN colsandparams.is_identity = 1 THEN
					' IDENTITY(' + CONVERT(VARCHAR(5), colsandparams.seed_value) + ',' +
					CONVERT(VARCHAR(5), colsandparams.increment_value) + ')'
				ELSE ''
			END +
			CASE
				WHEN colsandparams.XMLcollectionID <> 0 THEN
					'(' +
					CASE
						WHEN colsandparams.isXMLDocument = 1 THEN 'DOCUMENT '
						ELSE 'CONTENT '
					END +
					COALESCE(
						QUOTENAME(Schemae.name) + '.' + QUOTENAME(SchemaCollection.name),
						'NULL'
					) + ')' +
					CASE
						WHEN colsandparams.collation_name IS NOT NULL THEN
							' COLLATE ' + colsandparams.collation_name + ' '
						ELSE ''
					END +
					CASE
						WHEN colsandparams.is_nullable = 0 THEN ' NOT'
						ELSE ''
					END + ' NULL '
				ELSE ''
			END +
			COALESCE(' -- ' + colsandparams.Description, '')
	END AS "Column",
	colsandparams.TheOrder AS "TheOrder"
FROM
	(SELECT
		cols.object_id,
		cols.name,
		'Columns' AS "Type",
		CONVERT(NVARCHAR(2000), EP.value) AS "Description",
		cols.column_id AS TheOrder,
		cols.xml_collection_id,
		cols.max_length AS ValueTypemaxlength,
		cols.precision AS ValueTypePrecision,
		cols.scale AS ValueTypeScale,
		cols.is_nullable,
		cols.is_identity,
		cc.definition,
		IC.seed_value,
		IC.increment_value,
		cols.xml_collection_id AS XMLcollectionID,
		cols.is_xml_document AS isXMLDocument,
		cols.user_type_id,
		cols.collation_name
	FROM
		sys.objects AS object
		INNER JOIN sys.columns AS cols ON cols.object_id = object.object_id
		LEFT OUTER JOIN sys.extended_properties AS EP ON cols.object_id = EP.major_id
			AND EP.class = 1
			AND EP.minor_id = cols.column_id
			AND EP.name = 'MS_Description'
		LEFT OUTER JOIN sys.identity_columns IC ON ic.column_id = cols.column_id
			AND ic.object_id = object.object_id
		LEFT OUTER JOIN sys.computed_columns cc ON cols.object_id = cc.object_id
			AND cols.column_id = cc.column_id
	WHERE
		object.is_ms_shipped = 0
	UNION ALL
	SELECT
		params.object_id,
		params.name AS "Name",
		CASE WHEN params.parameter_id = 0 THEN 'Return' ELSE 'Parameters' END AS "Type",
		CONVERT(NVARCHAR(2000), EP.value) AS "Description",
		params.parameter_id AS TheOrder,
		params.xml_collection_id,
		params.max_length AS ValueTypemaxlength,
		params.precision AS ValueTypePrecision,
		params.scale AS ValueTypeScale,
		params.is_nullable,
		0 AS is_Identity,
		NULL AS "definition",
		NULL AS seed_value,
		NULL AS increment_value,
		params.xml_collection_id AS XMLcollectionID,
		params.is_xml_document AS isXMLDocument,
		params.user_type_id,
		NULL AS collation_name
	FROM
		sys.objects AS object
		INNER JOIN sys.parameters AS params ON params.object_id = object.object_id
		LEFT OUTER JOIN sys.extended_properties AS EP ON params.object_id = EP.major_id
			AND EP.class = 2
			AND EP.minor_id = params.parameter_id
			AND EP.name = 'MS_Description'
	WHERE
		object.is_ms_shipped = 0
	) AS colsandparams
	INNER JOIN sys.types AS t ON colsandparams.user_type_id = t.user_type_id
	INNER JOIN sys.schemas ts ON t.schema_id = ts.schema_id
	LEFT OUTER JOIN sys.xml_schema_collections AS SchemaCollection ON SchemaCollection.xml_collection_id = colsandparams.xml_collection_id
	LEFT OUTER JOIN sys.schemas AS Schemae ON SchemaCollection.schema_id = Schemae.schema_id
	INNER JOIN sys.objects ParentObjects ON ParentObjects.object_id = colsandparams.object_id
WHERE
	Object_Name(ParentObjects.object_id) <> '$FlywayTableName'
	AND Object_Schema_Name(ParentObjects.object_id) IN ($ListOfSchemas)
ORDER BY
	"Schema", "type", Name, colsandparams.TheOrder
FOR JSON PATH
"@

					$TheRelationMetadata = Execute-SQL $param1 $query | ConvertFrom-json
                    if ($TheRelationMetadata.Error -ne $null)
                        { $Problems += $TheRelationMetadata.Error
                        write-error "$($TheRelationMetadata.Error)"}
    #now we need to get the base 'parent' types
                    $query = @"
--all the base types and their documentation (and any other common information)
SELECT sch.name AS "schema", 
  Replace (Lower (Replace(Replace(o.type_desc,'user_',''),'sql_','')), '_', ' ') as "type",
   o.name AS "Name",
  Coalesce(ep.value,'') AS "documentation"
FROM sys.objects o
INNER JOIN sys.schemas sch
ON sch.schema_id = o.schema_id AND o.parent_object_id = 0
LEFT OUTER JOIN sys.extended_properties ep
ON o.object_id = ep.major_id  AND  ep.minor_id=0 
AND ep.name LIKE 'MS_Description'
WHERE sch.name IN ($ListOfSchemas)
AND o.name <> '$FlywayTableName'
FOR JSON path
"@
					$TheBaseTypes = Execute-SQL $param1 $query | ConvertFrom-json
                    if ($TheBaseTypes.Error -ne $null)
                        {write-error "$($TheBaseTypes.Error)";
                        $Problems += $TheBaseTypes.Error;
                        }
                        #now get the details of the routines
					$query = @'
SELECT Replace (Lower (Replace(Replace(so.type_desc,'user_',''),'sql_','')), '_', ' ') as type,
        so.name, Object_Schema_Name(so.object_id) AS "schema", 
        definition, 
        checksum(definition) AS hash, ep.value AS documentation
        FROM sys.sql_modules ssm
        INNER JOIN sys.objects so
        ON so.OBJECT_ID=ssm.object_id
		LEFT OUTER JOIN sys.extended_properties ep
        ON so.object_id = ep.major_id
		and minor_id=0 AND ep.name LIKE 'MS_Description'
        FOR JSON path                   
'@
					$Routines = Execute-SQL $param1 $query | ConvertFrom-json
                    if ($Routines.Error -ne $null)
                        {write-error "$($Routines.Error)";
                        $Problems += $Routines.Error;
                        }					
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
           # Now get the details of all the indexes that aren't primary keys, including the columns,  
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
					#$TheBaseTypes= schema, type, Name, documentation
                   	$THeTypes = ($TheBaseTypes | Select schema, type)+($preliminaries | Select schema, type)+($routines | Select schema, type)|Select schema,type -unique
            <# OK. we now have to assemble all this into a model that is as human-friendly as possible  #>
					$SchemaTree = @{ } <# This will become our model of the schema. Fist we put in
            all the types of relations  #>
					$TheTypes | Select -ExpandProperty schema -Unique | foreach{
						$TheSchema = $_;
						$ourtypes = @{ }
						$TheTypes | where { $_.schema -eq $TheSchema } | Select -ExpandProperty type | foreach{ $OurTypes += @{ $_ = @{ } } }
						$SchemaTree | add-member -NotePropertyName $TheSchema -NotePropertyValue $OurTypes
					}          
            #Get the tables and columns in place
                      #Schema, type, Name , Column, TheOrder
                     $TheRelationMetadata | Select schema, type, name -Unique | foreach{
						$schema = $_.schema;
						$type = $_.type;
						$object = $_.name;
						$TheColumnList = $TheRelationMetadata |
						where { $_.schema -eq $schema -and $_.type -eq $type -and $_.name -eq $object } |
						foreach{ $_.column }
						$SchemaTree.$schema.$type += @{ $object = @{ 'columns' = $TheColumnList } }
					} 
            #Add in the documentation for the tables          
                     $TheBaseTypes | Select schema, type, name, documentation | foreach{
						$schema = $_.schema;
						$type = $_.type;
						$object = $_.name;
                        $Documentation = $_.documentation;
						$SchemaTree.$schema.$type.$object += @{ 'documentation'=$Documentation } 
					}           
 
            <# now we get the difinitions for all the routines  #>
                    #Routines=schema, type, name. definition
					($Routines | Select schema, type, name, definition)+
                    ($preliminaries | Select schema, type, name, definition) | foreach{
						$schema = $_.schema;
						$type = $_.type;
						$object = $_.name;
						$Definition = $_.definition
						$SchemaTree.$schema.$type.$Object += @{ 'Definition'=$Definition } 
					}
					#$SchemaTree.$schema.$type.$Object.Definition
                    #$SchemaTree|convertto-json -depth 10
					#$SchemaTree.$schema.$type.$Object|convertto-json -depth 10
            <# now stitch in the constraints and indexes with their columns  #>
                    #Constraints=schema ,table_name,type,constraint_name ,definition ,referenced_table,column_name,ordinal_position,
                    #referenced_column,referenced_ordinal_position
					$constraints | Select schema, table_name, Type, constraint_name, referenced_table, definition -Unique | foreach{
						$constraintSchema = $_.schema;
						$constrainedTable = $_.table_name;
						$constraintName = $_.constraint_name;
						$ConstraintType = $_.type;
						$referenced_table = $_.referenced_table;
						$definition = $_.definition;
 						# get the original object
						if ($ConstraintType -notin @('Unique key','index', 'Primary key', 'foreign key'))
						{ $SchemaTree.$constraintSchema.table.$constrainedTable.$ConstraintType += @{ $constraintName = $definition } }
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
				  <# these are already included #>
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


