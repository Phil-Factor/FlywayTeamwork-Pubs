DELIMITER $$
DROP PROCEDURE IF EXISTS undo_Pubs1_1_4 $$ 
CREATE PROCEDURE undo_Pubs1_1_4()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		 GET DIAGNOSTICS CONDITION 1
	    @p2 = MESSAGE_TEXT;
	    SELECT CONCAT('I am sorry but ',@p2) AS 'Migration undo_Pubs1_1_4 terminated' INTO @theError;
	    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @theError ;
	END;
	DROP TABLE IF EXISTS dbo.prices;
	DROP TABLE IF EXISTS dbo.editions;
	DROP TABLE IF EXISTS dbo.publications;
	DROP view IF EXISTS dbo.titleview;
	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='titles' 
			AND CONSTRAINT_NAME='fk_titles_Publishers_pub_id' AND constraint_SCHEMA = DATABASE())) then 
		ALTER TABLE dbo.titles DROP FOREIGN KEY fk_titles_Publishers_pub_id;
	END IF;	
	if EXISTS ((SELECT * FROM information_schema.tables
			WHERE TABLE_NAME='titles' AND table_SCHEMA = DATABASE())) then 
		ALTER TABLE dbo.titles Modify COLUMN title VARCHAR(80) NOT NULL;
		ALTER TABLE dbo.titles Modify COLUMN notes varchar(200);
		ALTER TABLE dbo.titles Modify COLUMN type CHAR(12) NOT NULL;
		ALTER TABLE dbo.titles Modify COLUMN pub_id CHAR (4) NOT NULL;
	END IF;
	CREATE VIEW IF NOT EXISTS  dbo.titleview
	AS
	select title, au_ord, au_lname, price, ytd_sales, pub_id
	from authors, titles, titleauthor
	where authors.au_id = titleauthor.au_id
	   AND titles.title_id = titleauthor.title_id;

	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='employee' 
			AND CONSTRAINT_NAME='fk_Employee_publishers_pub_id' AND constraint_SCHEMA = DATABASE())) then 
	ALTER TABLE dbo.employee DROP FOREIGN KEY fk_Employee_publishers_pub_id;
	end if;
	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='pub_info' 
			AND CONSTRAINT_NAME='fk_Pubinfo_publishers_pub_id' AND constraint_SCHEMA = DATABASE())) then 
			ALTER TABLE dbo.pub_info DROP FOREIGN KEY fk_Pubinfo_publishers_pub_id;
	END IF;
	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='employee' 
			AND CONSTRAINT_NAME='fk_Employee_JobID' AND constraint_SCHEMA = DATABASE())) then 
			ALTER TABLE dbo.employee DROP FOREIGN KEY fk_Employee_JobID;
	END IF;
	-- 'Altering dbo.employee'
	ALTER TABLE dbo.employee Modify COLUMN pub_id  CHAR (4) NOT NULL;
	
	-- ''Altering dbo.publishers'
	ALTER TABLE dbo.publishers Modify COLUMN pub_id CHAR (4) NOT NULL;
	
	-- ''Altering dbo.pub_info'
	ALTER TABLE dbo.pub_info Modify COLUMN pub_id  CHAR (4) NOT NULL;

	ALTER TABLE dbo.employee
		ADD constraint fk_Employee_publishers_pub_id  FOREIGN KEY (pub_id) 
		REFERENCES publishers (pub_id);
	
	ALTER TABLE dbo.pub_info
		ADD constraint fk_Pubinfo_publishers_pub_id FOREIGN KEY (pub_id) 
		REFERENCES publishers (pub_id);
			
	ALTER TABLE titles
		ADD constraint fk_titles_Publishers_pub_id  FOREIGN KEY (pub_id) 
		REFERENCES publishers (pub_id);
	

END $$

CALL undo_Pubs1_1_4  $$

DELIMITER ;
DROP PROCEDURE  undo_Pubs1_1_4;


