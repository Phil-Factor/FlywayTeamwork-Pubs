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
;-- Create a temporary table to store the tables that need comments
CREATE GLOBAL TEMPORARY TABLE WhatTableToDocument (
  TheOrder NUMBER(10,0) PRIMARY KEY,
  TableName VARCHAR2(80),
  TheDescription VARCHAR2(255)
) ON COMMIT DELETE ROWS;

-- Insert the tables that need comments into the temporary table
INSERT INTO WhatTableToDocument (TheOrder, TableName, TheDescription)
SELECT ROW_NUMBER() OVER (ORDER BY tc.tablename), tc.tablename, tc.thedescription
FROM all_tables t
JOIN TableCommentsWanted tc ON (t.owner || '.' || t.table_name) = TableName
LEFT JOIN all_col_comments d ON (d.owner || '.' || d.table_name) = TableName
WHERE d.column_name IS NULL OR d.comments <> tc.TheDescription;

-- Procedure to iterate over each table and add the comments
CREATE OR REPLACE PROCEDURE CommentEachTable AS
  v_Max NUMBER(10,0);
  v_Counter NUMBER(10,0) := 1;
  v_TableName VARCHAR2(80);
  v_TheComment VARCHAR2(255);
  v_SqlStmt VARCHAR2(4000);
BEGIN
  SELECT COUNT(*) INTO v_Max FROM WhatTableToDocument;

  WHILE v_Counter <= v_Max LOOP
    SELECT TableName, TheDescription INTO v_TableName, v_TheComment FROM WhatTableToDocument WHERE TheOrder = v_Counter;
    
    v_SqlStmt := 'COMMENT ON TABLE ' || v_TableName || ' IS ' || q'[''||v_TheComment||'']';
    EXECUTE IMMEDIATE v_SqlStmt;
    
    v_Counter := v_Counter + 1;
  END LOOP;
END CommentEachTable;
/

-- Call the procedure to add comments to tables
EXEC CommentEachTable;

-- Create a temporary table to store the columns that need comments
CREATE GLOBAL TEMPORARY TABLE WhatColumnToDocument (
  TheOrder NUMBER(10,0) PRIMARY KEY,
  TheExpression VARCHAR2(4000)
) ON COMMIT DELETE ROWS;

-- Insert the columns that need comments into the temporary table
INSERT INTO WhatColumnToDocument (TheOrder, TheExpression)
SELECT ROW_NUMBER() OVER (ORDER BY cc."TableObjectName"), 
       'COMMENT ON COLUMN ' || cc."TableObjectName" || ' IS ' || q'[''||cc."comment"||''];'
FROM ColumnCommentsWanted cc
LEFT JOIN all_col_comments d ON (d.owner || '.' || d.table_name || '.' || d.column_name) = cc."TableObjectName"
WHERE d.column_name IS NULL OR d.comments <> cc."comment";

-- Procedure to iterate over each column and add the comments
CREATE OR REPLACE PROCEDURE CommentPerRow AS
  v_Max NUMBER(10,0);
  v_Counter NUMBER(10,0) := 1;
  v_TheExpression VARCHAR2(4000);
BEGIN
  SELECT COUNT(*) INTO v_Max FROM WhatColumnToDocument;
  
  WHILE v_Counter <= v_Max LOOP
    SELECT TheExpression INTO v_TheExpression FROM WhatColumnToDocument WHERE TheOrder = v_Counter;
    
    EXECUTE IMMEDIATE v_TheExpression;
    
    v_Counter := v_Counter + 1;
  END LOOP;
END CommentPerRow;
/

-- Call the procedure to add comments to columns
EXEC CommentPerRow;

-- Clean up temporary objects
DROP TABLE WhatColumnToDocument;
DROP TABLE WhatTableToDocument;



