SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE  SCHEMA IF NOT EXISTS dbo;
CREATE DOMAIN dbo.tid as varchar(6) NOT NULL;
CREATE DOMAIN dbo.id as varchar(11) NOT NULL;
CREATE DOMAIN dbo.empid as char(9) NOT NULL;

CREATE TABLE dbo.employee
(
emp_id dbo.empid NOT NULL,
fname varchar (20) NOT NULL,
minit char (1) NULL,
lname varchar (30) NOT NULL,
job_id smallint NOT NULL DEFAULT ((1)),
job_lvl smallint NULL   DEFAULT ((10)),
pub_id char (4) NOT NULL  DEFAULT ('9952'),
hire_date DATE NOT NULL   DEFAULT (CURRENT_DATE)
);

-- Creating index employee_ind on dbo.employee'

CREATE INDEX employee_ind ON dbo.employee (lname, fname, minit);

ALTER TABLE dbo.employee CLUSTER ON "employee_ind";

-- Creating primary key PK_emp_id on dbo.employee'

ALTER TABLE dbo.employee ADD CONSTRAINT PK_emp_id PRIMARY KEY   (emp_id); 

-- Creating dbo.jobs'

CREATE TABLE dbo.jobs
(
job_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY,
job_desc varchar (50) NOT NULL DEFAULT ('New Position - title not formalized yet'),
min_lvl smallint NOT NULL,
max_lvl smallint NOT NULL
);

-- Creating primary key PK__jobs__6E32B6A51A14E395 on dbo.jobs'
ALTER TABLE dbo.jobs ADD CONSTRAINT PK__jobs PRIMARY KEY (job_id);
CREATE INDEX pk__idx
    ON dbo.jobs USING btree
    (job_id ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.jobs
    CLUSTER ON pk__idx;
-- Creating trigger dbo.employee_insupd on dbo.employee'

/*
CREATE TRIGGER dbo.employee_insupd
ON dbo.employee
FOR insert, UPDATE
AS
--Get the range of level for this job type from the jobs table.
declare @min_lvl smallint,
   @max_lvl smallint,
   @emp_lvl smallint,
   @job_id smallint
select @min_lvl = min_lvl,
   @max_lvl = max_lvl,
   @emp_lvl = i.job_lvl,
   @job_id = i.job_id
from employee e, jobs j, inserted i
where e.emp_id = i.emp_id AND i.job_id = j.job_id
IF (@job_id = 1) and (@emp_lvl <> 10)
begin
   raiserror ('Job id 1 expects the default level of 10.',16,1)
   ROLLBACK TRANSACTION
end
ELSE
IF NOT (@emp_lvl BETWEEN @min_lvl AND @max_lvl)
begin
   raiserror ('The level for job_id:%d should be between %d and %d.',
      16, 1, @job_id, @min_lvl, @max_lvl)
   ROLLBACK TRANSACTION
end;
*/
-- Creating dbo.stores'
CREATE TABLE dbo.stores
(
stor_id char (4) NOT NULL,
stor_name varchar (40) NULL,
stor_address varchar (40) NULL,
city varchar (20) NULL,
state char (2) NULL,
zip char (5) NULL
);

-- Creating primary key UPK_storeid on dbo.stores'

ALTER TABLE dbo.stores ADD CONSTRAINT UPK_storeid PRIMARY KEY (stor_id);
CREATE UNIQUE INDEX pk_stores_idx
    ON dbo.stores USING btree
    (stor_id ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.stores
    CLUSTER ON pk_stores_idx;
-- Creating dbo.discounts'

CREATE TABLE dbo.discounts
(
discounttype varchar (40) NOT NULL,
stor_id char (4) NULL,
lowqty smallint NULL,
highqty smallint NULL,
discount decimal (4, 2) NOT NULL
);
-- Creating dbo.publishers'
CREATE TABLE dbo.publishers
(
pub_id char (4) NOT NULL,
pub_name varchar (40) NULL,
city varchar (20) NULL,
state char (2) NULL,
country varchar (30) NULL DEFAULT ('USA')
) ;
-- Creating primary key UPKCL_pubind on dbo.publishers'
ALTER TABLE dbo.publishers ADD CONSTRAINT UPKCL_pubind PRIMARY KEY (pub_id);
CREATE INDEX pk_pub_idx
    ON dbo.publishers  USING btree
    (pub_id ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.publishers
    CLUSTER ON pk_pub_idx;

-- Creating dbo.pub_info'
CREATE TABLE dbo.pub_info
(
pub_id char (4) NOT NULL,
logo BYTEA NULL,
pr_info text NULL
);

-- Creating primary key UPKCL_pubinfo on dbo.pub_info'
ALTER TABLE dbo.pub_info ADD CONSTRAINT UPKCL_pubinfo PRIMARY KEY  (pub_id);
CREATE INDEX pk_pub_Info_idx
    ON dbo.pub_info  USING btree
    (pub_id ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.pub_info
    CLUSTER ON pk_pub_Info_idx;


-- Creating dbo.titles'
CREATE TABLE dbo.titles
(
title_id dbo.tid NOT NULL,
title varchar (80) NOT NULL,
type char (12) NOT NULL DEFAULT ('UNDECIDED'),
pub_id char (4) NULL,
price money NULL,
advance money NULL,
royalty int NULL,
ytd_sales int NULL,
notes varchar (200) NULL,
pubdate DATE NOT NULL DEFAULT (CURRENT_DATE)
);



-- Creating primary key UPKCL_titleidind on dbo.titles'

ALTER TABLE dbo.titles ADD CONSTRAINT UPKCL_titleidind PRIMARY KEY  (title_id);

CREATE INDEX pk_Titles_idx
    ON dbo.titles  USING btree
    (title_id ASC NULLS LAST)
    TABLESPACE pg_default;

ALTER TABLE dbo.pub_info
    CLUSTER ON pk_pub_Info_idx;

-- Creating index titleind on dbo.titles'

CREATE  INDEX titleind ON dbo.titles (title);



-- Creating dbo.roysched'

CREATE TABLE dbo.roysched
(
title_id dbo.tid NOT NULL,
lorange int NULL,
hirange int NULL,
royalty int NULL
);



-- Creating index titleidRoyind on dbo.roysched'

CREATE  INDEX titleidRoyInd ON dbo.roysched (title_id); 

-- Creating dbo.sales'
CREATE TABLE dbo.sales
(
stor_id char (4) NOT NULL,
ord_num varchar (20) NOT NULL,
ord_date DATE NOT NULL,
qty smallint NOT NULL,
payterms varchar (12) NOT NULL,
title_id dbo.tid NOT NULL
);

-- Creating primary key UPKCL_sales on dbo.sales'
ALTER TABLE dbo.sales ADD CONSTRAINT UPKCL_sales PRIMARY KEY  (stor_id, ord_num, title_id);
CREATE INDEX pk_sales_idx
    ON dbo.sales  USING btree
    (stor_id, ord_num, title_id)
    TABLESPACE pg_default;

ALTER TABLE dbo.sales
    CLUSTER ON pk_sales_idx;


-- Creating index titleidindSales on dbo.sales'

CREATE  INDEX titleidindSales ON dbo.sales (title_id);



-- Creating dbo.authors'

CREATE TABLE dbo.authors
(
au_id dbo.id NOT NULL,
au_lname varchar (40) NOT NULL,
au_fname varchar (20) NOT NULL,
phone char (12) NOT NULL DEFAULT ('UNKNOWN'),
address varchar (40) NULL,
city varchar (20) NULL,
state char (2) NULL,
zip char (5) NULL,
contract bit NOT NULL
) ;



-- Creating primary key UPKCL_auidind on dbo.authors'

ALTER TABLE dbo.authors ADD CONSTRAINT UPKCL_auidind PRIMARY KEY (au_id);
CREATE INDEX pk_authors_idx
    ON dbo.authors  USING btree
    (au_id)
    TABLESPACE pg_default;

ALTER TABLE dbo.authors
    CLUSTER ON pk_authors_idx;



-- Creating index aunmind on dbo.authors'

CREATE  INDEX aunmind ON dbo.authors (au_lname, au_fname);



-- Creating dbo.titleauthor'

CREATE TABLE dbo.titleauthor
(
au_id dbo.id NOT NULL,
title_id dbo.tid NOT NULL,
au_ord smallint NULL,
royaltyper int NULL
);



-- Creating primary key UPKCL_taind on dbo.titleauthor'

ALTER TABLE dbo.titleauthor ADD CONSTRAINT UPKCL_taind PRIMARY KEY   (au_id, title_id);
CREATE INDEX pk_titleauthor_idx
    ON dbo.titleauthor  USING btree
    (au_id, title_id)
    TABLESPACE pg_default;

ALTER TABLE dbo.titleauthor
    CLUSTER ON pk_titleauthor_idx;


-- Creating index auidind on dbo.titleauthor'

CREATE  INDEX auidind ON dbo.titleauthor (au_id);



-- Creating index titleidind on dbo.titleauthor'

CREATE  INDEX titleidind ON dbo.titleauthor (title_id);



-- Creating dbo.titleview'


CREATE VIEW dbo.titleview
AS
select title, au_ord, au_lname, price, ytd_sales, pub_id
from dbo.titleauthor  inner join dbo.titles
on titles.title_id = titleauthor.title_id
inner join dbo.authors
on dbo.authors.au_id = dbo.titleauthor.au_id;

-- Creating dbo.byroyalty'
CREATE PROCEDURE dbo.byroyalty (percentage int)
language SQL
AS $$
select au_id from titleauthor
where titleauthor.royaltyper = percentage
$$;



-- Creating dbo.reptq1'


CREATE PROCEDURE dbo.reptq1()
language SQL
AS $$
select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(price) as avg_price
from titles
where price is NOT NULL
group by pub_id 
order by pub_id
$$;



-- Creating dbo.reptq2'
CREATE PROCEDURE dbo.reptq2 ()
language SQL
AS $$
select 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	avg(ytd_sales) as avg_ytd_sales
from titles
where pub_id is NOT NULL
group by pub_id, type
$$;



-- Creating dbo.reptq3'


CREATE PROCEDURE dbo.reptq3 (lolimit money, hilimit money,type char(12))
language SQL
AS $$

select 
	case when grouping(pub_id) = 1 then 'ALL' else pub_id end as pub_id, 
	case when grouping(type) = 1 then 'ALL' else type end as type, 
	count(title_id) as cnt
from titles
where price >@lolimit AND price <@hilimit AND type = @type OR type LIKE '%cook%'
group by pub_id, type
$$;

-- Adding constraints to dbo.authors'
ALTER TABLE dbo.authors ADD CONSTRAINT CK__authors__au_id__ CHECK (au_id ~* '\d\d\d-\d\d-\d\d\d\d');
ALTER TABLE dbo.authors ADD CONSTRAINT CK__authors__zip__ CHECK (zip ~* '\d\d\d\d\d');
-- Adding constraints to dbo.employee'
ALTER TABLE dbo.employee ADD CONSTRAINT CK_emp_id CHECK (emp_id ~* '\w[\w-]\w\d\d\d\d\d\w');
-- Adding constraints to dbo.jobs
ALTER TABLE dbo.jobs ADD CONSTRAINT CK__jobs__min_lvl CHECK ((min_lvl>=(10)));
ALTER TABLE dbo.jobs ADD CONSTRAINT CK__jobs__max_lvl CHECK ((max_lvl<=(250)));
-- Adding constraints to dbo.publishers'
ALTER TABLE dbo.publishers ADD CONSTRAINT CK__publisher__pub_id CHECK (pub_id='1756' OR pub_id='1622' OR pub_id='0877' OR pub_id='0736' OR pub_id='1389' OR pub_id ~* '99\d\d');
-- Adding foreign keys to dbo.titleauthor'
ALTER TABLE dbo.titleauthor ADD CONSTRAINT FK__titleauth__au_id FOREIGN KEY (au_id) REFERENCES dbo.authors (au_id);
ALTER TABLE dbo.titleauthor ADD CONSTRAINT FK__titleauth__title FOREIGN KEY (title_id) REFERENCES dbo.titles (title_id);
-- Adding foreign keys to dbo.discounts'
ALTER TABLE dbo.discounts ADD CONSTRAINT FK__discounts__stor FOREIGN KEY (stor_id) REFERENCES dbo.stores (stor_id);
-- Adding foreign keys to dbo.employee'
ALTER TABLE dbo.employee ADD CONSTRAINT FK__employee__job_id FOREIGN KEY (job_id) REFERENCES dbo.jobs (job_id);
ALTER TABLE dbo.employee ADD CONSTRAINT FK__employee__pub_id FOREIGN KEY (pub_id) REFERENCES dbo.publishers (pub_id);
-- Adding foreign keys to dbo.pub_info'
ALTER TABLE dbo.pub_info ADD CONSTRAINT FK__pub_info__pub_id FOREIGN KEY (pub_id) REFERENCES dbo.publishers (pub_id);
-- Adding foreign keys to dbo.titles'
ALTER TABLE dbo.titles ADD CONSTRAINT FK__titles__pub_id FOREIGN KEY (pub_id) REFERENCES dbo.publishers (pub_id);
-- Adding foreign keys to dbo.roysched'
ALTER TABLE dbo.roysched ADD CONSTRAINT FK__roysched__title FOREIGN KEY (title_id) REFERENCES dbo.titles (title_id);
ALTER TABLE dbo.sales ADD CONSTRAINT FK__sales__stor_id FOREIGN KEY (stor_id) REFERENCES dbo.stores (stor_id);
ALTER TABLE dbo.sales ADD CONSTRAINT FK__sales__title_id FOREIGN KEY (title_id) REFERENCES dbo.titles (title_id);






