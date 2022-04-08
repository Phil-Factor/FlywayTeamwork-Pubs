/* Flyway generic Pubs build using SQL-92 syntax where possible
and using placeholders for any syntax that is database-specific.  
'currentDateTime' the function used to give the current date
'schemaPrefix' the schema prefix to use.(e.g. dbo. )
'CLOB' the data type you use for text of indeterminate large size
'BLOB' the data type you use for binary data of large size
'autoIncrement' how you specify an identity column
'DateDatatype' the datatype for storing both date and time
'hexValueStart' how you declare hex-based binary data
'hexValueEnd' how you terminate hex-based binary data
'arg'the prefix for the variables that you use as parameters for procedures
'viewStart' the code to start the creation of a view
'viewFinish' the code to finish the creation of a view
'procStart'  the initial string for a procedure;;
'emptyProcArgs' how you denote that you have no args/parameters for creating a procedure
'procBegin' = the preliminary string for a procedure
'procEnd' = the termination string for a procedure;
'procFinish' = the final string for a procedure; */

/*authors table */

CREATE TABLE ${schemaPrefix}authors (
	au_id varchar(11) NOT NULL,
	au_lname varchar(40) NOT NULL,
	au_fname varchar(20) NOT NULL,
	phone char(12) DEFAULT 'UNKNOWN' NOT NULL,
	address varchar(40),
	city varchar(20),
	state char(2),
	zip char(5),
	contract int NOT NULL,
        CONSTRAINT CK__authors__au_id CHECK (au_id LIKE '___-__-____'),
	CONSTRAINT CK__authors__zip CHECK (zip LIKE '_____'),
	PRIMARY KEY (au_id)
);

/*jobs table */
CREATE TABLE ${schemaPrefix}jobs (
	job_id ${autoIncrement},
	job_desc varchar(50) DEFAULT 'New Position - title not formalized yet' NOT NULL,
	min_lvl int NOT NULL,
	max_lvl int NOT NULL,
  	CONSTRAINT CK__jobs__min_lvl CHECK (min_lvl >= 0),
  	CONSTRAINT CK__jobs__max_lvl CHECK (max_lvl <= 250)
);


/*publishers table */
CREATE TABLE ${schemaPrefix}publishers (
	pub_id char(4) NOT NULL,
	pub_name varchar(40),
	city varchar(20),
	state char(2),
	country varchar(30) DEFAULT 'USA',
	CONSTRAINT CK__publisher__pub CHECK ((pub_id='1756' OR pub_id='1622' OR pub_id='0877' OR pub_id='0736' OR pub_id='1389' OR pub_id Like '99__')),
	PRIMARY KEY (pub_id)
);

/*stores table */
CREATE TABLE ${schemaPrefix}stores (
	stor_id char(4) NOT NULL,
	stor_name varchar(40),
	stor_address varchar(40),
	city varchar(20),
	state char(2),
	zip char(5),
	PRIMARY KEY (stor_id)
);

/*jobs titles */
CREATE TABLE ${schemaPrefix}titles (
	title_id varchar(6) NOT NULL,
	title varchar(80) NOT NULL,
	type char(12) DEFAULT 'UNDECIDED' NOT NULL,
	pub_id char(4),
	price decimal(19,4),
	advance decimal(19,4),
	royalty int,
	ytd_sales int,
	notes varchar(200),
   	pubdate varchar(50)  DEFAULT (${currentDateTime}) NOT NULL,
	FOREIGN KEY (pub_id) REFERENCES publishers (pub_id),
	PRIMARY KEY (title_id)
);	

/*pub_info table */
CREATE TABLE ${schemaPrefix}pub_info (
	pub_id char(4) NOT NULL,
	logo ${Blob},
	pr_info ${Clob},
	PRIMARY KEY (pub_id),
	FOREIGN KEY (pub_id) REFERENCES publishers (pub_id)
);

/*roysched table */
CREATE TABLE ${schemaPrefix}roysched (
	title_id varchar(6) NOT NULL,
	lorange int,
	hirange int,
	royalty int,
	FOREIGN KEY (title_id) REFERENCES titles (title_id)
);


/*discounts table */
CREATE TABLE ${schemaPrefix}discounts (
	discounttype varchar(40) NOT NULL,
	stor_id char(4),
	lowqty int,
	highqty int,
	discount decimal(4,2) NOT NULL,
	FOREIGN KEY (stor_id) REFERENCES stores (stor_id)
);

/*titleauthor table */
CREATE TABLE ${schemaPrefix}titleauthor (
	au_id varchar(11) NOT NULL,
	title_id varchar(6) NOT NULL,
	au_ord int,
	royaltyper int,
	FOREIGN KEY (au_id) REFERENCES authors (au_id),
        FOREIGN KEY (title_id) REFERENCES titles (title_id),
	PRIMARY KEY (au_id,title_id)
);

CREATE INDEX auidind ON ${schemaPrefix}titleauthor (au_id);

/*employee table */
CREATE TABLE ${schemaPrefix}employee (
	emp_id char(9) NOT NULL,
	fname varchar(20) NOT NULL,
	minit char(1),
	lname varchar(30) NOT NULL,
	job_id int DEFAULT ((1)) NOT NULL,
	job_lvl int DEFAULT ((10)),
	pub_id char(4) DEFAULT '9952' NOT NULL,
	hire_date ${dateDatatype} DEFAULT (${currentDateTime}) NOT NULL,
	FOREIGN KEY (job_id) REFERENCES jobs (job_id),
	FOREIGN KEY (pub_id)  REFERENCES publishers (pub_id),
	CONSTRAINT CK_emp_id CHECK (emp_id LIKE '_________' OR emp_id LIKE '_-_______'),
	PRIMARY KEY (emp_id)
);
-- Creating index employee_ind on ${schemaPrefix}employee'

CREATE INDEX employee_ind ON ${schemaPrefix}employee (lname, fname, minit);

/*Sales table */
CREATE TABLE ${schemaPrefix}sales (
	stor_id char(4) NOT NULL,
	ord_num varchar(20) NOT NULL,
	ord_date varchar(50) NOT NULL,
	qty int NOT NULL,
	payterms varchar(12) NOT NULL,
	title_id varchar(6) NOT NULL,
	PRIMARY KEY (ord_num,stor_id,title_id),
	FOREIGN KEY (stor_id) REFERENCES stores (stor_id),
	FOREIGN KEY (title_id) REFERENCES titles (title_id)
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

/*TitleView View */
${viewStart}
CREATE VIEW ${schemaPrefix}titleview
AS
select title, au_ord, au_lname, price, ytd_sales, pub_id
from authors, titles, titleauthor
where authors.au_id = titleauthor.au_id
   AND titles.title_id = titleauthor.title_id;
${viewFinish}

/*ByRoyalty procedure*/
${procStart}
CREATE PROCEDURE ${schemaPrefix}byroyalty (${arg}percentage int)
${procBegin}
select au_id from titleauthor
where titleauthor.royaltyper = ${arg}percentage;
${procEnd}
${procFinish}

/*reptq1 procedure*/
${procStart}
CREATE PROCEDURE ${schemaPrefix}reptq1  ${emptyProcArgs}
${procBegin}
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
${procEnd}
${procFinish}

/*BReptq2 procedure*/
${procStart}
CREATE PROCEDURE ${schemaPrefix}reptq2 ${emptyProcArgs}
${procBegin}
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
${procEnd}
${procFinish}

/*reptq3 procedure*/
${procStart}
CREATE PROCEDURE ${schemaPrefix}reptq3 (${arg}lolimit decimal(19,4), ${arg}hilimit decimal(19,4),
${arg}type char(12))
${procBegin}
(select 
	pub_id, 
	avg(price) as avg_price
from titles
where price > ${arg}lolimit AND price < ${arg}hilimit AND type = ${arg}type OR type LIKE '%cook%'
group by pub_id)
union all
(select 
	'ALL' as pub_id, avg(price)  avg_price
from titles
where price >${arg}lolimit AND price <${arg}hilimit AND type = ${arg}type OR type LIKE '%cook%'
group by pub_id, type);
${procEnd}
${procFinish}

/*
ALTER TABLE dbo.authors ADD CONSTRAINT CK__authors__au_id CHECK (au_id regexp '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]');
ALTER TABLE dbo.authors ADD CONSTRAINT CK__authors__zip CHECK (zip regexp '[0-9][0-9][0-9][0-9][0-9]');
ALTER TABLE dbo.employee ADD CONSTRAINT CK_emp_id CHECK (emp_id regexp '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' OR emp_id regexp '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]');
ALTER TABLE dbo.jobs ADD CONSTRAINT CK__jobs__min_lvl CHECK ((min_lvl>=(10)));
ALTER TABLE dbo.jobs ADD CONSTRAINT CK__jobs__max_lvl CHECK ((max_lvl<=(250)));
ALTER TABLE dbo.publishers ADD CONSTRAINT CK__publisher__pub CHECK ((pub_id='1756' OR pub_id='1622' OR pub_id='0877' OR pub_id='0736' OR pub_id='1389' OR pub_id regexp  '99[0-9][0-9]'));
*/
