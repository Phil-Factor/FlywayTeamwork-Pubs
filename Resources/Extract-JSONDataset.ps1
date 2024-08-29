<#
	.SYNOPSIS
		Extract a JSON-based dataset, one file per table, together with  a JSON Schema file, and a table manifest, to  the specified directory.
	
	.DESCRIPTION
		This is designed to use ODBC, either by itself, or in a Flyway Callback. 
	
	.EXAMPLE

		$Parameters= @{
			'SourceDSN'=$env:FP__SourceDSN__;
			'Database'=$Env:FP__flyway_database__;
			'Schemas'=$Env:FP__schemas__;
			'ReportDirectory'=$env:FP__ReportDirectory__;
			'User'=$env:FLYWAY_USER;
			'Password'=$env:FLYWAY_PASSWORD;
		}
		Extract-JSONDataset @Parameters

		$Parameters= @{
			'TargetDSN'='MyDSN';
			'Database'='MyDatabase';
			'ReportDirectory'='MyLocation';
			'User'='MyUserName';
			'Password'='MyUnguessablePassword';
		}
		Extract-JSONDataset @Parameters	
	.NOTES
		Additional information about the function.
#>
function Extract-JSONDataSet
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[String]$SourceDSN,
		[Parameter(Mandatory = $true)]
		[String]$Database,
		[Parameter(Mandatory = $true)]
		[String]$Schemas = '*',
		# or a list of schemas as in Flyway
        [string]$Server = $Null,
		[String]$ReportDirectory = $PWD,
		#where you want the report to go
		[String]$User = $null,
		#the user for the connection
		[String]$Password = $null,
		#The password for the connection
		[string]$Secretsfile = $null,
		#if you use a flyway secrets file.
		[string]$TablesToExtract = '*' #single wildcard string schema and table
	)
	
	
	# Firstly, determine the connection
    # $DSN=Get-odbcDSN 'Clone Server'

	$DSN = Get-OdbcDsn $SourceDSN -ErrorAction SilentlyContinue
	if ($DSN -eq $Null) { Throw "Sorry but we need a valid DSN installed, not '$SourceDSN'" }
	
	# find out the server and database
	$DefaultDatabase = $DSN.Attribute.Database
	$DefaultServer = $DSN.Attribute.Server
	if ($DefaultServer -eq $Null) { $DefaultServer = $DSN.Attribute.Servername }
    if ($Server -ne $null) 
      {$DefaultServer=$Server; $ServerDefinition="server=$Server; "} 
    else {$ServerDefinition=""}
<# Now what RDBMS is being requested? Examine the driver name (Might need alteration)
   if the driver name is different or if you use a different RDBMS #>
	$RDBMS = 'SQLserver', 'SQL Server', 'MySQL', 'MariaDB', 'PostgreSQL' | foreach{
		$Drivername = $DSN.DriverName;
		if ($Drivername -like "*$_*") { $_ }
	}
	if ($RDBMS -eq $Null) { Throw "Sorry, but we don't support $($DSN.Name) yet" }
	
	#Make sure we have a valid place to store the dataset
	$WhereToStoreIt = $ReportDirectory;
	If (-Not (Test-path "$Wheretostoreit" -Pathtype Container))
	{ try
        {$null = New-Item -ItemType directory -Path "$WhereToStoreIt" -Force }
      catch 
        {Write-error "The file location "$Wheretostoreit" isn't there: $($_.Exception.Message)"}
    }
	#if we have our secrets in a flyway config file 
	if (!([string]::IsNullOrEmpty($SecretsFile)))
	{
		$OurSecrets = get-content "$env:USERPROFILE\$SecretsFile" | where {
			($_ -notlike '#*') -and ("$($_)".Trim() -notlike '')
		} |
		foreach{ $_ -replace '\\', '\\' -replace '\Aflyway\.', '' } |
		ConvertFrom-StringData
	}
	else
	{
		$OurSecrets = @{ 'Password' = $Password; 'User' = $User }
	}
	# we need to define what is a legal SQL identifier. Otherwise we need to delimit it 
	$LegalSQLNameRegex = '^(\A[\p{N}\p{L}_][\p{L}\p{N}@$#_]{0,127})$'
	
	$conn = New-Object System.Data.Odbc.OdbcConnection;
	#now we create the connection string, using our DSN, the credentials and anything else we need
	#we access the sourceDSN to get the metadata.
	#We check to see if the database name has been over-ridden
	$TheDatabase = if ($Database -ne $null)
	{
		"database=$Database;"
	}
	else { '' }; #take the database from the DSN
	Write-verbose "connection via $SourceDSN to  server=$DefaultServer  $TheDatabase"
	$conn.ConnectionString = "DSN=$SourceDSN; $ServerDefinition $TheDatabase pwd=$($OurSecrets.Password); UID=$($OurSecrets.User)";
	#Crunch time. 
	$conn.open(); #open the connection 
	# we check that the DSN supports what we need to do 
	$MetadataCollections = $Conn.GetSchema('MetaDataCollections')
	$ActualDatabase = ($Conn.GetSchema('Tables') | select -first 1).'TABLE_CAT'
	if ($ActualDatabase -ne $database)
	{ Write-Error "we connected to $ActualDatabase, not  $database" }
<# we check that the collections that we need are there. Trigger an error if not #>
	$MetadataCollections.CollectionName | foreach -Begin {
		$CanDoDatatypes = $False; $CanDoTables = $False; $CanDoColumns = $False; $CanDoReservedWords = $False
	} {
		$CanDoDatatypes = $CanDoDatatypes -or ($_ -eq 'DATATYPES')
		$CanDoTables = $CanDoTables -or ($_ -eq 'TABLES')
		$CanDoColumns = $CanDoColumns -or ($_ -eq 'COLUMNS')
		$CanDoReservedWords = $CanDoReservedWords -or ($_ -eq 'ReservedWords')
	}
	if (!$CanDoDatatypes -or !$CanDoTables -or !$CanDoColumns -or !$CanDoReservedWords)
	{ Write-Error "Sorry, but this ODBC source is not supported" };
<# Get the reserved words for this ODBC connection so we can, if necessary, provide delimiters #>
	$What = $conn.GetSchema('ReservedWords')
	if ($What.GetType().Name -eq 'DataTable')
	{
		$ReservedWords = $What | foreach{ $_.item(0) }
	}
	else
	{
		$ReservedWords = $What
	}
	@('schema', 'group', 'primary') | where { $_ -notin $reservedwords } | foreach{
		$reservedwords += $_
	} #we all make mistakes, Microsoft included
<# Now we Get all the datatypes. We need to know the C# names for the datatypes for validation #>
	$Datatypes = $conn.GetSchema('DATATYPES') | Select Typename, ProviderDbType, Datatype
<# now we restrict the schemas that we are getting to what we need #>
	if ($Schemas -eq '*')
	{
		$WhereClause = "where table_schema not in ('pg_catalog','information_schema', 'performance_schema','mysql')"
	}
	else
	{
		$WhereClause = "where table_schema in ('$(($Schemas -split ',') -join "','")')"
	}
<# we need to get the relationship data from the information schema because it isn't
provided by default by ODBC for some reason. We use it to work out the correct sequence
for import #>
	if ($RDBMS -in ('PostgreSQL', 'SQL Server', 'SQLServer'))
	{
		$DependencyCommand = New-object System.Data.Odbc.OdbcCommand(@"
Select concat(table_schema, '.', table_name) as The_Table, f.Referenced_by  
from information_schema.tables Mytables
left outer join
(Select Concat(tc.table_schema, '.', tc.Table_name) as Reference , Concat(t.table_schema, '.', t.Table_name) as Referenced_by  
from information_schema.referential_constraints rc
inner join 
information_schema.table_constraints tc
    on rc.unique_constraint_name = tc.constraint_name
    and rc.unique_constraint_schema = tc.table_schema
inner join 
information_schema.table_constraints t
    on rc.constraint_name = t.constraint_name
    and rc.constraint_schema = t.table_schema)f
on f.reference=(concat(Mytables.table_schema, '.', Mytables.table_name))
$WhereClause  AND TABLE_TYPE = 'BASE TABLE';
"@, $conn);
	}
	elseif ($RDBMS -in ('MySQL', 'MariaDB'))
	{
		$DependencyCommand = New-object System.Data.Odbc.OdbcCommand(@"
    Select concat(Mytables.table_schema, '.', Mytables.table_name) as The_Table, 
	       concat(rc.UNIQUE_CONSTRAINT_SCHEMA, '.', rc.REFERENCED_TABLE_NAME) as  Referenced_by
    from information_schema.tables Mytables
    left outer join 
    information_schema.referential_constraints rc
    on concat(Mytables.table_schema, '.', Mytables.table_name)=concat(rc.CONSTRAINT_SCHEMA, '.', rc.TABLE_NAME)
    $WhereClause AND TABLE_TYPE = 'BASE TABLE';
"@, $conn);
	}
	
	#Adding back in  the ommissions in the MySQL ODBC 
	if ($RDBMS -in ('MySQL', 'MariaDB'))
	{
		$MissingColumnAttributesCommand = New-object System.Data.Odbc.OdbcCommand(@"
  Select TheTable, TheColumn, TheSetting from
    (
	SELECT 
	    concat(Table_Schema,'.',TABLE_NAME) as TheTable, 
	    table_schema,   COLUMN_NAME as TheColumn, 
	    'calculated' as TheSetting
	FROM information_schema.columns
	  WHERE is_generated = 'ALWAYS'
	union all
	SELECT 
	   concat(Table_Schema,'.',TABLE_NAME),Table_Schema, 
	   COLUMN_NAME, 'auto_increment'
	FROM information_schema.columns
	  Where extra LIKE '%auto_increment%')f
    $WhereClause;
"@, $conn)
		$ReturnedData = New-Object system.Data.DataSet;
		(New-Object system.Data.odbc.odbcDataAdapter($MissingColumnAttributesCommand)).fill($ReturnedData) | out-null;
		$MissingColumnAttributes = $ReturnedData.Tables[0] | Select TheTable, TheColumn, TheSetting
	}
	
<# now get the relationship data #>
	$DependencyData = New-Object system.Data.DataSet;
	(New-Object system.Data.odbc.odbcDataAdapter($DependencyCommand)).fill($DependencyData) | out-null;
	$TheListOfDependencies = $DependencyData.Tables[0] | Select @{ n = "Table"; e = { $_.item(0) } }, @{ n = "Referrer"; e = { $_.item(1) } }
	$TheOrderOfDependency = @() # our manifest table
    <# Now create the manifest table #>
	$TheRemainingTables = $TheListOfDependencies | select Table -unique # Get the list of tables
	$TableCount = $TheRemainingTables.count # Get the number so we know when they are all listed
	$DependencyLevel = 1 #start at 1 - meaning they make no foreign references
	while ($TheOrderOfDependency.count -lt $TableCount -and $DependencyLevel -lt 30)
	{
		$TheRemainingTables = $TheRemainingTables | where { $_.Table -notin $TheOrderOfDependency.Table }
		#select tables that are not making references to surviving objects 
		$TheRemainingForegnReferences = $TheListOfDependencies |
		where { $_.Table -notin $TheOrderOfDependency.Table } |
		Select Referrer -unique | where { !([string]::IsNullOrEmpty($_.Referrer)) }
		$TheOrderOfDependency += $TheRemainingTables | where { $_.Table -notin $TheRemainingForegnReferences.Referrer } |
		Select Table, @{ n = "Sequence"; e = { $DependencyLevel } }
		$DependencyLevel++
	}
	
	$TheOrderOfDependency | ConvertTo-Json -Depth 5 > "$($ReportDirectory)\Manifest.JSON"
<# Now, with this list of the datatables, we can iterate through the tables, and write out the 
schema. We use the information about #>
	$TheOrderOfDependency | where { $_.table -like $TablesToExtract } | foreach {
		$ThisTable = $_.'Table' -split '\.';
		$ThisSchemaname = $ThisTable[0] #make sure the identifier is legal
		if ($ThisSchemaname -notmatch $LegalSQLNameRegex -or ($ThisSchemaname -in $ReservedWords))
		{ $ThisSchemaname = "`"$ThisSchemaname`"" }
		$ThisSequence = $_.'Sequence'
		$ThisTablename = $ThisTable[1] #make sure the identifier is legal
		if ($ThisTablename -notmatch $LegalSQLNameRegex -or ($ThisTablename -in $ReservedWords))
		{ $ThisTablename = "`"$ThisTablename`"" }
		$DelimitedTableName = "$ThisSchemaname.$ThisTablename";
		#purely for the filenames
		$UnQualifiedName = $ThisTable
		@{
			'Name' = $DelimitedTableName; 'FileName' = $_.'Table'; 'sequence' = $ThisSequence
		}
		
	} | <# where { $_.fileName -eq 'dbo.editions' } |#> foreach -Begin { } {
		$What = $_;
		# for each table 
		$restrictions = New-Object -TypeName string[] -ArgumentList 4
		$ThisTable = $What.'Name' -split '\.';
		if ($RDBMS -eq 'MariaDB') { $restrictions[0] = $ThisTable[0] } #it insists on this 
		$restrictions[1] = $ThisTable[0]
		$restrictions[2] = $ThisTable[1]
		$TheTableSchema = $conn.GetSchema('Columns', $restrictions)
		# Now get the metadata as a list of properties
		$OurTableMetadata = $TheTableSchema | foreach -Begin { $ColumnCount = 0 } {
			$ColumnCount++;
			$ColumnName = $_.'COLUMN_NAME';
			if ($ColumnName -notmatch $LegalSQLNameRegex -or ($ColumnName -in $ReservedWords)) #make sure the identifier is legal
			{ $ColumnName = "`"$ColumnName`"" }
			$Nullable = $_.'NULLABLE';
			$Description = $_.'REMARKS';
			$ColumnNo = $_.'ORDINAL_POSITION';
			if ($RDBMS -in 'SQL Server', 'SQLserver')
			{
				$identity = $_.'SS_IS_IDENTITY'; #SQL Server only
				$Computed = $_.'SS_IS_COMPUTED'; #SQL Server only
			}
			elseif ($RDBMS -eq 'PostgreSQL')
			{
				$identity = $_.'AUTO_INCREMENT'; #SQL Server only
				$Computed = $False; #SQL Server only
			}
			elseif ($RDBMS -in ('MariaDB', 'MySQL'))
			{
				$identity = $False; $Computed = $False;
				$MissingColumnAttributes | where {
					$_.TheTable -eq $What.'Name' -and $_.TheColumn -eq $What.'COLUMN_NAME'
				} | Foreach {
					if ($_TheSetting -eq 'auto_increment') { $identity = $True }
					if ($_TheSetting -eq 'calculated') { $Computed = $True }
				}
			}
			else
			{
				$identity = $False;
				$Computed = $False;
			}
			$Typename = $_.TYPE_Name;
			$Datatype = $Datatypes | where Typename -like $Typename | Select -ExpandProperty datatype | Select -first 1
			if ([string]::IsNullOrEmpty($Datatype)) { $Datatype = $typename }
			$JsonType = "$(
				switch ($Datatype) # Missing geography and hierarchyid
				{
					{ $PSItem -in ('System.String', 'System.Object', 'system.DateTime', 'System.Guid') }
					{ 'string' }
					{
						$PSItem -in ('System.Byte', 'System.Int64', 'System.Byte[]', 'System.Decimal',
							'System.Int32', 'System.Int16', 'System.Double', 'System.Single')
					}
					{ 'number' }
					{ $PSItem -eq 'System.Boolean' }
					{ 'boolean' } #true or false
					{ $PSItem -eq 'Time' }
					{ 'System.String' } #true or false
					{ $PSItem -eq 'hierarchyid' }
					{ 'System.String' }
					{ $PSItem -eq 'geography' }
					{ 'System.String' }
					Default { 'System.String'; Write-Warning "Unknown datatype '$PSitem' ($Datatype - $Typename) in $ThisTable" }
				})$(if ($Nullable -eq 1) { ',null' })" -split ',';
			@{
				'ColumnName' = $ColumnName;
				'Nullable' = $Nullable;
				'Description' = $Description;
				'ColumnNo' = $ColumnNo;
				'Identity' = $Identity;
				'Computed' = $Computed;
				'SQLType' = $Typename;
				'Datatype' = $Datatype;
				"Type" = $JsonType;
			}
		}
		$OurProperties = New-Object -TypeName PSCustomObject
		$OurTableMetadata | foreach{ Add-Member -inputObject $OurProperties -MemberType NoteProperty -Name $_.columnName -Value $_ }
		
		$JSONSchema = @{
			'$schema' = 'http://json-schema.org/draft-07/schema#'
			'title' = $ThisTablename;
			'Origin Database' = $DefaultDatabase;
			'Origin Server' = $DefaultServer;
			'DependencyLevel' = $ThisSequence;
			'SQLtablename' = $DelimitedTableName;
			'SQLschema' = $ThisSchemaname;
			'type' = 'array';
			'items' = @{
				'type' = 'object';
				'required' = $OurTableMetadata.columnName;
				'maxProperties' = $ColumnCount;
				'minProperties' = $ColumnCount;
				'properties' = $OurProperties;
			}
		} | ConvertTo-json -Depth 5;
		# TEMP
		#$JSONSchema.items.properties|foreach{$What=$_}	
<#
You can edd extra properties that are useful to you
The built-in properties that are used by JSON Schema are these.

Data Types: The "type" keyword specifies the data type expected for a property. 
Common data types include "string", "number", "integer", "boolean", "object", and "array".

Required Properties: The "required" keyword specifies which properties must be present in 
the JSON object. If a required property is missing, the validation fails.

Minimum and Maximum Values: For numeric properties ("number" and "integer" types), you 
can use the "minimum", "maximum", "exclusiveMinimum", and "exclusiveMaximum" keywords 
to specify constraints on the allowed range of values.

String Length: For string properties, you can use the "minLength" and "maxLength" keywords
 to specify constraints on the length of the string.

Pattern Matching: The "pattern" keyword allows you to specify a regular expression pattern
 that the string property must match.

Enumeration: The "enum" keyword allows you to specify a list of possible values that a 
property can take.

Combining Conditions: JSON Schema supports combining conditions using logical operators like
"allOf", "anyOf", and "oneOf", allowing for complex validation rules.

Nested Objects and Arrays: JSON Schema allows you to define nested objects and arrays with
their own validation rules.

Default Values: The "default" keyword allows you to specify default values for properties
if they are not provided in the JSON data.

Conditional Validation: JSON Schema supports conditional validation using keywords like "if",
"then", and "else", allowing for different validation rules based on the data.#>
		$JSONSchema > "$($ReportDirectory)\$($_.FileName)_Schema.JSON"
		# now we've written out the json schemas, we can do the same to the data.
		
		#$SQL = $_.SQL; #We execute the SQL and place the result of the first query in the string into a JSON file
		#$SQL ='Select pub_id, cast (logo as nvarchar(max)) as logo,pr_info from dbo.pub_info' 
    <# we need to do some sunstitutions for decprecated datatypes otherwise the JSON goes doolally #>
		$SQL = 'Select ' + (($OurTableMetadata | foreach {
					$Columname = $_.ColumnName;
					switch ($_.SQLType)
					{
						'geography'{ " cast ($Columname as NVARCHAR(MAX)) as `"$Columname`"" }
						'geometry'{ " cast ($Columname as NVARCHAR(MAX))  as `"$Columname`"" }
						'Hierarchyid'{ " cast ($Columname as NVARCHAR(MAX)) as `"$Columname`"" }
						#'varbinary'{ " cast ($Columname as NVARCHAR(MAX)) as `"$Columname`"" }
						'time'  { " cast ($Columname as nvarchar(10)) as `"$Columname`"" }
						default { $Columname }
					}
				}) -join ', ') + " From $DelimitedTableName"
		
		
		$cmd = New-object System.Data.Odbc.OdbcCommand($SQL, $conn)
		$ds = New-Object system.Data.DataSet
		write-Verbose "Calling with '$SQL' for '$($_.FileName)'"
		(New-Object system.Data.odbc.odbcDataAdapter($cmd)).fill($ds) | out-null
		$TableObject = $ds.Tables[0] | select $ds.Tables[0].Columns.ColumnName
		if (!($TableObject -is [system.array])) { $TableObject = @($TableObject) }
		if ($PSVersionTable.PSVersion.Major -gt 6)
		{ $TableData = $TableObject | ConvertTo-Json -Compress -AsArray -Depth 5 }
		else
		{ $TableData = $TableObject | ConvertTo-Json -Compress -Depth 5 };
		if ([string]::IsNullOrWhiteSpace($TableData)) { $TableData = '[]' }
		$TableData> "$($ReportDirectory)\$($_.FileName).JSON"
		#now verify what we've done
		#write-Verbose "Testing $($ReportDirectory)\$($_.Name).JSON with $($ReportDirectory)\$($_.FileName)_Schema.JSON"
		if (Get-Command 'Test-Json' -errorAction SilentlyContinue)
		{
			if (!(Test-Json -Path "$($ReportDirectory)\$($_.Name).JSON" -SchemaFile "$($ReportDirectory)\$($_.FileName)_Schema.JSON"))
			{ Write-error "The JSON files for $($_.FileName) failed validation" }
		}
	} -End {
		$conn.close()
		# after we've worked through the list we cleanup
		
	};
}

