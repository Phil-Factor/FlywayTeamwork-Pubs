DELIMITER $$
DROP PROCEDURE IF EXISTS undo_Pubs1_1_3 $$ 
CREATE PROCEDURE undo_Pubs1_1_3()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	 GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    SELECT CONCAT('I am sorry but ',@p2) AS 'Migration undo_Pubs1_1_3 terminated' INTO @theError;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @theError ;
	END;
	
	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='sales' 
			AND CONSTRAINT_NAME='FK_Sales_Title' AND constraint_SCHEMA = DATABASE())) then 
		ALTER TABLE sales DROP FOREIGN KEY FK_Sales_Title;
	END IF;	
	
	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='sales' AND constraint_SCHEMA = DATABASE()
			AND CONSTRAINT_NAME='FK_Sales_Stores')) then 
		ALTER TABLE sales DROP FOREIGN KEY FK_Sales_Stores;
	END IF;
		
	if EXISTS (SELECT * FROM information_schema.COLUMNS
	             WHERE TABLE_NAME='publishers' AND  COLUMN_NAME = 'country' 
						 and column_default IS not null and column_default <> 'NULL') then 
 		ALTER TABLE publishers  ALTER  COLUMN country DROP DEFAULT; 
	END if; 
	IF EXISTS((SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = N'roysched_id' 
	                  AND TABLE_NAME = 'roysched' AND TABLE_SCHEMA = DATABASE())) then
	   ALTER TABLE roysched DROP COLUMN roysched_id;               
	END if;
	IF EXISTS ((SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = N'discount_id' 
	                  AND TABLE_NAME = 'discounts' AND TABLE_SCHEMA = DATABASE())) then	
	   ALTER TABLE discounts DROP COLUMN discount_id;   
	END if;
	DROP INDEX if exists aunmind on dbo.authors;	 
	drop TEMPORARY TABLE IF EXISTS authorsColumns;          
	CREATE temporary TABLE authorsColumns(TheColumn national character varying(200));
	INSERT INTO authorsColumns (TheColumn) 
		SELECT column_name FROM information_schema.columns 
		WHERE TABLE_NAME = 'authors' AND TABLE_SCHEMA = DATABASE();	
	if EXISTS ((SELECT * from authorsColumns WHERE TheColumn = 'au_lname')) THEN
		ALTER TABLE authors  modify COLUMN au_lname  varchar(40) NOT NULL;
	END if;
	if EXISTS ((SELECT * from authorsColumns WHERE TheColumn = 'au_fname')) then
		ALTER TABLE dbo.authors  modify COLUMN au_fname   varchar(20) NOT NULL;
	END if;
	if EXISTS ((SELECT * from authorsColumns WHERE TheColumn = 'phone')) then 
		ALTER TABLE dbo.authors MODIFY COLUMN phone char(12) DEFAULT 'UNKNOWN' NOT NULL;
	END if;
	if EXISTS ((SELECT * from authorsColumns WHERE TheColumn = 'address')) then
		ALTER TABLE dbo.authors MODIFY COLUMN address varchar(40);
	END if;
	if EXISTS ((SELECT * from authorsColumns WHERE TheColumn = 'city')) then
		ALTER TABLE dbo.authors MODIFY COLUMN city varchar(20);
	END if;
	CREATE INDEX aunmind ON dbo.authors (au_lname, au_fname);
	drop TEMPORARY TABLE IF EXISTS authorsColumns; 
END $$

CALL undo_Pubs1_1_3  $$

DROP PROCEDURE IF exists undo_Pubs1_1_3