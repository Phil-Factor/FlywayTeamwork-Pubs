DECLARE @MyString NVARCHAR(MAX)='
--CREATE TABLE statement without a PRIMARY KEY constraint:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
--A table created but has no MS_Description property added:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
--A DROP TABLE statement:
DROP TABLE ExampleTable;
--An attempt to change password:
ALTER LOGIN [username] WITH PASSWORD = ''newpassword'';
--TRUNCATE statement:
TRUNCATE TABLE ExampleTable;

--A DROP COLUMN statement:
ALTER TABLE ExampleTable
DROP COLUMN ColumnName;
--A GRANT TO PUBLIC statement:
GRANT SELECT ON ExampleTable TO PUBLIC;
--GRANT WITH GRANT OPTION:
GRANT SELECT ON ExampleTable TO [username] WITH GRANT OPTION;
--GRANT WITH ADMIN OPTION:
GRANT ALTER ANY LOGIN TO [username] WITH ADMIN OPTION;
--ALTER USER statement:
ALTER USER [username] WITH DEFAULT_SCHEMA = [schema_name];
--GRANT ALL:
GRANT ALL ON ExampleTable TO [username];
--CREATE ROLE:
CREATE ROLE ExampleRole;
--ALTER ROLE:
ALTER ROLE ExampleRole ADD MEMBER [username];
--DROP PARTITION:
DROP PARTITION SCHEME PartitionName;
--CREATE TABLE statement without a PRIMARY KEY constraint:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
-- table created that has no MS_Description property added:
CREATE TABLE ExampleTable (
    ID INT,
    Name NVARCHAR(50)
);
*/'