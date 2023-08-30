ALTER TABLE dbo.employee DROP FOREIGN KEY fk_Employee_publishers_pub_id;
ALTER TABLE dbo.pub_info DROP FOREIGN KEY fk_Pubinfo_publishers_pub_id;
ALTER TABLE dbo.titles DROP FOREIGN KEY fk_titles_Publishers_pub_id;

-- 'Altering dbo.employee'
ALTER TABLE dbo.employee Modify COLUMN pub_id  char (8) NOT NULL;

-- ''Altering dbo.publishers'

ALTER TABLE dbo.publishers Modify COLUMN pub_id char (8) NOT NULL;

-- ''Altering dbo.pub_info'

ALTER TABLE dbo.pub_info Modify COLUMN pub_id  char (8) NOT NULL;

ALTER TABLE dbo.employee
	ADD constraint fk_Employee_publishers_pub_id  FOREIGN KEY (pub_id) 
	REFERENCES publishers (pub_id);

ALTER TABLE dbo.pub_info
	ADD constraint fk_Pubinfo_publishers_pub_id FOREIGN KEY (pub_id) 
	REFERENCES publishers (pub_id);

	
-- ''Altering dbo.titles'
ALTER TABLE dbo.employee
	ADD constraint fk_Employee_JobID FOREIGN KEY (job_id) 
	REFERENCES jobs (job_id);

drop view dbo.titleview;

ALTER TABLE dbo.titles Modify COLUMN pub_id char (8) NOT NULL;
ALTER TABLE dbo.titles Modify COLUMN type varchar (80) NOT NULL;
ALTER TABLE dbo.titles Modify COLUMN notes text  NULL;
ALTER TABLE dbo.titles Modify COLUMN title varchar(255) NOT NULL;
ALTER TABLE dbo.titles
	ADD constraint fk_titles_Publishers_pub_id  FOREIGN KEY (pub_id) 
	REFERENCES publishers (pub_id);
	
CREATE OR REPLACE VIEW dbo.titleview
AS 
Select title, au_ord, au_lname, price, ytd_sales, pub_id
from dbo.titleauthor  inner join dbo.titles
on titles.title_id = titleauthor.title_id
inner join dbo.authors
on dbo.authors.au_id = dbo.titleauthor.au_id;

-- ''Creating dbo.publications'
CREATE TABLE dbo.publications
(
Publication_id varchar(6) NOT NULL primary key,
title character varying (255) NOT NULL,
pub_id char (8) NULL,
notes character varying(4000) NULL,
pubdate datetime DEFAULT ( CURDATE() ) NOT NULL
);

-- ''Creating dbo.editions'
CREATE TABLE dbo.editions
(
Edition_id int  NOT NULL auto_increment Primary Key,
publication_id varchar(6) NOT NULL,
Publication_type character varying (20) NOT NULL DEFAULT ('book'),
EditionDate datetime DEFAULT ( CURDATE() ) NOT NULL
);

-- ''Creating dbo.prices'
CREATE TABLE dbo.prices
(
Price_id int  NOT NULL auto_increment Primary Key,
Edition_id int NULL,
price decimal(19,4) NULL,
advance decimal(19,4) NULL,
royalty int NULL,
ytd_sales int NULL,
PriceStartDate datetime NOT NULL DEFAULT (current_Date),
PriceEndDate date NULL
);






