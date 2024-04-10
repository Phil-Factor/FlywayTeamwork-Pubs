<#
	.SYNOPSIS
		inserts a  JSON dataset into a copy of the database that provided the source.
	
	.DESCRIPTION
		A detailed description of the Insert-JSONData function.
	
	.EXAMPLE
	$Parameters= @{
	'TargetDSN'='MyDSN';
	'Database'='MyDatabase';
	'ReportDirectory'='MyLocation';
	'User'='MyUserName';
	'Password'='MyUnguessablePassword';
}
cls
Insert-JSONDataset @Parameters

	$Parameters= @{
    'TargetDSN'='PostgreSQL';
	'Database'='pubsdev';
	'ReportDirectory'='J:\JSONDataExperiments\PGPubsDev';
    'SecretsFile'='\Pubs_PostgreSQL_Develop_MyServer.conf'
}
Insert-JSONDataset @Parameters

type 'J:\JSONDataExperiments\AdventureWorks\manifest.json'| convertfrom-json
	
	.NOTES
		Additional information about the function.
#>
function Insert-JSONDataSet
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[String]$TargetDSN,
		[Parameter(Mandatory = $true)]
		[String]$Database,
		[Parameter(Mandatory = $true)]
		[String]$ReportDirectory = $PWD,
		[String]$User = $null,
		[String]$Password = $null,
		[string]$Secretsfile = $null,
		[string]$Chunk = 500 #how many rows to insert at a time are optimal
	)
	$DSN = Get-OdbcDsn  $TargetDSN -ErrorAction SilentlyContinue
	if ($DSN -eq $Null) { Throw "Sorry but we need a valid DSN installed, not '$TargetDSN'" }
	# find out the server and database
	$DefaultDatabase = $DSN.Attribute.Database
	$DefaultServer = $DSN.Attribute.Server
	if ($DefaultServer -eq $Null) { $DefaultServer = $DSN.Attribute.Servername }
	if ($DefaultServer -eq $Null) { $DefaultServer = $DSN.Attribute.Description }
<# Now what RDBMS is being requested? Examine the driver name (Might need alteration)
   if the driver name is different or if you use a different RDBMS #>
	$RDBMS = 'SQL Server', 'SQLServer', 'Sqlite', 'DocumentDB', 'MongoDB', 'MariaDB', 'PostgreSQL' | foreach{
		$Drivername = $DSN.DriverName;
		if ($Drivername -like "*$_*") { $_ }
	}
	if ($RDBMS -eq $Null) { Throw "Sorry, but we don't support $($DSN.Name) yet" }
	
	if ($RDBMS -in ('SQL Server', 'SQLServer'))
	{
		$SQLForSequel =@"
EXEC sp_MSforeachtable @command1='ALTER TABLE ? with check CHECK CONSTRAINT ALL';
EXEC sp_MSforeachtable @command1='ALTER TABLE ? enable TRIGGER ALL';
"@
		$SQLForPrequel =@"
EXEC sp_MSforeachtable @command1='ALTER TABLE ? NOCHECK CONSTRAINT ALL';
EXEC sp_MSforeachtable @command1='ALTER TABLE ? DISABLE TRIGGER ALL';
"@
	}
	else
	{ $SQLForSequel = $null; $SQLForPrequel = $null; }
	
	# firstly Check your input.
	
	#The manifest is the best way of getting the dependency information
	if (Test-path "$($ReportDirectory)\Manifest.JSON" -Pathtype Leaf)
	{
		$Manifest = [IO.File]::ReadAllText("$($ReportDirectory)\Manifest.JSON") | convertfrom-json
		$Manifest = $Manifest | foreach {
			[psCustomObject]@{ 'Table' = $_.'Table'; 'Sequence' = $_.'Sequence'; 'Filename' = "$($ReportDirectory)\$($_.'Table')_Schema.json" }
		}
		$manifest | select -ExpandProperty Table | Foreach{
			if ((Test-path "$($ReportDirectory)\$($_).json" -Pathtype Leaf) -and
				(Test-path "$($ReportDirectory)\$($_)_Schema.json" -Pathtype Leaf))
			{ }
			else { Write-Error " the $($_) table is missing one of its JSON files" }
		}
	}
	else
	{
		$Manifest = dir "$($ReportDirectory)\*_Schema.json" | foreach{
			$TheSchema = ([IO.File]::ReadAllText("$_") | convertFrom-JSON);
			[pscustomObject]@{ 'TableName' = $TheSchema.sqlTableName; 'Level' = $TheSchema.'DependencyLevel'; 'Filename' = $_.FullName }
		} | Sort-Object -Property Level
	}
	#start by creating the ODBC Connection
	$conn = New-Object System.Data.Odbc.OdbcConnection;
	#now we create the connection string, using our DSN, the credentials and anything else we need
	#we have our secrets in a flyway config file 
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
	$conn.ConnectionString = "DSN=$TargetDSN; database=$Database; uid=$($OurSecrets.user); pWD=$($OurSecrets.password);"
	
	#Crunch time. 
	$conn.open(); #open the connection 
	Write-Verbose "conntected to $($Conn.Datasource) to server '$DefaultServer' database $($Conn.Database)"
	
	
	if (!([string]::IsNullOrEmpty($SQLForPrequel)))
	{
		$Prequel = $Conn.CreateCommand(); $Prequel.CommandText = $SQLForprequel; $Prequel.ExecuteReader();
	}
	
	
	# Delete all the existing data. This code assumes legal table and schema names 	
	$DeletionOrder = $manifest | Select @{ n = "Schema"; e = { ($_.table -split '\.')[0] } }, @{ n = "Table"; e = { ($_.table -split '\.')[1] } };
	[array]::Reverse($DeletionOrder) #Reverse the array.   
	$DeletionOrder | foreach{
		
		if ($RDBMS -in ('SQL Server', 'SQLServer'))
		{@"
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = '$($_.Schema)' 
                 AND  TABLE_NAME = '$($_.Table)'))
BEGIN
   Delete from $($_.Schema + '.' + $_.Table);
END;

"@
		}
		elseif ($RDBMS -eq 'PostgreSQL')
		{@"
DO `$`$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = '$($_.Schema)'
        AND table_name = '$($_.Table)'
    ) THEN
        DELETE FROM  $($_.Schema).$($_.Table);
    END IF;
END `$`$;
"@
		}
		else
		{ Throw "Sorry, but $RDBMS isn't implemented yet" }
		
	} | foreach{
		$TheSQLCommand = $_
		$DeleteCommand = $Conn.CreateCommand();
		$DeleteCommand.CommandTimeout = 200;
		$DeleteCommand.CommandText = $TheSQLCommand
		Try { $DeleteCommand.ExecuteReader(); }
		catch
		{
			"/*$($_.Exception.Message) while deleting table with ... */  $TheSQLCommand"> "$($ReportDirectory)\FaultyDeletion.SQL"
			Throw "$($_.Exception.Message) while deleting table";
		}
	}
	Write-verbose "Deleted existing data from tables";
	
	
	$ExistingTables = $conn.GetSchema('Tables') | where { $_.TABLE_SCHEM -notin ('pg_catalog', 'information_schema', 'performance_schema', 'mysql') } | Select  @{ n = "Table"; e = { "$($_.'TABLE_SCHEM').$($_.'TABLE_NAME')" } }
 <# The Column list. In making up the select list, you may need to do explicit conversions for 
troublesome datatypes such as the CLRs #>
	$Manifest | where { $_.Table -in $ExistingTables.Table } | foreach{
		Write-verbose "Filling table $($_.Table) at level $($_.Sequence)"
		$TheSchema = [IO.File]::ReadAllText($_.'Filename') | convertfrom-json
		$TheData = [IO.File]::ReadAllText(($_.'Filename' -ireplace '_Schema\.JSON', '.JSON')) | convertfrom-json
		$TheDataRowcount = $TheData.Count
		#omit any computed columns
		$TheSelectList = ($TheSchema.items.properties.psobject.Properties.value | where { $_.Computed -eq 0 } | Foreach -Begin { $IsIdentity = $False }{
				$TheSQLType = $_.sqltype
				$TheName = $_.ColumnName;
				$IsIdentity = $IsIdentity -or ($_.Identity -eq 1) #if any columns are identity columns
				$IsIdentity = $IsIdentity -or ($_.SQLType -like '*identity')
				Switch ($TheSQLType)
				{
					'uniqueidentifier'{ "Cast( $TheName as nvarchar(100)) AS $TheName" }
					'varbinary(max)'{ "Cast( $TheName as varbinary(max)) AS $TheName" }
					'varbinary'{ "Cast( $TheName as varbinary(max)) AS $TheName" }
					'hierarchyid' { "Cast( $TheName as hierarchyid) AS $TheName" }
					'geometry'{ "Cast($TheName as geometry) AS $TheName" }
					'geography' { "Cast($TheName as geography) AS $TheName" }
					'image' { "Cast($TheName as Varbinary(max)) AS $TheName" }
					#'text' { "Cast($TheName as Varchar(max)) AS $TheName" }
					'bit' { "Cast($TheName  AS bit) AS $TheName" }
					'bool' { "Cast($TheName  AS BOOLEAN) AS $TheName" }
					'date'{
						if ($RDBMS -eq 'PostgreSQL') { "TO_DATE($TheName, 'MM/DD/YYYY HH24:MI:ss') AS $TheName" }
						else { $TheName }
					}
					'bytea'{ "convert_to($TheName, 'LATIN1') AS $TheName" }
					'timestamp' { "TO_TIMESTAMP($TheName, 'MM/DD/YYYY HH24:MI:ss') AS $TheName" }
					'ntext' { "Cast($TheName as Nvarchar(max)) AS $TheName" }
					default { $TheName }
				}
			}) -join ', '
		if ([string]::IsNullOrEmpty($TheSelectList)) { Throw "No select list for $($_.'Filename')" };
		
<# The Column list is far simpler #>
		$ColumnList = (
			$TheSchema.items.properties.psobject.Properties.value | where { $_.Computed -eq 0 } | select -ExpandProperty ColumnName
		) -join ', ';
		$ValuesList = (
			$TheSchema.items.properties.psobject.Properties.value | select -ExpandProperty ColumnName
		) -join ', ';
		
		#For each table -- This helps SQL Server! --only SQL Server
		if ($IsIdentity -and ($RDBMS -in ('SQL Server', 'SQLServer')))
		{
			$prescript = "Set identity_insert $($TheSchema.SQLTableName) on;`n "
			$PostScript = "Set identity_insert $($TheSchema.SQLTableName) off;`n "
		}
		elseif ($IsIdentity -and ($RDBMS -eq 'postgreSQL'))
		{
			$WeaselClause = "`nOVERRIDING SYSTEM VALUE`n"
		}
		else
		{ $prescript = ""; $postscript = ''; $WeaselClause = ''; }
		
		
		$InsertStatement = "$Prescript";
		$Chunk = 500
		$InsertStatement += 0..$TheData.Count | Where-Object { $_ % $Chunk -eq 0 } | foreach{
			$TheChunk = $TheData | Select -first $Chunk -Skip $_;
			if ($TheChunk.count -gt 0)
			{
				"INSERT INTO $($TheSchema.SQLTableName)`n   ($ColumnList) $WeaselClause
 SELECT $TheSelectList
   FROM`n (VALUES `n`t(" +
				(($TheChunk | foreach{
							#Row
							$Row = $_.PSObject.Properties | foreach {
								#column
								$TheColumn = $_;
								$TheValue = $TheColumn.Value
								switch ($TheColumn.TypeNameOfValue)
								{
									'System.String'  { "N'$($TheValue -replace "'", "''")'" }
									'System.object'  {
										if ($TheValue -eq $null) { 'NULL' }
										else { "N'$TheValue'" }
									}
									'System.DateTime'{ "'$TheValue'" }
									'System.Int32'   { "$TheValue" }
									'System.decimal'   { "$TheValue" }
									'System.Object[]'{ "N'/$($TheValue -join '/')/'"; }
									'System.array'   { "N'/$($TheValue -join '/')/'"; Write-Warning "Array in JSON for $($TheSchema.SQLTableName)" }
									'System.Boolean' {
										if ($TheValue -eq 'true') { 1 }
										else { 0 }
									}
									default { "N'$($TheValue -replace "'", "''")'"; Write-Warning "'$($TheColumn.TypeNameOfValue)' in JSON for $($TheSchema.SQLTableName)" }
								}
							}
							$Row -join ', '
						}
					) -join "),`n`t(") + ")`n) AS $($TheSchema.title)_values `n ($ValuesList);`n/* end */`n";
			}
		};
		$InsertStatement += "$Postscript";
		
		if ($TheDataRowcount -gt 0 -and $TheDataRowcount -ne $null)
		{
			$insertStatement -split '/\* end \*/' | foreach{
				$DBCmd = $Conn.CreateCommand();
				$WhatWasExecuted = $_
				$DBCmd.CommandText = $WhatWasExecuted
				Try { $DBCmd.ExecuteReader(); }
				catch
				{
					write-warning  "$($_.Exception.Message) while importing $TheDataRowcount rows into $($TheSchema.SQLTableName)";
					$InsertStatement> "$($ReportDirectory)\$($TheSchema.SQLTableName).SQL"
					$WhatWasExecuted>"$($ReportDirectory)\$($TheSchema.SQLTableName)Batch.SQL"
					$conn.close()
					Throw "Data insert terminated. Comand saved in $($ReportDirectory)\$($TheSchema.SQLTableName)Batch.SQL"
				}
			}
			$DBCmd.Dispose()
		}
		#$Inserts = New-object System.Data.Odbc.OdbcCommand("SELECT count(*) as written from $($TheSchema.SQLTableName)", $conn)
		#$ReturnedData = New-Object system.Data.DataSet;
		#(New-Object system.Data.odbc.odbcDataAdapter($Inserts)).fill($ReturnedData) | out-null;
		#	$written = $ReturnedData.Tables[0] | Select written
		Write-verbose "written out  $TheDataRowcount rows to $($TheSchema.SQLTableName)"
		
		if (!([string]::IsNullOrEmpty($SQLForSequel)))
		{
			$Sequel = $Conn.CreateCommand(); $Sequel.CommandText = $SQLForSequel; $Sequel.ExecuteReader();
		}
	}
	
	$conn.close()
}

