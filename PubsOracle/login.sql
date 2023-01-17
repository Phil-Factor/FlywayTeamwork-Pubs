set sqlformat json
SET TERMOUT OFF 
spool TempOutput819.json
@TempInput556.SQL
spool off
exit
