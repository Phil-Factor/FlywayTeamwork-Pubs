CREATE TABLE employee (
	emp_id char(9) NOT NULL,
	fname varchar(20) NOT NULL,
	minit char(1),
	lname varchar(30) NOT NULL,
	job_id smallint DEFAULT ((1)) NOT NULL,
	job_lvl smallint DEFAULT ((10)),
	pub_id char(4) DEFAULT '9952' NOT NULL,
	hire_date datetime DEFAULT ( CURDATE() ) NOT NULL,
	PRIMARY KEY (emp_id)
);

CREATE TABLE jobs (
	job_id smallint NOT NULL auto_increment,
	job_desc varchar(50) DEFAULT 'New Position - title not formalized yet' NOT NULL,
	min_lvl smallint NOT NULL,
	max_lvl smallint NOT NULL,
	PRIMARY KEY (job_id)
);


/*
CREATE TRIGGER dbo.employee_insupd
ON dbo.employee
FOR insert, UPDATE
AS
--Get the range of level for this job type from the jobs table.
declare min_lvl tinyint,
   max_lvl tinyint,
   emp_lvl tinyint,
   job_id smallint
select min_lvl = min_lvl,
   max_lvl = max_lvl,
   emp_lvl = i.job_lvl,
   job_id = i.job_id
from employee e, jobs j, inserted i
where e.emp_id = i.emp_id AND i.job_id = j.job_id
IF (job_id = 1) and (emp_lvl <> 10)
begin
   raiserror ('Job id 1 expects the default level of 10.',16,1)
   ROLLBACK TRANSACTION
end
ELSE
IF NOT (emp_lvl BETWEEN min_lvl AND max_lvl)
begin
   raiserror ('The level for job_id:%d should be between %d and %d.',
      16, 1, job_id, min_lvl, max_lvl)
   ROLLBACK TRANSACTION
end

*/
CREATE TABLE stores (
	stor_id char(4) NOT NULL,
	stor_name varchar(40),
	stor_address varchar(40),
	city varchar(20),
	state char(2),
	zip char(5),
	PRIMARY KEY (stor_id)
);


CREATE TABLE discounts (
	discounttype varchar(40) NOT NULL,
	stor_id char(4),
	lowqty smallint,
	highqty smallint,
	discount decimal(4,2) NOT NULL
);


CREATE TABLE publishers (
	pub_id char(4) NOT NULL,
	pub_name varchar(40),
	city varchar(20),
	state char(2),
	country varchar(30) DEFAULT 'USA',
	PRIMARY KEY (pub_id)
);


CREATE TABLE pub_info (
	pub_id char(4) NOT NULL,
	logo longblob,
	pr_info longtext,
	PRIMARY KEY (pub_id)
);

CREATE TABLE titles (
	title_id varchar(6) NOT NULL,
	title varchar(80) NOT NULL,
	type char(12) DEFAULT 'UNDECIDED' NOT NULL,
	pub_id char(4),
	price decimal(19,4),
	advance decimal(19,4),
	royalty integer,
	ytd_sales integer,
	notes varchar(200),
	pubdate datetime DEFAULT ( CURDATE() ) NOT NULL,
	PRIMARY KEY (title_id)
);


CREATE  INDEX titleind ON dbo.titles (title);

CREATE TABLE roysched (
	title_id varchar(6) NOT NULL,
	lorange integer,
	hirange integer,
	royalty integer
);

CREATE INDEX titleidind ON dbo.roysched (title_id);

CREATE TABLE sales (
	stor_id char(4) NOT NULL,
	ord_num varchar(20) NOT NULL,
	ord_date datetime NOT NULL,
	qty smallint NOT NULL,
	payterms varchar(12) NOT NULL,
	title_id varchar(6) NOT NULL,
	PRIMARY KEY (ord_num,stor_id,title_id)
);

CREATE INDEX titleidind ON dbo.sales (title_id);

CREATE TABLE authors (
	au_id varchar(11) NOT NULL,
	au_lname varchar(40) NOT NULL,
	au_fname varchar(20) NOT NULL,
	phone char(12) DEFAULT 'UNKNOWN' NOT NULL,
	address varchar(40),
	city varchar(20),
	state char(2),
	zip char(5),
	contract smallint NOT NULL,
	PRIMARY KEY (au_id)
);

CREATE INDEX aunmind ON dbo.authors (au_lname, au_fname);


CREATE TABLE titleauthor (
	au_id varchar(11) NOT NULL,
	title_id varchar(6) NOT NULL,
	au_ord smallint,
	royaltyper integer,
	PRIMARY KEY (au_id,title_id)
);


CREATE INDEX auidind ON dbo.titleauthor (au_id);

CREATE VIEW dbo.titleview
AS
select title, au_ord, au_lname, price, ytd_sales, pub_id
from authors, titles, titleauthor
where authors.au_id = titleauthor.au_id
   AND titles.title_id = titleauthor.title_id;

DELIMITER //
CREATE PROCEDURE dbo.byroyalty (percentage int)
Begin
select au_id from titleauthor
where titleauthor.royaltyper = percentage;
end;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE dbo.reptq1 () 
Begin
(select 
	pub_id, 
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id)
union all
(select 
	'ALL' as pub_id, avg(price)  avg_price
from titles
where price is NOT NULL);
end
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE dbo.reptq2 () 
Begin
(select 
	type, 
	pub_id, 
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id, TYPE)
union all
(select 
	type, 'ALL' as pub_id, avg(price)  avg_price
from titles
where price is NOT NULL
GROUP BY type)
union all
(select 
	'ALL' as TYPE , pub_id, avg(price)  avg_price
from titles
where price is NOT NULL
GROUP BY pub_id);
end
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE dbo.reptq3 (lolimit decimal(19,4), hilimit decimal(19,4),
type char(12))
Begin
(select 
	pub_id, 
	avg(price) as avg_price
from titles
where price >lolimit AND price <hilimit AND type = type OR type LIKE '%cook%'
group by pub_id)
union all
(select 
	'ALL' as pub_id, avg(price)  avg_price
from titles
where price >lolimit AND price <hilimit AND type = type OR type LIKE '%cook%'
group by pub_id, type);
end
//
DELIMITER ;


ALTER TABLE dbo.authors ADD CONSTRAINT CK__authors__au_id CHECK (au_id regexp '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]');

ALTER TABLE dbo.authors ADD CONSTRAINT CK__authors__zip CHECK (zip regexp '[0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE dbo.employee ADD CONSTRAINT CK_emp_id CHECK (emp_id regexp '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR emp_id regexp '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]');

ALTER TABLE dbo.jobs ADD CONSTRAINT CK__jobs__min_lvl CHECK ((min_lvl>=(10)));

ALTER TABLE dbo.jobs ADD CONSTRAINT CK__jobs__max_lvl CHECK ((max_lvl<=(250)));

ALTER TABLE dbo.publishers ADD CONSTRAINT CK__publisher__pub CHECK ((pub_id='1756' OR pub_id='1622' OR pub_id='0877' OR pub_id='0736' OR pub_id='1389' OR pub_id regexp  '99[0-9][0-9]'));

