#first check for required variables. Are all our required values there?
('FP__DSN__', 'FLYWAY_PASSWORD', 'FLYWAY_USER') |
foreach {
	if ((Get-Item -Path "Env:\$_" -ErrorAction SilentlyContinue) -eq $null)
	{ Write-Error "No value for $_" }
}

@(
	@{
		'Name' = 'TheBackups'; 'SQL' = @'
use PhilFactor
-- (Most Recent Full Backups) Look at recent Full backups for the current database (Glen Berry Query 84) 
SELECT TOP (20) bs.machine_name, bs.server_name,
                bs.database_name AS "Database", 
                bs.recovery_model,
                Convert (BIGINT, bs.backup_size / 1048576) AS "Uncompressed Backup Size (MB)",
                Convert (BIGINT, bs.compressed_backup_size / 1048576) AS "Compressed Backup Size (MB)",
                Convert (
                  NUMERIC(20, 2),
                  (Convert (FLOAT, bs.backup_size)
                   / Convert (FLOAT, bs.compressed_backup_size))) AS "Compression Ratio",
               bs.has_backup_checksums, bs.is_copy_only, bs.encryptor_type,
               DateDiff (SECOND, bs.backup_start_date, bs.backup_finish_date) AS "Backup Elapsed Time (sec)",
               bs.backup_finish_date AS "Backup Finish Date",
               bmf.physical_device_name AS "Backup Location",
               bmf.physical_block_size
  FROM
  msdb.dbo.backupset AS bs
    INNER JOIN msdb.dbo.backupmediafamily AS bmf 
      ON bs.media_set_id = bmf.media_set_id
  WHERE
  bs.database_name = Db_Name (Db_Id ()) AND bs.[type] = 'D' -- Change to L if you want Log backups
  ORDER BY bs.backup_finish_date DESC
;
'@
	},
	@{
		'Name' = 'LogSize'; 'SQL' = @'
-- Log space usage for current database  (Query 53) (Log Space Usage)
SELECT Db_Name (lsu.database_id) AS "Database Name",
       db.recovery_model_desc AS "Recovery Model",
       Cast (lsu.total_log_size_in_bytes / 1048576.0 AS DECIMAL(10, 2)) AS "Total Log Space (MB)",
       Cast (lsu.used_log_space_in_bytes / 1048576.0 AS DECIMAL(10, 2)) AS "Used Log Space (MB)",
       Cast (lsu.used_log_space_in_percent AS DECIMAL(10, 2)) AS "Used Log Space %",
       Cast (lsu.log_space_in_bytes_since_last_backup / 1048576.0 AS DECIMAL(10, 2)) AS "Used Log Space Since Last Backup (MB)",
       db.log_reuse_wait_desc
  FROM
  sys.dm_db_log_space_usage AS lsu
    INNER JOIN sys.databases AS db
      ON lsu.database_id = db.database_id;

'@
	}) | foreach -Begin { #start by creating the ODBC Connection
	$conn = New-Object System.Data.Odbc.OdbcConnection;
    #now we create the connectioin string, using our DSN, the credentials and anything else we need
	$conn.ConnectionString = "DSN=$env:FP__DSN__; pwd=$env:FLYWAY_PASSWORD; UID=$env:FLYWAY_USER";
	$conn.open();
} {
	$SQL = $_.SQL; #We execute the SQL and place the result of the first query in the string into a JSON file
	$cmd = New-object System.Data.Odbc.OdbcCommand($SQL, $conn)
	$ds = New-Object system.Data.DataSet
	(New-Object system.Data.odbc.odbcDataAdapter($cmd)).fill($ds) | out-null
	($ds.Tables[0] | select $ds.Tables[0].Columns.ColumnName) | ConvertTo-Json -Depth 5  > "$($_.Name).JSON"
} -End {
    # after we've worked through the list we cleanup
	$conn.close()
};










