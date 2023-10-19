
-- now put the table comments into a temporary table called TableCommentsWanted
drop table  if exists TableCommentsWanted;
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
drop table  if exists ColumnCommentsWanted;
CREATE TEMPORARY TABLE ColumnCommentsWanted ("TableObjectName" varchar (128), "Type" varchar(20),
                                        "Column" VARCHAR(128), "comment" VARCHAR(1024) );
INSERT INTO ColumnCommentsWanted ("TableObjectName", "Type", "Column", "comment")
VALUES
( N'dbo.publications', N'TABLE', N'Publication_id', N'The surrogate key to the Publications Table' ), 
( N'dbo.publications', N'TABLE', N'title', N'the title of the publicxation' ), 
( N'dbo.publications', N'TABLE', N'pub_id', N'the legacy publication key' ), 
( N'dbo.publications', N'TABLE', N'notes', N'any notes about this publication' ), 
( N'dbo.publications', N'TABLE', N'pubdate', N'the date that it was published' ), 
( N'dbo.editions', N'TABLE', N'Edition_id', N'The surrogate key to the Editions Table' ), 
( N'dbo.editions', N'TABLE', N'publication_id', N'the foreign key to the publication' ), 
( N'dbo.editions', N'TABLE', N'Publication_type', N'the type of publication' ), 
( N'dbo.editions', N'TABLE', N'EditionDate', N'the date at which this edition was created' ), 
( N'dbo.prices', N'TABLE', N'Price_id', N'The surrogate key to the Prices Table' ), 
( N'dbo.prices', N'TABLE', N'Edition_id', N'The edition that this price applies to' ), 
( N'dbo.prices', N'TABLE', N'price', N'the price in dollars' ), 
( N'dbo.prices', N'TABLE', N'advance', N'the advance to the authors' ), 
( N'dbo.prices', N'TABLE', N'royalty', N'the royalty' ), 
( N'dbo.prices', N'TABLE', N'ytd_sales', N'the current sales this year' ), 
( N'dbo.prices', N'TABLE', N'PriceStartDate', N'the start date for which this price applies' ), 
( N'dbo.prices', N'TABLE', N'PriceEndDate', N'null if the price is current, otherwise the date at which it was supoerceded' ), 
( N'dbo.TagName', N'TABLE', N'TagName_ID', N'The surrogate key to the Tag Table' ), 
( N'dbo.TagName', N'TABLE', N'Tag', N'the name of the tag' ), 
( N'dbo.TagTitle', N'TABLE', N'TagTitle_ID', N'The surrogate key to the TagTitle Table' ), 
( N'dbo.TagTitle', N'TABLE', N'title_id', N'The foreign key to the title' ), 
( N'dbo.TagTitle', N'TABLE', N'Is_Primary', N'is this the primary tag (e.g. ''Fiction''' ), 
( N'dbo.TagTitle', N'TABLE', N'TagName_ID', N'The foreign key to the tagname' ), 
( N'dbo.employee', N'TABLE', N'emp_id', N'The key to the Employee Table' ), 
( N'dbo.employee', N'TABLE', N'fname', N'first name' ), 
( N'dbo.employee', N'TABLE', N'minit', N'middle initial' ), 
( N'dbo.employee', N'TABLE', N'lname', N'last name' ), 
( N'dbo.employee', N'TABLE', N'job_id', N'the job that the employee does' ), 
( N'dbo.employee', N'TABLE', N'job_lvl', N'the job level' ), 
( N'dbo.employee', N'TABLE', N'pub_id', N'the publisher that the employee works for' ), 
( N'dbo.employee', N'TABLE', N'hire_date', N'the date that the employeee was hired' ), 
( N'dbo.jobs', N'TABLE', N'job_id', N'The surrogate key to the Jobs Table' ), 
( N'dbo.jobs', N'TABLE', N'job_desc', N'The description of the job' ), 
( N'dbo.jobs', N'TABLE', N'min_lvl', N'the minimum pay level appropriate for the job' ), 
( N'dbo.jobs', N'TABLE', N'max_lvl', N'the maximum pay level appropriate for the job' ), 
( N'dbo.stores', N'TABLE', N'stor_id', N'The primary key to the Store Table' ), 
( N'dbo.stores', N'TABLE', N'stor_name', N'The name of the store' ), 
( N'dbo.stores', N'TABLE', N'stor_address', N'The first-line address of the store' ), 
( N'dbo.stores', N'TABLE', N'city', N'The city in which the store is based' ), 
( N'dbo.stores', N'TABLE', N'state', N'The state where the store is base' ), 
( N'dbo.stores', N'TABLE', N'zip', N'The zipt code for the store' ), 
( N'dbo.discounts', N'TABLE', N'discounttype', N'The type of discount' ), 
( N'dbo.discounts', N'TABLE', N'stor_id', N'The store that has the discount' ), 
( N'dbo.discounts', N'TABLE', N'lowqty', N'The lowest order quantity for which the discount applies' ), 
( N'dbo.discounts', N'TABLE', N'highqty', N'The highest order quantity for which the discount applies' ), 
( N'dbo.discounts', N'TABLE', N'discount', N'the percentage discount' ), 
( N'dbo.discounts', N'TABLE', N'Discount_id', N'The surrogate key to the Discounts Table' ), 
( N'dbo.publishers', N'TABLE', N'pub_id', N'The surrogate key to the Publishers Table' ), 
( N'dbo.publishers', N'TABLE', N'pub_name', N'The name of the publisher' ), 
( N'dbo.publishers', N'TABLE', N'city', N'the city where this publisher is based' ), 
( N'dbo.publishers', N'TABLE', N'state', N'Thge state where this publisher is based' ), 
( N'dbo.publishers', N'TABLE', N'country', N'The country where this publisher is based' ), 
( N'dbo.pub_info', N'TABLE', N'pub_id', N'The foreign key to the publisher' ), 
( N'dbo.pub_info', N'TABLE', N'logo', N'the publisher''s logo' ), 
( N'dbo.pub_info', N'TABLE', N'pr_info', N'The blurb of this publisher' ), 
( N'dbo.roysched', N'TABLE', N'title_id', N'The title to which this applies' ), 
( N'dbo.roysched', N'TABLE', N'lorange', N'the lowest range to which the royalty applies' ), 
( N'dbo.roysched', N'TABLE', N'hirange', N'the highest range to which this royalty applies' ), 
( N'dbo.roysched', N'TABLE', N'royalty', N'the royalty' ), 
( N'dbo.roysched', N'TABLE', N'roysched_id', N'The surrogate key to the RoySched Table' ), 
( N'dbo.sales', N'TABLE', N'stor_id', N'The store for which the sales apply' ), 
( N'dbo.sales', N'TABLE', N'ord_num', N'the reference to the order' ), 
( N'dbo.sales', N'TABLE', N'ord_date', N'the date of the order' ), 
( N'dbo.sales', N'TABLE', N'qty', N'the quantity ordered' ), 
( N'dbo.sales', N'TABLE', N'payterms', N'the pay terms' ), 
( N'dbo.sales', N'TABLE', N'title_id', N'foreign key to the title' ), 
( N'dbo.authors', N'TABLE', N'au_id', N'The key to the Authors Table' ), 
( N'dbo.authors', N'TABLE', N'au_lname', N'last name of the author' ), 
( N'dbo.authors', N'TABLE', N'au_fname', N'first name of the author' ), 
( N'dbo.authors', N'TABLE', N'phone', N'the author''s phone number' ), 
( N'dbo.authors', N'TABLE', N'address', N'the author=s firest line address' ), 
( N'dbo.authors', N'TABLE', N'city', N'the city where the author lives' ), 
( N'dbo.authors', N'TABLE', N'state', N'the state where the author lives' ), 
( N'dbo.authors', N'TABLE', N'zip', N'the zip of the address where the author lives' ), 
( N'dbo.authors', N'TABLE', N'contract', N'had the author agreed a contract?' ), 
( N'dbo.titleauthor', N'TABLE', N'au_id', N'Foreign key to the author' ), 
( N'dbo.titleauthor', N'TABLE', N'title_id', N'Foreign key to the publication' ), 
( N'dbo.titleauthor', N'TABLE', N'au_ord', N' the order in which authors are listed' ), 
( N'dbo.titleauthor', N'TABLE', N'royaltyper', N'the royalty percentage figure' ), 
( N'dbo.titleview', N'VIEW', N'title', N'the name of the title' ), 
( N'dbo.titleview', N'VIEW', N'au_ord', N'order in which the authors are listed' ), 
( N'dbo.titleview', N'VIEW', N'au_lname', N'author last name' ), 
( N'dbo.titleview', N'VIEW', N'price', N'the price of the title' ), 
( N'dbo.titleview', N'VIEW', N'ytd_sales', N'year to date sales' ), 
( N'dbo.titleview', N'VIEW', N'pub_id', N'the id if the publisher' ), 
( N'dbo.titles', N'VIEW', N'title_id', N'The primary key to the Titles table' ), 
( N'dbo.titles', N'VIEW', N'title', N'the name of the title' ), 
( N'dbo.titles', N'VIEW', N'Type', N'the type/tag' ), 
( N'dbo.titles', N'VIEW', N'pub_id', N'the id of the publisher' ), 
( N'dbo.titles', N'VIEW', N'price', N'the price of the publication' ), 
( N'dbo.titles', N'VIEW', N'advance', N'the advance' ), 
( N'dbo.titles', N'VIEW', N'royalty', N'the royalty' ), 
( N'dbo.titles', N'VIEW', N'ytd_sales', N'Year to date sales for the title' ), 
( N'dbo.titles', N'VIEW', N'notes', N'Notes about the title' ), 
( N'dbo.titles', N'VIEW', N'pubdate', N'Date of publication' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'publisher', N'Name of the publisher' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'AudioBook', N'audiobook sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'Book', N'Book sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'Calendar', N'Calendar sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'Ebook', N'Ebook sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'Hardback', N'Hardback sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'Map', N'Map sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'PaperBack', N'Paperback sales' ), 
( N'dbo.PublishersByPublicationType', N'VIEW', N'total', N'Total sales' ), 
( N'dbo.TitlesAndEditionsByPublisher', N'VIEW', N'Publisher', N'Name of publisher' ), 
( N'dbo.TitlesAndEditionsByPublisher', N'VIEW', N'Title', N'the name of the title' ), 
( N'dbo.TitlesAndEditionsByPublisher', N'VIEW', N'Listofeditions', N'a list of editions with its price' )
;
  
drop table  if exists WhatTableToDocument;
-- Create a temporary table to store the tables that need comments
CREATE TEMPORARY TABLE WhatTableToDocument (
  TheOrder SERIAL PRIMARY KEY,
  TableName VARCHAR(80),
  TheDescription VARCHAR(255)
);

drop table  if exists Warnings;
CREATE TEMPORARY TABLE Warnings (
 	Warning  VARCHAR(80)
);

-- Insert the tables that need comments into the temporary table
INSERT INTO WhatTableToDocument (TableName, TheDescription)
SELECT tc.tablename, tc.thedescription
FROM information_schema.tables t
JOIN TableCommentsWanted tc ON CONCAT(t.table_schema, '.', t.table_name) = TableName
LEFT JOIN pg_catalog.pg_description d ON d.objoid = (quote_ident(t.table_schema) || '.' || quote_ident(t.table_name))::regclass::oid
WHERE t.table_type = 'BASE TABLE'
  AND COALESCE(d.description, '') <> tc.TheDescription;

-- Function to iterate over each table and add the comments
CREATE OR REPLACE FUNCTION dbo.CommentEachTable() RETURNS VOID AS $$
DECLARE
  iiMax INT;
  ii INT := 1;
  TABLE_NAME VARCHAR(80);
  THE_COMMENT VARCHAR(255);
  sqlstmt TEXT;
BEGIN
  SELECT COUNT(*) INTO iiMax FROM WhatTableToDocument;
  
  WHILE ii <= iiMax LOOP
    SELECT TableName, TheDescription INTO TABLE_NAME, THE_COMMENT FROM WhatTableToDocument WHERE TheOrder = ii;
    
    sqlstmt := 'COMMENT ON TABLE ' || TABLE_NAME || ' IS ' || quote_literal(THE_COMMENT);
    EXECUTE sqlstmt;
    
    ii := ii + 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Call the function to add comments to tables
insert into warnings (warning)
	SELECT dbo.CommentEachTable();


drop table  if exists WhatColumnToDocument;
-- Create a temporary table to store the columns that need comments
CREATE TEMPORARY TABLE WhatColumnToDocument (
  TheOrder SERIAL PRIMARY KEY,
  TheExpression VARCHAR(255)
);

-- Insert the columns that need comments into the temporary table
INSERT INTO WhatColumnToDocument (TheExpression)
-- || comments.type || ' ' 
SELECT 'COMMENT ON COLUMN ' || cc."TableObjectName" || '.' || quote_ident(c.column_name) || ' IS ' || quote_literal(cc."comment")||';'

/*'ALTER TABLE ' || quote_ident(c.table_schema) || '.' || quote_ident(c.table_name) ||
       ' ALTER COLUMN ' || quote_ident(c.column_name) || ' SET COMMENT ' || quote_literal(cc.comment) AS TheExpression*/
FROM ColumnCommentsWanted cc
  JOIN information_schema.columns c 
    ON cc."Column" = c.column_name 
    and cc."TableObjectName"= quote_ident(c.table_schema) || '.' || quote_ident(c.table_name)
--  LEFT JOIN pg_catalog.pg_description d ON d.objoid = (quote_ident(c.table_schema) || '.' || quote_ident(c.table_name))::regclass::oid
LEFT JOIN pg_catalog.pg_description d ON d.objoid = (cc."TableObjectName")::regclass::oid
WHERE  COALESCE(d.description, '') <> cc."comment";


-- Function to iterate over each column and add the comments
CREATE OR REPLACE FUNCTION dbo.CommentPerRow() RETURNS VOID AS $$
DECLARE
  iiMax INT;
  ii INT := 1;
  THE_EXPRESSION VARCHAR(255);
  sqlstmt TEXT;
BEGIN
  SELECT COUNT(*) INTO iiMax FROM WhatColumnToDocument;
  
  WHILE ii <= iiMax LOOP
    SELECT TheExpression INTO THE_EXPRESSION FROM WhatColumnToDocument WHERE TheOrder = ii;
    
    EXECUTE THE_EXPRESSION;
    
    ii := ii + 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Call the function to add comments to columns
insert into warnings (warning) SELECT dbo.CommentPerRow();

-- Clean up temporary objects
DROP FUNCTION dbo.CommentPerRow();
DROP FUNCTION dbo.CommentEachTable();
DROP TABLE if exists WhatColumnToDocument;
DROP TABLE if exists  WhatTableToDocument;

