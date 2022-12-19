USE Hyrcanus;
SELECT --
  referenced_database_name + '.' + referenced_schema_name + '.'
  + referenced_entity_name AS reference,
  Db_Name () + '.' + Coalesce (Object_Schema_Name (referencing_id) + '.', '')
  + Object_Name (referencing_id)
  + Coalesce ('.' + Col_Name (referencing_id, referencing_minor_id), '') AS referencing
  FROM sys.sql_expression_dependencies
  WHERE referenced_database_name IS NOT NULL;
USE Antigonus;
SELECT --
  referenced_database_name + '.' + referenced_schema_name + '.'
  + referenced_entity_name AS reference,
  Db_Name () + '.' + Coalesce (Object_Schema_Name (referencing_id) + '.', '')
  + Object_Name (referencing_id)
  + Coalesce ('.' + Col_Name (referencing_id, referencing_minor_id), '') AS referencing
  FROM sys.sql_expression_dependencies
  WHERE referenced_database_name IS NOT NULL;


SELECT *  FROM sys.sql_expression_dependencies