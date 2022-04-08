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

call createindex('dbo','editions','Publicationid_index','publication_id');
call createindex('dbo','prices','Editionid_index','edition_id');
call createindex('dbo','discounts','Storid_index','Stor_id');
call createindex('dbo','TagTitle','Titleid_index','Title_id');
call createindex('dbo','TagTitle','TagName_index','Tagname_id');    
call createindex('dbo','Employee','Jobid_index','Job_id');    
call createindex('dbo','Employee','pub_id_index','pub_id');  
call createindex('dbo','publications','pubid_index','pub_id'); 

DROP PROCEDURE IF EXISTS dbo.CreateIndex;

Create table WhatToDocument (
	TheOrder int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Tablename varchar(80), 
 	TheDescription VARCHAR(255));

INSERT INTO WhatToDocument (Tablename, TheDescription)
VALUES
  ('dbo.authors', 'The authors of the publications. a publication can have one or more author'),
  ('dbo.discounts', 'These are the discounts offered by the sales people for bulk orders'),
  ('dbo.editions', 'A publication can come out in several different editions, of maybe a different type'),
  ('dbo.employee', 'An employee of any of the publishers'),
  ('dbo.jobs', 'These are the job descriptions and min/max salary level' ),
  ('dbo.prices', 'these are the current prices of every edition of every publication'),
  ('dbo.Sales', 'these are the sales of every edition of every publication'),
  ('dbo.pub_info', 'this holds the special information about every publisher'),
  ('dbo.publications', 'This lists every publication marketed by the distributor'),
  ('dbo.publishers', 'this is a table of publishers who we distribute books for'),
  ('dbo.roysched', 'this is a table of the authors royalty scheduleable'),
  ('dbo.stores', 'these are all the stores who are our customers'),
  ('dbo.TagName', 'All the categories of publications'),
  ('dbo.TagTitle', 'This relates tags to publications so that publications can have more than one'),
  ('dbo.titleauthor', 'this is a table that relates authors to publications, and gives their order of listing and royalty%');
  

Delimiter $$
DROP PROCEDURE IF EXISTS CommentPerRow $$

CREATE PROCEDURE CommentPerRow()
BEGIN
set @iiMax = 0;
set @ii = 0;
SELECT COUNT(*) FROM WhatToDocument INTO @iiMax;
SET @ii=1;
WHILE @ii <= @iiMax DO 
		SET @TABLE=(Select tablename FROM whatToDocument WHERE TheOrder=@ii);
		SET @COMMENT=(Select TheDescription FROM whatToDocument WHERE TheOrder=@ii);
		SET @sqlstmt = CONCAT(
		'ALTER TABLE ',@Table,' COMMENT ''',@COMMENT,''';');
		PREPARE st FROM @sqlstmt;
        EXECUTE st;
        DEALLOCATE PREPARE st;
 SET @ii = @ii + 1;
END WHILE;
END;
$$
DELIMITER ;  

CALL CommentPerRow;
DROP PROCEDURE IF EXISTS dbo.CommentPerRow;
DROP TABLE IF EXISTS WhatToDocument;
