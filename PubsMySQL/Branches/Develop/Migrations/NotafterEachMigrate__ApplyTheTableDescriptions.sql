-- now put the table comments into a temporary table called TableCommentsWanted
-- DROP TABLE IF EXISTS TableCommentsWanted;
CREATE TEMPORARY TABLE  TableCommentsWanted(Tablename VARCHAR(128), TheDescription VARCHAR(1024));
INSERT INTO TableCommentsWanted (Tablename, TheDescription)-- used to store all the table comments
VALUES -- all the tables either in place or planned in future work
  ('dbo.authors' , 'The authors of the publications. a publication can have one or more author'),
  ('dbo.discounts', 'These are the discounts offered by the sales people for bulk orders'),
  ('dbo.editions', 'A publication can come out in several different editions, of maybe a different type'),
  ('dbo.employee', 'An employee of any of the publishers'),
  ('dbo.jobs', 'These are the job descriptions and min/max salary level' ),
  ('dbo.prices', 'these are the current prices of every edition of every publication'),
  ('dbo.sales', 'these are the sales of every edition of every publication'),
  ('dbo.pub_info', 'this holds the special information about every publisher'),
  ('dbo.publications', 'This lists every publication marketed by the distributor'),
  ('dbo.publishers', 'this is a table of publishers who we distribute books for'),
  ('dbo.roysched', 'this is a table of the authors royalty scheduleable'),
  ('dbo.stores', 'these are all the stores who are our customers'),
  ('dbo.TagName', 'All the categories of publications'),
  ('dbo.TagTitle', 'This relates tags to publications so that publications can have more than one'),
  ('dbo.titleauthor', 'this is a table that relates authors to publications, and gives their order of listing and royalty')
  ;
-- now put the table comments into a temporary table called ColumnCommentsWanted
-- DROP TABLE IF EXISTS ColumnCommentsWanted;
CREATE TEMPORARY TABLE ColumnCommentsWanted (TableObjectName varchar (128), `Type` varchar(20),
                                        `Column` VARCHAR(128), `comment` VARCHAR(1024) );
INSERT INTO ColumnCommentsWanted (`TableObjectName`, `TYPE`, `Column`, `comment`)
VALUES
('dbo.publications','TABLE','Publication_id','The surrogate key to the Publications Table' ), 
('dbo.publications','TABLE','title','the title of the publicxation' ), 
('dbo.publications','TABLE','pub_id','the legacy publication key' ), 
('dbo.publications','TABLE','notes','any notes about this publication' ), 
('dbo.publications','TABLE','pubdate','the date that it was published' ), 
('dbo.editions','TABLE','Edition_id','The surrogate key to the Editions Table' ), 
('dbo.editions','TABLE','publication_id','the foreign key to the publication' ), 
('dbo.editions','TABLE','Publication_type','the type of publication' ), 
('dbo.editions','TABLE','EditionDate','the date at which this edition was created' ), 
('dbo.prices','TABLE','Price_id','The surrogate key to the Prices Table' ), 
('dbo.prices','TABLE','Edition_id','The edition that this price applies to' ), 
('dbo.prices','TABLE','price','the price in dollars' ), 
('dbo.prices','TABLE','advance','the advance to the authors' ), 
('dbo.prices','TABLE','royalty','the royalty' ), 
('dbo.prices','TABLE','ytd_sales','the current sales this year' ), 
('dbo.prices','TABLE','PriceStartDate','the start date for which this price applies' ), 
('dbo.prices','TABLE','PriceEndDate','null if the price is current, otherwise the date at which it was supoerceded' ), 
('dbo.TagName','TABLE','TagName_ID','The surrogate key to the Tag Table' ), 
('dbo.TagName','TABLE','Tag','the name of the tag' ), 
('dbo.TagTitle','TABLE','TagTitle_ID','The surrogate key to the TagTitle Table' ), 
('dbo.TagTitle','TABLE','title_id','The foreign key to the title' ), 
('dbo.TagTitle','TABLE','Is_Primary','is this the primary tag (e.g. ''Fiction''' ), 
('dbo.TagTitle','TABLE','TagName_ID','The foreign key to the tagname' ), 
('dbo.employee','TABLE','emp_id','The key to the Employee Table' ), 
('dbo.employee','TABLE','fname','first name' ), 
('dbo.employee','TABLE','minit','middle initial' ), 
('dbo.employee','TABLE','lname','last name' ), 
('dbo.employee','TABLE','job_id','the job that the employee does' ), 
('dbo.employee','TABLE','job_lvl','the job level' ), 
('dbo.employee','TABLE','pub_id','the publisher that the employee works for' ), 
('dbo.employee','TABLE','hire_date','the date that the employeee was hired' ), 
('dbo.jobs','TABLE','job_id','The surrogate key to the Jobs Table' ), 
('dbo.jobs','TABLE','job_desc','The description of the job' ), 
('dbo.jobs','TABLE','min_lvl','the minimum pay level appropriate for the job' ), 
('dbo.jobs','TABLE','max_lvl','the maximum pay level appropriate for the job' ), 
('dbo.stores','TABLE','stor_id','The primary key to the Store Table' ), 
('dbo.stores','TABLE','stor_name','The name of the store' ), 
('dbo.stores','TABLE','stor_address','The first-line address of the store' ), 
('dbo.stores','TABLE','city','The city in which the store is based' ), 
('dbo.stores','TABLE','state','The state where the store is base' ), 
('dbo.stores','TABLE','zip','The zipt code for the store' ), 
('dbo.discounts','TABLE','discounttype','The type of discount' ), 
('dbo.discounts','TABLE','stor_id','The store that has the discount' ), 
('dbo.discounts','TABLE','lowqty','The lowest order quantity for which the discount applies' ), 
('dbo.discounts','TABLE','highqty','The highest order quantity for which the discount applies' ), 
('dbo.discounts','TABLE','discount','the percentage discount' ), 
('dbo.discounts','TABLE','Discount_id','The surrogate key to the Discounts Table' ), 
('dbo.publishers','TABLE','pub_id','The surrogate key to the Publishers Table' ), 
('dbo.publishers','TABLE','pub_name','The name of the publisher' ), 
('dbo.publishers','TABLE','city','the city where this publisher is based' ), 
('dbo.publishers','TABLE','state','Thge state where this publisher is based' ), 
('dbo.publishers','TABLE','country','The country where this publisher is based' ), 
('dbo.pub_info','TABLE','pub_id','The foreign key to the publisher' ), 
('dbo.pub_info','TABLE','logo','the publisher''s logo' ), 
('dbo.pub_info','TABLE','pr_info','The blurb of this publisher' ), 
('dbo.roysched','TABLE','title_id','The title to which this applies' ), 
('dbo.roysched','TABLE','lorange','the lowest range to which the royalty applies' ), 
('dbo.roysched','TABLE','hirange','the highest range to which this royalty applies' ), 
('dbo.roysched','TABLE','royalty','the royalty' ), 
('dbo.roysched','TABLE','roysched_id','The surrogate key to the RoySched Table' ), 
('dbo.sales','TABLE','stor_id','The store for which the sales apply' ), 
('dbo.sales','TABLE','ord_num','the reference to the order' ), 
('dbo.sales','TABLE','ord_date','the date of the order' ), 
('dbo.sales','TABLE','qty','the quantity ordered' ), 
('dbo.sales','TABLE','payterms','the pay terms' ), 
('dbo.sales','TABLE','title_id','foreign key to the title' ), 
('dbo.authors','TABLE','au_id','The key to the Authors Table' ), 
('dbo.authors','TABLE','au_lname','last name of the author' ), 
('dbo.authors','TABLE','au_fname','first name of the author' ), 
('dbo.authors','TABLE','phone','the author''s phone number' ), 
('dbo.authors','TABLE','address','the author=s firest line address' ), 
('dbo.authors','TABLE','city','the city where the author lives' ), 
('dbo.authors','TABLE','state','the state where the author lives' ), 
('dbo.authors','TABLE','zip','the zip of the address where the author lives' ), 
('dbo.authors','TABLE','contract','had the author agreed a contract?' ), 
('dbo.titleauthor','TABLE','au_id','Foreign key to the author' ), 
('dbo.titleauthor','TABLE','title_id','Foreign key to the publication' ), 
('dbo.titleauthor','TABLE','au_ord',' the order in which authors are listed' ), 
('dbo.titleauthor','TABLE','royaltyper','the royalty percentage figure' ), 
('dbo.titleview','VIEW','title','the name of the title' ), 
('dbo.titleview','VIEW','au_ord','order in which the authors are listed' ), 
('dbo.titleview','VIEW','au_lname','author last name' ), 
('dbo.titleview','VIEW','price','the price of the title' ), 
('dbo.titleview','VIEW','ytd_sales','year to date sales' ), 
('dbo.titleview','VIEW','pub_id','the id if the publisher' ), 
('dbo.titles','VIEW','title_id','The primary key to the Titles table' ), 
('dbo.titles','VIEW','title','the name of the title' ), 
('dbo.titles','VIEW','Type','the type/tag' ), 
('dbo.titles','VIEW','pub_id','the id of the publisher' ), 
('dbo.titles','VIEW','price','the price of the publication' ), 
('dbo.titles','VIEW','advance','the advance' ), 
('dbo.titles','VIEW','royalty','the royalty' ), 
('dbo.titles','VIEW','ytd_sales','Year to date sales for the title' ), 
('dbo.titles','VIEW','notes','Notes about the title' ), 
('dbo.titles','VIEW','pubdate','Date of publication' ), 
('dbo.PublishersByPublicationType','VIEW','publisher','Name of the publisher' ), 
('dbo.PublishersByPublicationType','VIEW','AudioBook','audiobook sales' ), 
('dbo.PublishersByPublicationType','VIEW','Book','Book sales' ), 
('dbo.PublishersByPublicationType','VIEW','Calendar','Calendar sales' ), 
('dbo.PublishersByPublicationType','VIEW','Ebook','Ebook sales' ), 
('dbo.PublishersByPublicationType','VIEW','Hardback','Hardback sales' ), 
('dbo.PublishersByPublicationType','VIEW','Map','Map sales' ), 
('dbo.PublishersByPublicationType','VIEW','PaperBack','Paperback sales' ), 
('dbo.PublishersByPublicationType','VIEW','total','Total sales' ), 
('dbo.TitlesAndEditionsByPublisher','VIEW','Publisher','Name of publisher' ), 
('dbo.TitlesAndEditionsByPublisher','VIEW','Title','the name of the title' ), 
('dbo.TitlesAndEditionsByPublisher','VIEW','Listofeditions','a list of editions with its price' )
;

-- now we determine what comments need to be inseted or updated into a table
-- and insert the results into a temporary table WhatTableToDocument
-- DROP TABLE IF EXISTS WhatTableToDocument;
CREATE TEMPORARY TABLE  WhatTableToDocument (
	TheOrder int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Tablename varchar(80), 
 	TheDescription VARCHAR(255));
INSERT INTO WhatTableToDocument (Tablename, TheDescription) 	
 SELECT Tablename, TheDescription FROM information_schema.`TABLES`
 INNER JOIN TableCommentsWanted 
 on CONCAT (TABLE_SCHEMA,'.',TABLE_NAME)=TableName
 AND TABLE_TYPE = 'BASE TABLE'
 WHERE table_comment <> TheDescription;
-- We now need to insert these comments into the tables
-- we'll do it one at a time so it requirese several prepared sttements
Delimiter $$

CREATE PROCEDURE CommentEachTable()
BEGIN
set @iiMax = 0;
set @ii = 0;
SELECT COUNT(*) FROM WhatTableToDocument INTO @iiMax;
SET @ii=1;
WHILE @ii <= @iiMax DO 
		SET @TABLE=(Select tablename FROM WhatTableToDocument WHERE TheOrder=@ii);
		SET @COMMENT=(Select TheDescription FROM WhatTableToDocument WHERE TheOrder=@ii);
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

CALL CommentEachTable; -- execute the temporary procedure

/*now we need to insert or update all the comments. This is a bit more
complicated because we need to recereate the colunm exactly as it existed
with the addition of the comment */

-- DROP TABLE IF EXISTS WhatColumnToDocument;
Create temporary table WhatColumnToDocument (
	TheOrder int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Theexpression VARCHAR(255)); 
INSERT INTO WhatColumnToDocument (Theexpression)
SELECT CONCAT('ALTER ',
			comments.type,
			'  `',
        TABLE_SCHEMA,
        '`.`',
        table_name,
        '` CHANGE `',
        column_name,
        '` `',
        column_name,
        '` ',
        column_type,
        ' ',
        IF(collation_name IS NOT NULL,CONCAT ('COLLATE ',collation_name,' '),' '),
        IF(is_nullable = 'YES', '' , 'NOT NULL '),
        case when COLUMN_DEFAULT IS NULL then '' ELSE CONCAT (' DEFAULT (',COLUMN_DEFAULT,')') END,
        extra,
        ' COMMENT \'',
        REPLACE(`comment`,'''',''''''),
        '\' ;') as script FROM ColumnCommentsWanted comments
INNER JOIN information_schema.`COLUMNS` 
ON comments.column=`COLUMNS`.COLUMN_NAME 
and TABLE_SCHEMA = DATABASE() 
AND TYPE <> 'VIEW'
AND CONCAT (TABLE_SCHEMA,'.',TABLE_NAME)=TableObjectName
WHERE COLUMN_COMMENT <> COMMENT; 
/* now a procedure to do each column that needs to be updated */
Delimiter $$

CREATE PROCEDURE CommentPerRow()
BEGIN
set @iiMax = 0;
set @ii = 0;
SELECT COUNT(*) FROM WhatColumnToDocument INTO @iiMax;
SET @ii=1;
WHILE @ii <= @iiMax DO 
		SET @expression=(Select Theexpression FROM WhatColumnToDocument WHERE TheOrder=@ii);
		PREPARE st FROM @expression;
        EXECUTE st;
        DEALLOCATE PREPARE st;
 SET @ii = @ii + 1;
END WHILE;
END;
$$
DELIMITER ;  
-- now mop up if necessary 
CALL CommentPerRow;
DROP PROCEDURE  CommentPerRow;
DROP PROCEDURE  CommentEachTable;
-- temporary tables will only last as long as the session is alive. 


