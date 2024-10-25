<#
	.SYNOPSIS
		inserts a  JSON dataset into a copy of the database that provided the source.
	
	.DESCRIPTION
		A detailed description of the Insert-JSONData function.
	
	.PARAMETER TargetDSN
		A description of the TargetDSN parameter.
	
	.PARAMETER Database
		A description of the Database parameter.
	
	.PARAMETER Server
		A description of the Server parameter.
	
	.PARAMETER ReportDirectory
		A description of the ReportDirectory parameter.
	
	.PARAMETER User
		A description of the User parameter.
	
	.PARAMETER Password
		A description of the Password parameter.
	
	.PARAMETER Secretsfile
		A description of the Secretsfile parameter.
	
	.PARAMETER Chunk
		A description of the Chunk parameter.
	
	.PARAMETER QueryTimeout
		how many rows to insert at a time are optimal
	
	.PARAMETER Inserting
		Are we inserting or just deleting the existing data
	
	.PARAMETER TablesToAvoid
		A description of the TablesToAvoid parameter.
	
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
		[Parameter(Mandatory = $false)]
		[string]$Server = $Null,
		[String]$ReportDirectory = $PWD,
		[String]$User = $null,
		[String]$Password = $null,
		[string]$Secretsfile = $null,
		[int]$Chunk = 500,
		[int]$QueryTimeout = 120,
		[bool]$Inserting = $True, #are we inserting after the clean-out of the existing data?,
		[array]$TablesToAvoid =@()
	)
	
	$DSN = Get-OdbcDsn  $TargetDSN -ErrorAction SilentlyContinue
	if ($DSN -eq $Null) { Throw "Sorry but we need a valid DSN installed, not '$TargetDSN'" }
	# find out the server and database
	$DefaultServer = $DSN.Attribute.Server
	if ([string]::IsNullOrEmpty($Server))
	{ $ServerDefinition = "" }
	else
	{ $DefaultServer = $Server; $ServerDefinition = "server=$Server; " }
	
	$DefaultDatabase = $DSN.Attribute.Database
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
    if ($Manifest.Count-eq 0) 
        {Write-Error "No details of tables could be found at $ReportDirectory" } 
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
	$TheConnectionString = "DSN=$TargetDSN; $ServerDefinition database=$Database; uid=$($OurSecrets.user); pWd=$($OurSecrets.password);Query Timeout=1;"
	$conn.ConnectionString = $TheConnectionString
	
	#Crunch time. 
	$conn.open(); #open the connection 
	if ($conn.State -eq 'Open')
	{ Write-Verbose "connected to $($Conn.Datasource) to server '$DefaultServer' database $($Conn.Database)" }
	else
	{ Write-Verbose "Could not connect to $DefaultServer to access $Database using datasource $TargetDSN, with DSN $TheConnectionString" }
	
	if (!([string]::IsNullOrEmpty($SQLForPrequel)))
	{
		$Prequel = $Conn.CreateCommand(); $Prequel.CommandText = $SQLForprequel; $Prequel.ExecuteReader();
	}
	
	
	# Delete all the existing data. This code assumes legal table and schema names 	
	$DeletionOrder = $manifest | where {
		$_ -notin $TablesToAvoid
	}  | Select @{ n = "Schema"; e = { ($_.table -split '\.')[0] } }, @{ n = "Table"; e = { ($_.table -split '\.')[1] } };
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
	If ($Inserting)
	{

    	Write-verbose "Now inserting data into the empty tables";
		$ExistingTables = $conn.GetSchema('Tables') | where { $_.TABLE_SCHEM -notin ('pg_catalog', 'information_schema', 'performance_schema', 'mysql') } | Select  @{ n = "Table"; e = { "$($_.'TABLE_SCHEM').$($_.'TABLE_NAME')" } }
 <# The Column list. In making up the select list, you may need to do explicit conversions for 
troublesome datatypes such as the CLRs #>
        if ($ExistingTables.count-eq 0 ) {write-error "there are no tables in the destination"}
		$Manifest | where { $_.Table -in $ExistingTables.Table } | where {
             "$($_.Schema).$($_.Table)" -notin $TablesToAvoid } | foreach -begin{$ii=0} {
            $SourceTable=$_.Table;
			Write-verbose "Filling table $SourceTable at level $($_.Sequence)"
            $ii++; # count the number we do 
			$TheSchema = [IO.File]::ReadAllText($_.'Filename') | convertfrom-json
            $TheDataFile=$_.'Filename' -ireplace '_Schema\.JSON', '.JSON';
			$TheData = [IO.File]::ReadAllText($TheDataFile) | convertfrom-json
            if ($Thedata -isnot [array]) {
                $Thedata = @($Thedata)
            }
			$TheDataRowcount = $TheData.Count
            if ($TheDataRowcount -eq 0) {Write-verbose "there was no data provided for $SourceTable in $TheDataFile "}
			if ($TheDataRowcount -eq $null) {Write-warning "null count for $SourceTable in $TheDataFile "}
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
			$ii = 1;
			$InsertStatement += 0..$TheDataRowcount | Where-Object { $_ % $Chunk -eq 0 } | foreach{
				if ($TheDataRowcount -eq 1){$TheChunk = $TheData}
                else
                {$TheChunk = $TheData | Select -first $Chunk -Skip $_;}
				if ($ii -gt 1) { write-verbose "chunk $ii" }
				$ii++;
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
			#Now we execute each chunk of insert statements
			if ($TheDataRowcount -gt 0 -and $TheDataRowcount -ne $null)
			{
				$insertStatement -split '/\* end \*/' | foreach{
					$DBCmd = $Conn.CreateCommand();
					# Set the CommandTimeout (in seconds)
					$DBCmd.CommandTimeout = $QueryTimeout # Set to 120 seconds, for example
					$WhatWasExecuted = $_
					$DBCmd.CommandText = $WhatWasExecuted
					Try { $rowsAffected = $DBCmd.ExecuteNonQuery(); }
					catch
					{
						write-warning  "$($_.Exception.Message) while importing $TheDataRowcount rows into $($TheSchema.SQLTableName)";
						$InsertStatement> "$($ReportDirectory)\$($TheSchema.SQLTableName).SQL"
						$WhatWasExecuted>"$($ReportDirectory)\$($TheSchema.SQLTableName)Batch.SQL"
						$conn.close()
						Throw "Data insert terminated. Comand saved in $($ReportDirectory)\$($TheSchema.SQLTableName)Batch.SQL"
					}
					$DBCmd.Dispose()
				}
			}
			#$Inserts = New-object System.Data.Odbc.OdbcCommand("SELECT count(*) as written from $($TheSchema.SQLTableName)", $conn)
			#$ReturnedData = New-Object system.Data.DataSet;
			#(New-Object system.Data.odbc.odbcDataAdapter($Inserts)).fill($ReturnedData) | out-null;
			#	$written = $ReturnedData.Tables[0] | Select written
			Write-verbose "written out  $TheDataRowcount of rows to $($TheSchema.SQLTableName)"
			
			if (!([string]::IsNullOrEmpty($SQLForSequel)))
			{
				$Sequel = $Conn.CreateCommand(); $Sequel.CommandText = $SQLForSequel; $Sequel.ExecuteReader();
			}
		} -end{if ($ii -eq 0) {Write-error "no tables matched in the source and target  databases"}}
	}
    else
    {Write-verbose "Just cleared out the tables ready for insertion"}
	$conn.close()
}

