<#
	.SYNOPSIS
		inserts a  JSON dataset into a copy of the database that provided the source.
	
	.DESCRIPTION
		A detailed description of the Insert-JSONData function.
	
	.EXAMPLE
	$Parameters= @{
	'TargetDSN'='Philf01';
	'Database'='Adworks';
	'ReportDirectory'='J:\JSONDataExperiments\AdventureWorks';
	'User'='sa';
	'Password'='ismellofpoo4U';
}
cls
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
		[String]$User,
		[String]$Password,
		[string]$Secretsfile = $null
	)
	
	# The Fill part. 
	
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
# Delete all the existing data. This code assumes legal table and schema names 	
    $executableExpressions=$manifest|foreach{ $Tablenames=($_.table -split '\.');
    @"
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = ''$($Tablenames[0])'' 
                 AND  TABLE_NAME = ''$($Tablenames[1])''))
BEGIN
   Delete from $($_.table);
END;
"@  }
    $SQLtoDeleteTableData="Execute ('$executableExpressions')"
	#start by creating the ODBC Connection
	$conn = New-Object System.Data.Odbc.OdbcConnection;
	#now we create the connection string, using our DSN, the credentials and anything else we need
	#we have our secrets in a flyway config file 
	if (!([string]::IsNullOrEmpty($SecretsFile)))
	{
		$OurSecrets = get-content "$SecretsFile" | where {
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
    $ExistingTables=$conn.GetSchema('Tables')|Select  @{ n = "Table"; e = { "$($_.'TABLE_SCHEM').$($_.'TABLE_NAME')" } }
    $DeleteCommand= $Conn.CreateCommand();
    $DeleteCommand.CommandText=$SQLtoDeleteTableData
    Try{ $DeleteCommand.ExecuteReader();}
    catch
        { write-warning  "$($_.Exception.Message) while deleting tables";
            "/* $($_.Exception.Message) while deleting tables */"
            $SQLtoDeleteTableData>> "$($ReportDirectory)\FaultyDeletion.SQL"
        } 
    Write-verbose "Deleted existing data from tables"
	
<# The Column list. In making up the select list, you may need to do explicit conversions for 
troublesome datatypes such as the CLRs #>
	$Manifest | where {$_.Table -in $ExistingTables.Table } | foreach{
        Write-verbose "Sequence=$($_.Sequence)  Table=$($_.Table)"
		$TheSchema = [IO.File]::ReadAllText($_.'Filename') | convertfrom-json
		$TheData = [IO.File]::ReadAllText(($_.'Filename' -ireplace '_Schema\.JSON', '.JSON')) | convertfrom-json
        $TheDataRowcount=$TheData.Count
        #omit any computed columns
		$TheSelectList = ($TheSchema.items.properties.psobject.Properties.value | where {$_.Computed -eq 0} | Foreach -Begin { $IsIdentity = $False }{
				$TheSQLType=$_.sqltype
                $TheName = $_.ColumnName;
				$IsIdentity = $IsIdentity -or ($_.Identity -eq 1) #if any columns are identity columns
                $IsIdentity = $IsIdentity -or ($_.SQLType -like '*identity')
				Switch ($TheSQLType)
				{
					'uniqueidentifier'{ "Cast( $TheName as nvarchar(100)) AS $TheName" }
					'varbinary(max)'{ "Cast( $TheName as varbinary(max)) AS $TheName" }
					'varbinary'{ "Cast( $TheName as varbinary(max)) AS $TheName" }
                    'hierarchyid' { "Cast( $TheName as nvarchar(30)) AS $TheName" }
					'geometry'{ "Cast($TheName as nvarchar(100)) AS $TheName" }
					'geography' { "Cast($TheName as nvarchar(100)) AS $TheName" }
					'image' { "Cast($TheName as Varbinary(max)) AS $TheName" }
					'text' { "Cast($TheName as Varchar(max)) AS $TheName" }
					'ntext' { "Cast($TheName as Nvarchar(max)) AS $TheName" }
					default { $TheName }
				}
			}) -join ', '
	   if ([string]::IsNullOrEmpty($TheSelectList)){Throw "No select list for $($_.'Filename')"};	
		
<# The Column list is far simpler #>
		$ColumnList = (
			$TheSchema.items.properties.psobject.Properties.value | where {$_.Computed -eq 0} | select -ExpandProperty ColumnName
		) -join ', ';
		
		#For each table -- This helps SQL Server! --only SQL Server
		if ($IsIdentity)
		{
			$prescript = "Set identity_insert $($TheSchema.SQLTableName) on;`n "
			$PostScript = "Set identity_insert $($TheSchema.SQLTableName) off;`n "
		}
		else
		{ $prescript = ""; $postscript = '' }
		
		
		$InsertStatement = "$Prescript
INSERT INTO $($TheSchema.SQLTableName)`n   ($ColumnList) 
 SELECT $TheSelectList 
   FROM`n (VALUES `n`t(" +
		(($TheData | foreach{
					#Row
					$Row = $_.PSObject.Properties | foreach {
						#column
						$TheColumn = $_;
						$TheValue = $TheColumn.Value
						switch ($TheColumn.TypeNameOfValue)
						{
							'System.String'  { "'$($TheValue -replace "'","''")'" }
							'System.object'  {
								if ($TheValue -eq $null) { 'NULL' }
								else { "'$TheValue'" }
							}
							'System.DateTime'{ "'$TheValue'" }
							'System.Int32'   { "$TheValue" }
							'System.array'   { "'/$($TheValue -join '/')/'" }
							'System.Boolean' {
								if ($TheValue -eq 'true') { 1 }
								else { 0 }
							}
							default { "'$($TheValue -replace "'","''")'" }
						}
					}
					$Row -join ', '
				}
			) -join "),`n`t(") + ")`n) AS $($TheSchema.title)_values `n ($ColumnList) ;
$postscript"
    $DBCmd = $Conn.CreateCommand();
    $DBCmd.CommandText=$InsertStatement
    if ($TheDataRowcount -gt 0 -and $TheDataRowcount -ne $null) {
    Try{ $DBCmd.ExecuteReader();}
    catch{ write-warning  "$($_.Exception.Message) while importing $TheDataRowcount rows into $($TheSchema.SQLTableName)";
            $InsertStatement> "$($ReportDirectory)\$($TheSchema.SQLTableName).SQL"
            Throw "Oh! What's the use?"} 
    }
    Write-verbose "written out  $TheDataRowcount rows to $($TheSchema.SQLTableName)"
	}
$conn.close()	
}
