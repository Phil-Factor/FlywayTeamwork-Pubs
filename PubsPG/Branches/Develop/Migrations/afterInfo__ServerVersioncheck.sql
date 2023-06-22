
CREATE OR REPLACE FUNCTION dbo.check_postgresql_version(min_version INTEGER) RETURNS int 
AS $$
/**
Summary: >
This function uses the current_setting('server_version_num')
function to retrieve the version of the PostgreSQL server 
as an integer. It then compares it to the figure (e.g. 130000, 140000, 150000)
provided in the parameter
If the server version is less than  figure provided in the placeholder,
it raises an exception with the specified error message.

Author: Phil Factor
Date: Monday, 12 June 2023
Database: PubsDev
Returns: >
  Error if server version is too old
**/

DECLARE
  version_num INTEGER;
BEGIN
  version_num := current_setting('server_version_num')::integer;

  IF version_num < min_version THEN
    RAISE EXCEPTION 'PostgreSQL version % or higher is required.', min_version;
  ELSE
    Return version_num;
  END IF;
END;
$$ LANGUAGE plpgsql;
Select dbo.check_postgresql_version(${serverversion}0000)
