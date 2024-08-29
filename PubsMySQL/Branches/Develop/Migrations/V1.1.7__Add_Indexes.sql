DELIMITER $$

DROP PROCEDURE IF EXISTS dbo.CreateIndex $$
CREATE PROCEDURE dbo.CreateIndex
(
    given_database VARCHAR(64),
    given_table    VARCHAR(64),
    given_index    VARCHAR(64),
    given_columns  VARCHAR(64)
)
BEGIN

    DECLARE IndexIsThere INTEGER;

    SELECT COUNT(1) INTO IndexIsThere
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE table_schema = given_database
    AND   table_name   = given_table
    AND   index_name   = given_index;

    IF IndexIsThere = 0 THEN
        SET @sqlstmt = CONCAT('CREATE INDEX ',given_index,' ON ',
        given_database,'.',given_table,' (',given_columns,')');
        PREPARE st FROM @sqlstmt;
        EXECUTE st;
        DEALLOCATE PREPARE st;
    ELSE
        SELECT CONCAT('Index ',given_index,' already exists on Table ',
        given_database,'.',given_table) CreateindexErrorMessage;   
    END IF;

END $$

DELIMITER ;

call dbo.createindex('dbo','editions','Publicationid_index','publication_id');
call dbo.createindex('dbo','prices','Editionid_index','edition_id');
call dbo.createindex('dbo','discounts','Storid_index','Stor_id');
call dbo.createindex('dbo','TagTitle','Titleid_index','Title_id');
call dbo.createindex('dbo','TagTitle','TagName_index','Tagname_id');    
call dbo.createindex('dbo','employee','Jobid_index','Job_id');    
call dbo.createindex('dbo','employee','pub_id_index','pub_id');  
call dbo.createindex('dbo','publications','pubid_index','pub_id'); 

DROP PROCEDURE IF EXISTS dbo.CreateIndex;


