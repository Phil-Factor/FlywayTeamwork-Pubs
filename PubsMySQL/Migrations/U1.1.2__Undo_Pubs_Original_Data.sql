DELIMITER $$
DROP PROCEDURE IF EXISTS dbo.undo_Pubs1_1_2 $$ 
CREATE PROCEDURE dbo.undo_Pubs1_1_2()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	 GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    SELECT CONCAT('I am sorry but ',@p2) AS 'Migration undo_Pubs1_1_3 terminated' INTO @theError;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @theError ;
	END;
	
	if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='discounts' 
			AND CONSTRAINT_NAME='fk_Discounts_Stores_Stor_id')) then 
		ALTER TABLE discounts DROP FOREIGN KEY  fk_Discounts_Stores_Stor_id;
	END IF;	
 
  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='employee' 
			AND CONSTRAINT_NAME='fk_Employee_Pubs_JobID')) then 
		ALTER TABLE employee DROP FOREIGN KEY  fk_Employee_Pubs_JobID;
	END IF;		
  
  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='employee' 
			AND CONSTRAINT_NAME='fk_Employee_publishers_pub_id')) then 
		ALTER TABLE employee DROP FOREIGN KEY  fk_Employee_publishers_pub_id;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='pub_info' 
			AND CONSTRAINT_NAME='fk_Pubinfo_publishers_pub_id')) then 
		ALTER TABLE pub_info DROP FOREIGN KEY  fk_Pubinfo_publishers_pub_id;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='roysched' 
			AND CONSTRAINT_NAME='fk_roysched_Titles_title_id')) then 
		ALTER TABLE roysched DROP FOREIGN KEY  fk_roysched_Titles_title_id;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='sales' 
			AND CONSTRAINT_NAME='fk_sales_stores_Store_id')) then 
		ALTER TABLE sales DROP FOREIGN KEY  fk_sales_stores_Store_id;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='sales' 
			AND CONSTRAINT_NAME='fk_sales_titles_titleid')) then 
		ALTER TABLE sales DROP FOREIGN KEY  fk_sales_titles_titleid;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='titleauthor' 
			AND CONSTRAINT_NAME='fk_titleauthor_authors_au_id')) then 
		ALTER TABLE titleauthor DROP FOREIGN KEY fk_titleauthor_authors_au_id;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='titleauthor' 
			AND CONSTRAINT_NAME='fk_titleauthor_titles_title_id')) then 
		ALTER TABLE titleauthor DROP FOREIGN KEY fk_titleauthor_titles_title_id;
	END IF;		

  if EXISTS ((SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS 
			WHERE TABLE_NAME='titles' 
			AND CONSTRAINT_NAME='fk_titles_Publishers_pub_id')) then 
		ALTER TABLE titles DROP FOREIGN KEY fk_titles_Publishers_pub_id;
	END IF;		
	
	SET foreign_key_checks = 0;
	-- Delete rows from dbo.titleauthor')
	DELETE FROM dbo.titleauthor WHERE au_id = '172-32-1176' AND title_id = 'PS3333';
	DELETE FROM dbo.titleauthor WHERE au_id = '213-46-8915' AND title_id = 'BU1032';
	DELETE FROM dbo.titleauthor WHERE au_id = '213-46-8915' AND title_id = 'BU2075';
	DELETE FROM dbo.titleauthor WHERE au_id = '238-95-7766' AND title_id = 'PC1035';
	DELETE FROM dbo.titleauthor WHERE au_id = '267-41-2394' AND title_id = 'BU1111';
	DELETE FROM dbo.titleauthor WHERE au_id = '267-41-2394' AND title_id = 'TC7777';
	DELETE FROM dbo.titleauthor WHERE au_id = '274-80-9391' AND title_id = 'BU7832';
	DELETE FROM dbo.titleauthor WHERE au_id = '409-56-7008' AND title_id = 'BU1032';
	DELETE FROM dbo.titleauthor WHERE au_id = '427-17-2319' AND title_id = 'PC8888';
	DELETE FROM dbo.titleauthor WHERE au_id = '472-27-2349' AND title_id = 'TC7777';
	DELETE FROM dbo.titleauthor WHERE au_id = '486-29-1786' AND title_id = 'PC9999';
	DELETE FROM dbo.titleauthor WHERE au_id = '486-29-1786' AND title_id = 'PS7777';
	DELETE FROM dbo.titleauthor WHERE au_id = '648-92-1872' AND title_id = 'TC4203';
	DELETE FROM dbo.titleauthor WHERE au_id = '672-71-3249' AND title_id = 'TC7777';
	DELETE FROM dbo.titleauthor WHERE au_id = '712-45-1867' AND title_id = 'MC2222';
	DELETE FROM dbo.titleauthor WHERE au_id = '722-51-5454' AND title_id = 'MC3021';
	DELETE FROM dbo.titleauthor WHERE au_id = '724-80-9391' AND title_id = 'BU1111';
	DELETE FROM dbo.titleauthor WHERE au_id = '724-80-9391' AND title_id = 'PS1372';
	DELETE FROM dbo.titleauthor WHERE au_id = '756-30-7391' AND title_id = 'PS1372';
	DELETE FROM dbo.titleauthor WHERE au_id = '807-91-6654' AND title_id = 'TC3218';
	DELETE FROM dbo.titleauthor WHERE au_id = '846-92-7186' AND title_id = 'PC8888';
	DELETE FROM dbo.titleauthor WHERE au_id = '899-46-2035' AND title_id = 'MC3021';
	DELETE FROM dbo.titleauthor WHERE au_id = '899-46-2035' AND title_id = 'PS2091';
	DELETE FROM dbo.titleauthor WHERE au_id = '998-72-3567' AND title_id = 'PS2091';
	DELETE FROM dbo.titleauthor WHERE au_id = '998-72-3567' AND title_id = 'PS2106';
	-- Operation applied to 25 rows out of 25')
	
	-- Delete rows from dbo.sales')
	DELETE FROM dbo.sales WHERE stor_id = '6380' AND ord_num = '6871' AND title_id = 'BU1032';
	DELETE FROM dbo.sales WHERE stor_id = '6380' AND ord_num = '722a' AND title_id = 'PS2091';
	DELETE FROM dbo.sales WHERE stor_id = '7066' AND ord_num = 'A2976' AND title_id = 'PC8888';
	DELETE FROM dbo.sales WHERE stor_id = '7066' AND ord_num = 'QA7442.3' AND title_id = 'PS2091';
	DELETE FROM dbo.sales WHERE stor_id = '7067' AND ord_num = 'D4482' AND title_id = 'PS2091';
	DELETE FROM dbo.sales WHERE stor_id = '7067' AND ord_num = 'P2121' AND title_id = 'TC3218';
	DELETE FROM dbo.sales WHERE stor_id = '7067' AND ord_num = 'P2121' AND title_id = 'TC4203';
	DELETE FROM dbo.sales WHERE stor_id = '7067' AND ord_num = 'P2121' AND title_id = 'TC7777';
	DELETE FROM dbo.sales WHERE stor_id = '7131' AND ord_num = 'N914008' AND title_id = 'PS2091';
	DELETE FROM dbo.sales WHERE stor_id = '7131' AND ord_num = 'N914014' AND title_id = 'MC3021';
	DELETE FROM dbo.sales WHERE stor_id = '7131' AND ord_num = 'P3087a' AND title_id = 'PS1372';
	DELETE FROM dbo.sales WHERE stor_id = '7131' AND ord_num = 'P3087a' AND title_id = 'PS2106';
	DELETE FROM dbo.sales WHERE stor_id = '7131' AND ord_num = 'P3087a' AND title_id = 'PS3333';
	DELETE FROM dbo.sales WHERE stor_id = '7131' AND ord_num = 'P3087a' AND title_id = 'PS7777';
	DELETE FROM dbo.sales WHERE stor_id = '7896' AND ord_num = 'QQ2299' AND title_id = 'BU7832';
	DELETE FROM dbo.sales WHERE stor_id = '7896' AND ord_num = 'TQ456' AND title_id = 'MC2222';
	DELETE FROM dbo.sales WHERE stor_id = '7896' AND ord_num = 'X999' AND title_id = 'BU2075';
	DELETE FROM dbo.sales WHERE stor_id = '8042' AND ord_num = '423LL922' AND title_id = 'MC3021';
	DELETE FROM dbo.sales WHERE stor_id = '8042' AND ord_num = '423LL930' AND title_id = 'BU1032';
	DELETE FROM dbo.sales WHERE stor_id = '8042' AND ord_num = 'P723' AND title_id = 'BU1111';
	DELETE FROM dbo.sales WHERE stor_id = '8042' AND ord_num = 'QA879.1' AND title_id = 'PC1035';
	-- Operation applied to 21 rows out of 21')
	
	-- Delete rows from dbo.titles')
	DELETE FROM dbo.titles WHERE title_id = 'BU1032';
	DELETE FROM dbo.titles WHERE title_id = 'BU1111';
	DELETE FROM dbo.titles WHERE title_id = 'BU2075';
	DELETE FROM dbo.titles WHERE title_id = 'BU7832';
	DELETE FROM dbo.titles WHERE title_id = 'MC2222';
	DELETE FROM dbo.titles WHERE title_id = 'MC3021';
	DELETE FROM dbo.titles WHERE title_id = 'MC3026';
	DELETE FROM dbo.titles WHERE title_id = 'PC1035';
	DELETE FROM dbo.titles WHERE title_id = 'PC8888';
	DELETE FROM dbo.titles WHERE title_id = 'PC9999';
	DELETE FROM dbo.titles WHERE title_id = 'PS1372';
	DELETE FROM dbo.titles WHERE title_id = 'PS2091';
	DELETE FROM dbo.titles WHERE title_id = 'PS2106';
	DELETE FROM dbo.titles WHERE title_id = 'PS3333';
	DELETE FROM dbo.titles WHERE title_id = 'PS7777';
	DELETE FROM dbo.titles WHERE title_id = 'TC3218';
	DELETE FROM dbo.titles WHERE title_id = 'TC4203';
	DELETE FROM dbo.titles WHERE title_id = 'TC7777';
	-- Operation applied to 18 rows out of 18')
	
	-- Delete rows from dbo.pub_info')
	DELETE FROM dbo.pub_info WHERE pub_id = '0736';
	DELETE FROM dbo.pub_info WHERE pub_id = '0877';
	DELETE FROM dbo.pub_info WHERE pub_id = '1389';
	DELETE FROM dbo.pub_info WHERE pub_id = '1622';
	DELETE FROM dbo.pub_info WHERE pub_id = '1756';
	DELETE FROM dbo.pub_info WHERE pub_id = '9901';
	DELETE FROM dbo.pub_info WHERE pub_id = '9952';
	DELETE FROM dbo.pub_info WHERE pub_id = '9999';
	-- Operation applied to 8 rows out of 8')
	
	-- Delete rows from dbo.employee')
	DELETE FROM dbo.employee WHERE emp_id = 'A-C71970F';
	DELETE FROM dbo.employee WHERE emp_id = 'AMD15433F';
	DELETE FROM dbo.employee WHERE emp_id = 'A-R89858F';
	DELETE FROM dbo.employee WHERE emp_id = 'ARD36773F';
	DELETE FROM dbo.employee WHERE emp_id = 'CFH28514M';
	DELETE FROM dbo.employee WHERE emp_id = 'CGS88322F';
	DELETE FROM dbo.employee WHERE emp_id = 'DBT39435M';
	DELETE FROM dbo.employee WHERE emp_id = 'DWR65030M';
	DELETE FROM dbo.employee WHERE emp_id = 'ENL44273F';
	DELETE FROM dbo.employee WHERE emp_id = 'F-C16315M';
	DELETE FROM dbo.employee WHERE emp_id = 'GHT50241M';
	DELETE FROM dbo.employee WHERE emp_id = 'HAN90777M';
	DELETE FROM dbo.employee WHERE emp_id = 'HAS54740M';
	DELETE FROM dbo.employee WHERE emp_id = 'H-B39728F';
	DELETE FROM dbo.employee WHERE emp_id = 'JYL26161F';
	DELETE FROM dbo.employee WHERE emp_id = 'KFJ64308F';
	DELETE FROM dbo.employee WHERE emp_id = 'KJJ92907F';
	DELETE FROM dbo.employee WHERE emp_id = 'LAL21447M';
	DELETE FROM dbo.employee WHERE emp_id = 'L-B31947F';
	DELETE FROM dbo.employee WHERE emp_id = 'MAP77183M';
	DELETE FROM dbo.employee WHERE emp_id = 'MAS70474F';
	DELETE FROM dbo.employee WHERE emp_id = 'MFS52347M';
	DELETE FROM dbo.employee WHERE emp_id = 'MGK44605M';
	DELETE FROM dbo.employee WHERE emp_id = 'MJP25939M';
	DELETE FROM dbo.employee WHERE emp_id = 'M-L67958F';
	DELETE FROM dbo.employee WHERE emp_id = 'MMS49649F';
	DELETE FROM dbo.employee WHERE emp_id = 'M-P91209M';
	DELETE FROM dbo.employee WHERE emp_id = 'M-R38834F';
	DELETE FROM dbo.employee WHERE emp_id = 'PCM98509F';
	DELETE FROM dbo.employee WHERE emp_id = 'PDI47470M';
	DELETE FROM dbo.employee WHERE emp_id = 'PHF38899M';
	DELETE FROM dbo.employee WHERE emp_id = 'PMA42628M';
	DELETE FROM dbo.employee WHERE emp_id = 'POK93028M';
	DELETE FROM dbo.employee WHERE emp_id = 'PSA89086M';
	DELETE FROM dbo.employee WHERE emp_id = 'PSP68661F';
	DELETE FROM dbo.employee WHERE emp_id = 'PTC11962M';
	DELETE FROM dbo.employee WHERE emp_id = 'PXH22250M';
	DELETE FROM dbo.employee WHERE emp_id = 'RBM23061F';
	DELETE FROM dbo.employee WHERE emp_id = 'R-M53550M';
	DELETE FROM dbo.employee WHERE emp_id = 'SKO22412M';
	DELETE FROM dbo.employee WHERE emp_id = 'TPO55093M';
	DELETE FROM dbo.employee WHERE emp_id = 'VPA30890F';
	DELETE FROM dbo.employee WHERE emp_id = 'Y-L77953M';
	-- Operation applied to 43 rows out of 43')
	
	-- Delete rows from dbo.stores')
	DELETE FROM dbo.stores WHERE stor_id = '6380';
	DELETE FROM dbo.stores WHERE stor_id = '7066';
	DELETE FROM dbo.stores WHERE stor_id = '7067';
	DELETE FROM dbo.stores WHERE stor_id = '7131';
	DELETE FROM dbo.stores WHERE stor_id = '7896';
	DELETE FROM dbo.stores WHERE stor_id = '8042';
	-- Operation applied to 6 rows out of 6')
	
	-- Delete rows from dbo.publishers')
	DELETE FROM dbo.publishers WHERE pub_id = '0736';
	DELETE FROM dbo.publishers WHERE pub_id = '0877';
	DELETE FROM dbo.publishers WHERE pub_id = '1389';
	DELETE FROM dbo.publishers WHERE pub_id = '1622';
	DELETE FROM dbo.publishers WHERE pub_id = '1756';
	DELETE FROM dbo.publishers WHERE pub_id = '9901';
	DELETE FROM dbo.publishers WHERE pub_id = '9952';
	DELETE FROM dbo.publishers WHERE pub_id = '9999';
	-- Operation applied to 8 rows out of 8')
	
	-- Delete rows from dbo.jobs')
	DELETE FROM dbo.jobs WHERE job_id = 1;
	DELETE FROM dbo.jobs WHERE job_id = 2;
	DELETE FROM dbo.jobs WHERE job_id = 3;
	DELETE FROM dbo.jobs WHERE job_id = 4;
	DELETE FROM dbo.jobs WHERE job_id = 5;
	DELETE FROM dbo.jobs WHERE job_id = 6;
	DELETE FROM dbo.jobs WHERE job_id = 7;
	DELETE FROM dbo.jobs WHERE job_id = 8;
	DELETE FROM dbo.jobs WHERE job_id = 9;
	DELETE FROM dbo.jobs WHERE job_id = 10;
	DELETE FROM dbo.jobs WHERE job_id = 11;
	DELETE FROM dbo.jobs WHERE job_id = 12;
	DELETE FROM dbo.jobs WHERE job_id = 13;
	DELETE FROM dbo.jobs WHERE job_id = 14;
	-- Operation applied to 14 rows out of 14')
	ALTER TABLE dbo.jobs AUTO_INCREMENT = 1;
	
	-- Delete rows from dbo.authors')
	DELETE FROM dbo.authors WHERE au_id = '172-32-1176';
	DELETE FROM dbo.authors WHERE au_id = '213-46-8915';
	DELETE FROM dbo.authors WHERE au_id = '238-95-7766';
	DELETE FROM dbo.authors WHERE au_id = '267-41-2394';
	DELETE FROM dbo.authors WHERE au_id = '274-80-9391';
	DELETE FROM dbo.authors WHERE au_id = '341-22-1782';
	DELETE FROM dbo.authors WHERE au_id = '409-56-7008';
	DELETE FROM dbo.authors WHERE au_id = '427-17-2319';
	DELETE FROM dbo.authors WHERE au_id = '472-27-2349';
	DELETE FROM dbo.authors WHERE au_id = '486-29-1786';
	DELETE FROM dbo.authors WHERE au_id = '527-72-3246';
	DELETE FROM dbo.authors WHERE au_id = '648-92-1872';
	DELETE FROM dbo.authors WHERE au_id = '672-71-3249';
	DELETE FROM dbo.authors WHERE au_id = '712-45-1867';
	DELETE FROM dbo.authors WHERE au_id = '722-51-5454';
	DELETE FROM dbo.authors WHERE au_id = '724-08-9931';
	DELETE FROM dbo.authors WHERE au_id = '724-80-9391';
	DELETE FROM dbo.authors WHERE au_id = '756-30-7391';
	DELETE FROM dbo.authors WHERE au_id = '807-91-6654';
	DELETE FROM dbo.authors WHERE au_id = '846-92-7186';
	DELETE FROM dbo.authors WHERE au_id = '893-72-1158';
	DELETE FROM dbo.authors WHERE au_id = '899-46-2035';
	DELETE FROM dbo.authors WHERE au_id = '998-72-3567';
	-- Operation applied to 23 rows out of 23')
	
	delete from dbo.discounts;
	Delete from dbo.roysched;
	
	SET foreign_key_checks = 1;
END $$

call dbo.undo_Pubs1_1_2  $$

DROP PROCEDURE IF exists dbo.undo_Pubs1_1_2 $$

DELIMITER ;

